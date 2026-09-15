import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/positions_table.dart';

part 'position_dao.g.dart';

@DriftAccessor(tables: [Positions])
class PositionDao extends DatabaseAccessor<AppDatabase>
    with _$PositionDaoMixin {
  PositionDao(super.db);

  Stream<List<Position>> watchAll() => select(positions).watch();

  Future<List<Position>> getAll() => select(positions).get();

  Future<int> insertOne(PositionsCompanion entry) =>
      into(positions).insert(entry);

  Future<int> updateOne(PositionsCompanion entry) =>
      (update(positions)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<int> deleteOne(int id) =>
      (delete(positions)..where((t) => t.id.equals(id))).go();

  Future<int> countAll() async {
    final countExpr = positions.id.count();
    final query = selectOnly(positions)..addColumns([countExpr]);
    return await query.map((row) => row.read(countExpr) ?? 0).getSingle();
  }
}
