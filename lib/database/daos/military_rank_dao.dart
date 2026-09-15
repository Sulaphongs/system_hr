import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/military_ranks_table.dart';

part 'military_rank_dao.g.dart';

@DriftAccessor(tables: [MilitaryRanks])
class MilitaryRankDao extends DatabaseAccessor<AppDatabase>
    with _$MilitaryRankDaoMixin {
  MilitaryRankDao(super.db);

  Stream<List<MilitaryRank>> watchAll() =>
      (select(militaryRanks)..orderBy([(t) => OrderingTerm.asc(t.level)]))
          .watch();

  Future<List<MilitaryRank>> getAll() =>
      (select(militaryRanks)..orderBy([(t) => OrderingTerm.asc(t.level)]))
          .get();

  Future<int> insertOne(MilitaryRanksCompanion entry) =>
      into(militaryRanks).insert(entry);

  Future<int> updateOne(MilitaryRanksCompanion entry) =>
      (update(militaryRanks)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<int> deleteOne(int id) =>
      (delete(militaryRanks)..where((t) => t.id.equals(id))).go();

  Future<int> countAll() async {
    final countExpr = militaryRanks.id.count();
    final query = selectOnly(militaryRanks)..addColumns([countExpr]);
    return await query.map((row) => row.read(countExpr) ?? 0).getSingle();
  }
}
