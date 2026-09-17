# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

- Flutter SDK: `D:\SDK\flutter` (v3.44.7, Dart 3.12.2)
- Target platform: Windows desktop only
- Database file at runtime: `%APPDATA%\system_hr\system_hr.sqlite`

## Commands

Always prepend the PATH fix before any flutter command in PowerShell:

```powershell
$env:PATH = "D:\SDK\flutter\bin\mingit\cmd;D:\SDK\flutter\bin;C:\Windows\System32;C:\Windows\System32\Wbem;" + $env:PATH
Set-Location "D:\HR\system_hr"
```

`C:\Windows\System32` must be included — otherwise `WHERE` and other system tools are not found.

| Task | Command |
|------|---------|
| Run (debug, hot reload) | `& "D:\SDK\flutter\bin\flutter.bat" run -d windows` |
| Build exe | `& "D:\SDK\flutter\bin\flutter.bat" build windows --debug` |
| Run built exe directly | `Start-Process "build\windows\x64\runner\Debug\system_hr.exe"` |
| Regenerate drift code | `& "D:\SDK\flutter\bin\flutter.bat" pub run build_runner build --delete-conflicting-outputs` |
| Run tests | `& "D:\SDK\flutter\bin\flutter.bat" test` |

**Hot reload keys** (while `flutter run` is active): `r` = hot reload, `R` = hot restart, `q` = quit.

**After any drift table change** (adding/removing columns or tables), run `build_runner` before running — the `.g.dart` generated files must be regenerated.

PowerToys stderr noise (`"The system cannot find the path specified"`, `DSCModules`) appears on every flutter invocation — ignore it.

### VS Code Flutter Daemon

`.vscode/settings.json` sets `dart.env.PATH` which replaces the process PATH for the Dart extension. It must include `C:\Windows\System32\WindowsPowerShell\v1.0` — Flutter daemon requires PowerShell.exe on startup.

## Architecture

### Data flow

```
Table (drift schema) → DAO (queries) → AppDatabase → Provider (ChangeNotifier) → Screen
```

`main.dart` creates a single `AppDatabase` instance and wires all providers into a `MultiProvider` at the root. Providers receive their DAO from the database. Screens access data through `context.read<XProvider>()` / `context.watch<XProvider>()`.

**Exception:** `DashboardProvider` receives the full `AppDatabase` (not a single DAO) because it aggregates data from multiple DAOs (`employeeDao`, `positionDao`, `financeDao`).

### Directory layout

- `lib/database/tables/` — drift table definitions (schema source of truth)
- `lib/database/daos/` — typed query methods; each DAO has a corresponding `.g.dart` file
- `lib/database/app_database.dart` — `@DriftDatabase` class, schema version, migrations
- `lib/providers/` — one `ChangeNotifier` per feature domain; calls DAO methods then `notifyListeners()`
- `lib/screens/` — feature folders, each containing list/form/detail screens
- `lib/widgets/layout/` — `AppShell` (sidebar + content row) and `SidebarNav`
- `lib/widgets/common/` — shared form fields (`AppTextField`, `AppDropdown`, `AppDatePicker`), `SummaryCard`, `StatusBadge`, `ConfirmDialog`; `table_helpers.dart` provides `TableSearchField`, `TableEmptyState`, and `TableStyle` constants used by all list screens
- `lib/core/constants/app_strings.dart` — all UI strings (Lao language)
- `lib/core/constants/app_colors.dart` — theme
- `lib/core/utils/` — `currency_utils.dart`, `date_utils.dart`, `validators.dart`

### Navigation

`app.dart` defines a single `GoRouter` with a `ShellRoute` wrapping all routes. `AppShell` renders `SidebarNav` on the left and the active screen on the right. Routes follow the pattern `/feature`, `/feature/new`, `/feature/:id`, `/feature/:id/edit`.

**Exception:** `PayrollImportScreen` and `EmployeeImportScreen` are not GoRouter routes — they are pushed via `Navigator.push` from their respective list screens and run as modal pages outside the shell.

### Database schema (drift, SQLite, schema v6)

Tables: `Positions`, `MilitaryRanks`, `Employees`, `Attendance`, `Leaves`, `Payroll`, `FinanceTransactions`

`Employees` references `Positions` and `MilitaryRanks` via nullable foreign keys. DAOs that join across tables return custom result classes (e.g. `EmployeeWithDetails`, `PayrollWithEmployee`) — not raw table rows.

**`@DataClassName` notes:** The `Payroll` table uses `@DataClassName('PayrollRecord')`, so Dart code works with `PayrollRecord` objects (not `Payroll`). Similarly, `FinanceTransactions` generates `FinanceTransaction` objects. The table class and the generated data class have different names in these two cases.

Schema migrations are manual `ALTER TABLE` statements in `AppDatabase.migration.onUpgrade`. When bumping `schemaVersion`, add the matching migration case.

