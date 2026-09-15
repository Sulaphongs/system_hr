import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/finance_table.dart';

part 'finance_dao.g.dart';

@DriftAccessor(tables: [FinanceTransactions])
class FinanceDao extends DatabaseAccessor<AppDatabase>
    with _$FinanceDaoMixin {
  FinanceDao(super.db);

  Future<List<FinanceTransaction>> getByMonthYear(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return (select(financeTransactions)
          ..where((t) =>
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<List<FinanceTransaction>> getAll() =>
      (select(financeTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
          .get();

  Future<int> insertOne(FinanceTransactionsCompanion entry) =>
      into(financeTransactions).insert(entry);

  Future<bool> updateOne(FinanceTransactionsCompanion entry) =>
      update(financeTransactions).replace(entry);

  Future<int> deleteOne(int id) =>
      (delete(financeTransactions)..where((t) => t.id.equals(id))).go();

  Future<double> sumByTypeAndMonthYear(
      String type, int month, int year) async {
    final rows = await getByMonthYear(month, year);
    return rows
        .where((r) => r.type == type)
        .fold<double>(0.0, (s, r) => s + r.amount);
  }
}
