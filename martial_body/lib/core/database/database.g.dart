// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PhasesTable extends Phases with TableInfo<$PhasesTable, Phase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subtitleMeta =
      const VerificationMeta('subtitle');
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
      'subtitle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weeksStartMeta =
      const VerificationMeta('weeksStart');
  @override
  late final GeneratedColumn<int> weeksStart = GeneratedColumn<int>(
      'weeks_start', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weeksEndMeta =
      const VerificationMeta('weeksEnd');
  @override
  late final GeneratedColumn<int> weeksEnd = GeneratedColumn<int>(
      'weeks_end', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _intensityMinMeta =
      const VerificationMeta('intensityMin');
  @override
  late final GeneratedColumn<double> intensityMin = GeneratedColumn<double>(
      'intensity_min', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _intensityMaxMeta =
      const VerificationMeta('intensityMax');
  @override
  late final GeneratedColumn<double> intensityMax = GeneratedColumn<double>(
      'intensity_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _deloadWeeksMeta =
      const VerificationMeta('deloadWeeks');
  @override
  late final GeneratedColumn<String> deloadWeeks = GeneratedColumn<String>(
      'deload_weeks', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewTextMeta =
      const VerificationMeta('overviewText');
  @override
  late final GeneratedColumn<String> overviewText = GeneratedColumn<String>(
      'overview_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        number,
        name,
        subtitle,
        weeksStart,
        weeksEnd,
        intensityMin,
        intensityMax,
        deloadWeeks,
        overviewText
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'phases';
  @override
  VerificationContext validateIntegrity(Insertable<Phase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(_subtitleMeta,
          subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta));
    } else if (isInserting) {
      context.missing(_subtitleMeta);
    }
    if (data.containsKey('weeks_start')) {
      context.handle(
          _weeksStartMeta,
          weeksStart.isAcceptableOrUnknown(
              data['weeks_start']!, _weeksStartMeta));
    } else if (isInserting) {
      context.missing(_weeksStartMeta);
    }
    if (data.containsKey('weeks_end')) {
      context.handle(_weeksEndMeta,
          weeksEnd.isAcceptableOrUnknown(data['weeks_end']!, _weeksEndMeta));
    } else if (isInserting) {
      context.missing(_weeksEndMeta);
    }
    if (data.containsKey('intensity_min')) {
      context.handle(
          _intensityMinMeta,
          intensityMin.isAcceptableOrUnknown(
              data['intensity_min']!, _intensityMinMeta));
    } else if (isInserting) {
      context.missing(_intensityMinMeta);
    }
    if (data.containsKey('intensity_max')) {
      context.handle(
          _intensityMaxMeta,
          intensityMax.isAcceptableOrUnknown(
              data['intensity_max']!, _intensityMaxMeta));
    } else if (isInserting) {
      context.missing(_intensityMaxMeta);
    }
    if (data.containsKey('deload_weeks')) {
      context.handle(
          _deloadWeeksMeta,
          deloadWeeks.isAcceptableOrUnknown(
              data['deload_weeks']!, _deloadWeeksMeta));
    } else if (isInserting) {
      context.missing(_deloadWeeksMeta);
    }
    if (data.containsKey('overview_text')) {
      context.handle(
          _overviewTextMeta,
          overviewText.isAcceptableOrUnknown(
              data['overview_text']!, _overviewTextMeta));
    } else if (isInserting) {
      context.missing(_overviewTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Phase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Phase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      subtitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtitle'])!,
      weeksStart: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weeks_start'])!,
      weeksEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weeks_end'])!,
      intensityMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}intensity_min'])!,
      intensityMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}intensity_max'])!,
      deloadWeeks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deload_weeks'])!,
      overviewText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview_text'])!,
    );
  }

  @override
  $PhasesTable createAlias(String alias) {
    return $PhasesTable(attachedDatabase, alias);
  }
}

class Phase extends DataClass implements Insertable<Phase> {
  final int id;
  final int number;
  final String name;
  final String subtitle;
  final int weeksStart;
  final int weeksEnd;
  final double intensityMin;
  final double intensityMax;
  final String deloadWeeks;
  final String overviewText;
  const Phase(
      {required this.id,
      required this.number,
      required this.name,
      required this.subtitle,
      required this.weeksStart,
      required this.weeksEnd,
      required this.intensityMin,
      required this.intensityMax,
      required this.deloadWeeks,
      required this.overviewText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['name'] = Variable<String>(name);
    map['subtitle'] = Variable<String>(subtitle);
    map['weeks_start'] = Variable<int>(weeksStart);
    map['weeks_end'] = Variable<int>(weeksEnd);
    map['intensity_min'] = Variable<double>(intensityMin);
    map['intensity_max'] = Variable<double>(intensityMax);
    map['deload_weeks'] = Variable<String>(deloadWeeks);
    map['overview_text'] = Variable<String>(overviewText);
    return map;
  }

  PhasesCompanion toCompanion(bool nullToAbsent) {
    return PhasesCompanion(
      id: Value(id),
      number: Value(number),
      name: Value(name),
      subtitle: Value(subtitle),
      weeksStart: Value(weeksStart),
      weeksEnd: Value(weeksEnd),
      intensityMin: Value(intensityMin),
      intensityMax: Value(intensityMax),
      deloadWeeks: Value(deloadWeeks),
      overviewText: Value(overviewText),
    );
  }

  factory Phase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Phase(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      name: serializer.fromJson<String>(json['name']),
      subtitle: serializer.fromJson<String>(json['subtitle']),
      weeksStart: serializer.fromJson<int>(json['weeksStart']),
      weeksEnd: serializer.fromJson<int>(json['weeksEnd']),
      intensityMin: serializer.fromJson<double>(json['intensityMin']),
      intensityMax: serializer.fromJson<double>(json['intensityMax']),
      deloadWeeks: serializer.fromJson<String>(json['deloadWeeks']),
      overviewText: serializer.fromJson<String>(json['overviewText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'name': serializer.toJson<String>(name),
      'subtitle': serializer.toJson<String>(subtitle),
      'weeksStart': serializer.toJson<int>(weeksStart),
      'weeksEnd': serializer.toJson<int>(weeksEnd),
      'intensityMin': serializer.toJson<double>(intensityMin),
      'intensityMax': serializer.toJson<double>(intensityMax),
      'deloadWeeks': serializer.toJson<String>(deloadWeeks),
      'overviewText': serializer.toJson<String>(overviewText),
    };
  }

  Phase copyWith(
          {int? id,
          int? number,
          String? name,
          String? subtitle,
          int? weeksStart,
          int? weeksEnd,
          double? intensityMin,
          double? intensityMax,
          String? deloadWeeks,
          String? overviewText}) =>
      Phase(
        id: id ?? this.id,
        number: number ?? this.number,
        name: name ?? this.name,
        subtitle: subtitle ?? this.subtitle,
        weeksStart: weeksStart ?? this.weeksStart,
        weeksEnd: weeksEnd ?? this.weeksEnd,
        intensityMin: intensityMin ?? this.intensityMin,
        intensityMax: intensityMax ?? this.intensityMax,
        deloadWeeks: deloadWeeks ?? this.deloadWeeks,
        overviewText: overviewText ?? this.overviewText,
      );
  Phase copyWithCompanion(PhasesCompanion data) {
    return Phase(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      name: data.name.present ? data.name.value : this.name,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      weeksStart:
          data.weeksStart.present ? data.weeksStart.value : this.weeksStart,
      weeksEnd: data.weeksEnd.present ? data.weeksEnd.value : this.weeksEnd,
      intensityMin: data.intensityMin.present
          ? data.intensityMin.value
          : this.intensityMin,
      intensityMax: data.intensityMax.present
          ? data.intensityMax.value
          : this.intensityMax,
      deloadWeeks:
          data.deloadWeeks.present ? data.deloadWeeks.value : this.deloadWeeks,
      overviewText: data.overviewText.present
          ? data.overviewText.value
          : this.overviewText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Phase(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('weeksStart: $weeksStart, ')
          ..write('weeksEnd: $weeksEnd, ')
          ..write('intensityMin: $intensityMin, ')
          ..write('intensityMax: $intensityMax, ')
          ..write('deloadWeeks: $deloadWeeks, ')
          ..write('overviewText: $overviewText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, name, subtitle, weeksStart,
      weeksEnd, intensityMin, intensityMax, deloadWeeks, overviewText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Phase &&
          other.id == this.id &&
          other.number == this.number &&
          other.name == this.name &&
          other.subtitle == this.subtitle &&
          other.weeksStart == this.weeksStart &&
          other.weeksEnd == this.weeksEnd &&
          other.intensityMin == this.intensityMin &&
          other.intensityMax == this.intensityMax &&
          other.deloadWeeks == this.deloadWeeks &&
          other.overviewText == this.overviewText);
}

class PhasesCompanion extends UpdateCompanion<Phase> {
  final Value<int> id;
  final Value<int> number;
  final Value<String> name;
  final Value<String> subtitle;
  final Value<int> weeksStart;
  final Value<int> weeksEnd;
  final Value<double> intensityMin;
  final Value<double> intensityMax;
  final Value<String> deloadWeeks;
  final Value<String> overviewText;
  const PhasesCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.name = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.weeksStart = const Value.absent(),
    this.weeksEnd = const Value.absent(),
    this.intensityMin = const Value.absent(),
    this.intensityMax = const Value.absent(),
    this.deloadWeeks = const Value.absent(),
    this.overviewText = const Value.absent(),
  });
  PhasesCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required String name,
    required String subtitle,
    required int weeksStart,
    required int weeksEnd,
    required double intensityMin,
    required double intensityMax,
    required String deloadWeeks,
    required String overviewText,
  })  : number = Value(number),
        name = Value(name),
        subtitle = Value(subtitle),
        weeksStart = Value(weeksStart),
        weeksEnd = Value(weeksEnd),
        intensityMin = Value(intensityMin),
        intensityMax = Value(intensityMax),
        deloadWeeks = Value(deloadWeeks),
        overviewText = Value(overviewText);
  static Insertable<Phase> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? name,
    Expression<String>? subtitle,
    Expression<int>? weeksStart,
    Expression<int>? weeksEnd,
    Expression<double>? intensityMin,
    Expression<double>? intensityMax,
    Expression<String>? deloadWeeks,
    Expression<String>? overviewText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (name != null) 'name': name,
      if (subtitle != null) 'subtitle': subtitle,
      if (weeksStart != null) 'weeks_start': weeksStart,
      if (weeksEnd != null) 'weeks_end': weeksEnd,
      if (intensityMin != null) 'intensity_min': intensityMin,
      if (intensityMax != null) 'intensity_max': intensityMax,
      if (deloadWeeks != null) 'deload_weeks': deloadWeeks,
      if (overviewText != null) 'overview_text': overviewText,
    });
  }

  PhasesCompanion copyWith(
      {Value<int>? id,
      Value<int>? number,
      Value<String>? name,
      Value<String>? subtitle,
      Value<int>? weeksStart,
      Value<int>? weeksEnd,
      Value<double>? intensityMin,
      Value<double>? intensityMax,
      Value<String>? deloadWeeks,
      Value<String>? overviewText}) {
    return PhasesCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      weeksStart: weeksStart ?? this.weeksStart,
      weeksEnd: weeksEnd ?? this.weeksEnd,
      intensityMin: intensityMin ?? this.intensityMin,
      intensityMax: intensityMax ?? this.intensityMax,
      deloadWeeks: deloadWeeks ?? this.deloadWeeks,
      overviewText: overviewText ?? this.overviewText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (weeksStart.present) {
      map['weeks_start'] = Variable<int>(weeksStart.value);
    }
    if (weeksEnd.present) {
      map['weeks_end'] = Variable<int>(weeksEnd.value);
    }
    if (intensityMin.present) {
      map['intensity_min'] = Variable<double>(intensityMin.value);
    }
    if (intensityMax.present) {
      map['intensity_max'] = Variable<double>(intensityMax.value);
    }
    if (deloadWeeks.present) {
      map['deload_weeks'] = Variable<String>(deloadWeeks.value);
    }
    if (overviewText.present) {
      map['overview_text'] = Variable<String>(overviewText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhasesCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('weeksStart: $weeksStart, ')
          ..write('weeksEnd: $weeksEnd, ')
          ..write('intensityMin: $intensityMin, ')
          ..write('intensityMax: $intensityMax, ')
          ..write('deloadWeeks: $deloadWeeks, ')
          ..write('overviewText: $overviewText')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _phaseIdMeta =
      const VerificationMeta('phaseId');
  @override
  late final GeneratedColumn<int> phaseId = GeneratedColumn<int>(
      'phase_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES phases (id)'));
  static const VerificationMeta _weekDayMeta =
      const VerificationMeta('weekDay');
  @override
  late final GeneratedColumn<int> weekDay = GeneratedColumn<int>(
      'week_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
      'focus', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estimatedMinutesMeta =
      const VerificationMeta('estimatedMinutes');
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
      'estimated_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, phaseId, weekDay, name, focus, estimatedMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phase_id')) {
      context.handle(_phaseIdMeta,
          phaseId.isAcceptableOrUnknown(data['phase_id']!, _phaseIdMeta));
    } else if (isInserting) {
      context.missing(_phaseIdMeta);
    }
    if (data.containsKey('week_day')) {
      context.handle(_weekDayMeta,
          weekDay.isAcceptableOrUnknown(data['week_day']!, _weekDayMeta));
    } else if (isInserting) {
      context.missing(_weekDayMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('focus')) {
      context.handle(
          _focusMeta, focus.isAcceptableOrUnknown(data['focus']!, _focusMeta));
    } else if (isInserting) {
      context.missing(_focusMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
          _estimatedMinutesMeta,
          estimatedMinutes.isAcceptableOrUnknown(
              data['estimated_minutes']!, _estimatedMinutesMeta));
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      phaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}phase_id'])!,
      weekDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_day'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      focus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}focus'])!,
      estimatedMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estimated_minutes'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int phaseId;
  final int weekDay;
  final String name;
  final String focus;
  final int estimatedMinutes;
  const Session(
      {required this.id,
      required this.phaseId,
      required this.weekDay,
      required this.name,
      required this.focus,
      required this.estimatedMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phase_id'] = Variable<int>(phaseId);
    map['week_day'] = Variable<int>(weekDay);
    map['name'] = Variable<String>(name);
    map['focus'] = Variable<String>(focus);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      phaseId: Value(phaseId),
      weekDay: Value(weekDay),
      name: Value(name),
      focus: Value(focus),
      estimatedMinutes: Value(estimatedMinutes),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      phaseId: serializer.fromJson<int>(json['phaseId']),
      weekDay: serializer.fromJson<int>(json['weekDay']),
      name: serializer.fromJson<String>(json['name']),
      focus: serializer.fromJson<String>(json['focus']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phaseId': serializer.toJson<int>(phaseId),
      'weekDay': serializer.toJson<int>(weekDay),
      'name': serializer.toJson<String>(name),
      'focus': serializer.toJson<String>(focus),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
    };
  }

  Session copyWith(
          {int? id,
          int? phaseId,
          int? weekDay,
          String? name,
          String? focus,
          int? estimatedMinutes}) =>
      Session(
        id: id ?? this.id,
        phaseId: phaseId ?? this.phaseId,
        weekDay: weekDay ?? this.weekDay,
        name: name ?? this.name,
        focus: focus ?? this.focus,
        estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      phaseId: data.phaseId.present ? data.phaseId.value : this.phaseId,
      weekDay: data.weekDay.present ? data.weekDay.value : this.weekDay,
      name: data.name.present ? data.name.value : this.name,
      focus: data.focus.present ? data.focus.value : this.focus,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('phaseId: $phaseId, ')
          ..write('weekDay: $weekDay, ')
          ..write('name: $name, ')
          ..write('focus: $focus, ')
          ..write('estimatedMinutes: $estimatedMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, phaseId, weekDay, name, focus, estimatedMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.phaseId == this.phaseId &&
          other.weekDay == this.weekDay &&
          other.name == this.name &&
          other.focus == this.focus &&
          other.estimatedMinutes == this.estimatedMinutes);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> phaseId;
  final Value<int> weekDay;
  final Value<String> name;
  final Value<String> focus;
  final Value<int> estimatedMinutes;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.phaseId = const Value.absent(),
    this.weekDay = const Value.absent(),
    this.name = const Value.absent(),
    this.focus = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int phaseId,
    required int weekDay,
    required String name,
    required String focus,
    required int estimatedMinutes,
  })  : phaseId = Value(phaseId),
        weekDay = Value(weekDay),
        name = Value(name),
        focus = Value(focus),
        estimatedMinutes = Value(estimatedMinutes);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? phaseId,
    Expression<int>? weekDay,
    Expression<String>? name,
    Expression<String>? focus,
    Expression<int>? estimatedMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phaseId != null) 'phase_id': phaseId,
      if (weekDay != null) 'week_day': weekDay,
      if (name != null) 'name': name,
      if (focus != null) 'focus': focus,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? phaseId,
      Value<int>? weekDay,
      Value<String>? name,
      Value<String>? focus,
      Value<int>? estimatedMinutes}) {
    return SessionsCompanion(
      id: id ?? this.id,
      phaseId: phaseId ?? this.phaseId,
      weekDay: weekDay ?? this.weekDay,
      name: name ?? this.name,
      focus: focus ?? this.focus,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phaseId.present) {
      map['phase_id'] = Variable<int>(phaseId.value);
    }
    if (weekDay.present) {
      map['week_day'] = Variable<int>(weekDay.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('phaseId: $phaseId, ')
          ..write('weekDay: $weekDay, ')
          ..write('name: $name, ')
          ..write('focus: $focus, ')
          ..write('estimatedMinutes: $estimatedMinutes')
          ..write(')'))
        .toString();
  }
}

