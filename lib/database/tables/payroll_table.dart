import 'package:drift/drift.dart';
import 'employees_table.dart';

@DataClassName('PayrollRecord')
class Payroll extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  IntColumn get month => integer()();
  IntColumn get year => integer()();

  // ພາກສ່ວນຮັບ (Income)
  RealColumn get rankSalary =>
      real().withDefault(const Constant(0.0))();
  RealColumn get dutyAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get seniorityAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get militaryBonus =>
      real().withDefault(const Constant(0.0))();
  RealColumn get specialistAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get nutritionAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get childrenAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get wifeAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get costOfLivingAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get professionalAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get certificateAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get extraMealAllowance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get totalIncome =>
      real().withDefault(const Constant(0.0))();

  // ພາກສ່ວນຫັກ (Deductions)
  RealColumn get socialSecurity =>
      real().withDefault(const Constant(0.0))();
  RealColumn get incomeTax =>
      real().withDefault(const Constant(0.0))();
  RealColumn get clothingDeduction =>
      real().withDefault(const Constant(0.0))();
  RealColumn get utilityDeduction =>
      real().withDefault(const Constant(0.0))();
  RealColumn get riceDeduction =>
      real().withDefault(const Constant(0.0))();
  RealColumn get foodRateDeduction =>
      real().withDefault(const Constant(0.0))();
  RealColumn get tenPercentDeduction =>
      real().withDefault(const Constant(0.0))();
  RealColumn get totalDeductions =>
      real().withDefault(const Constant(0.0))();

  // ຈຳນວນເງິນສົດ
  RealColumn get netPay =>
      real().withDefault(const Constant(0.0))();

  TextColumn get note => text().nullable()();
  DateTimeColumn get generatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, month, year}
      ];
}
