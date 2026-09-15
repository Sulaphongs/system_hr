import 'package:drift/drift.dart';
import 'positions_table.dart';
import 'military_ranks_table.dart';

class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get employeeCode =>
      text().withLength(min: 1, max: 20).unique()();
  TextColumn get firstName => text().withLength(min: 1, max: 100)();
  TextColumn get lastName => text().withLength(min: 1, max: 100)();
  TextColumn get gender => text().withLength(min: 1, max: 10)();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get positionId =>
      integer().nullable().references(Positions, #id)();
  IntColumn get militaryRankId =>
      integer().nullable().references(MilitaryRanks, #id)();
  DateTimeColumn get hireDate => dateTime()();
  RealColumn get salary =>
      real().withDefault(const Constant(0.0))();
  TextColumn get status =>
      text().withDefault(const Constant('active'))();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