class $BlocksTable extends Blocks with TableInfo<$BlocksTable, Block> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sessions (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _blockOrderMeta =
      const VerificationMeta('blockOrder');
  @override
  late final GeneratedColumn<int> blockOrder = GeneratedColumn<int>(
      'block_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _blockTypeMeta =
      const VerificationMeta('blockType');
  @override
  late final GeneratedColumn<String> blockType = GeneratedColumn<String>(
      'block_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        name,
        blockOrder,
        blockType,
        instructions,
        durationMinutes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocks';
  @override
  VerificationContext validateIntegrity(Insertable<Block> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('block_order')) {
      context.handle(
          _blockOrderMeta,
          blockOrder.isAcceptableOrUnknown(
              data['block_order']!, _blockOrderMeta));
    } else if (isInserting) {
      context.missing(_blockOrderMeta);
    }
    if (data.containsKey('block_type')) {
      context.handle(_blockTypeMeta,
          blockType.isAcceptableOrUnknown(data['block_type']!, _blockTypeMeta));
    } else if (isInserting) {
      context.missing(_blockTypeMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Block map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Block(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      blockOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}block_order'])!,
      blockType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}block_type'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions']),
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes']),
    );
  }

  @override
  $BlocksTable createAlias(String alias) {
    return $BlocksTable(attachedDatabase, alias);
  }
}

class Block extends DataClass implements Insertable<Block> {
  final int id;
  final int sessionId;
  final String name;
  final int blockOrder;
  final String blockType;
  final String? instructions;
  final int? durationMinutes;
  const Block(
      {required this.id,
      required this.sessionId,
      required this.name,
      required this.blockOrder,
      required this.blockType,
      this.instructions,
      this.durationMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['name'] = Variable<String>(name);
    map['block_order'] = Variable<int>(blockOrder);
    map['block_type'] = Variable<String>(blockType);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    return map;
  }

  BlocksCompanion toCompanion(bool nullToAbsent) {
    return BlocksCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      name: Value(name),
      blockOrder: Value(blockOrder),
      blockType: Value(blockType),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
    );
  }

  factory Block.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Block(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      name: serializer.fromJson<String>(json['name']),
      blockOrder: serializer.fromJson<int>(json['blockOrder']),
      blockType: serializer.fromJson<String>(json['blockType']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'name': serializer.toJson<String>(name),
      'blockOrder': serializer.toJson<int>(blockOrder),
      'blockType': serializer.toJson<String>(blockType),
      'instructions': serializer.toJson<String?>(instructions),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
    };
  }

