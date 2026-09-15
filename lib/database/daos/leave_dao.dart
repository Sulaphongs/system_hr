import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/leaves_table.dart';
import '../tables/employees_table.dart';

part 'leave_dao.g.dart';

@DriftAccessor(tables: [Leaves, Employees])
class LeaveDao extends DatabaseAccessor<AppDatabase> with _$LeaveDaoMixin {
  LeaveDao(super.db);

  Stream<List<Leave>> watchAll() =>
      (select(leaves)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<List<Leave>> getAll() =>
      (select(leaves)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Leave>> getByEmployee(int employeeId) =>
      (select(leaves)..where((t) => t.employeeId.equals(employeeId))).get();

  Future<List<Leave>> getByStatus(String status) =>
      (select(leaves)..where((t) => t.approvalStatus.equals(status))).get();

  Future<int> insertOne(LeavesCompanion entry) =>
      into(leaves).insert(entry);

  Future<int> updateStatus(int id, String status) =>
      (update(leaves)..where((t) => t.id.equals(id)))
          .write(LeavesCompanion(approvalStatus: Value(status)));

  Future<int> deleteOne(int id) =>
      (delete(leaves)..where((t) => t.id.equals(id))).go();

  Future<int> countPending() async {
    final countExpr = leaves.id.count();
    final query = selectOnly(leaves)
      ..addColumns([countExpr])
      ..where(leaves.approvalStatus.equals('pending'));
    return await query.map((row) => row.read(countExpr) ?? 0).getSingle();
  }
}
