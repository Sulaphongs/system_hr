import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/employees_table.dart';
import '../tables/positions_table.dart';
import '../tables/military_ranks_table.dart';

part 'employee_dao.g.dart';

class EmployeeWithDetails {
  final Employee employee;
  final String? positionName;
  final String? militaryRankName;
  final String? militaryRankCode;
  final int? militaryRankLevel;

  EmployeeWithDetails({
    required this.employee,
    this.positionName,
    this.militaryRankName,
    this.militaryRankCode,
    this.militaryRankLevel,
  });
}

@DriftAccessor(tables: [Employees, Positions, MilitaryRanks])
class EmployeeDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  Stream<List<Employee>> watchAll() => select(employees).watch();

  Future<List<Employee>> getAll() => select(employees).get();

  Future<List<Employee>> getActive() =>
      (select(employees)..where((t) => t.status.equals('active'))).get();

  Future<Employee?> getById(int id) =>
      (select(employees)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<EmployeeWithDetails>> getAllWithDetails() async {
    final query = select(employees).join([
      leftOuterJoin(positions, positions.id.equalsExp(employees.positionId)),
      leftOuterJoin(
          militaryRanks, militaryRanks.id.equalsExp(employees.militaryRankId)),
    ]);
    final rows = await query.get();
    return rows.map((row) {
      return EmployeeWithDetails(
        employee: row.readTable(employees),
        positionName: row.readTableOrNull(positions)?.name,
        militaryRankName: row.readTableOrNull(militaryRanks)?.name,
        militaryRankCode: row.readTableOrNull(militaryRanks)?.code,
        militaryRankLevel: row.readTableOrNull(militaryRanks)?.level,
      );
    }).toList();
  }

  Future<int> insertOne(EmployeesCompanion entry) =>
      into(employees).insert(entry);

  Future<int> updateOne(EmployeesCompanion entry) =>
      (update(employees)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<int> deleteOne(int id) =>
      (delete(employees)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAll() => delete(employees).go();

  Future<int> countActive() async {
    final countExpr = employees.id.count();
    final query = selectOnly(employees)
      ..addColumns([countExpr])
      ..where(employees.status.equals('active'));
    return await query.map((row) => row.read(countExpr) ?? 0).getSingle();
  }
}