  Block copyWith(
          {int? id,
          int? sessionId,
          String? name,
          int? blockOrder,
          String? blockType,
          Value<String?> instructions = const Value.absent(),
          Value<int?> durationMinutes = const Value.absent()}) =>
      Block(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        name: name ?? this.name,
        blockOrder: blockOrder ?? this.blockOrder,
        blockType: blockType ?? this.blockType,
        instructions:
            instructions.present ? instructions.value : this.instructions,
        durationMinutes: durationMinutes.present
            ? durationMinutes.value
            : this.durationMinutes,
      );
  Block copyWithCompanion(BlocksCompanion data) {
    return Block(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      name: data.name.present ? data.name.value : this.name,
      blockOrder:
          data.blockOrder.present ? data.blockOrder.value : this.blockOrder,
      blockType: data.blockType.present ? data.blockType.value : this.blockType,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Block(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('blockOrder: $blockOrder, ')
          ..write('blockType: $blockType, ')
          ..write('instructions: $instructions, ')
          ..write('durationMinutes: $durationMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, name, blockOrder, blockType,
      instructions, durationMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Block &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.name == this.name &&
          other.blockOrder == this.blockOrder &&
          other.blockType == this.blockType &&
          other.instructions == this.instructions &&
          other.durationMinutes == this.durationMinutes);
}

class BlocksCompanion extends UpdateCompanion<Block> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> name;
  final Value<int> blockOrder;
  final Value<String> blockType;
  final Value<String?> instructions;
  final Value<int?> durationMinutes;
  const BlocksCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.name = const Value.absent(),
    this.blockOrder = const Value.absent(),
    this.blockType = const Value.absent(),
    this.instructions = const Value.absent(),
    this.durationMinutes = const Value.absent(),
  });
  BlocksCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String name,
    required int blockOrder,
    required String blockType,
    this.instructions = const Value.absent(),
    this.durationMinutes = const Value.absent(),
  })  : sessionId = Value(sessionId),
        name = Value(name),
        blockOrder = Value(blockOrder),
        blockType = Value(blockType);
  static Insertable<Block> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? name,
    Expression<int>? blockOrder,
    Expression<String>? blockType,
    Expression<String>? instructions,
    Expression<int>? durationMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (name != null) 'name': name,
      if (blockOrder != null) 'block_order': blockOrder,
      if (blockType != null) 'block_type': blockType,
      if (instructions != null) 'instructions': instructions,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
    });
  }

  BlocksCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<String>? name,
      Value<int>? blockOrder,
      Value<String>? blockType,
      Value<String?>? instructions,
      Value<int?>? durationMinutes}) {
    return BlocksCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      blockOrder: blockOrder ?? this.blockOrder,
      blockType: blockType ?? this.blockType,
      instructions: instructions ?? this.instructions,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (blockOrder.present) {
      map['block_order'] = Variable<int>(blockOrder.value);
    }
    if (blockType.present) {
      map['block_type'] = Variable<String>(blockType.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('blockOrder: $blockOrder, ')
          ..write('blockType: $blockType, ')
          ..write('instructions: $instructions, ')
          ..write('durationMinutes: $durationMinutes')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String category;
  const Exercise(
      {required this.id, required this.name, required this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
    };
  }

  Exercise copyWith({int? id, String? name, String? category}) => Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
  })  : name = Value(name),
        category = Value(category);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
    });
  }

  ExercisesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? category}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $BlockExercisesTable extends BlockExercises
    with TableInfo<$BlockExercisesTable, BlockExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _blockIdMeta =
      const VerificationMeta('blockId');
  @override
  late final GeneratedColumn<int> blockId = GeneratedColumn<int>(
      'block_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES blocks (id)'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES exercises (id)'));
  static const VerificationMeta _exerciseOrderMeta =
      const VerificationMeta('exerciseOrder');
  @override
  late final GeneratedColumn<int> exerciseOrder = GeneratedColumn<int>(
      'exercise_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
      'sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<String> reps = GeneratedColumn<String>(
      'reps', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<String> tempo = GeneratedColumn<String>(
      'tempo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _restSecondsMeta =
      const VerificationMeta('restSeconds');
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
      'rest_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew = GeneratedColumn<bool>(
      'is_new', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_new" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        blockId,
        exerciseId,
        exerciseOrder,
        sets,
        reps,
        tempo,
        restSeconds,
        notes,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'block_exercises';
  @override
  VerificationContext validateIntegrity(Insertable<BlockExercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('block_id')) {
      context.handle(_blockIdMeta,
          blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta));
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('exercise_order')) {
      context.handle(
          _exerciseOrderMeta,
          exerciseOrder.isAcceptableOrUnknown(
              data['exercise_order']!, _exerciseOrderMeta));
    } else if (isInserting) {
      context.missing(_exerciseOrderMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
          _setsMeta, sets.isAcceptableOrUnknown(data['sets']!, _setsMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('tempo')) {
      context.handle(
          _tempoMeta, tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta));
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
          _restSecondsMeta,
          restSeconds.isAcceptableOrUnknown(
              data['rest_seconds']!, _restSecondsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockExercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      blockId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}block_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_id'])!,
      exerciseOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_order'])!,
      sets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sets']),
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reps']),
      tempo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tempo']),
      restSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_seconds']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
    );
  }

  @override
  $BlockExercisesTable createAlias(String alias) {
    return $BlockExercisesTable(attachedDatabase, alias);
  }
}

class BlockExercise extends DataClass implements Insertable<BlockExercise> {
  final int id;
  final int blockId;
  final int exerciseId;
  final int exerciseOrder;
  final int? sets;
  final String? reps;
  final String? tempo;
  final int? restSeconds;
  final String? notes;
  final bool isNew;
  const BlockExercise(
      {required this.id,
      required this.blockId,
      required this.exerciseId,
      required this.exerciseOrder,
      this.sets,
      this.reps,
      this.tempo,
      this.restSeconds,
      this.notes,
      required this.isNew});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['block_id'] = Variable<int>(blockId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['exercise_order'] = Variable<int>(exerciseOrder);
    if (!nullToAbsent || sets != null) {
      map['sets'] = Variable<int>(sets);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<String>(reps);
    }
    if (!nullToAbsent || tempo != null) {
      map['tempo'] = Variable<String>(tempo);
    }
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_new'] = Variable<bool>(isNew);
    return map;
  }

  BlockExercisesCompanion toCompanion(bool nullToAbsent) {
    return BlockExercisesCompanion(
      id: Value(id),
      blockId: Value(blockId),
      exerciseId: Value(exerciseId),
      exerciseOrder: Value(exerciseOrder),
      sets: sets == null && nullToAbsent ? const Value.absent() : Value(sets),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      tempo:
          tempo == null && nullToAbsent ? const Value.absent() : Value(tempo),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isNew: Value(isNew),
    );
  }

  factory BlockExercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockExercise(
      id: serializer.fromJson<int>(json['id']),
      blockId: serializer.fromJson<int>(json['blockId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      exerciseOrder: serializer.fromJson<int>(json['exerciseOrder']),
      sets: serializer.fromJson<int?>(json['sets']),
      reps: serializer.fromJson<String?>(json['reps']),
      tempo: serializer.fromJson<String?>(json['tempo']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
      notes: serializer.fromJson<String?>(json['notes']),
      isNew: serializer.fromJson<bool>(json['isNew']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blockId': serializer.toJson<int>(blockId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'exerciseOrder': serializer.toJson<int>(exerciseOrder),
      'sets': serializer.toJson<int?>(sets),
      'reps': serializer.toJson<String?>(reps),
      'tempo': serializer.toJson<String?>(tempo),
      'restSeconds': serializer.toJson<int?>(restSeconds),
      'notes': serializer.toJson<String?>(notes),
      'isNew': serializer.toJson<bool>(isNew),
    };
  }

  BlockExercise copyWith(
          {int? id,
          int? blockId,
          int? exerciseId,
          int? exerciseOrder,
          Value<int?> sets = const Value.absent(),
          Value<String?> reps = const Value.absent(),
          Value<String?> tempo = const Value.absent(),
          Value<int?> restSeconds = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isNew}) =>
      BlockExercise(
        id: id ?? this.id,
        blockId: blockId ?? this.blockId,
        exerciseId: exerciseId ?? this.exerciseId,
        exerciseOrder: exerciseOrder ?? this.exerciseOrder,
        sets: sets.present ? sets.value : this.sets,
        reps: reps.present ? reps.value : this.reps,
        tempo: tempo.present ? tempo.value : this.tempo,
        restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
        notes: notes.present ? notes.value : this.notes,
        isNew: isNew ?? this.isNew,
      );
  BlockExercise copyWithCompanion(BlockExercisesCompanion data) {
    return BlockExercise(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      exerciseOrder: data.exerciseOrder.present
          ? data.exerciseOrder.value
          : this.exerciseOrder,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      restSeconds:
          data.restSeconds.present ? data.restSeconds.value : this.restSeconds,
      notes: data.notes.present ? data.notes.value : this.notes,
      isNew: data.isNew.present ? data.isNew.value : this.isNew,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockExercise(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseOrder: $exerciseOrder, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('tempo: $tempo, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('notes: $notes, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, blockId, exerciseId, exerciseOrder, sets,
      reps, tempo, restSeconds, notes, isNew);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockExercise &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.exerciseId == this.exerciseId &&
          other.exerciseOrder == this.exerciseOrder &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.tempo == this.tempo &&
          other.restSeconds == this.restSeconds &&
          other.notes == this.notes &&
          other.isNew == this.isNew);
}

class BlockExercisesCompanion extends UpdateCompanion<BlockExercise> {
  final Value<int> id;
  final Value<int> blockId;
  final Value<int> exerciseId;
  final Value<int> exerciseOrder;
  final Value<int?> sets;
  final Value<String?> reps;
  final Value<String?> tempo;
  final Value<int?> restSeconds;
  final Value<String?> notes;
  final Value<bool> isNew;
  const BlockExercisesCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.exerciseOrder = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.tempo = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  BlockExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int blockId,
    required int exerciseId,
    required int exerciseOrder,
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.tempo = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : blockId = Value(blockId),
        exerciseId = Value(exerciseId),
        exerciseOrder = Value(exerciseOrder);
  static Insertable<BlockExercise> custom({
    Expression<int>? id,
    Expression<int>? blockId,
    Expression<int>? exerciseId,
    Expression<int>? exerciseOrder,
    Expression<int>? sets,
    Expression<String>? reps,
    Expression<String>? tempo,
    Expression<int>? restSeconds,
    Expression<String>? notes,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (exerciseOrder != null) 'exercise_order': exerciseOrder,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (tempo != null) 'tempo': tempo,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (notes != null) 'notes': notes,
      if (isNew != null) 'is_new': isNew,
    });
  }

  BlockExercisesCompanion copyWith(
      {Value<int>? id,
      Value<int>? blockId,
      Value<int>? exerciseId,
      Value<int>? exerciseOrder,
      Value<int?>? sets,
      Value<String?>? reps,
      Value<String?>? tempo,
      Value<int?>? restSeconds,
      Value<String?>? notes,
      Value<bool>? isNew}) {
    return BlockExercisesCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseOrder: exerciseOrder ?? this.exerciseOrder,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      tempo: tempo ?? this.tempo,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<int>(blockId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (exerciseOrder.present) {
      map['exercise_order'] = Variable<int>(exerciseOrder.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<String>(reps.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<String>(tempo.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockExercisesCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseOrder: $exerciseOrder, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('tempo: $tempo, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('notes: $notes, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $WorkoutLogsTable extends WorkoutLogs
    with TableInfo<$WorkoutLogsTable, WorkoutLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sessions (id)'));
  static const VerificationMeta _weekNumberMeta =
      const VerificationMeta('weekNumber');
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
      'week_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _phaseNumberMeta =
      const VerificationMeta('phaseNumber');
  @override
  late final GeneratedColumn<int> phaseNumber = GeneratedColumn<int>(
      'phase_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        sessionId,
        weekNumber,
        phaseNumber,
        completed,
        startedAt,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_logs';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
          _weekNumberMeta,
          weekNumber.isAcceptableOrUnknown(
              data['week_number']!, _weekNumberMeta));
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('phase_number')) {
      context.handle(
          _phaseNumberMeta,
          phaseNumber.isAcceptableOrUnknown(
              data['phase_number']!, _phaseNumberMeta));
    } else if (isInserting) {
      context.missing(_phaseNumberMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      weekNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_number'])!,
      phaseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}phase_number'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $WorkoutLogsTable createAlias(String alias) {
    return $WorkoutLogsTable(attachedDatabase, alias);
  }
}

class WorkoutLog extends DataClass implements Insertable<WorkoutLog> {
  final int id;
  final DateTime date;
  final int sessionId;
  final int weekNumber;
  final int phaseNumber;
  final bool completed;
  final DateTime? startedAt;
  final DateTime? completedAt;
  const WorkoutLog(
      {required this.id,
      required this.date,
      required this.sessionId,
      required this.weekNumber,
      required this.phaseNumber,
      required this.completed,
      this.startedAt,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['session_id'] = Variable<int>(sessionId);
    map['week_number'] = Variable<int>(weekNumber);
    map['phase_number'] = Variable<int>(phaseNumber);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  WorkoutLogsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutLogsCompanion(
      id: Value(id),
      date: Value(date),
      sessionId: Value(sessionId),
      weekNumber: Value(weekNumber),
      phaseNumber: Value(phaseNumber),
      completed: Value(completed),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory WorkoutLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      phaseNumber: serializer.fromJson<int>(json['phaseNumber']),
      completed: serializer.fromJson<bool>(json['completed']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'sessionId': serializer.toJson<int>(sessionId),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'phaseNumber': serializer.toJson<int>(phaseNumber),
      'completed': serializer.toJson<bool>(completed),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  WorkoutLog copyWith(
          {int? id,
          DateTime? date,
          int? sessionId,
          int? weekNumber,
          int? phaseNumber,
          bool? completed,
          Value<DateTime?> startedAt = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent()}) =>
      WorkoutLog(
        id: id ?? this.id,
        date: date ?? this.date,
        sessionId: sessionId ?? this.sessionId,
        weekNumber: weekNumber ?? this.weekNumber,
        phaseNumber: phaseNumber ?? this.phaseNumber,
        completed: completed ?? this.completed,
        startedAt: startedAt.present ? startedAt.value : this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  WorkoutLog copyWithCompanion(WorkoutLogsCompanion data) {
    return WorkoutLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      weekNumber:
          data.weekNumber.present ? data.weekNumber.value : this.weekNumber,
      phaseNumber:
          data.phaseNumber.present ? data.phaseNumber.value : this.phaseNumber,
      completed: data.completed.present ? data.completed.value : this.completed,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('sessionId: $sessionId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('phaseNumber: $phaseNumber, ')
          ..write('completed: $completed, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, sessionId, weekNumber, phaseNumber,
      completed, startedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.sessionId == this.sessionId &&
          other.weekNumber == this.weekNumber &&
          other.phaseNumber == this.phaseNumber &&
          other.completed == this.completed &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class WorkoutLogsCompanion extends UpdateCompanion<WorkoutLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> sessionId;
  final Value<int> weekNumber;
  final Value<int> phaseNumber;
  final Value<bool> completed;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  const WorkoutLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.phaseNumber = const Value.absent(),
    this.completed = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  WorkoutLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int sessionId,
    required int weekNumber,
    required int phaseNumber,
    this.completed = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  })  : date = Value(date),
        sessionId = Value(sessionId),
        weekNumber = Value(weekNumber),
        phaseNumber = Value(phaseNumber);
  static Insertable<WorkoutLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? sessionId,
    Expression<int>? weekNumber,
    Expression<int>? phaseNumber,
    Expression<bool>? completed,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (sessionId != null) 'session_id': sessionId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (phaseNumber != null) 'phase_number': phaseNumber,
      if (completed != null) 'completed': completed,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  WorkoutLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? sessionId,
      Value<int>? weekNumber,
      Value<int>? phaseNumber,
      Value<bool>? completed,
      Value<DateTime?>? startedAt,
      Value<DateTime?>? completedAt}) {
    return WorkoutLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      sessionId: sessionId ?? this.sessionId,
      weekNumber: weekNumber ?? this.weekNumber,
      phaseNumber: phaseNumber ?? this.phaseNumber,
      completed: completed ?? this.completed,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (phaseNumber.present) {
      map['phase_number'] = Variable<int>(phaseNumber.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('sessionId: $sessionId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('phaseNumber: $phaseNumber, ')
          ..write('completed: $completed, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workoutLogIdMeta =
      const VerificationMeta('workoutLogId');
  @override
  late final GeneratedColumn<int> workoutLogId = GeneratedColumn<int>(
      'workout_log_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES workout_logs (id)'));
  static const VerificationMeta _blockExerciseIdMeta =
      const VerificationMeta('blockExerciseId');
  @override
  late final GeneratedColumn<int> blockExerciseId = GeneratedColumn<int>(
      'block_exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES block_exercises (id)'));
  static const VerificationMeta _setNumberMeta =
      const VerificationMeta('setNumber');
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
      'set_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _repsCompletedMeta =
      const VerificationMeta('repsCompleted');
  @override
  late final GeneratedColumn<int> repsCompleted = GeneratedColumn<int>(
      'reps_completed', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workoutLogId,
        blockExerciseId,
        setNumber,
        repsCompleted,
        weightKg,
        completed,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SetLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_log_id')) {
      context.handle(
          _workoutLogIdMeta,
          workoutLogId.isAcceptableOrUnknown(
              data['workout_log_id']!, _workoutLogIdMeta));
    } else if (isInserting) {
      context.missing(_workoutLogIdMeta);
    }
    if (data.containsKey('block_exercise_id')) {
      context.handle(
          _blockExerciseIdMeta,
          blockExerciseId.isAcceptableOrUnknown(
              data['block_exercise_id']!, _blockExerciseIdMeta));
    } else if (isInserting) {
      context.missing(_blockExerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(_setNumberMeta,
          setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta));
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps_completed')) {
      context.handle(
          _repsCompletedMeta,
          repsCompleted.isAcceptableOrUnknown(
              data['reps_completed']!, _repsCompletedMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workoutLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}workout_log_id'])!,
      blockExerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}block_exercise_id'])!,
      setNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set_number'])!,
      repsCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps_completed']),
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg']),
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLog extends DataClass implements Insertable<SetLog> {
  final int id;
  final int workoutLogId;
  final int blockExerciseId;
  final int setNumber;
  final int? repsCompleted;
  final double? weightKg;
  final bool completed;
  final DateTime? completedAt;
  const SetLog(
      {required this.id,
      required this.workoutLogId,
      required this.blockExerciseId,
      required this.setNumber,
      this.repsCompleted,
      this.weightKg,
      required this.completed,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_log_id'] = Variable<int>(workoutLogId);
    map['block_exercise_id'] = Variable<int>(blockExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || repsCompleted != null) {
      map['reps_completed'] = Variable<int>(repsCompleted);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      workoutLogId: Value(workoutLogId),
      blockExerciseId: Value(blockExerciseId),
      setNumber: Value(setNumber),
      repsCompleted: repsCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(repsCompleted),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory SetLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLog(
      id: serializer.fromJson<int>(json['id']),
      workoutLogId: serializer.fromJson<int>(json['workoutLogId']),
      blockExerciseId: serializer.fromJson<int>(json['blockExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      repsCompleted: serializer.fromJson<int?>(json['repsCompleted']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutLogId': serializer.toJson<int>(workoutLogId),
      'blockExerciseId': serializer.toJson<int>(blockExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'repsCompleted': serializer.toJson<int?>(repsCompleted),
      'weightKg': serializer.toJson<double?>(weightKg),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  SetLog copyWith(
          {int? id,
          int? workoutLogId,
          int? blockExerciseId,
          int? setNumber,
          Value<int?> repsCompleted = const Value.absent(),
          Value<double?> weightKg = const Value.absent(),
          bool? completed,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      SetLog(
        id: id ?? this.id,
        workoutLogId: workoutLogId ?? this.workoutLogId,
        blockExerciseId: blockExerciseId ?? this.blockExerciseId,
        setNumber: setNumber ?? this.setNumber,
        repsCompleted:
            repsCompleted.present ? repsCompleted.value : this.repsCompleted,
        weightKg: weightKg.present ? weightKg.value : this.weightKg,
        completed: completed ?? this.completed,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  SetLog copyWithCompanion(SetLogsCompanion data) {
    return SetLog(
      id: data.id.present ? data.id.value : this.id,
      workoutLogId: data.workoutLogId.present
          ? data.workoutLogId.value
          : this.workoutLogId,
      blockExerciseId: data.blockExerciseId.present
          ? data.blockExerciseId.value
          : this.blockExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      repsCompleted: data.repsCompleted.present
          ? data.repsCompleted.value
          : this.repsCompleted,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLog(')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('blockExerciseId: $blockExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('repsCompleted: $repsCompleted, ')
          ..write('weightKg: $weightKg, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutLogId, blockExerciseId, setNumber,
      repsCompleted, weightKg, completed, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLog &&
          other.id == this.id &&
          other.workoutLogId == this.workoutLogId &&
          other.blockExerciseId == this.blockExerciseId &&
          other.setNumber == this.setNumber &&
          other.repsCompleted == this.repsCompleted &&
          other.weightKg == this.weightKg &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<int> id;
  final Value<int> workoutLogId;
  final Value<int> blockExerciseId;
  final Value<int> setNumber;
  final Value<int?> repsCompleted;
  final Value<double?> weightKg;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.workoutLogId = const Value.absent(),
    this.blockExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.repsCompleted = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutLogId,
    required int blockExerciseId,
    required int setNumber,
    this.repsCompleted = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
  })  : workoutLogId = Value(workoutLogId),
        blockExerciseId = Value(blockExerciseId),
        setNumber = Value(setNumber);
  static Insertable<SetLog> custom({
    Expression<int>? id,
    Expression<int>? workoutLogId,
    Expression<int>? blockExerciseId,
    Expression<int>? setNumber,
    Expression<int>? repsCompleted,
    Expression<double>? weightKg,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutLogId != null) 'workout_log_id': workoutLogId,
      if (blockExerciseId != null) 'block_exercise_id': blockExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (repsCompleted != null) 'reps_completed': repsCompleted,
      if (weightKg != null) 'weight_kg': weightKg,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  SetLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? workoutLogId,
      Value<int>? blockExerciseId,
      Value<int>? setNumber,
      Value<int?>? repsCompleted,
      Value<double?>? weightKg,
      Value<bool>? completed,
      Value<DateTime?>? completedAt}) {
    return SetLogsCompanion(
      id: id ?? this.id,
      workoutLogId: workoutLogId ?? this.workoutLogId,
      blockExerciseId: blockExerciseId ?? this.blockExerciseId,
      setNumber: setNumber ?? this.setNumber,
      repsCompleted: repsCompleted ?? this.repsCompleted,
      weightKg: weightKg ?? this.weightKg,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutLogId.present) {
      map['workout_log_id'] = Variable<int>(workoutLogId.value);
    }
    if (blockExerciseId.present) {
      map['block_exercise_id'] = Variable<int>(blockExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (repsCompleted.present) {
      map['reps_completed'] = Variable<int>(repsCompleted.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('blockExerciseId: $blockExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('repsCompleted: $repsCompleted, ')
          ..write('weightKg: $weightKg, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $UserStateTableTable extends UserStateTable
    with TableInfo<$UserStateTableTable, UserStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _programStartDateMeta =
      const VerificationMeta('programStartDate');
  @override
  late final GeneratedColumn<DateTime> programStartDate =
      GeneratedColumn<DateTime>('program_start_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
      'onboarding_complete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("onboarding_complete" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, programStartDate, onboardingComplete];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_state';
  @override
  VerificationContext validateIntegrity(Insertable<UserStateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('program_start_date')) {
      context.handle(
          _programStartDateMeta,
          programStartDate.isAcceptableOrUnknown(
              data['program_start_date']!, _programStartDateMeta));
    } else if (isInserting) {
      context.missing(_programStartDateMeta);
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
          _onboardingCompleteMeta,
          onboardingComplete.isAcceptableOrUnknown(
              data['onboarding_complete']!, _onboardingCompleteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      programStartDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}program_start_date'])!,
      onboardingComplete: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}onboarding_complete'])!,
    );
  }

  @override
  $UserStateTableTable createAlias(String alias) {
    return $UserStateTableTable(attachedDatabase, alias);
  }
}

class UserStateRow extends DataClass implements Insertable<UserStateRow> {
  final int id;
  final DateTime programStartDate;
  final bool onboardingComplete;
  const UserStateRow(
      {required this.id,
      required this.programStartDate,
      required this.onboardingComplete});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['program_start_date'] = Variable<DateTime>(programStartDate);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    return map;
  }

  UserStateTableCompanion toCompanion(bool nullToAbsent) {
    return UserStateTableCompanion(
      id: Value(id),
      programStartDate: Value(programStartDate),
      onboardingComplete: Value(onboardingComplete),
    );
  }

  factory UserStateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStateRow(
      id: serializer.fromJson<int>(json['id']),
      programStartDate: serializer.fromJson<DateTime>(json['programStartDate']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'programStartDate': serializer.toJson<DateTime>(programStartDate),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
    };
  }

  UserStateRow copyWith(
          {int? id, DateTime? programStartDate, bool? onboardingComplete}) =>
      UserStateRow(
        id: id ?? this.id,
        programStartDate: programStartDate ?? this.programStartDate,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      );
  UserStateRow copyWithCompanion(UserStateTableCompanion data) {
    return UserStateRow(
      id: data.id.present ? data.id.value : this.id,
      programStartDate: data.programStartDate.present
          ? data.programStartDate.value
          : this.programStartDate,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStateRow(')
          ..write('id: $id, ')
          ..write('programStartDate: $programStartDate, ')
          ..write('onboardingComplete: $onboardingComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, programStartDate, onboardingComplete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStateRow &&
          other.id == this.id &&
          other.programStartDate == this.programStartDate &&
          other.onboardingComplete == this.onboardingComplete);
}

class UserStateTableCompanion extends UpdateCompanion<UserStateRow> {
  final Value<int> id;
  final Value<DateTime> programStartDate;
  final Value<bool> onboardingComplete;
  const UserStateTableCompanion({
    this.id = const Value.absent(),
    this.programStartDate = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
  });
  UserStateTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime programStartDate,
    this.onboardingComplete = const Value.absent(),
  }) : programStartDate = Value(programStartDate);
  static Insertable<UserStateRow> custom({
    Expression<int>? id,
    Expression<DateTime>? programStartDate,
    Expression<bool>? onboardingComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programStartDate != null) 'program_start_date': programStartDate,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
    });
  }

  UserStateTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? programStartDate,
      Value<bool>? onboardingComplete}) {
    return UserStateTableCompanion(
      id: id ?? this.id,
      programStartDate: programStartDate ?? this.programStartDate,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (programStartDate.present) {
      map['program_start_date'] = Variable<DateTime>(programStartDate.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStateTableCompanion(')
          ..write('id: $id, ')
          ..write('programStartDate: $programStartDate, ')
          ..write('onboardingComplete: $onboardingComplete')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
      'sex', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, age, sex, weightKg, heightCm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    }
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age']),
      sex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex']),
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg']),
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm']),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String? name;
  final int? age;
  final String? sex;
  final double? weightKg;
  final double? heightCm;
  const UserProfile(
      {required this.id,
      this.name,
      this.age,
      this.sex,
      this.weightKg,
      this.heightCm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      age: serializer.fromJson<int?>(json['age']),
      sex: serializer.fromJson<String?>(json['sex']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'age': serializer.toJson<int?>(age),
      'sex': serializer.toJson<String?>(sex),
      'weightKg': serializer.toJson<double?>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
    };
  }

  UserProfile copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<int?> age = const Value.absent(),
          Value<String?> sex = const Value.absent(),
          Value<double?> weightKg = const Value.absent(),
          Value<double?> heightCm = const Value.absent()}) =>
      UserProfile(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        age: age.present ? age.value : this.age,
        sex: sex.present ? sex.value : this.sex,
        weightKg: weightKg.present ? weightKg.value : this.weightKg,
        heightCm: heightCm.present ? heightCm.value : this.heightCm,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      sex: data.sex.present ? data.sex.value : this.sex,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, age, sex, weightKg, heightCm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.sex == this.sex &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String?> name;
  final Value<int?> age;
  final Value<String?> sex;
  final Value<double?> weightKg;
  final Value<double?> heightCm;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? sex,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (sex != null) 'sex': sex,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<int?>? age,
      Value<String?>? sex,
      Value<double?>? weightKg,
      Value<double?>? heightCm}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
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
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PhasesTable phases = $PhasesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $BlocksTable blocks = $BlocksTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $BlockExercisesTable blockExercises = $BlockExercisesTable(this);
  late final $WorkoutLogsTable workoutLogs = $WorkoutLogsTable(this);
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $UserStateTableTable userStateTable = $UserStateTableTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final ProgramDao programDao = ProgramDao(this as AppDatabase);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final UserProfileDao userProfileDao =
      UserProfileDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        phases,
        sessions,
        blocks,
        exercises,
        blockExercises,
        workoutLogs,
        setLogs,
        userStateTable,
        userProfiles
      ];
}

typedef $$PhasesTableCreateCompanionBuilder = PhasesCompanion Function({
  Value<int> id,
  required int number,
  required String name,
  required String subtitle,
  required int weeksStart,
  required int weeksEnd,
  required double intensityMin,
  required double intensityMax,
  required String deloadWeeks,
  required String overviewText,
});
typedef $$PhasesTableUpdateCompanionBuilder = PhasesCompanion Function({
  Value<int> id,
  Value<int> number,
  Value<String> name,
  Value<String> subtitle,
  Value<int> weeksStart,
  Value<int> weeksEnd,
  Value<double> intensityMin,
  Value<double> intensityMax,
  Value<String> deloadWeeks,
  Value<String> overviewText,
});

final class $$PhasesTableReferences
    extends BaseReferences<_$AppDatabase, $PhasesTable, Phase> {
  $$PhasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sessions,
          aliasName: $_aliasNameGenerator(db.phases.id, db.sessions.phaseId));

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.phaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PhasesTableFilterComposer
    extends Composer<_$AppDatabase, $PhasesTable> {
  $$PhasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeksStart => $composableBuilder(
      column: $table.weeksStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeksEnd => $composableBuilder(
      column: $table.weeksEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get intensityMin => $composableBuilder(
      column: $table.intensityMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get intensityMax => $composableBuilder(
      column: $table.intensityMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deloadWeeks => $composableBuilder(
      column: $table.deloadWeeks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overviewText => $composableBuilder(
      column: $table.overviewText, builder: (column) => ColumnFilters(column));

  Expression<bool> sessionsRefs(
      Expression<bool> Function($$SessionsTableFilterComposer f) f) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.phaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PhasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PhasesTable> {
  $$PhasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeksStart => $composableBuilder(
      column: $table.weeksStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeksEnd => $composableBuilder(
      column: $table.weeksEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get intensityMin => $composableBuilder(
      column: $table.intensityMin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get intensityMax => $composableBuilder(
      column: $table.intensityMax,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deloadWeeks => $composableBuilder(
      column: $table.deloadWeeks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overviewText => $composableBuilder(
      column: $table.overviewText,
      builder: (column) => ColumnOrderings(column));
}

class $$PhasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhasesTable> {
  $$PhasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<int> get weeksStart => $composableBuilder(
      column: $table.weeksStart, builder: (column) => column);

  GeneratedColumn<int> get weeksEnd =>
      $composableBuilder(column: $table.weeksEnd, builder: (column) => column);

  GeneratedColumn<double> get intensityMin => $composableBuilder(
      column: $table.intensityMin, builder: (column) => column);

  GeneratedColumn<double> get intensityMax => $composableBuilder(
      column: $table.intensityMax, builder: (column) => column);

  GeneratedColumn<String> get deloadWeeks => $composableBuilder(
      column: $table.deloadWeeks, builder: (column) => column);

  GeneratedColumn<String> get overviewText => $composableBuilder(
      column: $table.overviewText, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
      Expression<T> Function($$SessionsTableAnnotationComposer a) f) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.phaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PhasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhasesTable,
    Phase,
    $$PhasesTableFilterComposer,
    $$PhasesTableOrderingComposer,
    $$PhasesTableAnnotationComposer,
    $$PhasesTableCreateCompanionBuilder,
    $$PhasesTableUpdateCompanionBuilder,
    (Phase, $$PhasesTableReferences),
    Phase,
    PrefetchHooks Function({bool sessionsRefs})> {
  $$PhasesTableTableManager(_$AppDatabase db, $PhasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> subtitle = const Value.absent(),
            Value<int> weeksStart = const Value.absent(),
            Value<int> weeksEnd = const Value.absent(),
            Value<double> intensityMin = const Value.absent(),
            Value<double> intensityMax = const Value.absent(),
            Value<String> deloadWeeks = const Value.absent(),
            Value<String> overviewText = const Value.absent(),
          }) =>
              PhasesCompanion(
            id: id,
            number: number,
            name: name,
            subtitle: subtitle,
            weeksStart: weeksStart,
            weeksEnd: weeksEnd,
            intensityMin: intensityMin,
            intensityMax: intensityMax,
            deloadWeeks: deloadWeeks,
            overviewText: overviewText,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int number,
            required String name,
            required String subtitle,
            required int weeksStart,
            required int weeksEnd,
            required double intensityMin,
            required double intensityMax,
            required String deloadWeeks,
            required String overviewText,
          }) =>
              PhasesCompanion.insert(
            id: id,
            number: number,
            name: name,
            subtitle: subtitle,
            weeksStart: weeksStart,
            weeksEnd: weeksEnd,
            intensityMin: intensityMin,
            intensityMax: intensityMax,
            deloadWeeks: deloadWeeks,
            overviewText: overviewText,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PhasesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<Phase, $PhasesTable, Session>(
                        currentTable: table,
                        referencedTable:
                            $$PhasesTableReferences._sessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PhasesTableReferences(db, table, p0).sessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.phaseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PhasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PhasesTable,
    Phase,
    $$PhasesTableFilterComposer,
    $$PhasesTableOrderingComposer,
    $$PhasesTableAnnotationComposer,
    $$PhasesTableCreateCompanionBuilder,
    $$PhasesTableUpdateCompanionBuilder,
    (Phase, $$PhasesTableReferences),
    Phase,
    PrefetchHooks Function({bool sessionsRefs})>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int phaseId,
  required int weekDay,
  required String name,
  required String focus,
  required int estimatedMinutes,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> phaseId,
  Value<int> weekDay,
  Value<String> name,
  Value<String> focus,
  Value<int> estimatedMinutes,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PhasesTable _phaseIdTable(_$AppDatabase db) => db.phases
      .createAlias($_aliasNameGenerator(db.sessions.phaseId, db.phases.id));

  $$PhasesTableProcessedTableManager get phaseId {
    final $_column = $_itemColumn<int>('phase_id')!;

    final manager = $$PhasesTableTableManager($_db, $_db.phases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_phaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BlocksTable, List<Block>> _blocksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.blocks,
          aliasName: $_aliasNameGenerator(db.sessions.id, db.blocks.sessionId));

  $$BlocksTableProcessedTableManager get blocksRefs {
    final manager = $$BlocksTableTableManager($_db, $_db.blocks)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blocksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutLogsTable, List<WorkoutLog>>
      _workoutLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.workoutLogs,
          aliasName:
              $_aliasNameGenerator(db.sessions.id, db.workoutLogs.sessionId));

  $$WorkoutLogsTableProcessedTableManager get workoutLogsRefs {
    final manager = $$WorkoutLogsTableTableManager($_db, $_db.workoutLogs)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekDay => $composableBuilder(
      column: $table.weekDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get focus => $composableBuilder(
      column: $table.focus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes,
      builder: (column) => ColumnFilters(column));

  $$PhasesTableFilterComposer get phaseId {
    final $$PhasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.phaseId,
        referencedTable: $db.phases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PhasesTableFilterComposer(
              $db: $db,
              $table: $db.phases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> blocksRefs(
      Expression<bool> Function($$BlocksTableFilterComposer f) f) {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableFilterComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workoutLogsRefs(
      Expression<bool> Function($$WorkoutLogsTableFilterComposer f) f) {
    final $$WorkoutLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutLogs,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutLogsTableFilterComposer(
              $db: $db,
              $table: $db.workoutLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekDay => $composableBuilder(
      column: $table.weekDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get focus => $composableBuilder(
      column: $table.focus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes,
      builder: (column) => ColumnOrderings(column));

  $$PhasesTableOrderingComposer get phaseId {
    final $$PhasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.phaseId,
        referencedTable: $db.phases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PhasesTableOrderingComposer(
              $db: $db,
              $table: $db.phases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekDay =>
      $composableBuilder(column: $table.weekDay, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes, builder: (column) => column);

  $$PhasesTableAnnotationComposer get phaseId {
    final $$PhasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.phaseId,
        referencedTable: $db.phases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PhasesTableAnnotationComposer(
              $db: $db,
              $table: $db.phases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> blocksRefs<T extends Object>(
      Expression<T> Function($$BlocksTableAnnotationComposer a) f) {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> workoutLogsRefs<T extends Object>(
      Expression<T> Function($$WorkoutLogsTableAnnotationComposer a) f) {
    final $$WorkoutLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutLogs,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, $$SessionsTableReferences),
    Session,
    PrefetchHooks Function(
        {bool phaseId, bool blocksRefs, bool workoutLogsRefs})> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> phaseId = const Value.absent(),
            Value<int> weekDay = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> focus = const Value.absent(),
            Value<int> estimatedMinutes = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            phaseId: phaseId,
            weekDay: weekDay,
            name: name,
            focus: focus,
            estimatedMinutes: estimatedMinutes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int phaseId,
            required int weekDay,
            required String name,
            required String focus,
            required int estimatedMinutes,
          }) =>
              SessionsCompanion.insert(
            id: id,
            phaseId: phaseId,
            weekDay: weekDay,
            name: name,
            focus: focus,
            estimatedMinutes: estimatedMinutes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SessionsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {phaseId = false, blocksRefs = false, workoutLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (blocksRefs) db.blocks,
                if (workoutLogsRefs) db.workoutLogs
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (phaseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.phaseId,
                    referencedTable:
                        $$SessionsTableReferences._phaseIdTable(db),
                    referencedColumn:
                        $$SessionsTableReferences._phaseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (blocksRefs)
                    await $_getPrefetchedData<Session, $SessionsTable, Block>(
                        currentTable: table,
                        referencedTable:
                            $$SessionsTableReferences._blocksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionsTableReferences(db, table, p0).blocksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (workoutLogsRefs)
                    await $_getPrefetchedData<Session, $SessionsTable,
                            WorkoutLog>(
                        currentTable: table,
                        referencedTable:
                            $$SessionsTableReferences._workoutLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionsTableReferences(db, table, p0)
                                .workoutLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, $$SessionsTableReferences),
    Session,
    PrefetchHooks Function(
        {bool phaseId, bool blocksRefs, bool workoutLogsRefs})>;
typedef $$BlocksTableCreateCompanionBuilder = BlocksCompanion Function({
  Value<int> id,
  required int sessionId,
  required String name,
  required int blockOrder,
  required String blockType,
  Value<String?> instructions,
  Value<int?> durationMinutes,
});
typedef $$BlocksTableUpdateCompanionBuilder = BlocksCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<String> name,
  Value<int> blockOrder,
  Value<String> blockType,
  Value<String?> instructions,
  Value<int?> durationMinutes,
});

final class $$BlocksTableReferences
    extends BaseReferences<_$AppDatabase, $BlocksTable, Block> {
  $$BlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) => db.sessions
      .createAlias($_aliasNameGenerator(db.blocks.sessionId, db.sessions.id));

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BlockExercisesTable, List<BlockExercise>>
      _blockExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.blockExercises,
              aliasName: $_aliasNameGenerator(
                  db.blocks.id, db.blockExercises.blockId));

  $$BlockExercisesTableProcessedTableManager get blockExercisesRefs {
    final manager = $$BlockExercisesTableTableManager($_db, $_db.blockExercises)
        .filter((f) => f.blockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blockExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BlocksTableFilterComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get blockOrder => $composableBuilder(
      column: $table.blockOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockType => $composableBuilder(
      column: $table.blockType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> blockExercisesRefs(
      Expression<bool> Function($$BlockExercisesTableFilterComposer f) f) {
    final $$BlockExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blockExercises,
        getReferencedColumn: (t) => t.blockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockExercisesTableFilterComposer(
              $db: $db,
              $table: $db.blockExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get blockOrder => $composableBuilder(
      column: $table.blockOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockType => $composableBuilder(
      column: $table.blockType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableOrderingComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableAnnotationComposer({
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

  GeneratedColumn<int> get blockOrder => $composableBuilder(
      column: $table.blockOrder, builder: (column) => column);

  GeneratedColumn<String> get blockType =>
      $composableBuilder(column: $table.blockType, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> blockExercisesRefs<T extends Object>(
      Expression<T> Function($$BlockExercisesTableAnnotationComposer a) f) {
    final $$BlockExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blockExercises,
        getReferencedColumn: (t) => t.blockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.blockExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BlocksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BlocksTable,
    Block,
    $$BlocksTableFilterComposer,
    $$BlocksTableOrderingComposer,
    $$BlocksTableAnnotationComposer,
    $$BlocksTableCreateCompanionBuilder,
    $$BlocksTableUpdateCompanionBuilder,
    (Block, $$BlocksTableReferences),
    Block,
    PrefetchHooks Function({bool sessionId, bool blockExercisesRefs})> {
  $$BlocksTableTableManager(_$AppDatabase db, $BlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> blockOrder = const Value.absent(),
            Value<String> blockType = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
          }) =>
              BlocksCompanion(
            id: id,
            sessionId: sessionId,
            name: name,
            blockOrder: blockOrder,
            blockType: blockType,
            instructions: instructions,
            durationMinutes: durationMinutes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required String name,
            required int blockOrder,
            required String blockType,
            Value<String?> instructions = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
          }) =>
              BlocksCompanion.insert(
            id: id,
            sessionId: sessionId,
            name: name,
            blockOrder: blockOrder,
            blockType: blockType,
            instructions: instructions,
            durationMinutes: durationMinutes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BlocksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {sessionId = false, blockExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (blockExercisesRefs) db.blockExercises
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$BlocksTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$BlocksTableReferences._sessionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (blockExercisesRefs)
                    await $_getPrefetchedData<Block, $BlocksTable,
                            BlockExercise>(
                        currentTable: table,
                        referencedTable: $$BlocksTableReferences
                            ._blockExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BlocksTableReferences(db, table, p0)
                                .blockExercisesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.blockId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BlocksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BlocksTable,
    Block,
    $$BlocksTableFilterComposer,
    $$BlocksTableOrderingComposer,
    $$BlocksTableAnnotationComposer,
    $$BlocksTableCreateCompanionBuilder,
    $$BlocksTableUpdateCompanionBuilder,
    (Block, $$BlocksTableReferences),
    Block,
    PrefetchHooks Function({bool sessionId, bool blockExercisesRefs})>;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  required String category,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BlockExercisesTable, List<BlockExercise>>
      _blockExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.blockExercises,
              aliasName: $_aliasNameGenerator(
                  db.exercises.id, db.blockExercises.exerciseId));

  $$BlockExercisesTableProcessedTableManager get blockExercisesRefs {
    final manager = $$BlockExercisesTableTableManager($_db, $_db.blockExercises)
        .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blockExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  Expression<bool> blockExercisesRefs(
      Expression<bool> Function($$BlockExercisesTableFilterComposer f) f) {
    final $$BlockExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blockExercises,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockExercisesTableFilterComposer(
              $db: $db,
              $table: $db.blockExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  Expression<T> blockExercisesRefs<T extends Object>(
      Expression<T> Function($$BlockExercisesTableAnnotationComposer a) f) {
    final $$BlockExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blockExercises,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.blockExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function({bool blockExercisesRefs})> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            name: name,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String category,
          }) =>
              ExercisesCompanion.insert(
            id: id,
            name: name,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({blockExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (blockExercisesRefs) db.blockExercises
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (blockExercisesRefs)
                    await $_getPrefetchedData<Exercise, $ExercisesTable,
                            BlockExercise>(
                        currentTable: table,
                        referencedTable: $$ExercisesTableReferences
                            ._blockExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExercisesTableReferences(db, table, p0)
                                .blockExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function({bool blockExercisesRefs})>;
typedef $$BlockExercisesTableCreateCompanionBuilder = BlockExercisesCompanion
    Function({
  Value<int> id,
  required int blockId,
  required int exerciseId,
  required int exerciseOrder,
  Value<int?> sets,
  Value<String?> reps,
  Value<String?> tempo,
  Value<int?> restSeconds,
  Value<String?> notes,
  Value<bool> isNew,
});
typedef $$BlockExercisesTableUpdateCompanionBuilder = BlockExercisesCompanion
    Function({
  Value<int> id,
  Value<int> blockId,
  Value<int> exerciseId,
  Value<int> exerciseOrder,
  Value<int?> sets,
  Value<String?> reps,
  Value<String?> tempo,
  Value<int?> restSeconds,
  Value<String?> notes,
  Value<bool> isNew,
});

final class $$BlockExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $BlockExercisesTable, BlockExercise> {
  $$BlockExercisesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $BlocksTable _blockIdTable(_$AppDatabase db) => db.blocks.createAlias(
      $_aliasNameGenerator(db.blockExercises.blockId, db.blocks.id));

  $$BlocksTableProcessedTableManager get blockId {
    final $_column = $_itemColumn<int>('block_id')!;

    final manager = $$BlocksTableTableManager($_db, $_db.blocks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias(
          $_aliasNameGenerator(db.blockExercises.exerciseId, db.exercises.id));

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.setLogs,
          aliasName: $_aliasNameGenerator(
              db.blockExercises.id, db.setLogs.blockExerciseId));

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager($_db, $_db.setLogs).filter(
        (f) => f.blockExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BlockExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $BlockExercisesTable> {
  $$BlockExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exerciseOrder => $composableBuilder(
      column: $table.exerciseOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tempo => $composableBuilder(
      column: $table.tempo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isNew => $composableBuilder(
      column: $table.isNew, builder: (column) => ColumnFilters(column));

  $$BlocksTableFilterComposer get blockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableFilterComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> setLogsRefs(
      Expression<bool> Function($$SetLogsTableFilterComposer f) f) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setLogs,
        getReferencedColumn: (t) => t.blockExerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetLogsTableFilterComposer(
              $db: $db,
              $table: $db.setLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BlockExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockExercisesTable> {
  $$BlockExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exerciseOrder => $composableBuilder(
      column: $table.exerciseOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tempo => $composableBuilder(
      column: $table.tempo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isNew => $composableBuilder(
      column: $table.isNew, builder: (column) => ColumnOrderings(column));

  $$BlocksTableOrderingComposer get blockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableOrderingComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlockExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockExercisesTable> {
  $$BlockExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get exerciseOrder => $composableBuilder(
      column: $table.exerciseOrder, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<String> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<String> get tempo =>
      $composableBuilder(column: $table.tempo, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isNew =>
      $composableBuilder(column: $table.isNew, builder: (column) => column);

  $$BlocksTableAnnotationComposer get blockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
      Expression<T> Function($$SetLogsTableAnnotationComposer a) f) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setLogs,
        getReferencedColumn: (t) => t.blockExerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.setLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BlockExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BlockExercisesTable,
    BlockExercise,
    $$BlockExercisesTableFilterComposer,
    $$BlockExercisesTableOrderingComposer,
    $$BlockExercisesTableAnnotationComposer,
    $$BlockExercisesTableCreateCompanionBuilder,
    $$BlockExercisesTableUpdateCompanionBuilder,
    (BlockExercise, $$BlockExercisesTableReferences),
    BlockExercise,
    PrefetchHooks Function({bool blockId, bool exerciseId, bool setLogsRefs})> {
  $$BlockExercisesTableTableManager(
      _$AppDatabase db, $BlockExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> blockId = const Value.absent(),
            Value<int> exerciseId = const Value.absent(),
            Value<int> exerciseOrder = const Value.absent(),
            Value<int?> sets = const Value.absent(),
            Value<String?> reps = const Value.absent(),
            Value<String?> tempo = const Value.absent(),
            Value<int?> restSeconds = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isNew = const Value.absent(),
          }) =>
              BlockExercisesCompanion(
            id: id,
            blockId: blockId,
            exerciseId: exerciseId,
            exerciseOrder: exerciseOrder,
            sets: sets,
            reps: reps,
            tempo: tempo,
            restSeconds: restSeconds,
            notes: notes,
            isNew: isNew,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int blockId,
            required int exerciseId,
            required int exerciseOrder,
            Value<int?> sets = const Value.absent(),
            Value<String?> reps = const Value.absent(),
            Value<String?> tempo = const Value.absent(),
            Value<int?> restSeconds = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isNew = const Value.absent(),
          }) =>
              BlockExercisesCompanion.insert(
            id: id,
            blockId: blockId,
            exerciseId: exerciseId,
            exerciseOrder: exerciseOrder,
            sets: sets,
            reps: reps,
            tempo: tempo,
            restSeconds: restSeconds,
            notes: notes,
            isNew: isNew,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BlockExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {blockId = false, exerciseId = false, setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
              addJoins: <
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
                      dynamic>>(state) {
                if (blockId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.blockId,
                    referencedTable:
                        $$BlockExercisesTableReferences._blockIdTable(db),
                    referencedColumn:
                        $$BlockExercisesTableReferences._blockIdTable(db).id,
                  ) as T;
                }
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable:
                        $$BlockExercisesTableReferences._exerciseIdTable(db),
                    referencedColumn:
                        $$BlockExercisesTableReferences._exerciseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedData<BlockExercise,
                            $BlockExercisesTable, SetLog>(
                        currentTable: table,
                        referencedTable: $$BlockExercisesTableReferences
                            ._setLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BlockExercisesTableReferences(db, table, p0)
                                .setLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.blockExerciseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BlockExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BlockExercisesTable,
    BlockExercise,
    $$BlockExercisesTableFilterComposer,
    $$BlockExercisesTableOrderingComposer,
    $$BlockExercisesTableAnnotationComposer,
    $$BlockExercisesTableCreateCompanionBuilder,
    $$BlockExercisesTableUpdateCompanionBuilder,
    (BlockExercise, $$BlockExercisesTableReferences),
    BlockExercise,
    PrefetchHooks Function({bool blockId, bool exerciseId, bool setLogsRefs})>;
typedef $$WorkoutLogsTableCreateCompanionBuilder = WorkoutLogsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required int sessionId,
  required int weekNumber,
  required int phaseNumber,
  Value<bool> completed,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
});
typedef $$WorkoutLogsTableUpdateCompanionBuilder = WorkoutLogsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> sessionId,
  Value<int> weekNumber,
  Value<int> phaseNumber,
  Value<bool> completed,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
});

final class $$WorkoutLogsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutLogsTable, WorkoutLog> {
  $$WorkoutLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias(
          $_aliasNameGenerator(db.workoutLogs.sessionId, db.sessions.id));

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.setLogs,
          aliasName:
              $_aliasNameGenerator(db.workoutLogs.id, db.setLogs.workoutLogId));

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager($_db, $_db.setLogs)
        .filter((f) => f.workoutLogId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get phaseNumber => $composableBuilder(
      column: $table.phaseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> setLogsRefs(
      Expression<bool> Function($$SetLogsTableFilterComposer f) f) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setLogs,
        getReferencedColumn: (t) => t.workoutLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetLogsTableFilterComposer(
              $db: $db,
              $table: $db.setLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get phaseNumber => $composableBuilder(
      column: $table.phaseNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableOrderingComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableAnnotationComposer({
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

  GeneratedColumn<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => column);

  GeneratedColumn<int> get phaseNumber => $composableBuilder(
      column: $table.phaseNumber, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
      Expression<T> Function($$SetLogsTableAnnotationComposer a) f) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setLogs,
        getReferencedColumn: (t) => t.workoutLogId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.setLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutLogsTable,
    WorkoutLog,
    $$WorkoutLogsTableFilterComposer,
    $$WorkoutLogsTableOrderingComposer,
    $$WorkoutLogsTableAnnotationComposer,
    $$WorkoutLogsTableCreateCompanionBuilder,
    $$WorkoutLogsTableUpdateCompanionBuilder,
    (WorkoutLog, $$WorkoutLogsTableReferences),
    WorkoutLog,
    PrefetchHooks Function({bool sessionId, bool setLogsRefs})> {
  $$WorkoutLogsTableTableManager(_$AppDatabase db, $WorkoutLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> weekNumber = const Value.absent(),
            Value<int> phaseNumber = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              WorkoutLogsCompanion(
            id: id,
            date: date,
            sessionId: sessionId,
            weekNumber: weekNumber,
            phaseNumber: phaseNumber,
            completed: completed,
            startedAt: startedAt,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int sessionId,
            required int weekNumber,
            required int phaseNumber,
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              WorkoutLogsCompanion.insert(
            id: id,
            date: date,
            sessionId: sessionId,
            weekNumber: weekNumber,
            phaseNumber: phaseNumber,
            completed: completed,
            startedAt: startedAt,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false, setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$WorkoutLogsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$WorkoutLogsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedData<WorkoutLog, $WorkoutLogsTable,
                            SetLog>(
                        currentTable: table,
                        referencedTable:
                            $$WorkoutLogsTableReferences._setLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutLogsTableReferences(db, table, p0)
                                .setLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.workoutLogId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutLogsTable,
    WorkoutLog,
    $$WorkoutLogsTableFilterComposer,
    $$WorkoutLogsTableOrderingComposer,
    $$WorkoutLogsTableAnnotationComposer,
    $$WorkoutLogsTableCreateCompanionBuilder,
    $$WorkoutLogsTableUpdateCompanionBuilder,
    (WorkoutLog, $$WorkoutLogsTableReferences),
    WorkoutLog,
    PrefetchHooks Function({bool sessionId, bool setLogsRefs})>;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  required int workoutLogId,
  required int blockExerciseId,
  required int setNumber,
  Value<int?> repsCompleted,
  Value<double?> weightKg,
  Value<bool> completed,
  Value<DateTime?> completedAt,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> workoutLogId,
  Value<int> blockExerciseId,
  Value<int> setNumber,
  Value<int?> repsCompleted,
  Value<double?> weightKg,
  Value<bool> completed,
  Value<DateTime?> completedAt,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLog> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutLogsTable _workoutLogIdTable(_$AppDatabase db) =>
      db.workoutLogs.createAlias(
          $_aliasNameGenerator(db.setLogs.workoutLogId, db.workoutLogs.id));

  $$WorkoutLogsTableProcessedTableManager get workoutLogId {
    final $_column = $_itemColumn<int>('workout_log_id')!;

    final manager = $$WorkoutLogsTableTableManager($_db, $_db.workoutLogs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $BlockExercisesTable _blockExerciseIdTable(_$AppDatabase db) =>
      db.blockExercises.createAlias($_aliasNameGenerator(
          db.setLogs.blockExerciseId, db.blockExercises.id));

  $$BlockExercisesTableProcessedTableManager get blockExerciseId {
    final $_column = $_itemColumn<int>('block_exercise_id')!;

    final manager = $$BlockExercisesTableTableManager($_db, $_db.blockExercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repsCompleted => $composableBuilder(
      column: $table.repsCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$WorkoutLogsTableFilterComposer get workoutLogId {
    final $$WorkoutLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutLogId,
        referencedTable: $db.workoutLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutLogsTableFilterComposer(
              $db: $db,
              $table: $db.workoutLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlockExercisesTableFilterComposer get blockExerciseId {
    final $$BlockExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockExerciseId,
        referencedTable: $db.blockExercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockExercisesTableFilterComposer(
              $db: $db,
              $table: $db.blockExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repsCompleted => $composableBuilder(
      column: $table.repsCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$WorkoutLogsTableOrderingComposer get workoutLogId {
    final $$WorkoutLogsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutLogId,
        referencedTable: $db.workoutLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutLogsTableOrderingComposer(
              $db: $db,
              $table: $db.workoutLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlockExercisesTableOrderingComposer get blockExerciseId {
    final $$BlockExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockExerciseId,
        referencedTable: $db.blockExercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.blockExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get repsCompleted => $composableBuilder(
      column: $table.repsCompleted, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$WorkoutLogsTableAnnotationComposer get workoutLogId {
    final $$WorkoutLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutLogId,
        referencedTable: $db.workoutLogs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlockExercisesTableAnnotationComposer get blockExerciseId {
    final $$BlockExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.blockExerciseId,
        referencedTable: $db.blockExercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlockExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.blockExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SetLogsTable,
    SetLog,
    $$SetLogsTableFilterComposer,
    $$SetLogsTableOrderingComposer,
    $$SetLogsTableAnnotationComposer,
    $$SetLogsTableCreateCompanionBuilder,
    $$SetLogsTableUpdateCompanionBuilder,
    (SetLog, $$SetLogsTableReferences),
    SetLog,
    PrefetchHooks Function({bool workoutLogId, bool blockExerciseId})> {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> workoutLogId = const Value.absent(),
            Value<int> blockExerciseId = const Value.absent(),
            Value<int> setNumber = const Value.absent(),
            Value<int?> repsCompleted = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              SetLogsCompanion(
            id: id,
            workoutLogId: workoutLogId,
            blockExerciseId: blockExerciseId,
            setNumber: setNumber,
            repsCompleted: repsCompleted,
            weightKg: weightKg,
            completed: completed,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int workoutLogId,
            required int blockExerciseId,
            required int setNumber,
            Value<int?> repsCompleted = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              SetLogsCompanion.insert(
            id: id,
            workoutLogId: workoutLogId,
            blockExerciseId: blockExerciseId,
            setNumber: setNumber,
            repsCompleted: repsCompleted,
            weightKg: weightKg,
            completed: completed,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SetLogsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {workoutLogId = false, blockExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (workoutLogId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.workoutLogId,
                    referencedTable:
                        $$SetLogsTableReferences._workoutLogIdTable(db),
                    referencedColumn:
                        $$SetLogsTableReferences._workoutLogIdTable(db).id,
                  ) as T;
                }
                if (blockExerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.blockExerciseId,
                    referencedTable:
                        $$SetLogsTableReferences._blockExerciseIdTable(db),
                    referencedColumn:
                        $$SetLogsTableReferences._blockExerciseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SetLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SetLogsTable,
    SetLog,
    $$SetLogsTableFilterComposer,
    $$SetLogsTableOrderingComposer,
    $$SetLogsTableAnnotationComposer,
    $$SetLogsTableCreateCompanionBuilder,
    $$SetLogsTableUpdateCompanionBuilder,
    (SetLog, $$SetLogsTableReferences),
    SetLog,
    PrefetchHooks Function({bool workoutLogId, bool blockExerciseId})>;
typedef $$UserStateTableTableCreateCompanionBuilder = UserStateTableCompanion
    Function({
  Value<int> id,
  required DateTime programStartDate,
  Value<bool> onboardingComplete,
});
typedef $$UserStateTableTableUpdateCompanionBuilder = UserStateTableCompanion
    Function({
  Value<int> id,
  Value<DateTime> programStartDate,
  Value<bool> onboardingComplete,
});

class $$UserStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserStateTableTable> {
  $$UserStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get programStartDate => $composableBuilder(
      column: $table.programStartDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
      column: $table.onboardingComplete,
      builder: (column) => ColumnFilters(column));
}

class $$UserStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStateTableTable> {
  $$UserStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get programStartDate => $composableBuilder(
      column: $table.programStartDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
      column: $table.onboardingComplete,
      builder: (column) => ColumnOrderings(column));
}

class $$UserStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStateTableTable> {
  $$UserStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get programStartDate => $composableBuilder(
      column: $table.programStartDate, builder: (column) => column);

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
      column: $table.onboardingComplete, builder: (column) => column);
}

class $$UserStateTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserStateTableTable,
    UserStateRow,
    $$UserStateTableTableFilterComposer,
    $$UserStateTableTableOrderingComposer,
    $$UserStateTableTableAnnotationComposer,
    $$UserStateTableTableCreateCompanionBuilder,
    $$UserStateTableTableUpdateCompanionBuilder,
    (
      UserStateRow,
      BaseReferences<_$AppDatabase, $UserStateTableTable, UserStateRow>
    ),
    UserStateRow,
    PrefetchHooks Function()> {
  $$UserStateTableTableTableManager(
      _$AppDatabase db, $UserStateTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStateTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> programStartDate = const Value.absent(),
            Value<bool> onboardingComplete = const Value.absent(),
          }) =>
              UserStateTableCompanion(
            id: id,
            programStartDate: programStartDate,
            onboardingComplete: onboardingComplete,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime programStartDate,
            Value<bool> onboardingComplete = const Value.absent(),
          }) =>
              UserStateTableCompanion.insert(
            id: id,
            programStartDate: programStartDate,
            onboardingComplete: onboardingComplete,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserStateTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserStateTableTable,
    UserStateRow,
    $$UserStateTableTableFilterComposer,
    $$UserStateTableTableOrderingComposer,
    $$UserStateTableTableAnnotationComposer,
    $$UserStateTableTableCreateCompanionBuilder,
    $$UserStateTableTableUpdateCompanionBuilder,
    (
      UserStateRow,
      BaseReferences<_$AppDatabase, $UserStateTableTable, UserStateRow>
    ),
    UserStateRow,
    PrefetchHooks Function()>;
typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<String?> name,
  Value<int?> age,
  Value<String?> sex,
  Value<double?> weightKg,
  Value<double?> heightCm,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<String?> name,
  Value<int?> age,
  Value<String?> sex,
  Value<double?> weightKg,
  Value<double?> heightCm,
});

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
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

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);
}

class $$UserProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int?> age = const Value.absent(),
            Value<String?> sex = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            id: id,
            name: name,
            age: age,
            sex: sex,
            weightKg: weightKg,
            heightCm: heightCm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int?> age = const Value.absent(),
            Value<String?> sex = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
          }) =>
              UserProfilesCompanion.insert(
            id: id,
            name: name,
            age: age,
            sex: sex,
            weightKg: weightKg,
            heightCm: heightCm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PhasesTableTableManager get phases =>
      $$PhasesTableTableManager(_db, _db.phases);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$BlocksTableTableManager get blocks =>
      $$BlocksTableTableManager(_db, _db.blocks);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$BlockExercisesTableTableManager get blockExercises =>
      $$BlockExercisesTableTableManager(_db, _db.blockExercises);
  $$WorkoutLogsTableTableManager get workoutLogs =>
      $$WorkoutLogsTableTableManager(_db, _db.workoutLogs);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$UserStateTableTableTableManager get userStateTable =>
      $$UserStateTableTableTableManager(_db, _db.userStateTable);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
}
