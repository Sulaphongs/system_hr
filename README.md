# ລະບົບຈັດການພະນັກງານ (HR Management System)

ລະບົບຈັດການຊັບພະຍາກອນມະນຸດ (HR) ສຳລັບ Windows — ພັດທະນາດ້ວຍ Flutter, ເຮັດວຽກແບບ offline ເຕັມຮູບແບບ, ຂໍ້ມູນທັງໝົດເກັບໃນ SQLite ຢູ່ເຄື່ອງ.

---

## ຄຸນສົມບັດຫຼັກ

| ໂໝດ | ລາຍລະອຽດ |
|-----|-----------|
| ພະນັກງານ | ເພີ່ມ, ແກ້ໄຂ, ລົບ, ນຳເຂົ້າ CSV, ເບິ່ງລາຍລະອຽດ |
| ຕຳແໜ່ງ & ຊັ້ນທະຫານ | ຈັດການຕຳແໜ່ງວຽກ ແລະ ຊັ້ນຍົດທະຫານ |
| ເງິນເດືອນ | ສ້າງເງິນເດືອນອັດຕະໂນມັດ, ນຳເຂົ້າ CSV, ພິມໃບລາຍຮັບ |
| ລາຍຮັບ-ລາຍຈ່າຍ | ບັນທຶກລາຍການການເງິນ, ສະຫຼຸບຕາມເດືອນ |
| ລາຍງານ | ສົ່ງອອກ PDF (ບັນຊີພະນັກງານ, ສະຫຼຸບເງິນເດືອນ, ສະຫຼຸບການເງິນ) |
| ໂຄງຮ່າງອົງກອນ | ສະແດງຕາຕະລາງພະນັກງານຕາມຕຳແໜ່ງ |
| Dashboard | ສະຖິຕິ ແລະ ກຣາຟລາຍຮັບ-ລາຍຈ່າຍ |

---

## ຄວາມຕ້ອງການຂອງລະບົບ

- **OS:** Windows 10 / 11 (64-bit)
- **Flutter SDK:** v3.44.7 ຂຶ້ນໄປ
- **Dart SDK:** v3.12.2 ຂຶ້ນໄປ

---

## ການຕິດຕັ້ງ ແລະ ການເຮັດວຽກ

### 1. Clone ໂຄງການ

```bash
git clone https://github.com/Sulaphongs/system_hr.git
cd system_hr
```

### 2. ຕິດຕັ້ງ dependencies

```powershell
flutter pub get
```

### 3. ລັນໂຄງການ (debug mode)

```powershell
$env:PATH = "D:\SDK\flutter\bin\mingit\cmd;D:\SDK\flutter\bin;C:\Windows\System32;C:\Windows\System32\Wbem;" + $env:PATH
flutter run -d windows
```

### 4. Build ໄຟລ໌ .exe

```powershell
flutter build windows --debug
```

ໄຟລ໌ exe ຈະຢູ່ທີ່: `build\windows\x64\runner\Debug\system_hr.exe`

---

## ໂຄງສ້າງໂຄງການ

```
lib/
├── core/
│   ├── constants/      # AppStrings (ລາວ), AppColors
│   └── utils/          # date_utils, currency_utils, validators, csv_parser
├── database/
│   ├── tables/         # Drift schema (ແຫຼ່ງຂໍ້ມູນ)
│   ├── daos/           # Query methods
│   └── app_database.dart
├── providers/          # ChangeNotifier ຕໍ່ feature
├── screens/            # UI ຕໍ່ feature
└── widgets/
    ├── common/         # ສ່ວນປະກອບທີ່ໃຊ້ຮ່ວມ
    └── layout/         # AppShell, SidebarNav
```

---

## ຖານຂໍ້ມູນ

- **Engine:** SQLite ຜ່ານ Drift ORM
- **ໄຟລ໌:** `%APPDATA%\system_hr\system_hr.sqlite`
- **Schema version:** 5
- **ຕາຕະລາງ:** Positions, MilitaryRanks, Employees, Payroll, FinanceTransactions, Attendance, Leaves

ຫຼັງຈາກແກ້ໄຂ schema ຕ້ອງລັນ:

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ການນຳເຂົ້າ CSV

**ພະນັກງານ** (6 columns):
| # | ຊັ້ນທະຫານ | ຊື່-ນາມສະກຸນ | ວັນທີເຂົ້າວຽກ | ... | ເງິນເດືອນ |

**ເງິນເດືອນ** (24 columns) — ຮູບແບບໃບລາຍຮັບທາງການ:
ລຳດັບ, ຊັ້ນ, ຊື່, ..., ລວມ, ຫັກ, ສຸດທິ

---

## ສູດຄຳນວນເງິນເດືອນ

| ລາຍການ | ສູດ |
|--------|-----|
| ເງິນເດືອນຕາມຊັ້ນ | `employee.salary` |
| ເງິນເພີ່ມທະຫານ | `rankSalary × 30%` |
| ເງິນອາວຸໂສ | ປີ 1–5: 10,000/ປີ · ປີ 6–15: 20,000/ປີ · ປີ 16–25: 30,000/ປີ · ປີ 26+: 40,000/ປີ |

---

## ເທັກໂນໂລຊີທີ່ໃຊ້

| Package | ໜ້າທີ່ |
|---------|--------|
| `drift` | SQLite ORM |
| `provider` | State management |
| `go_router` | Navigation |
| `pdf` + `printing` | ສ້າງ ແລະ ພິມ PDF |
| `fl_chart` | ກຣາຟໃນ Dashboard |
| `file_picker` | ເລືອກໄຟລ໌ (Windows) |
| `shared_preferences` | ການຕັ້ງຄ່າ (font scale) |

---

## ໃບອະນຸຍາດ

ໂຄງການນີ້ພັດທະນາສຳລັບໃຊ້ພາຍໃນ — ສະຫງວນລິຂະສິດທຸກປະການ.