**String enum values used in queries (not Dart enums):**
- `Employee.status`: `'active'` / `'inactive'`
- `FinanceTransaction.type`: `'income'` / `'expense'`
- `Attendance.status`: `'present'` / `'absent'` / `'late'`

**Unique constraints:**
- `Employee.employeeCode` — unique; `EmployeeProvider.nextCode` generates the next `EMP001`-style code
- `Payroll(employeeId, month, year)` — unique per employee per month; use `upsertOne` to overwrite, `insertIfNew` to skip existing

### Payroll generation

`PayrollProvider.generateForEmployees()` auto-calculates three fields fresh each run:
- `rankSalary` = `employee.salary`
- `militaryBonus` = `rankSalary × 0.30`
- `seniorityAllowance` = 4-tier formula in `AppDateUtils.calcSeniorityAllowance`: years 1–5 → 10,000/yr, 6–15 → 20,000/yr, 16–25 → 30,000/yr, 26+ → 40,000/yr

All other allowance/deduction fields are copied from the employee's most recent previous month record (`PayrollDao.getLatestForEmployee`). This includes counts: `wifeCount` and `childrenCount` are copied from the previous record, and their allowances are recalculated as `count × 200,000 LAK`. Records are inserted with `insertIfNew` (`InsertMode.insertOrIgnore`) — already-generated months are not overwritten.

**`wifeAllowance` is intentionally excluded from `totalIncome`** even though it is stored and copied. The `totalIncome` formula is: `rankSalary + militaryBonus + seniorityAllowance + dutyAllowance + specialistAllowance + extraMealAllowance + childrenAllowance + nutritionAllowance + costOfLivingAllowance + professionalAllowance + certificateAllowance`.

### CSV import

Two import flows share `lib/core/utils/csv_parser.dart`:

- **Payroll import** (`PayrollImportScreen`) — reads a fixed 24-column CSV. Column indices are hard-coded in `parseCsvPayroll`; rows with fewer than 24 columns are skipped. After parsing, `matchEmployees()` resolves each row to an employee by normalising the CSV name (strips Lao title prefixes, parenthesised suffixes) and comparing to `firstName + " " + lastName` — exact match first, then substring fallback. Unmatched rows are skipped silently on import.

- **Employee import** (`EmployeeImportScreen`) — reads a 6-column CSV via `parseCsvEmployees`. `resolveEmployeeRows()` splits names, parses `M.YYYY` hire dates (handles 3-digit year truncation), and looks up `MilitaryRank` by `code`. Rows matching an existing employee by full name are flagged `isExisting = true` and skipped on insert.

Both parsers strip the UTF-8 BOM and handle double-quoted fields with escaped `""` pairs.

### Reports and PDF export

`ReportsScreen` has three tabs:
1. **Employee list** — table of all filtered employees; exports to A4 PDF via `Printing.layoutPdf`.
2. **Payroll summary** — income/deductions/net per employee for a selected month/year.
3. **Finance summary** — income and expense grouped by category for a selected month/year.

All PDFs use the `PhetsarathOT` font loaded from `assets/fonts/Phetsarath OT.ttf` via `rootBundle.load`.

`PayrollListScreen` also generates individual pay slips per employee (distinct from the report tabs). Pay slips include a logo watermark from `assets/images/logo_watermark.png` and open via `Printing.layoutPdf`.

### Attendance and Leave modules

Tables, DAOs, providers, and screens exist for `Attendance` and `Leaves`, but they are **not yet registered** in `main.dart`'s `MultiProvider` and have no routes in `app.dart`. To activate them: add `ChangeNotifierProvider` entries to `main.dart` and add `GoRoute` entries to `app.dart`.

### Finance categories

Income and expense categories are hardcoded as `_incomeCategories` / `_expenseCategories` constants at the top of `lib/screens/finance/finance_screen.dart`. They are not in `AppStrings`, not in the database, and not configurable at runtime — edit that file to add or rename categories.

### Key conventions

- All display strings go in `AppStrings` — the UI is entirely in Lao language.
- Use `file_picker` (not `image_picker`) for file/photo selection — `image_picker` has no Windows support.
- `PhetsarathOT` is the custom Lao font; it must be referenced for any text that renders Lao script in PDFs.
- PDF generation uses the `pdf` + `printing` packages; print previews open via `Printing.layoutPdf(...)`.
- `SettingsProvider` stores `fontScale` (range 0.75–1.50) in `SharedPreferences`; `app.dart` wraps the router in a `MediaQuery` override so all text scales globally.
- `DashboardScreen` uses `fl_chart` (`BarChart`, `PieChart`) for finance and payroll visualisations.
- `OrgChartScreen` groups active employees by position name and renders each group as a card column; it reads from `EmployeeProvider` and requires no dedicated DAO.
