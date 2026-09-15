// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PositionsTable extends Positions
    with TableInfo<$PositionsTable, Position> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Position> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Position map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Position(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PositionsTable createAlias(String alias) {
    return $PositionsTable(attachedDatabase, alias);
  }
}

class Position extends DataClass implements Insertable<Position> {
  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  const Position({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PositionsCompanion toCompanion(bool nullToAbsent) {
    return PositionsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Position.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Position(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Position copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
  }) => Position(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  Position copyWithCompanion(PositionsCompanion data) {
    return Position(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Position(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Position &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class PositionsCompanion extends UpdateCompanion<Position> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const PositionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PositionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Position> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PositionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime>? createdAt,
  }) {
    return PositionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MilitaryRanksTable extends MilitaryRanks
    with TableInfo<$MilitaryRanksTable, MilitaryRank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilitaryRanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    description,
    level,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'military_ranks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilitaryRank> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilitaryRank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilitaryRank(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MilitaryRanksTable createAlias(String alias) {
    return $MilitaryRanksTable(attachedDatabase, alias);
  }
}

class MilitaryRank extends DataClass implements Insertable<MilitaryRank> {
  final int id;
  final String code;
  final String name;
  final String? description;
  final int level;
  final DateTime createdAt;
  const MilitaryRank({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.level,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['level'] = Variable<int>(level);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MilitaryRanksCompanion toCompanion(bool nullToAbsent) {
    return MilitaryRanksCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      level: Value(level),
      createdAt: Value(createdAt),
    );
  }

  factory MilitaryRank.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilitaryRank(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      level: serializer.fromJson<int>(json['level']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'level': serializer.toJson<int>(level),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MilitaryRank copyWith({
    int? id,
    String? code,
    String? name,
    Value<String?> description = const Value.absent(),
    int? level,
    DateTime? createdAt,
  }) => MilitaryRank(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    level: level ?? this.level,
    createdAt: createdAt ?? this.createdAt,
  );
  MilitaryRank copyWithCompanion(MilitaryRanksCompanion data) {
    return MilitaryRank(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      level: data.level.present ? data.level.value : this.level,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilitaryRank(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, description, level, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilitaryRank &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.level == this.level &&
          other.createdAt == this.createdAt);
}

class MilitaryRanksCompanion extends UpdateCompanion<MilitaryRank> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> level;
  final Value<DateTime> createdAt;
  const MilitaryRanksCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MilitaryRanksCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : code = Value(code),
       name = Value(name);
  static Insertable<MilitaryRank> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? level,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (level != null) 'level': level,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MilitaryRanksCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? level,
    Value<DateTime>? createdAt,
  }) {
    return MilitaryRanksCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilitaryRanksCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeCodeMeta = const VerificationMeta(
    'employeeCode',
  );
  @override
  late final GeneratedColumn<String> employeeCode = GeneratedColumn<String>(
    'employee_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionIdMeta = const VerificationMeta(
    'positionId',
  );
  @override
  late final GeneratedColumn<int> positionId = GeneratedColumn<int>(
    'position_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES positions (id)',
    ),
  );
  static const VerificationMeta _militaryRankIdMeta = const VerificationMeta(
    'militaryRankId',
  );
  @override
  late final GeneratedColumn<int> militaryRankId = GeneratedColumn<int>(
    'military_rank_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES military_ranks (id)',
    ),
  );
  static const VerificationMeta _hireDateMeta = const VerificationMeta(
    'hireDate',
  );
  @override
  late final GeneratedColumn<DateTime> hireDate = GeneratedColumn<DateTime>(
    'hire_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salaryMeta = const VerificationMeta('salary');
  @override
  late final GeneratedColumn<double> salary = GeneratedColumn<double>(
    'salary',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeCode,
    firstName,
    lastName,
    gender,
    birthDate,
    phone,
    address,
    positionId,
    militaryRankId,
    hireDate,
    salary,
    status,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_code')) {
      context.handle(
        _employeeCodeMeta,
        employeeCode.isAcceptableOrUnknown(
          data['employee_code']!,
          _employeeCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_employeeCodeMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('position_id')) {
      context.handle(
        _positionIdMeta,
        positionId.isAcceptableOrUnknown(data['position_id']!, _positionIdMeta),
      );
    }
    if (data.containsKey('military_rank_id')) {
      context.handle(
        _militaryRankIdMeta,
        militaryRankId.isAcceptableOrUnknown(
          data['military_rank_id']!,
          _militaryRankIdMeta,
        ),
      );
    }
    if (data.containsKey('hire_date')) {
      context.handle(
        _hireDateMeta,
        hireDate.isAcceptableOrUnknown(data['hire_date']!, _hireDateMeta),
      );
    } else if (isInserting) {
      context.missing(_hireDateMeta);
    }
    if (data.containsKey('salary')) {
      context.handle(
        _salaryMeta,
        salary.isAcceptableOrUnknown(data['salary']!, _salaryMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_code'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      positionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_id'],
      ),
      militaryRankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}military_rank_id'],
      ),
      hireDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hire_date'],
      )!,
      salary: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salary'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime? birthDate;
  final String? phone;
  final String? address;
  final int? positionId;
  final int? militaryRankId;
  final DateTime hireDate;
  final double salary;
  final String status;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Employee({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.birthDate,
    this.phone,
    this.address,
    this.positionId,
    this.militaryRankId,
    required this.hireDate,
    required this.salary,
    required this.status,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_code'] = Variable<String>(employeeCode);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['gender'] = Variable<String>(gender);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || positionId != null) {
      map['position_id'] = Variable<int>(positionId);
    }
    if (!nullToAbsent || militaryRankId != null) {
      map['military_rank_id'] = Variable<int>(militaryRankId);
    }
    map['hire_date'] = Variable<DateTime>(hireDate);
    map['salary'] = Variable<double>(salary);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      employeeCode: Value(employeeCode),
      firstName: Value(firstName),
      lastName: Value(lastName),
      gender: Value(gender),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      positionId: positionId == null && nullToAbsent
          ? const Value.absent()
          : Value(positionId),
      militaryRankId: militaryRankId == null && nullToAbsent
          ? const Value.absent()
          : Value(militaryRankId),
      hireDate: Value(hireDate),
      salary: Value(salary),
      status: Value(status),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Employee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      employeeCode: serializer.fromJson<String>(json['employeeCode']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      gender: serializer.fromJson<String>(json['gender']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      positionId: serializer.fromJson<int?>(json['positionId']),
      militaryRankId: serializer.fromJson<int?>(json['militaryRankId']),
      hireDate: serializer.fromJson<DateTime>(json['hireDate']),
      salary: serializer.fromJson<double>(json['salary']),
      status: serializer.fromJson<String>(json['status']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeCode': serializer.toJson<String>(employeeCode),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'gender': serializer.toJson<String>(gender),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'positionId': serializer.toJson<int?>(positionId),
      'militaryRankId': serializer.toJson<int?>(militaryRankId),
      'hireDate': serializer.toJson<DateTime>(hireDate),
      'salary': serializer.toJson<double>(salary),
      'status': serializer.toJson<String>(status),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Employee copyWith({
    int? id,
    String? employeeCode,
    String? firstName,
    String? lastName,
    String? gender,
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<int?> positionId = const Value.absent(),
    Value<int?> militaryRankId = const Value.absent(),
    DateTime? hireDate,
    double? salary,
    String? status,
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Employee(
    id: id ?? this.id,
    employeeCode: employeeCode ?? this.employeeCode,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    gender: gender ?? this.gender,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    positionId: positionId.present ? positionId.value : this.positionId,
    militaryRankId: militaryRankId.present
        ? militaryRankId.value
        : this.militaryRankId,
    hireDate: hireDate ?? this.hireDate,
    salary: salary ?? this.salary,
    status: status ?? this.status,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      employeeCode: data.employeeCode.present
          ? data.employeeCode.value
          : this.employeeCode,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      positionId: data.positionId.present
          ? data.positionId.value
          : this.positionId,
      militaryRankId: data.militaryRankId.present
          ? data.militaryRankId.value
          : this.militaryRankId,
      hireDate: data.hireDate.present ? data.hireDate.value : this.hireDate,
      salary: data.salary.present ? data.salary.value : this.salary,
      status: data.status.present ? data.status.value : this.status,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('employeeCode: $employeeCode, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('positionId: $positionId, ')
          ..write('militaryRankId: $militaryRankId, ')
          ..write('hireDate: $hireDate, ')
          ..write('salary: $salary, ')
          ..write('status: $status, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeCode,
    firstName,
    lastName,
    gender,
    birthDate,
    phone,
    address,
    positionId,
    militaryRankId,
    hireDate,
    salary,
    status,
    photoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.employeeCode == this.employeeCode &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.gender == this.gender &&
          other.birthDate == this.birthDate &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.positionId == this.positionId &&
          other.militaryRankId == this.militaryRankId &&
          other.hireDate == this.hireDate &&
          other.salary == this.salary &&
          other.status == this.status &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<String> employeeCode;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> gender;
  final Value<DateTime?> birthDate;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<int?> positionId;
  final Value<int?> militaryRankId;
  final Value<DateTime> hireDate;
  final Value<double> salary;
  final Value<String> status;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.employeeCode = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.positionId = const Value.absent(),
    this.militaryRankId = const Value.absent(),
    this.hireDate = const Value.absent(),
    this.salary = const Value.absent(),
    this.status = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required String employeeCode,
    required String firstName,
    required String lastName,
    required String gender,
    this.birthDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.positionId = const Value.absent(),
    this.militaryRankId = const Value.absent(),
    required DateTime hireDate,
    this.salary = const Value.absent(),
    this.status = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : employeeCode = Value(employeeCode),
       firstName = Value(firstName),
       lastName = Value(lastName),
       gender = Value(gender),
       hireDate = Value(hireDate);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? employeeCode,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? gender,
    Expression<DateTime>? birthDate,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? positionId,
    Expression<int>? militaryRankId,
    Expression<DateTime>? hireDate,
    Expression<double>? salary,
    Expression<String>? status,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeCode != null) 'employee_code': employeeCode,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (gender != null) 'gender': gender,
      if (birthDate != null) 'birth_date': birthDate,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (positionId != null) 'position_id': positionId,
      if (militaryRankId != null) 'military_rank_id': militaryRankId,
      if (hireDate != null) 'hire_date': hireDate,
      if (salary != null) 'salary': salary,
      if (status != null) 'status': status,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmployeesCompanion copyWith({
    Value<int>? id,
    Value<String>? employeeCode,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? gender,
    Value<DateTime?>? birthDate,
    Value<String?>? phone,
    Value<String?>? address,
    Value<int?>? positionId,
    Value<int?>? militaryRankId,
    Value<DateTime>? hireDate,
    Value<double>? salary,
    Value<String>? status,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      positionId: positionId ?? this.positionId,
      militaryRankId: militaryRankId ?? this.militaryRankId,
      hireDate: hireDate ?? this.hireDate,
      salary: salary ?? this.salary,
      status: status ?? this.status,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeCode.present) {
      map['employee_code'] = Variable<String>(employeeCode.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (positionId.present) {
      map['position_id'] = Variable<int>(positionId.value);
    }
    if (militaryRankId.present) {
      map['military_rank_id'] = Variable<int>(militaryRankId.value);
    }
    if (hireDate.present) {
      map['hire_date'] = Variable<DateTime>(hireDate.value);
    }
    if (salary.present) {
      map['salary'] = Variable<double>(salary.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('employeeCode: $employeeCode, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('positionId: $positionId, ')
          ..write('militaryRankId: $militaryRankId, ')
          ..write('hireDate: $hireDate, ')
          ..write('salary: $salary, ')
          ..write('status: $status, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTable extends Attendance
    with TableInfo<$AttendanceTable, AttendanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInMeta = const VerificationMeta(
    'checkIn',
  );
  @override
  late final GeneratedColumn<DateTime> checkIn = GeneratedColumn<DateTime>(
    'check_in',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkOutMeta = const VerificationMeta(
    'checkOut',
  );
  @override
  late final GeneratedColumn<DateTime> checkOut = GeneratedColumn<DateTime>(
    'check_out',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    date,
    checkIn,
    checkOut,
    status,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('check_in')) {
      context.handle(
        _checkInMeta,
        checkIn.isAcceptableOrUnknown(data['check_in']!, _checkInMeta),
      );
    }
    if (data.containsKey('check_out')) {
      context.handle(
        _checkOutMeta,
        checkOut.isAcceptableOrUnknown(data['check_out']!, _checkOutMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {employeeId, date},
  ];
  @override
  AttendanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      checkIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_in'],
      ),
      checkOut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_out'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $AttendanceTable createAlias(String alias) {
    return $AttendanceTable(attachedDatabase, alias);
  }
}

class AttendanceRecord extends DataClass
    implements Insertable<AttendanceRecord> {
  final int id;
  final int employeeId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String status;
  final String? note;
  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || checkIn != null) {
      map['check_in'] = Variable<DateTime>(checkIn);
    }
    if (!nullToAbsent || checkOut != null) {
      map['check_out'] = Variable<DateTime>(checkOut);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  AttendanceCompanion toCompanion(bool nullToAbsent) {
    return AttendanceCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      date: Value(date),
      checkIn: checkIn == null && nullToAbsent
          ? const Value.absent()
          : Value(checkIn),
      checkOut: checkOut == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOut),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory AttendanceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRecord(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      date: serializer.fromJson<DateTime>(json['date']),
      checkIn: serializer.fromJson<DateTime?>(json['checkIn']),
      checkOut: serializer.fromJson<DateTime?>(json['checkOut']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'date': serializer.toJson<DateTime>(date),
      'checkIn': serializer.toJson<DateTime?>(checkIn),
      'checkOut': serializer.toJson<DateTime?>(checkOut),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
    };
  }

  AttendanceRecord copyWith({
    int? id,
    int? employeeId,
    DateTime? date,
    Value<DateTime?> checkIn = const Value.absent(),
    Value<DateTime?> checkOut = const Value.absent(),
    String? status,
    Value<String?> note = const Value.absent(),
  }) => AttendanceRecord(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    date: date ?? this.date,
    checkIn: checkIn.present ? checkIn.value : this.checkIn,
    checkOut: checkOut.present ? checkOut.value : this.checkOut,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
  );
  AttendanceRecord copyWithCompanion(AttendanceCompanion data) {
    return AttendanceRecord(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      date: data.date.present ? data.date.value : this.date,
      checkIn: data.checkIn.present ? data.checkIn.value : this.checkIn,
      checkOut: data.checkOut.present ? data.checkOut.value : this.checkOut,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecord(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('date: $date, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, employeeId, date, checkIn, checkOut, status, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRecord &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.date == this.date &&
          other.checkIn == this.checkIn &&
          other.checkOut == this.checkOut &&
          other.status == this.status &&
          other.note == this.note);
}

class AttendanceCompanion extends UpdateCompanion<AttendanceRecord> {
  final Value<int> id;
  final Value<int> employeeId;
  final Value<DateTime> date;
  final Value<DateTime?> checkIn;
  final Value<DateTime?> checkOut;
  final Value<String> status;
  final Value<String?> note;
  const AttendanceCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.date = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
  });
  AttendanceCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    required DateTime date,
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    required String status,
    this.note = const Value.absent(),
  }) : employeeId = Value(employeeId),
       date = Value(date),
       status = Value(status);
  static Insertable<AttendanceRecord> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<DateTime>? date,
    Expression<DateTime>? checkIn,
    Expression<DateTime>? checkOut,
    Expression<String>? status,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (date != null) 'date': date,
      if (checkIn != null) 'check_in': checkIn,
      if (checkOut != null) 'check_out': checkOut,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
    });
  }

  AttendanceCompanion copyWith({
    Value<int>? id,
    Value<int>? employeeId,
    Value<DateTime>? date,
    Value<DateTime?>? checkIn,
    Value<DateTime?>? checkOut,
    Value<String>? status,
    Value<String?>? note,
  }) {
    return AttendanceCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (checkIn.present) {
      map['check_in'] = Variable<DateTime>(checkIn.value);
    }
    if (checkOut.present) {
      map['check_out'] = Variable<DateTime>(checkOut.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('date: $date, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $LeavesTable extends Leaves with TableInfo<$LeavesTable, Leave> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeavesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _leaveTypeMeta = const VerificationMeta(
    'leaveType',
  );
  @override
  late final GeneratedColumn<String> leaveType = GeneratedColumn<String>(
    'leave_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDaysMeta = const VerificationMeta(
    'totalDays',
  );
  @override
  late final GeneratedColumn<int> totalDays = GeneratedColumn<int>(
    'total_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvalStatusMeta = const VerificationMeta(
    'approvalStatus',
  );
  @override
  late final GeneratedColumn<String> approvalStatus = GeneratedColumn<String>(
    'approval_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    leaveType,
    startDate,
    endDate,
    totalDays,
    reason,
    approvalStatus,
    approvedBy,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leaves';
  @override
  VerificationContext validateIntegrity(
    Insertable<Leave> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('leave_type')) {
      context.handle(
        _leaveTypeMeta,
        leaveType.isAcceptableOrUnknown(data['leave_type']!, _leaveTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_leaveTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('total_days')) {
      context.handle(
        _totalDaysMeta,
        totalDays.isAcceptableOrUnknown(data['total_days']!, _totalDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_totalDaysMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('approval_status')) {
      context.handle(
        _approvalStatusMeta,
        approvalStatus.isAcceptableOrUnknown(
          data['approval_status']!,
          _approvalStatusMeta,
        ),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Leave map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Leave(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      leaveType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      totalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_days'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      approvalStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approval_status'],
      )!,
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LeavesTable createAlias(String alias) {
    return $LeavesTable(attachedDatabase, alias);
  }
}

class Leave extends DataClass implements Insertable<Leave> {
  final int id;
  final int employeeId;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String? reason;
  final String approvalStatus;
  final String? approvedBy;
  final DateTime createdAt;
  const Leave({
    required this.id,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    this.reason,
    required this.approvalStatus,
    this.approvedBy,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['leave_type'] = Variable<String>(leaveType);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['total_days'] = Variable<int>(totalDays);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['approval_status'] = Variable<String>(approvalStatus);
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LeavesCompanion toCompanion(bool nullToAbsent) {
    return LeavesCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      leaveType: Value(leaveType),
      startDate: Value(startDate),
      endDate: Value(endDate),
      totalDays: Value(totalDays),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      approvalStatus: Value(approvalStatus),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      createdAt: Value(createdAt),
    );
  }

  factory Leave.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Leave(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      leaveType: serializer.fromJson<String>(json['leaveType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      totalDays: serializer.fromJson<int>(json['totalDays']),
      reason: serializer.fromJson<String?>(json['reason']),
      approvalStatus: serializer.fromJson<String>(json['approvalStatus']),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'leaveType': serializer.toJson<String>(leaveType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'totalDays': serializer.toJson<int>(totalDays),
      'reason': serializer.toJson<String?>(reason),
      'approvalStatus': serializer.toJson<String>(approvalStatus),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Leave copyWith({
    int? id,
    int? employeeId,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    Value<String?> reason = const Value.absent(),
    String? approvalStatus,
    Value<String?> approvedBy = const Value.absent(),
    DateTime? createdAt,
  }) => Leave(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    leaveType: leaveType ?? this.leaveType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    totalDays: totalDays ?? this.totalDays,
    reason: reason.present ? reason.value : this.reason,
    approvalStatus: approvalStatus ?? this.approvalStatus,
    approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
    createdAt: createdAt ?? this.createdAt,
  );
  Leave copyWithCompanion(LeavesCompanion data) {
    return Leave(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      leaveType: data.leaveType.present ? data.leaveType.value : this.leaveType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      totalDays: data.totalDays.present ? data.totalDays.value : this.totalDays,
      reason: data.reason.present ? data.reason.value : this.reason,
      approvalStatus: data.approvalStatus.present
          ? data.approvalStatus.value
          : this.approvalStatus,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Leave(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('totalDays: $totalDays, ')
          ..write('reason: $reason, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    leaveType,
    startDate,
    endDate,
    totalDays,
    reason,
    approvalStatus,
    approvedBy,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Leave &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.leaveType == this.leaveType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.totalDays == this.totalDays &&
          other.reason == this.reason &&
          other.approvalStatus == this.approvalStatus &&
          other.approvedBy == this.approvedBy &&
          other.createdAt == this.createdAt);
}

class LeavesCompanion extends UpdateCompanion<Leave> {
  final Value<int> id;
  final Value<int> employeeId;
  final Value<String> leaveType;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> totalDays;
  final Value<String?> reason;
  final Value<String> approvalStatus;
  final Value<String?> approvedBy;
  final Value<DateTime> createdAt;
  const LeavesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.leaveType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.totalDays = const Value.absent(),
    this.reason = const Value.absent(),
    this.approvalStatus = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LeavesCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int totalDays,
    this.reason = const Value.absent(),
    this.approvalStatus = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : employeeId = Value(employeeId),
       leaveType = Value(leaveType),
       startDate = Value(startDate),
       endDate = Value(endDate),
       totalDays = Value(totalDays);
  static Insertable<Leave> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<String>? leaveType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? totalDays,
    Expression<String>? reason,
    Expression<String>? approvalStatus,
    Expression<String>? approvedBy,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (leaveType != null) 'leave_type': leaveType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (totalDays != null) 'total_days': totalDays,
      if (reason != null) 'reason': reason,
      if (approvalStatus != null) 'approval_status': approvalStatus,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LeavesCompanion copyWith({
    Value<int>? id,
    Value<int>? employeeId,
    Value<String>? leaveType,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? totalDays,
    Value<String?>? reason,
    Value<String>? approvalStatus,
    Value<String?>? approvedBy,
    Value<DateTime>? createdAt,
  }) {
    return LeavesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      reason: reason ?? this.reason,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvedBy: approvedBy ?? this.approvedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (leaveType.present) {
      map['leave_type'] = Variable<String>(leaveType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (totalDays.present) {
      map['total_days'] = Variable<int>(totalDays.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (approvalStatus.present) {
      map['approval_status'] = Variable<String>(approvalStatus.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeavesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('totalDays: $totalDays, ')
          ..write('reason: $reason, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PayrollTable extends Payroll
    with TableInfo<$PayrollTable, PayrollRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankSalaryMeta = const VerificationMeta(
    'rankSalary',
  );
  @override
  late final GeneratedColumn<double> rankSalary = GeneratedColumn<double>(
    'rank_salary',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _dutyAllowanceMeta = const VerificationMeta(
    'dutyAllowance',
  );
  @override
  late final GeneratedColumn<double> dutyAllowance = GeneratedColumn<double>(
    'duty_allowance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _seniorityAllowanceMeta =
      const VerificationMeta('seniorityAllowance');
  @override
  late final GeneratedColumn<double> seniorityAllowance =
      GeneratedColumn<double>(
        'seniority_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _militaryBonusMeta = const VerificationMeta(
    'militaryBonus',
  );
  @override
  late final GeneratedColumn<double> militaryBonus = GeneratedColumn<double>(
    'military_bonus',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _specialistAllowanceMeta =
      const VerificationMeta('specialistAllowance');
  @override
  late final GeneratedColumn<double> specialistAllowance =
      GeneratedColumn<double>(
        'specialist_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _nutritionAllowanceMeta =
      const VerificationMeta('nutritionAllowance');
  @override
  late final GeneratedColumn<double> nutritionAllowance =
      GeneratedColumn<double>(
        'nutrition_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _childrenAllowanceMeta = const VerificationMeta(
    'childrenAllowance',
  );
  @override
  late final GeneratedColumn<double> childrenAllowance =
      GeneratedColumn<double>(
        'children_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _wifeAllowanceMeta = const VerificationMeta(
    'wifeAllowance',
  );
  @override
  late final GeneratedColumn<double> wifeAllowance = GeneratedColumn<double>(
    'wife_allowance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _costOfLivingAllowanceMeta =
      const VerificationMeta('costOfLivingAllowance');
  @override
  late final GeneratedColumn<double> costOfLivingAllowance =
      GeneratedColumn<double>(
        'cost_of_living_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _professionalAllowanceMeta =
      const VerificationMeta('professionalAllowance');
  @override
  late final GeneratedColumn<double> professionalAllowance =
      GeneratedColumn<double>(
        'professional_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _certificateAllowanceMeta =
      const VerificationMeta('certificateAllowance');
  @override
  late final GeneratedColumn<double> certificateAllowance =
      GeneratedColumn<double>(
        'certificate_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _extraMealAllowanceMeta =
      const VerificationMeta('extraMealAllowance');
  @override
  late final GeneratedColumn<double> extraMealAllowance =
      GeneratedColumn<double>(
        'extra_meal_allowance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _totalIncomeMeta = const VerificationMeta(
    'totalIncome',
  );
  @override
  late final GeneratedColumn<double> totalIncome = GeneratedColumn<double>(
    'total_income',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _socialSecurityMeta = const VerificationMeta(
    'socialSecurity',
  );
  @override
  late final GeneratedColumn<double> socialSecurity = GeneratedColumn<double>(
    'social_security',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _incomeTaxMeta = const VerificationMeta(
    'incomeTax',
  );
  @override
  late final GeneratedColumn<double> incomeTax = GeneratedColumn<double>(
    'income_tax',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _clothingDeductionMeta = const VerificationMeta(
    'clothingDeduction',
  );
  @override
  late final GeneratedColumn<double> clothingDeduction =
      GeneratedColumn<double>(
        'clothing_deduction',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _utilityDeductionMeta = const VerificationMeta(
    'utilityDeduction',
  );
  @override
  late final GeneratedColumn<double> utilityDeduction = GeneratedColumn<double>(
    'utility_deduction',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _riceDeductionMeta = const VerificationMeta(
    'riceDeduction',
  );
  @override
  late final GeneratedColumn<double> riceDeduction = GeneratedColumn<double>(
    'rice_deduction',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _foodRateDeductionMeta = const VerificationMeta(
    'foodRateDeduction',
  );
  @override
  late final GeneratedColumn<double> foodRateDeduction =
      GeneratedColumn<double>(
        'food_rate_deduction',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _tenPercentDeductionMeta =
      const VerificationMeta('tenPercentDeduction');
  @override
  late final GeneratedColumn<double> tenPercentDeduction =
      GeneratedColumn<double>(
        'ten_percent_deduction',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _totalDeductionsMeta = const VerificationMeta(
    'totalDeductions',
  );
  @override
  late final GeneratedColumn<double> totalDeductions = GeneratedColumn<double>(
    'total_deductions',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _netPayMeta = const VerificationMeta('netPay');
  @override
  late final GeneratedColumn<double> netPay = GeneratedColumn<double>(
    'net_pay',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    month,
    year,
    rankSalary,
    dutyAllowance,
    seniorityAllowance,
    militaryBonus,
    specialistAllowance,
    nutritionAllowance,
    childrenAllowance,
    wifeAllowance,
    costOfLivingAllowance,
    professionalAllowance,
    certificateAllowance,
    extraMealAllowance,
    totalIncome,
    socialSecurity,
    incomeTax,
    clothingDeduction,
    utilityDeduction,
    riceDeduction,
    foodRateDeduction,
    tenPercentDeduction,
    totalDeductions,
    netPay,
    note,
    generatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayrollRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('rank_salary')) {
      context.handle(
        _rankSalaryMeta,
        rankSalary.isAcceptableOrUnknown(data['rank_salary']!, _rankSalaryMeta),
      );
    }
    if (data.containsKey('duty_allowance')) {
      context.handle(
        _dutyAllowanceMeta,
        dutyAllowance.isAcceptableOrUnknown(
          data['duty_allowance']!,
          _dutyAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('seniority_allowance')) {
      context.handle(
        _seniorityAllowanceMeta,
        seniorityAllowance.isAcceptableOrUnknown(
          data['seniority_allowance']!,
          _seniorityAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('military_bonus')) {
      context.handle(
        _militaryBonusMeta,
        militaryBonus.isAcceptableOrUnknown(
          data['military_bonus']!,
          _militaryBonusMeta,
        ),
      );
    }
    if (data.containsKey('specialist_allowance')) {
      context.handle(
        _specialistAllowanceMeta,
        specialistAllowance.isAcceptableOrUnknown(
          data['specialist_allowance']!,
          _specialistAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('nutrition_allowance')) {
      context.handle(
        _nutritionAllowanceMeta,
        nutritionAllowance.isAcceptableOrUnknown(
          data['nutrition_allowance']!,
          _nutritionAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('children_allowance')) {
      context.handle(
        _childrenAllowanceMeta,
        childrenAllowance.isAcceptableOrUnknown(
          data['children_allowance']!,
          _childrenAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('wife_allowance')) {
      context.handle(
        _wifeAllowanceMeta,
        wifeAllowance.isAcceptableOrUnknown(
          data['wife_allowance']!,
          _wifeAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('cost_of_living_allowance')) {
      context.handle(
        _costOfLivingAllowanceMeta,
        costOfLivingAllowance.isAcceptableOrUnknown(
          data['cost_of_living_allowance']!,
          _costOfLivingAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('professional_allowance')) {
      context.handle(
        _professionalAllowanceMeta,
        professionalAllowance.isAcceptableOrUnknown(
          data['professional_allowance']!,
          _professionalAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('certificate_allowance')) {
      context.handle(
        _certificateAllowanceMeta,
        certificateAllowance.isAcceptableOrUnknown(
          data['certificate_allowance']!,
          _certificateAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('extra_meal_allowance')) {
      context.handle(
        _extraMealAllowanceMeta,
        extraMealAllowance.isAcceptableOrUnknown(
          data['extra_meal_allowance']!,
          _extraMealAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('total_income')) {
      context.handle(
        _totalIncomeMeta,
        totalIncome.isAcceptableOrUnknown(
          data['total_income']!,
          _totalIncomeMeta,
        ),
      );
    }
    if (data.containsKey('social_security')) {
      context.handle(
        _socialSecurityMeta,
        socialSecurity.isAcceptableOrUnknown(
          data['social_security']!,
          _socialSecurityMeta,
        ),
      );
    }
    if (data.containsKey('income_tax')) {
      context.handle(
        _incomeTaxMeta,
        incomeTax.isAcceptableOrUnknown(data['income_tax']!, _incomeTaxMeta),
      );
    }
    if (data.containsKey('clothing_deduction')) {
      context.handle(
        _clothingDeductionMeta,
        clothingDeduction.isAcceptableOrUnknown(
          data['clothing_deduction']!,
          _clothingDeductionMeta,
        ),
      );
    }
    if (data.containsKey('utility_deduction')) {
      context.handle(
        _utilityDeductionMeta,
        utilityDeduction.isAcceptableOrUnknown(
          data['utility_deduction']!,
          _utilityDeductionMeta,
        ),
      );
    }
    if (data.containsKey('rice_deduction')) {
      context.handle(
        _riceDeductionMeta,
        riceDeduction.isAcceptableOrUnknown(
          data['rice_deduction']!,
          _riceDeductionMeta,
        ),
      );
    }
    if (data.containsKey('food_rate_deduction')) {
      context.handle(
        _foodRateDeductionMeta,
        foodRateDeduction.isAcceptableOrUnknown(
          data['food_rate_deduction']!,
          _foodRateDeductionMeta,
        ),
      );
    }
    if (data.containsKey('ten_percent_deduction')) {
      context.handle(
        _tenPercentDeductionMeta,
        tenPercentDeduction.isAcceptableOrUnknown(
          data['ten_percent_deduction']!,
          _tenPercentDeductionMeta,
        ),
      );
    }
    if (data.containsKey('total_deductions')) {
      context.handle(
        _totalDeductionsMeta,
        totalDeductions.isAcceptableOrUnknown(
          data['total_deductions']!,
          _totalDeductionsMeta,
        ),
      );
    }
    if (data.containsKey('net_pay')) {
      context.handle(
        _netPayMeta,
        netPay.isAcceptableOrUnknown(data['net_pay']!, _netPayMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {employeeId, month, year},
  ];
  @override
  PayrollRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      rankSalary: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rank_salary'],
      )!,
      dutyAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duty_allowance'],
      )!,
      seniorityAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}seniority_allowance'],
      )!,
      militaryBonus: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}military_bonus'],
      )!,
      specialistAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}specialist_allowance'],
      )!,
      nutritionAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}nutrition_allowance'],
      )!,
      childrenAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}children_allowance'],
      )!,
      wifeAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wife_allowance'],
      )!,
      costOfLivingAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_of_living_allowance'],
      )!,
      professionalAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}professional_allowance'],
      )!,
      certificateAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}certificate_allowance'],
      )!,
      extraMealAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}extra_meal_allowance'],
      )!,
      totalIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_income'],
      )!,
      socialSecurity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}social_security'],
      )!,
      incomeTax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}income_tax'],
      )!,
      clothingDeduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}clothing_deduction'],
      )!,
      utilityDeduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}utility_deduction'],
      )!,
      riceDeduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rice_deduction'],
      )!,
      foodRateDeduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}food_rate_deduction'],
      )!,
      tenPercentDeduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ten_percent_deduction'],
      )!,
      totalDeductions: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_deductions'],
      )!,
      netPay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}net_pay'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
    );
  }

  @override
  $PayrollTable createAlias(String alias) {
    return $PayrollTable(attachedDatabase, alias);
  }
}

class PayrollRecord extends DataClass implements Insertable<PayrollRecord> {
  final int id;
  final int employeeId;
  final int month;
  final int year;
  final double rankSalary;
  final double dutyAllowance;
  final double seniorityAllowance;
  final double militaryBonus;
  final double specialistAllowance;
  final double nutritionAllowance;
  final double childrenAllowance;
  final double wifeAllowance;
  final double costOfLivingAllowance;
  final double professionalAllowance;
  final double certificateAllowance;
  final double extraMealAllowance;
  final double totalIncome;
  final double socialSecurity;
  final double incomeTax;
  final double clothingDeduction;
  final double utilityDeduction;
  final double riceDeduction;
  final double foodRateDeduction;
  final double tenPercentDeduction;
  final double totalDeductions;
  final double netPay;
  final String? note;
  final DateTime generatedAt;
  const PayrollRecord({
    required this.id,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.rankSalary,
    required this.dutyAllowance,
    required this.seniorityAllowance,
    required this.militaryBonus,
    required this.specialistAllowance,
    required this.nutritionAllowance,
    required this.childrenAllowance,
    required this.wifeAllowance,
    required this.costOfLivingAllowance,
    required this.professionalAllowance,
    required this.certificateAllowance,
    required this.extraMealAllowance,
    required this.totalIncome,
    required this.socialSecurity,
    required this.incomeTax,
    required this.clothingDeduction,
    required this.utilityDeduction,
    required this.riceDeduction,
    required this.foodRateDeduction,
    required this.tenPercentDeduction,
    required this.totalDeductions,
    required this.netPay,
    this.note,
    required this.generatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['rank_salary'] = Variable<double>(rankSalary);
    map['duty_allowance'] = Variable<double>(dutyAllowance);
    map['seniority_allowance'] = Variable<double>(seniorityAllowance);
    map['military_bonus'] = Variable<double>(militaryBonus);
    map['specialist_allowance'] = Variable<double>(specialistAllowance);
    map['nutrition_allowance'] = Variable<double>(nutritionAllowance);
    map['children_allowance'] = Variable<double>(childrenAllowance);
    map['wife_allowance'] = Variable<double>(wifeAllowance);
    map['cost_of_living_allowance'] = Variable<double>(costOfLivingAllowance);
    map['professional_allowance'] = Variable<double>(professionalAllowance);
    map['certificate_allowance'] = Variable<double>(certificateAllowance);
    map['extra_meal_allowance'] = Variable<double>(extraMealAllowance);
    map['total_income'] = Variable<double>(totalIncome);
    map['social_security'] = Variable<double>(socialSecurity);
    map['income_tax'] = Variable<double>(incomeTax);
    map['clothing_deduction'] = Variable<double>(clothingDeduction);
    map['utility_deduction'] = Variable<double>(utilityDeduction);
    map['rice_deduction'] = Variable<double>(riceDeduction);
    map['food_rate_deduction'] = Variable<double>(foodRateDeduction);
    map['ten_percent_deduction'] = Variable<double>(tenPercentDeduction);
    map['total_deductions'] = Variable<double>(totalDeductions);
    map['net_pay'] = Variable<double>(netPay);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['generated_at'] = Variable<DateTime>(generatedAt);
    return map;
  }

  PayrollCompanion toCompanion(bool nullToAbsent) {
    return PayrollCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      month: Value(month),
      year: Value(year),
      rankSalary: Value(rankSalary),
      dutyAllowance: Value(dutyAllowance),
      seniorityAllowance: Value(seniorityAllowance),
      militaryBonus: Value(militaryBonus),
      specialistAllowance: Value(specialistAllowance),
      nutritionAllowance: Value(nutritionAllowance),
      childrenAllowance: Value(childrenAllowance),
      wifeAllowance: Value(wifeAllowance),
      costOfLivingAllowance: Value(costOfLivingAllowance),
      professionalAllowance: Value(professionalAllowance),
      certificateAllowance: Value(certificateAllowance),
      extraMealAllowance: Value(extraMealAllowance),
      totalIncome: Value(totalIncome),
      socialSecurity: Value(socialSecurity),
      incomeTax: Value(incomeTax),
      clothingDeduction: Value(clothingDeduction),
      utilityDeduction: Value(utilityDeduction),
      riceDeduction: Value(riceDeduction),
      foodRateDeduction: Value(foodRateDeduction),
      tenPercentDeduction: Value(tenPercentDeduction),
      totalDeductions: Value(totalDeductions),
      netPay: Value(netPay),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      generatedAt: Value(generatedAt),
    );
  }

  factory PayrollRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollRecord(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      rankSalary: serializer.fromJson<double>(json['rankSalary']),
      dutyAllowance: serializer.fromJson<double>(json['dutyAllowance']),
      seniorityAllowance: serializer.fromJson<double>(
        json['seniorityAllowance'],
      ),
      militaryBonus: serializer.fromJson<double>(json['militaryBonus']),
      specialistAllowance: serializer.fromJson<double>(
        json['specialistAllowance'],
      ),
      nutritionAllowance: serializer.fromJson<double>(
        json['nutritionAllowance'],
      ),
      childrenAllowance: serializer.fromJson<double>(json['childrenAllowance']),
      wifeAllowance: serializer.fromJson<double>(json['wifeAllowance']),
      costOfLivingAllowance: serializer.fromJson<double>(
        json['costOfLivingAllowance'],
      ),
      professionalAllowance: serializer.fromJson<double>(
        json['professionalAllowance'],
      ),
      certificateAllowance: serializer.fromJson<double>(
        json['certificateAllowance'],
      ),
      extraMealAllowance: serializer.fromJson<double>(
        json['extraMealAllowance'],
      ),
      totalIncome: serializer.fromJson<double>(json['totalIncome']),
      socialSecurity: serializer.fromJson<double>(json['socialSecurity']),
      incomeTax: serializer.fromJson<double>(json['incomeTax']),
      clothingDeduction: serializer.fromJson<double>(json['clothingDeduction']),
      utilityDeduction: serializer.fromJson<double>(json['utilityDeduction']),
      riceDeduction: serializer.fromJson<double>(json['riceDeduction']),
      foodRateDeduction: serializer.fromJson<double>(json['foodRateDeduction']),
      tenPercentDeduction: serializer.fromJson<double>(
        json['tenPercentDeduction'],
      ),
      totalDeductions: serializer.fromJson<double>(json['totalDeductions']),
      netPay: serializer.fromJson<double>(json['netPay']),
      note: serializer.fromJson<String?>(json['note']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'rankSalary': serializer.toJson<double>(rankSalary),
      'dutyAllowance': serializer.toJson<double>(dutyAllowance),
      'seniorityAllowance': serializer.toJson<double>(seniorityAllowance),
      'militaryBonus': serializer.toJson<double>(militaryBonus),
      'specialistAllowance': serializer.toJson<double>(specialistAllowance),
      'nutritionAllowance': serializer.toJson<double>(nutritionAllowance),
      'childrenAllowance': serializer.toJson<double>(childrenAllowance),
      'wifeAllowance': serializer.toJson<double>(wifeAllowance),
      'costOfLivingAllowance': serializer.toJson<double>(costOfLivingAllowance),
      'professionalAllowance': serializer.toJson<double>(professionalAllowance),
      'certificateAllowance': serializer.toJson<double>(certificateAllowance),
      'extraMealAllowance': serializer.toJson<double>(extraMealAllowance),
      'totalIncome': serializer.toJson<double>(totalIncome),
      'socialSecurity': serializer.toJson<double>(socialSecurity),
      'incomeTax': serializer.toJson<double>(incomeTax),
      'clothingDeduction': serializer.toJson<double>(clothingDeduction),
      'utilityDeduction': serializer.toJson<double>(utilityDeduction),
      'riceDeduction': serializer.toJson<double>(riceDeduction),
      'foodRateDeduction': serializer.toJson<double>(foodRateDeduction),
      'tenPercentDeduction': serializer.toJson<double>(tenPercentDeduction),
      'totalDeductions': serializer.toJson<double>(totalDeductions),
      'netPay': serializer.toJson<double>(netPay),
      'note': serializer.toJson<String?>(note),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
    };
  }

  PayrollRecord copyWith({
    int? id,
    int? employeeId,
    int? month,
    int? year,
    double? rankSalary,
    double? dutyAllowance,
    double? seniorityAllowance,
    double? militaryBonus,
    double? specialistAllowance,
    double? nutritionAllowance,
    double? childrenAllowance,
    double? wifeAllowance,
    double? costOfLivingAllowance,
    double? professionalAllowance,
    double? certificateAllowance,
    double? extraMealAllowance,
    double? totalIncome,
    double? socialSecurity,
    double? incomeTax,
    double? clothingDeduction,
    double? utilityDeduction,
    double? riceDeduction,
    double? foodRateDeduction,
    double? tenPercentDeduction,
    double? totalDeductions,
    double? netPay,
    Value<String?> note = const Value.absent(),
    DateTime? generatedAt,
  }) => PayrollRecord(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    month: month ?? this.month,
    year: year ?? this.year,
    rankSalary: rankSalary ?? this.rankSalary,
    dutyAllowance: dutyAllowance ?? this.dutyAllowance,
    seniorityAllowance: seniorityAllowance ?? this.seniorityAllowance,
    militaryBonus: militaryBonus ?? this.militaryBonus,
    specialistAllowance: specialistAllowance ?? this.specialistAllowance,
    nutritionAllowance: nutritionAllowance ?? this.nutritionAllowance,
    childrenAllowance: childrenAllowance ?? this.childrenAllowance,
    wifeAllowance: wifeAllowance ?? this.wifeAllowance,
    costOfLivingAllowance: costOfLivingAllowance ?? this.costOfLivingAllowance,
    professionalAllowance: professionalAllowance ?? this.professionalAllowance,
    certificateAllowance: certificateAllowance ?? this.certificateAllowance,
    extraMealAllowance: extraMealAllowance ?? this.extraMealAllowance,
    totalIncome: totalIncome ?? this.totalIncome,
    socialSecurity: socialSecurity ?? this.socialSecurity,
    incomeTax: incomeTax ?? this.incomeTax,
    clothingDeduction: clothingDeduction ?? this.clothingDeduction,
    utilityDeduction: utilityDeduction ?? this.utilityDeduction,
    riceDeduction: riceDeduction ?? this.riceDeduction,
    foodRateDeduction: foodRateDeduction ?? this.foodRateDeduction,
    tenPercentDeduction: tenPercentDeduction ?? this.tenPercentDeduction,
    totalDeductions: totalDeductions ?? this.totalDeductions,
    netPay: netPay ?? this.netPay,
    note: note.present ? note.value : this.note,
    generatedAt: generatedAt ?? this.generatedAt,
  );
  PayrollRecord copyWithCompanion(PayrollCompanion data) {
    return PayrollRecord(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      rankSalary: data.rankSalary.present
          ? data.rankSalary.value
          : this.rankSalary,
      dutyAllowance: data.dutyAllowance.present
          ? data.dutyAllowance.value
          : this.dutyAllowance,
      seniorityAllowance: data.seniorityAllowance.present
          ? data.seniorityAllowance.value
          : this.seniorityAllowance,
      militaryBonus: data.militaryBonus.present
          ? data.militaryBonus.value
          : this.militaryBonus,
      specialistAllowance: data.specialistAllowance.present
          ? data.specialistAllowance.value
          : this.specialistAllowance,
      nutritionAllowance: data.nutritionAllowance.present
          ? data.nutritionAllowance.value
          : this.nutritionAllowance,
      childrenAllowance: data.childrenAllowance.present
          ? data.childrenAllowance.value
          : this.childrenAllowance,
      wifeAllowance: data.wifeAllowance.present
          ? data.wifeAllowance.value
          : this.wifeAllowance,
      costOfLivingAllowance: data.costOfLivingAllowance.present
          ? data.costOfLivingAllowance.value
          : this.costOfLivingAllowance,
      professionalAllowance: data.professionalAllowance.present
          ? data.professionalAllowance.value
          : this.professionalAllowance,
      certificateAllowance: data.certificateAllowance.present
          ? data.certificateAllowance.value
          : this.certificateAllowance,
      extraMealAllowance: data.extraMealAllowance.present
          ? data.extraMealAllowance.value
          : this.extraMealAllowance,
      totalIncome: data.totalIncome.present
          ? data.totalIncome.value
          : this.totalIncome,
      socialSecurity: data.socialSecurity.present
          ? data.socialSecurity.value
          : this.socialSecurity,
      incomeTax: data.incomeTax.present ? data.incomeTax.value : this.incomeTax,
      clothingDeduction: data.clothingDeduction.present
          ? data.clothingDeduction.value
          : this.clothingDeduction,
      utilityDeduction: data.utilityDeduction.present
          ? data.utilityDeduction.value
          : this.utilityDeduction,
      riceDeduction: data.riceDeduction.present
          ? data.riceDeduction.value
          : this.riceDeduction,
      foodRateDeduction: data.foodRateDeduction.present
          ? data.foodRateDeduction.value
          : this.foodRateDeduction,
      tenPercentDeduction: data.tenPercentDeduction.present
          ? data.tenPercentDeduction.value
          : this.tenPercentDeduction,
      totalDeductions: data.totalDeductions.present
          ? data.totalDeductions.value
          : this.totalDeductions,
      netPay: data.netPay.present ? data.netPay.value : this.netPay,
      note: data.note.present ? data.note.value : this.note,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollRecord(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('rankSalary: $rankSalary, ')
          ..write('dutyAllowance: $dutyAllowance, ')
          ..write('seniorityAllowance: $seniorityAllowance, ')
          ..write('militaryBonus: $militaryBonus, ')
          ..write('specialistAllowance: $specialistAllowance, ')
          ..write('nutritionAllowance: $nutritionAllowance, ')
          ..write('childrenAllowance: $childrenAllowance, ')
          ..write('wifeAllowance: $wifeAllowance, ')
          ..write('costOfLivingAllowance: $costOfLivingAllowance, ')
          ..write('professionalAllowance: $professionalAllowance, ')
          ..write('certificateAllowance: $certificateAllowance, ')
          ..write('extraMealAllowance: $extraMealAllowance, ')
          ..write('totalIncome: $totalIncome, ')
          ..write('socialSecurity: $socialSecurity, ')
          ..write('incomeTax: $incomeTax, ')
          ..write('clothingDeduction: $clothingDeduction, ')
          ..write('utilityDeduction: $utilityDeduction, ')
          ..write('riceDeduction: $riceDeduction, ')
          ..write('foodRateDeduction: $foodRateDeduction, ')
          ..write('tenPercentDeduction: $tenPercentDeduction, ')
          ..write('totalDeductions: $totalDeductions, ')
          ..write('netPay: $netPay, ')
          ..write('note: $note, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    employeeId,
    month,
    year,
    rankSalary,
    dutyAllowance,
    seniorityAllowance,
    militaryBonus,
    specialistAllowance,
    nutritionAllowance,
    childrenAllowance,
    wifeAllowance,
    costOfLivingAllowance,
    professionalAllowance,
    certificateAllowance,
    extraMealAllowance,
    totalIncome,
    socialSecurity,
    incomeTax,
    clothingDeduction,
    utilityDeduction,
    riceDeduction,
    foodRateDeduction,
    tenPercentDeduction,
    totalDeductions,
    netPay,
    note,
    generatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollRecord &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.month == this.month &&
          other.year == this.year &&
          other.rankSalary == this.rankSalary &&
          other.dutyAllowance == this.dutyAllowance &&
          other.seniorityAllowance == this.seniorityAllowance &&
          other.militaryBonus == this.militaryBonus &&
          other.specialistAllowance == this.specialistAllowance &&
          other.nutritionAllowance == this.nutritionAllowance &&
          other.childrenAllowance == this.childrenAllowance &&
          other.wifeAllowance == this.wifeAllowance &&
          other.costOfLivingAllowance == this.costOfLivingAllowance &&
          other.professionalAllowance == this.professionalAllowance &&
          other.certificateAllowance == this.certificateAllowance &&
          other.extraMealAllowance == this.extraMealAllowance &&
          other.totalIncome == this.totalIncome &&
          other.socialSecurity == this.socialSecurity &&
          other.incomeTax == this.incomeTax &&
          other.clothingDeduction == this.clothingDeduction &&
          other.utilityDeduction == this.utilityDeduction &&
          other.riceDeduction == this.riceDeduction &&
          other.foodRateDeduction == this.foodRateDeduction &&
          other.tenPercentDeduction == this.tenPercentDeduction &&
          other.totalDeductions == this.totalDeductions &&
          other.netPay == this.netPay &&
          other.note == this.note &&
          other.generatedAt == this.generatedAt);
}

class PayrollCompanion extends UpdateCompanion<PayrollRecord> {
  final Value<int> id;
  final Value<int> employeeId;
  final Value<int> month;
  final Value<int> year;
  final Value<double> rankSalary;
  final Value<double> dutyAllowance;
  final Value<double> seniorityAllowance;
  final Value<double> militaryBonus;
  final Value<double> specialistAllowance;
  final Value<double> nutritionAllowance;
  final Value<double> childrenAllowance;
  final Value<double> wifeAllowance;
  final Value<double> costOfLivingAllowance;
  final Value<double> professionalAllowance;
  final Value<double> certificateAllowance;
  final Value<double> extraMealAllowance;
  final Value<double> totalIncome;
  final Value<double> socialSecurity;
  final Value<double> incomeTax;
  final Value<double> clothingDeduction;
  final Value<double> utilityDeduction;
  final Value<double> riceDeduction;
  final Value<double> foodRateDeduction;
  final Value<double> tenPercentDeduction;
  final Value<double> totalDeductions;
  final Value<double> netPay;
  final Value<String?> note;
  final Value<DateTime> generatedAt;
  const PayrollCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.rankSalary = const Value.absent(),
    this.dutyAllowance = const Value.absent(),
    this.seniorityAllowance = const Value.absent(),
    this.militaryBonus = const Value.absent(),
    this.specialistAllowance = const Value.absent(),
    this.nutritionAllowance = const Value.absent(),
    this.childrenAllowance = const Value.absent(),
    this.wifeAllowance = const Value.absent(),
    this.costOfLivingAllowance = const Value.absent(),
    this.professionalAllowance = const Value.absent(),
    this.certificateAllowance = const Value.absent(),
    this.extraMealAllowance = const Value.absent(),
    this.totalIncome = const Value.absent(),
    this.socialSecurity = const Value.absent(),
    this.incomeTax = const Value.absent(),
    this.clothingDeduction = const Value.absent(),
    this.utilityDeduction = const Value.absent(),
    this.riceDeduction = const Value.absent(),
    this.foodRateDeduction = const Value.absent(),
    this.tenPercentDeduction = const Value.absent(),
    this.totalDeductions = const Value.absent(),
    this.netPay = const Value.absent(),
    this.note = const Value.absent(),
    this.generatedAt = const Value.absent(),
  });
  PayrollCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    required int month,
    required int year,
    this.rankSalary = const Value.absent(),
    this.dutyAllowance = const Value.absent(),
    this.seniorityAllowance = const Value.absent(),
    this.militaryBonus = const Value.absent(),
    this.specialistAllowance = const Value.absent(),
    this.nutritionAllowance = const Value.absent(),
    this.childrenAllowance = const Value.absent(),
    this.wifeAllowance = const Value.absent(),
    this.costOfLivingAllowance = const Value.absent(),
    this.professionalAllowance = const Value.absent(),
    this.certificateAllowance = const Value.absent(),
    this.extraMealAllowance = const Value.absent(),
    this.totalIncome = const Value.absent(),
    this.socialSecurity = const Value.absent(),
    this.incomeTax = const Value.absent(),
    this.clothingDeduction = const Value.absent(),
    this.utilityDeduction = const Value.absent(),
    this.riceDeduction = const Value.absent(),
    this.foodRateDeduction = const Value.absent(),
    this.tenPercentDeduction = const Value.absent(),
    this.totalDeductions = const Value.absent(),
    this.netPay = const Value.absent(),
    this.note = const Value.absent(),
    this.generatedAt = const Value.absent(),
  }) : employeeId = Value(employeeId),
       month = Value(month),
       year = Value(year);
  static Insertable<PayrollRecord> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<int>? month,
    Expression<int>? year,
    Expression<double>? rankSalary,
    Expression<double>? dutyAllowance,
    Expression<double>? seniorityAllowance,
    Expression<double>? militaryBonus,
    Expression<double>? specialistAllowance,
    Expression<double>? nutritionAllowance,
    Expression<double>? childrenAllowance,
    Expression<double>? wifeAllowance,
    Expression<double>? costOfLivingAllowance,
    Expression<double>? professionalAllowance,
    Expression<double>? certificateAllowance,
    Expression<double>? extraMealAllowance,
    Expression<double>? totalIncome,
    Expression<double>? socialSecurity,
    Expression<double>? incomeTax,
    Expression<double>? clothingDeduction,
    Expression<double>? utilityDeduction,
    Expression<double>? riceDeduction,
    Expression<double>? foodRateDeduction,
    Expression<double>? tenPercentDeduction,
    Expression<double>? totalDeductions,
    Expression<double>? netPay,
    Expression<String>? note,
    Expression<DateTime>? generatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (rankSalary != null) 'rank_salary': rankSalary,
      if (dutyAllowance != null) 'duty_allowance': dutyAllowance,
      if (seniorityAllowance != null) 'seniority_allowance': seniorityAllowance,
      if (militaryBonus != null) 'military_bonus': militaryBonus,
      if (specialistAllowance != null)
        'specialist_allowance': specialistAllowance,
      if (nutritionAllowance != null) 'nutrition_allowance': nutritionAllowance,
      if (childrenAllowance != null) 'children_allowance': childrenAllowance,
      if (wifeAllowance != null) 'wife_allowance': wifeAllowance,
      if (costOfLivingAllowance != null)
        'cost_of_living_allowance': costOfLivingAllowance,
      if (professionalAllowance != null)
        'professional_allowance': professionalAllowance,
      if (certificateAllowance != null)
        'certificate_allowance': certificateAllowance,
      if (extraMealAllowance != null)
        'extra_meal_allowance': extraMealAllowance,
      if (totalIncome != null) 'total_income': totalIncome,
      if (socialSecurity != null) 'social_security': socialSecurity,
      if (incomeTax != null) 'income_tax': incomeTax,
      if (clothingDeduction != null) 'clothing_deduction': clothingDeduction,
      if (utilityDeduction != null) 'utility_deduction': utilityDeduction,
      if (riceDeduction != null) 'rice_deduction': riceDeduction,
      if (foodRateDeduction != null) 'food_rate_deduction': foodRateDeduction,
      if (tenPercentDeduction != null)
        'ten_percent_deduction': tenPercentDeduction,
      if (totalDeductions != null) 'total_deductions': totalDeductions,
      if (netPay != null) 'net_pay': netPay,
      if (note != null) 'note': note,
      if (generatedAt != null) 'generated_at': generatedAt,
    });
  }

  PayrollCompanion copyWith({
    Value<int>? id,
    Value<int>? employeeId,
    Value<int>? month,
    Value<int>? year,
    Value<double>? rankSalary,
    Value<double>? dutyAllowance,
    Value<double>? seniorityAllowance,
    Value<double>? militaryBonus,
    Value<double>? specialistAllowance,
    Value<double>? nutritionAllowance,
    Value<double>? childrenAllowance,
    Value<double>? wifeAllowance,
    Value<double>? costOfLivingAllowance,
    Value<double>? professionalAllowance,
    Value<double>? certificateAllowance,
    Value<double>? extraMealAllowance,
    Value<double>? totalIncome,
    Value<double>? socialSecurity,
    Value<double>? incomeTax,
    Value<double>? clothingDeduction,
    Value<double>? utilityDeduction,
    Value<double>? riceDeduction,
    Value<double>? foodRateDeduction,
    Value<double>? tenPercentDeduction,
    Value<double>? totalDeductions,
    Value<double>? netPay,
    Value<String?>? note,
    Value<DateTime>? generatedAt,
  }) {
    return PayrollCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      month: month ?? this.month,
      year: year ?? this.year,
      rankSalary: rankSalary ?? this.rankSalary,
      dutyAllowance: dutyAllowance ?? this.dutyAllowance,
      seniorityAllowance: seniorityAllowance ?? this.seniorityAllowance,
      militaryBonus: militaryBonus ?? this.militaryBonus,
      specialistAllowance: specialistAllowance ?? this.specialistAllowance,
      nutritionAllowance: nutritionAllowance ?? this.nutritionAllowance,
      childrenAllowance: childrenAllowance ?? this.childrenAllowance,
      wifeAllowance: wifeAllowance ?? this.wifeAllowance,
      costOfLivingAllowance:
          costOfLivingAllowance ?? this.costOfLivingAllowance,
      professionalAllowance:
          professionalAllowance ?? this.professionalAllowance,
      certificateAllowance: certificateAllowance ?? this.certificateAllowance,
      extraMealAllowance: extraMealAllowance ?? this.extraMealAllowance,
      totalIncome: totalIncome ?? this.totalIncome,
      socialSecurity: socialSecurity ?? this.socialSecurity,
      incomeTax: incomeTax ?? this.incomeTax,
      clothingDeduction: clothingDeduction ?? this.clothingDeduction,
      utilityDeduction: utilityDeduction ?? this.utilityDeduction,
      riceDeduction: riceDeduction ?? this.riceDeduction,
      foodRateDeduction: foodRateDeduction ?? this.foodRateDeduction,
      tenPercentDeduction: tenPercentDeduction ?? this.tenPercentDeduction,
      totalDeductions: totalDeductions ?? this.totalDeductions,
      netPay: netPay ?? this.netPay,
      note: note ?? this.note,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (rankSalary.present) {
      map['rank_salary'] = Variable<double>(rankSalary.value);
    }
    if (dutyAllowance.present) {
      map['duty_allowance'] = Variable<double>(dutyAllowance.value);
    }
    if (seniorityAllowance.present) {
      map['seniority_allowance'] = Variable<double>(seniorityAllowance.value);
    }
    if (militaryBonus.present) {
      map['military_bonus'] = Variable<double>(militaryBonus.value);
    }
    if (specialistAllowance.present) {
      map['specialist_allowance'] = Variable<double>(specialistAllowance.value);
    }
    if (nutritionAllowance.present) {
      map['nutrition_allowance'] = Variable<double>(nutritionAllowance.value);
    }
    if (childrenAllowance.present) {
      map['children_allowance'] = Variable<double>(childrenAllowance.value);
    }
    if (wifeAllowance.present) {
      map['wife_allowance'] = Variable<double>(wifeAllowance.value);
    }
    if (costOfLivingAllowance.present) {
      map['cost_of_living_allowance'] = Variable<double>(
        costOfLivingAllowance.value,
      );
    }
    if (professionalAllowance.present) {
      map['professional_allowance'] = Variable<double>(
        professionalAllowance.value,
      );
    }
    if (certificateAllowance.present) {
      map['certificate_allowance'] = Variable<double>(
        certificateAllowance.value,
      );
    }
    if (extraMealAllowance.present) {
      map['extra_meal_allowance'] = Variable<double>(extraMealAllowance.value);
    }
    if (totalIncome.present) {
      map['total_income'] = Variable<double>(totalIncome.value);
    }
    if (socialSecurity.present) {
      map['social_security'] = Variable<double>(socialSecurity.value);
    }
    if (incomeTax.present) {
      map['income_tax'] = Variable<double>(incomeTax.value);
    }
    if (clothingDeduction.present) {
      map['clothing_deduction'] = Variable<double>(clothingDeduction.value);
    }
    if (utilityDeduction.present) {
      map['utility_deduction'] = Variable<double>(utilityDeduction.value);
    }
    if (riceDeduction.present) {
      map['rice_deduction'] = Variable<double>(riceDeduction.value);
    }
    if (foodRateDeduction.present) {
      map['food_rate_deduction'] = Variable<double>(foodRateDeduction.value);
    }
    if (tenPercentDeduction.present) {
      map['ten_percent_deduction'] = Variable<double>(
        tenPercentDeduction.value,
      );
    }
    if (totalDeductions.present) {
      map['total_deductions'] = Variable<double>(totalDeductions.value);
    }
    if (netPay.present) {
      map['net_pay'] = Variable<double>(netPay.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('rankSalary: $rankSalary, ')
          ..write('dutyAllowance: $dutyAllowance, ')
          ..write('seniorityAllowance: $seniorityAllowance, ')
          ..write('militaryBonus: $militaryBonus, ')
          ..write('specialistAllowance: $specialistAllowance, ')
          ..write('nutritionAllowance: $nutritionAllowance, ')
          ..write('childrenAllowance: $childrenAllowance, ')
          ..write('wifeAllowance: $wifeAllowance, ')
          ..write('costOfLivingAllowance: $costOfLivingAllowance, ')
          ..write('professionalAllowance: $professionalAllowance, ')
          ..write('certificateAllowance: $certificateAllowance, ')
          ..write('extraMealAllowance: $extraMealAllowance, ')
          ..write('totalIncome: $totalIncome, ')
          ..write('socialSecurity: $socialSecurity, ')
          ..write('incomeTax: $incomeTax, ')
          ..write('clothingDeduction: $clothingDeduction, ')
          ..write('utilityDeduction: $utilityDeduction, ')
          ..write('riceDeduction: $riceDeduction, ')
          ..write('foodRateDeduction: $foodRateDeduction, ')
          ..write('tenPercentDeduction: $tenPercentDeduction, ')
          ..write('totalDeductions: $totalDeductions, ')
          ..write('netPay: $netPay, ')
          ..write('note: $note, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }
}

class $FinanceTransactionsTable extends FinanceTransactions
    with TableInfo<$FinanceTransactionsTable, FinanceTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinanceTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    category,
    amount,
    description,
    transactionDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finance_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinanceTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FinanceTransactionsTable createAlias(String alias) {
    return $FinanceTransactionsTable(attachedDatabase, alias);
  }
}

class FinanceTransaction extends DataClass
    implements Insertable<FinanceTransaction> {
  final int id;
  final String type;
  final String category;
  final double amount;
  final String? description;
  final DateTime transactionDate;
  final DateTime createdAt;
  const FinanceTransaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    required this.transactionDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FinanceTransactionsCompanion toCompanion(bool nullToAbsent) {
    return FinanceTransactionsCompanion(
      id: Value(id),
      type: Value(type),
      category: Value(category),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      transactionDate: Value(transactionDate),
      createdAt: Value(createdAt),
    );
  }

  factory FinanceTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceTransaction(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FinanceTransaction copyWith({
    int? id,
    String? type,
    String? category,
    double? amount,
    Value<String?> description = const Value.absent(),
    DateTime? transactionDate,
    DateTime? createdAt,
  }) => FinanceTransaction(
    id: id ?? this.id,
    type: type ?? this.type,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
    transactionDate: transactionDate ?? this.transactionDate,
    createdAt: createdAt ?? this.createdAt,
  );
  FinanceTransaction copyWithCompanion(FinanceTransactionsCompanion data) {
    return FinanceTransaction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransaction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    category,
    amount,
    description,
    transactionDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceTransaction &&
          other.id == this.id &&
          other.type == this.type &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.transactionDate == this.transactionDate &&
          other.createdAt == this.createdAt);
}

class FinanceTransactionsCompanion extends UpdateCompanion<FinanceTransaction> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> description;
  final Value<DateTime> transactionDate;
  final Value<DateTime> createdAt;
  const FinanceTransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FinanceTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String category,
    required double amount,
    this.description = const Value.absent(),
    required DateTime transactionDate,
    this.createdAt = const Value.absent(),
  }) : type = Value(type),
       category = Value(category),
       amount = Value(amount),
       transactionDate = Value(transactionDate);
  static Insertable<FinanceTransaction> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FinanceTransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? category,
    Value<double>? amount,
    Value<String?>? description,
    Value<DateTime>? transactionDate,
    Value<DateTime>? createdAt,
  }) {
    return FinanceTransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PositionsTable positions = $PositionsTable(this);
  late final $MilitaryRanksTable militaryRanks = $MilitaryRanksTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $AttendanceTable attendance = $AttendanceTable(this);
  late final $LeavesTable leaves = $LeavesTable(this);
  late final $PayrollTable payroll = $PayrollTable(this);
  late final $FinanceTransactionsTable financeTransactions =
      $FinanceTransactionsTable(this);
  late final PositionDao positionDao = PositionDao(this as AppDatabase);
  late final MilitaryRankDao militaryRankDao = MilitaryRankDao(
    this as AppDatabase,
  );
  late final EmployeeDao employeeDao = EmployeeDao(this as AppDatabase);
  late final AttendanceDao attendanceDao = AttendanceDao(this as AppDatabase);
  late final LeaveDao leaveDao = LeaveDao(this as AppDatabase);
  late final PayrollDao payrollDao = PayrollDao(this as AppDatabase);
  late final FinanceDao financeDao = FinanceDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    positions,
    militaryRanks,
    employees,
    attendance,
    leaves,
    payroll,
    financeTransactions,
  ];
}

typedef $$PositionsTableCreateCompanionBuilder =
    PositionsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<DateTime> createdAt,
    });
typedef $$PositionsTableUpdateCompanionBuilder =
    PositionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<DateTime> createdAt,
    });

final class $$PositionsTableReferences
    extends BaseReferences<_$AppDatabase, $PositionsTable, Position> {
  $$PositionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmployeesTable, List<Employee>>
  _employeesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.employees,
    aliasName: 'positions__id__employees__position_id',
  );

  $$EmployeesTableProcessedTableManager get employeesRefs {
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.positionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_employeesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PositionsTableFilterComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> employeesRefs(
    Expression<bool> Function($$EmployeesTableFilterComposer f) f,
  ) {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> employeesRefs<T extends Object>(
    Expression<T> Function($$EmployeesTableAnnotationComposer a) f,
  ) {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PositionsTable,
          Position,
          $$PositionsTableFilterComposer,
          $$PositionsTableOrderingComposer,
          $$PositionsTableAnnotationComposer,
          $$PositionsTableCreateCompanionBuilder,
          $$PositionsTableUpdateCompanionBuilder,
          (Position, $$PositionsTableReferences),
          Position,
          PrefetchHooks Function({bool employeesRefs})
        > {
  $$PositionsTableTableManager(_$AppDatabase db, $PositionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PositionsCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PositionsCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PositionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (employeesRefs) db.employees],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (employeesRefs)
                    await $_getPrefetchedData<
                      Position,
                      $PositionsTable,
                      Employee
                    >(
                      currentTable: table,
                      referencedTable: $$PositionsTableReferences
                          ._employeesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PositionsTableReferences(
                            db,
                            table,
                            p0,
                          ).employeesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.positionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PositionsTable,
      Position,
      $$PositionsTableFilterComposer,
      $$PositionsTableOrderingComposer,
      $$PositionsTableAnnotationComposer,
      $$PositionsTableCreateCompanionBuilder,
      $$PositionsTableUpdateCompanionBuilder,
      (Position, $$PositionsTableReferences),
      Position,
      PrefetchHooks Function({bool employeesRefs})
    >;
typedef $$MilitaryRanksTableCreateCompanionBuilder =
    MilitaryRanksCompanion Function({
      Value<int> id,
      required String code,
      required String name,
      Value<String?> description,
      Value<int> level,
      Value<DateTime> createdAt,
    });
typedef $$MilitaryRanksTableUpdateCompanionBuilder =
    MilitaryRanksCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> name,
      Value<String?> description,
      Value<int> level,
      Value<DateTime> createdAt,
    });

final class $$MilitaryRanksTableReferences
    extends BaseReferences<_$AppDatabase, $MilitaryRanksTable, MilitaryRank> {
  $$MilitaryRanksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EmployeesTable, List<Employee>>
  _employeesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.employees,
    aliasName: 'military_ranks__id__employees__military_rank_id',
  );

  $$EmployeesTableProcessedTableManager get employeesRefs {
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.militaryRankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_employeesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MilitaryRanksTableFilterComposer
    extends Composer<_$AppDatabase, $MilitaryRanksTable> {
  $$MilitaryRanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> employeesRefs(
    Expression<bool> Function($$EmployeesTableFilterComposer f) f,
  ) {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.militaryRankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MilitaryRanksTableOrderingComposer
    extends Composer<_$AppDatabase, $MilitaryRanksTable> {
  $$MilitaryRanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MilitaryRanksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilitaryRanksTable> {
  $$MilitaryRanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> employeesRefs<T extends Object>(
    Expression<T> Function($$EmployeesTableAnnotationComposer a) f,
  ) {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.militaryRankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MilitaryRanksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilitaryRanksTable,
          MilitaryRank,
          $$MilitaryRanksTableFilterComposer,
          $$MilitaryRanksTableOrderingComposer,
          $$MilitaryRanksTableAnnotationComposer,
          $$MilitaryRanksTableCreateCompanionBuilder,
          $$MilitaryRanksTableUpdateCompanionBuilder,
          (MilitaryRank, $$MilitaryRanksTableReferences),
          MilitaryRank,
          PrefetchHooks Function({bool employeesRefs})
        > {
  $$MilitaryRanksTableTableManager(_$AppDatabase db, $MilitaryRanksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilitaryRanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilitaryRanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilitaryRanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MilitaryRanksCompanion(
                id: id,
                code: code,
                name: name,
                description: description,
                level: level,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MilitaryRanksCompanion.insert(
                id: id,
                code: code,
                name: name,
                description: description,
                level: level,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MilitaryRanksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (employeesRefs) db.employees],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (employeesRefs)
                    await $_getPrefetchedData<
                      MilitaryRank,
                      $MilitaryRanksTable,
                      Employee
                    >(
                      currentTable: table,
                      referencedTable: $$MilitaryRanksTableReferences
                          ._employeesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MilitaryRanksTableReferences(
                            db,
                            table,
                            p0,
                          ).employeesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.militaryRankId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MilitaryRanksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilitaryRanksTable,
      MilitaryRank,
      $$MilitaryRanksTableFilterComposer,
      $$MilitaryRanksTableOrderingComposer,
      $$MilitaryRanksTableAnnotationComposer,
      $$MilitaryRanksTableCreateCompanionBuilder,
      $$MilitaryRanksTableUpdateCompanionBuilder,
      (MilitaryRank, $$MilitaryRanksTableReferences),
      MilitaryRank,
      PrefetchHooks Function({bool employeesRefs})
    >;
typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      required String employeeCode,
      required String firstName,
      required String lastName,
      required String gender,
      Value<DateTime?> birthDate,
      Value<String?> phone,
      Value<String?> address,
      Value<int?> positionId,
      Value<int?> militaryRankId,
      required DateTime hireDate,
      Value<double> salary,
      Value<String> status,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String> employeeCode,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> gender,
      Value<DateTime?> birthDate,
      Value<String?> phone,
      Value<String?> address,
      Value<int?> positionId,
      Value<int?> militaryRankId,
      Value<DateTime> hireDate,
      Value<double> salary,
      Value<String> status,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PositionsTable _positionIdTable(_$AppDatabase db) =>
      db.positions.createAlias('employees__position_id__positions__id');

  $$PositionsTableProcessedTableManager? get positionId {
    final $_column = $_itemColumn<int>('position_id');
    if ($_column == null) return null;
    final manager = $$PositionsTableTableManager(
      $_db,
      $_db.positions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_positionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MilitaryRanksTable _militaryRankIdTable(_$AppDatabase db) => db
      .militaryRanks
      .createAlias('employees__military_rank_id__military_ranks__id');

  $$MilitaryRanksTableProcessedTableManager? get militaryRankId {
    final $_column = $_itemColumn<int>('military_rank_id');
    if ($_column == null) return null;
    final manager = $$MilitaryRanksTableTableManager(
      $_db,
      $_db.militaryRanks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_militaryRankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceRecord>>
  _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: 'employees__id__attendance__employee_id',
  );

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LeavesTable, List<Leave>> _leavesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.leaves,
    aliasName: 'employees__id__leaves__employee_id',
  );

  $$LeavesTableProcessedTableManager get leavesRefs {
    final manager = $$LeavesTableTableManager(
      $_db,
      $_db.leaves,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_leavesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PayrollTable, List<PayrollRecord>>
  _payrollRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.payroll,
    aliasName: 'employees__id__payroll__employee_id',
  );

  $$PayrollTableProcessedTableManager get payrollRefs {
    final manager = $$PayrollTableTableManager(
      $_db,
      $_db.payroll,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_payrollRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeCode => $composableBuilder(
    column: $table.employeeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salary => $composableBuilder(
    column: $table.salary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PositionsTableFilterComposer get positionId {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableFilterComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MilitaryRanksTableFilterComposer get militaryRankId {
    final $$MilitaryRanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.militaryRankId,
      referencedTable: $db.militaryRanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilitaryRanksTableFilterComposer(
            $db: $db,
            $table: $db.militaryRanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> attendanceRefs(
    Expression<bool> Function($$AttendanceTableFilterComposer f) f,
  ) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> leavesRefs(
    Expression<bool> Function($$LeavesTableFilterComposer f) f,
  ) {
    final $$LeavesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaves,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeavesTableFilterComposer(
            $db: $db,
            $table: $db.leaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> payrollRefs(
    Expression<bool> Function($$PayrollTableFilterComposer f) f,
  ) {
    final $$PayrollTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payroll,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayrollTableFilterComposer(
            $db: $db,
            $table: $db.payroll,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeCode => $composableBuilder(
    column: $table.employeeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salary => $composableBuilder(
    column: $table.salary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PositionsTableOrderingComposer get positionId {
    final $$PositionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableOrderingComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MilitaryRanksTableOrderingComposer get militaryRankId {
    final $$MilitaryRanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.militaryRankId,
      referencedTable: $db.militaryRanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilitaryRanksTableOrderingComposer(
            $db: $db,
            $table: $db.militaryRanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeCode => $composableBuilder(
    column: $table.employeeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get hireDate =>
      $composableBuilder(column: $table.hireDate, builder: (column) => column);

  GeneratedColumn<double> get salary =>
      $composableBuilder(column: $table.salary, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PositionsTableAnnotationComposer get positionId {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableAnnotationComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MilitaryRanksTableAnnotationComposer get militaryRankId {
    final $$MilitaryRanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.militaryRankId,
      referencedTable: $db.militaryRanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilitaryRanksTableAnnotationComposer(
            $db: $db,
            $table: $db.militaryRanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($$AttendanceTableAnnotationComposer a) f,
  ) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> leavesRefs<T extends Object>(
    Expression<T> Function($$LeavesTableAnnotationComposer a) f,
  ) {
    final $$LeavesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaves,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeavesTableAnnotationComposer(
            $db: $db,
            $table: $db.leaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> payrollRefs<T extends Object>(
    Expression<T> Function($$PayrollTableAnnotationComposer a) f,
  ) {
    final $$PayrollTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payroll,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayrollTableAnnotationComposer(
            $db: $db,
            $table: $db.payroll,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTable,
          Employee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (Employee, $$EmployeesTableReferences),
          Employee,
          PrefetchHooks Function({
            bool positionId,
            bool militaryRankId,
            bool attendanceRefs,
            bool leavesRefs,
            bool payrollRefs,
          })
        > {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> employeeCode = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int?> positionId = const Value.absent(),
                Value<int?> militaryRankId = const Value.absent(),
                Value<DateTime> hireDate = const Value.absent(),
                Value<double> salary = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                employeeCode: employeeCode,
                firstName: firstName,
                lastName: lastName,
                gender: gender,
                birthDate: birthDate,
                phone: phone,
                address: address,
                positionId: positionId,
                militaryRankId: militaryRankId,
                hireDate: hireDate,
                salary: salary,
                status: status,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String employeeCode,
                required String firstName,
                required String lastName,
                required String gender,
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int?> positionId = const Value.absent(),
                Value<int?> militaryRankId = const Value.absent(),
                required DateTime hireDate,
                Value<double> salary = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                employeeCode: employeeCode,
                firstName: firstName,
                lastName: lastName,
                gender: gender,
                birthDate: birthDate,
                phone: phone,
                address: address,
                positionId: positionId,
                militaryRankId: militaryRankId,
                hireDate: hireDate,
                salary: salary,
                status: status,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                positionId = false,
                militaryRankId = false,
                attendanceRefs = false,
                leavesRefs = false,
                payrollRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (attendanceRefs) db.attendance,
                    if (leavesRefs) db.leaves,
                    if (payrollRefs) db.payroll,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (positionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.positionId,
                                    referencedTable: $$EmployeesTableReferences
                                        ._positionIdTable(db),
                                    referencedColumn: $$EmployeesTableReferences
                                        ._positionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (militaryRankId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.militaryRankId,
                                    referencedTable: $$EmployeesTableReferences
                                        ._militaryRankIdTable(db),
                                    referencedColumn: $$EmployeesTableReferences
                                        ._militaryRankIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (attendanceRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          AttendanceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._attendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (leavesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Leave
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._leavesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).leavesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (payrollRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          PayrollRecord
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._payrollRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).payrollRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTable,
      Employee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (Employee, $$EmployeesTableReferences),
      Employee,
      PrefetchHooks Function({
        bool positionId,
        bool militaryRankId,
        bool attendanceRefs,
        bool leavesRefs,
        bool payrollRefs,
      })
    >;
typedef $$AttendanceTableCreateCompanionBuilder =
    AttendanceCompanion Function({
      Value<int> id,
      required int employeeId,
      required DateTime date,
      Value<DateTime?> checkIn,
      Value<DateTime?> checkOut,
      required String status,
      Value<String?> note,
    });
typedef $$AttendanceTableUpdateCompanionBuilder =
    AttendanceCompanion Function({
      Value<int> id,
      Value<int> employeeId,
      Value<DateTime> date,
      Value<DateTime?> checkIn,
      Value<DateTime?> checkOut,
      Value<String> status,
      Value<String?> note,
    });

final class $$AttendanceTableReferences
    extends BaseReferences<_$AppDatabase, $AttendanceTable, AttendanceRecord> {
  $$AttendanceTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias('attendance__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkIn => $composableBuilder(
    column: $table.checkIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkOut => $composableBuilder(
    column: $table.checkOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkIn => $composableBuilder(
    column: $table.checkIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkOut => $composableBuilder(
    column: $table.checkOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get checkIn =>
      $composableBuilder(column: $table.checkIn, builder: (column) => column);

  GeneratedColumn<DateTime> get checkOut =>
      $composableBuilder(column: $table.checkOut, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceTable,
          AttendanceRecord,
          $$AttendanceTableFilterComposer,
          $$AttendanceTableOrderingComposer,
          $$AttendanceTableAnnotationComposer,
          $$AttendanceTableCreateCompanionBuilder,
          $$AttendanceTableUpdateCompanionBuilder,
          (AttendanceRecord, $$AttendanceTableReferences),
          AttendanceRecord,
          PrefetchHooks Function({bool employeeId})
        > {
  $$AttendanceTableTableManager(_$AppDatabase db, $AttendanceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> checkIn = const Value.absent(),
                Value<DateTime?> checkOut = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => AttendanceCompanion(
                id: id,
                employeeId: employeeId,
                date: date,
                checkIn: checkIn,
                checkOut: checkOut,
                status: status,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int employeeId,
                required DateTime date,
                Value<DateTime?> checkIn = const Value.absent(),
                Value<DateTime?> checkOut = const Value.absent(),
                required String status,
                Value<String?> note = const Value.absent(),
              }) => AttendanceCompanion.insert(
                id: id,
                employeeId: employeeId,
                date: date,
                checkIn: checkIn,
                checkOut: checkOut,
                status: status,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttendanceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$AttendanceTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$AttendanceTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceTable,
      AttendanceRecord,
      $$AttendanceTableFilterComposer,
      $$AttendanceTableOrderingComposer,
      $$AttendanceTableAnnotationComposer,
      $$AttendanceTableCreateCompanionBuilder,
      $$AttendanceTableUpdateCompanionBuilder,
      (AttendanceRecord, $$AttendanceTableReferences),
      AttendanceRecord,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$LeavesTableCreateCompanionBuilder =
    LeavesCompanion Function({
      Value<int> id,
      required int employeeId,
      required String leaveType,
      required DateTime startDate,
      required DateTime endDate,
      required int totalDays,
      Value<String?> reason,
      Value<String> approvalStatus,
      Value<String?> approvedBy,
      Value<DateTime> createdAt,
    });
typedef $$LeavesTableUpdateCompanionBuilder =
    LeavesCompanion Function({
      Value<int> id,
      Value<int> employeeId,
      Value<String> leaveType,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> totalDays,
      Value<String?> reason,
      Value<String> approvalStatus,
      Value<String?> approvedBy,
      Value<DateTime> createdAt,
    });

final class $$LeavesTableReferences
    extends BaseReferences<_$AppDatabase, $LeavesTable, Leave> {
  $$LeavesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias('leaves__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LeavesTableFilterComposer
    extends Composer<_$AppDatabase, $LeavesTable> {
  $$LeavesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvalStatus => $composableBuilder(
    column: $table.approvalStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeavesTableOrderingComposer
    extends Composer<_$AppDatabase, $LeavesTable> {
  $$LeavesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvalStatus => $composableBuilder(
    column: $table.approvalStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeavesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeavesTable> {
  $$LeavesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get leaveType =>
      $composableBuilder(column: $table.leaveType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get totalDays =>
      $composableBuilder(column: $table.totalDays, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get approvalStatus => $composableBuilder(
    column: $table.approvalStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeavesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeavesTable,
          Leave,
          $$LeavesTableFilterComposer,
          $$LeavesTableOrderingComposer,
          $$LeavesTableAnnotationComposer,
          $$LeavesTableCreateCompanionBuilder,
          $$LeavesTableUpdateCompanionBuilder,
          (Leave, $$LeavesTableReferences),
          Leave,
          PrefetchHooks Function({bool employeeId})
        > {
  $$LeavesTableTableManager(_$AppDatabase db, $LeavesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeavesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeavesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeavesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<String> leaveType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String> approvalStatus = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LeavesCompanion(
                id: id,
                employeeId: employeeId,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                totalDays: totalDays,
                reason: reason,
                approvalStatus: approvalStatus,
                approvedBy: approvedBy,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int employeeId,
                required String leaveType,
                required DateTime startDate,
                required DateTime endDate,
                required int totalDays,
                Value<String?> reason = const Value.absent(),
                Value<String> approvalStatus = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LeavesCompanion.insert(
                id: id,
                employeeId: employeeId,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                totalDays: totalDays,
                reason: reason,
                approvalStatus: approvalStatus,
                approvedBy: approvedBy,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LeavesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$LeavesTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$LeavesTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LeavesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeavesTable,
      Leave,
      $$LeavesTableFilterComposer,
      $$LeavesTableOrderingComposer,
      $$LeavesTableAnnotationComposer,
      $$LeavesTableCreateCompanionBuilder,
      $$LeavesTableUpdateCompanionBuilder,
      (Leave, $$LeavesTableReferences),
      Leave,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$PayrollTableCreateCompanionBuilder =
    PayrollCompanion Function({
      Value<int> id,
      required int employeeId,
      required int month,
      required int year,
      Value<double> rankSalary,
      Value<double> dutyAllowance,
      Value<double> seniorityAllowance,
      Value<double> militaryBonus,
      Value<double> specialistAllowance,
      Value<double> nutritionAllowance,
      Value<double> childrenAllowance,
      Value<double> wifeAllowance,
      Value<double> costOfLivingAllowance,
      Value<double> professionalAllowance,
      Value<double> certificateAllowance,
      Value<double> extraMealAllowance,
      Value<double> totalIncome,
      Value<double> socialSecurity,
      Value<double> incomeTax,
      Value<double> clothingDeduction,
      Value<double> utilityDeduction,
      Value<double> riceDeduction,
      Value<double> foodRateDeduction,
      Value<double> tenPercentDeduction,
      Value<double> totalDeductions,
      Value<double> netPay,
      Value<String?> note,
      Value<DateTime> generatedAt,
    });
typedef $$PayrollTableUpdateCompanionBuilder =
    PayrollCompanion Function({
      Value<int> id,
      Value<int> employeeId,
      Value<int> month,
      Value<int> year,
      Value<double> rankSalary,
      Value<double> dutyAllowance,
      Value<double> seniorityAllowance,
      Value<double> militaryBonus,
      Value<double> specialistAllowance,
      Value<double> nutritionAllowance,
      Value<double> childrenAllowance,
      Value<double> wifeAllowance,
      Value<double> costOfLivingAllowance,
      Value<double> professionalAllowance,
      Value<double> certificateAllowance,
      Value<double> extraMealAllowance,
      Value<double> totalIncome,
      Value<double> socialSecurity,
      Value<double> incomeTax,
      Value<double> clothingDeduction,
      Value<double> utilityDeduction,
      Value<double> riceDeduction,
      Value<double> foodRateDeduction,
      Value<double> tenPercentDeduction,
      Value<double> totalDeductions,
      Value<double> netPay,
      Value<String?> note,
      Value<DateTime> generatedAt,
    });

final class $$PayrollTableReferences
    extends BaseReferences<_$AppDatabase, $PayrollTable, PayrollRecord> {
  $$PayrollTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias('payroll__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PayrollTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollTable> {
  $$PayrollTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rankSalary => $composableBuilder(
    column: $table.rankSalary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dutyAllowance => $composableBuilder(
    column: $table.dutyAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get seniorityAllowance => $composableBuilder(
    column: $table.seniorityAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get militaryBonus => $composableBuilder(
    column: $table.militaryBonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get specialistAllowance => $composableBuilder(
    column: $table.specialistAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nutritionAllowance => $composableBuilder(
    column: $table.nutritionAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get childrenAllowance => $composableBuilder(
    column: $table.childrenAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wifeAllowance => $composableBuilder(
    column: $table.wifeAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costOfLivingAllowance => $composableBuilder(
    column: $table.costOfLivingAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get professionalAllowance => $composableBuilder(
    column: $table.professionalAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get certificateAllowance => $composableBuilder(
    column: $table.certificateAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get extraMealAllowance => $composableBuilder(
    column: $table.extraMealAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get socialSecurity => $composableBuilder(
    column: $table.socialSecurity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get incomeTax => $composableBuilder(
    column: $table.incomeTax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get clothingDeduction => $composableBuilder(
    column: $table.clothingDeduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get utilityDeduction => $composableBuilder(
    column: $table.utilityDeduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get riceDeduction => $composableBuilder(
    column: $table.riceDeduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get foodRateDeduction => $composableBuilder(
    column: $table.foodRateDeduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tenPercentDeduction => $composableBuilder(
    column: $table.tenPercentDeduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDeductions => $composableBuilder(
    column: $table.totalDeductions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get netPay => $composableBuilder(
    column: $table.netPay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayrollTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollTable> {
  $$PayrollTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rankSalary => $composableBuilder(
    column: $table.rankSalary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dutyAllowance => $composableBuilder(
    column: $table.dutyAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get seniorityAllowance => $composableBuilder(
    column: $table.seniorityAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get militaryBonus => $composableBuilder(
    column: $table.militaryBonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get specialistAllowance => $composableBuilder(
    column: $table.specialistAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nutritionAllowance => $composableBuilder(
    column: $table.nutritionAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get childrenAllowance => $composableBuilder(
    column: $table.childrenAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wifeAllowance => $composableBuilder(
    column: $table.wifeAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costOfLivingAllowance => $composableBuilder(
    column: $table.costOfLivingAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get professionalAllowance => $composableBuilder(
    column: $table.professionalAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get certificateAllowance => $composableBuilder(
    column: $table.certificateAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get extraMealAllowance => $composableBuilder(
    column: $table.extraMealAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get socialSecurity => $composableBuilder(
    column: $table.socialSecurity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get incomeTax => $composableBuilder(
    column: $table.incomeTax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get clothingDeduction => $composableBuilder(
    column: $table.clothingDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get utilityDeduction => $composableBuilder(
    column: $table.utilityDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get riceDeduction => $composableBuilder(
    column: $table.riceDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get foodRateDeduction => $composableBuilder(
    column: $table.foodRateDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tenPercentDeduction => $composableBuilder(
    column: $table.tenPercentDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDeductions => $composableBuilder(
    column: $table.totalDeductions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get netPay => $composableBuilder(
    column: $table.netPay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayrollTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollTable> {
  $$PayrollTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<double> get rankSalary => $composableBuilder(
    column: $table.rankSalary,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dutyAllowance => $composableBuilder(
    column: $table.dutyAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get seniorityAllowance => $composableBuilder(
    column: $table.seniorityAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get militaryBonus => $composableBuilder(
    column: $table.militaryBonus,
    builder: (column) => column,
  );

  GeneratedColumn<double> get specialistAllowance => $composableBuilder(
    column: $table.specialistAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nutritionAllowance => $composableBuilder(
    column: $table.nutritionAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get childrenAllowance => $composableBuilder(
    column: $table.childrenAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wifeAllowance => $composableBuilder(
    column: $table.wifeAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costOfLivingAllowance => $composableBuilder(
    column: $table.costOfLivingAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get professionalAllowance => $composableBuilder(
    column: $table.professionalAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get certificateAllowance => $composableBuilder(
    column: $table.certificateAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get extraMealAllowance => $composableBuilder(
    column: $table.extraMealAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => column,
  );

  GeneratedColumn<double> get socialSecurity => $composableBuilder(
    column: $table.socialSecurity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get incomeTax =>
      $composableBuilder(column: $table.incomeTax, builder: (column) => column);

  GeneratedColumn<double> get clothingDeduction => $composableBuilder(
    column: $table.clothingDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get utilityDeduction => $composableBuilder(
    column: $table.utilityDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get riceDeduction => $composableBuilder(
    column: $table.riceDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get foodRateDeduction => $composableBuilder(
    column: $table.foodRateDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tenPercentDeduction => $composableBuilder(
    column: $table.tenPercentDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalDeductions => $composableBuilder(
    column: $table.totalDeductions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get netPay =>
      $composableBuilder(column: $table.netPay, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayrollTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayrollTable,
          PayrollRecord,
          $$PayrollTableFilterComposer,
          $$PayrollTableOrderingComposer,
          $$PayrollTableAnnotationComposer,
          $$PayrollTableCreateCompanionBuilder,
          $$PayrollTableUpdateCompanionBuilder,
          (PayrollRecord, $$PayrollTableReferences),
          PayrollRecord,
          PrefetchHooks Function({bool employeeId})
        > {
  $$PayrollTableTableManager(_$AppDatabase db, $PayrollTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<double> rankSalary = const Value.absent(),
                Value<double> dutyAllowance = const Value.absent(),
                Value<double> seniorityAllowance = const Value.absent(),
                Value<double> militaryBonus = const Value.absent(),
                Value<double> specialistAllowance = const Value.absent(),
                Value<double> nutritionAllowance = const Value.absent(),
                Value<double> childrenAllowance = const Value.absent(),
                Value<double> wifeAllowance = const Value.absent(),
                Value<double> costOfLivingAllowance = const Value.absent(),
                Value<double> professionalAllowance = const Value.absent(),
                Value<double> certificateAllowance = const Value.absent(),
                Value<double> extraMealAllowance = const Value.absent(),
                Value<double> totalIncome = const Value.absent(),
                Value<double> socialSecurity = const Value.absent(),
                Value<double> incomeTax = const Value.absent(),
                Value<double> clothingDeduction = const Value.absent(),
                Value<double> utilityDeduction = const Value.absent(),
                Value<double> riceDeduction = const Value.absent(),
                Value<double> foodRateDeduction = const Value.absent(),
                Value<double> tenPercentDeduction = const Value.absent(),
                Value<double> totalDeductions = const Value.absent(),
                Value<double> netPay = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
              }) => PayrollCompanion(
                id: id,
                employeeId: employeeId,
                month: month,
                year: year,
                rankSalary: rankSalary,
                dutyAllowance: dutyAllowance,
                seniorityAllowance: seniorityAllowance,
                militaryBonus: militaryBonus,
                specialistAllowance: specialistAllowance,
                nutritionAllowance: nutritionAllowance,
                childrenAllowance: childrenAllowance,
                wifeAllowance: wifeAllowance,
                costOfLivingAllowance: costOfLivingAllowance,
                professionalAllowance: professionalAllowance,
                certificateAllowance: certificateAllowance,
                extraMealAllowance: extraMealAllowance,
                totalIncome: totalIncome,
                socialSecurity: socialSecurity,
                incomeTax: incomeTax,
                clothingDeduction: clothingDeduction,
                utilityDeduction: utilityDeduction,
                riceDeduction: riceDeduction,
                foodRateDeduction: foodRateDeduction,
                tenPercentDeduction: tenPercentDeduction,
                totalDeductions: totalDeductions,
                netPay: netPay,
                note: note,
                generatedAt: generatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int employeeId,
                required int month,
                required int year,
                Value<double> rankSalary = const Value.absent(),
                Value<double> dutyAllowance = const Value.absent(),
                Value<double> seniorityAllowance = const Value.absent(),
                Value<double> militaryBonus = const Value.absent(),
                Value<double> specialistAllowance = const Value.absent(),
                Value<double> nutritionAllowance = const Value.absent(),
                Value<double> childrenAllowance = const Value.absent(),
                Value<double> wifeAllowance = const Value.absent(),
                Value<double> costOfLivingAllowance = const Value.absent(),
                Value<double> professionalAllowance = const Value.absent(),
                Value<double> certificateAllowance = const Value.absent(),
                Value<double> extraMealAllowance = const Value.absent(),
                Value<double> totalIncome = const Value.absent(),
                Value<double> socialSecurity = const Value.absent(),
                Value<double> incomeTax = const Value.absent(),
                Value<double> clothingDeduction = const Value.absent(),
                Value<double> utilityDeduction = const Value.absent(),
                Value<double> riceDeduction = const Value.absent(),
                Value<double> foodRateDeduction = const Value.absent(),
                Value<double> tenPercentDeduction = const Value.absent(),
                Value<double> totalDeductions = const Value.absent(),
                Value<double> netPay = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
              }) => PayrollCompanion.insert(
                id: id,
                employeeId: employeeId,
                month: month,
                year: year,
                rankSalary: rankSalary,
                dutyAllowance: dutyAllowance,
                seniorityAllowance: seniorityAllowance,
                militaryBonus: militaryBonus,
                specialistAllowance: specialistAllowance,
                nutritionAllowance: nutritionAllowance,
                childrenAllowance: childrenAllowance,
                wifeAllowance: wifeAllowance,
                costOfLivingAllowance: costOfLivingAllowance,
                professionalAllowance: professionalAllowance,
                certificateAllowance: certificateAllowance,
                extraMealAllowance: extraMealAllowance,
                totalIncome: totalIncome,
                socialSecurity: socialSecurity,
                incomeTax: incomeTax,
                clothingDeduction: clothingDeduction,
                utilityDeduction: utilityDeduction,
                riceDeduction: riceDeduction,
                foodRateDeduction: foodRateDeduction,
                tenPercentDeduction: tenPercentDeduction,
                totalDeductions: totalDeductions,
                netPay: netPay,
                note: note,
                generatedAt: generatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PayrollTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$PayrollTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$PayrollTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PayrollTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayrollTable,
      PayrollRecord,
      $$PayrollTableFilterComposer,
      $$PayrollTableOrderingComposer,
      $$PayrollTableAnnotationComposer,
      $$PayrollTableCreateCompanionBuilder,
      $$PayrollTableUpdateCompanionBuilder,
      (PayrollRecord, $$PayrollTableReferences),
      PayrollRecord,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$FinanceTransactionsTableCreateCompanionBuilder =
    FinanceTransactionsCompanion Function({
      Value<int> id,
      required String type,
      required String category,
      required double amount,
      Value<String?> description,
      required DateTime transactionDate,
      Value<DateTime> createdAt,
    });
typedef $$FinanceTransactionsTableUpdateCompanionBuilder =
    FinanceTransactionsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> category,
      Value<double> amount,
      Value<String?> description,
      Value<DateTime> transactionDate,
      Value<DateTime> createdAt,
    });

class $$FinanceTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $FinanceTransactionsTable> {
  $$FinanceTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinanceTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinanceTransactionsTable> {
  $$FinanceTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinanceTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinanceTransactionsTable> {
  $$FinanceTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FinanceTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinanceTransactionsTable,
          FinanceTransaction,
          $$FinanceTransactionsTableFilterComposer,
          $$FinanceTransactionsTableOrderingComposer,
          $$FinanceTransactionsTableAnnotationComposer,
          $$FinanceTransactionsTableCreateCompanionBuilder,
          $$FinanceTransactionsTableUpdateCompanionBuilder,
          (
            FinanceTransaction,
            BaseReferences<
              _$AppDatabase,
              $FinanceTransactionsTable,
              FinanceTransaction
            >,
          ),
          FinanceTransaction,
          PrefetchHooks Function()
        > {
  $$FinanceTransactionsTableTableManager(
    _$AppDatabase db,
    $FinanceTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinanceTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinanceTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FinanceTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FinanceTransactionsCompanion(
                id: id,
                type: type,
                category: category,
                amount: amount,
                description: description,
                transactionDate: transactionDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String category,
                required double amount,
                Value<String?> description = const Value.absent(),
                required DateTime transactionDate,
                Value<DateTime> createdAt = const Value.absent(),
              }) => FinanceTransactionsCompanion.insert(
                id: id,
                type: type,
                category: category,
                amount: amount,
                description: description,
                transactionDate: transactionDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinanceTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinanceTransactionsTable,
      FinanceTransaction,
      $$FinanceTransactionsTableFilterComposer,
      $$FinanceTransactionsTableOrderingComposer,
      $$FinanceTransactionsTableAnnotationComposer,
      $$FinanceTransactionsTableCreateCompanionBuilder,
      $$FinanceTransactionsTableUpdateCompanionBuilder,
      (
        FinanceTransaction,
        BaseReferences<
          _$AppDatabase,
          $FinanceTransactionsTable,
          FinanceTransaction
        >,
      ),
      FinanceTransaction,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db, _db.positions);
  $$MilitaryRanksTableTableManager get militaryRanks =>
      $$MilitaryRanksTableTableManager(_db, _db.militaryRanks);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$AttendanceTableTableManager get attendance =>
      $$AttendanceTableTableManager(_db, _db.attendance);
  $$LeavesTableTableManager get leaves =>
      $$LeavesTableTableManager(_db, _db.leaves);
  $$PayrollTableTableManager get payroll =>
      $$PayrollTableTableManager(_db, _db.payroll);
  $$FinanceTransactionsTableTableManager get financeTransactions =>
      $$FinanceTransactionsTableTableManager(_db, _db.financeTransactions);
}
