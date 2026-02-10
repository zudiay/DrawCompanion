// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DrawingsTable extends Drawings with TableInfo<$DrawingsTable, Drawing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrawingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    category,
    date,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drawings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Drawing> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('image_data')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_data']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Drawing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Drawing(
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
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_data'],
      )!,
    );
  }

  @override
  $DrawingsTable createAlias(String alias) {
    return $DrawingsTable(attachedDatabase, alias);
  }
}

class Drawing extends DataClass implements Insertable<Drawing> {
  final int id;
  final String name;
  final String? description;
  final String? category;
  final DateTime date;
  final String imagePath;
  const Drawing({
    required this.id,
    required this.name,
    this.description,
    this.category,
    required this.date,
    required this.imagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['date'] = Variable<DateTime>(date);
    map['image_data'] = Variable<String>(imagePath);
    return map;
  }

  DrawingsCompanion toCompanion(bool nullToAbsent) {
    return DrawingsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      date: Value(date),
      imagePath: Value(imagePath),
    );
  }

  factory Drawing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Drawing(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String?>(category),
      'date': serializer.toJson<DateTime>(date),
      'imagePath': serializer.toJson<String>(imagePath),
    };
  }

  Drawing copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> category = const Value.absent(),
    DateTime? date,
    String? imagePath,
  }) => Drawing(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    category: category.present ? category.value : this.category,
    date: date ?? this.date,
    imagePath: imagePath ?? this.imagePath,
  );
  Drawing copyWithCompanion(DrawingsCompanion data) {
    return Drawing(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Drawing(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, category, date, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Drawing &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.date == this.date &&
          other.imagePath == this.imagePath);
}

class DrawingsCompanion extends UpdateCompanion<Drawing> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> category;
  final Value<DateTime> date;
  final Value<String> imagePath;
  const DrawingsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  DrawingsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    required DateTime date,
    required String imagePath,
  }) : name = Value(name),
       date = Value(date),
       imagePath = Value(imagePath);
  static Insertable<Drawing> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (imagePath != null) 'image_data': imagePath,
    });
  }

  DrawingsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? category,
    Value<DateTime>? date,
    Value<String>? imagePath,
  }) {
    return DrawingsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (imagePath.present) {
      map['image_data'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrawingsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class $InspoImagesTable extends InspoImages
    with TableInfo<$InspoImagesTable, InspoImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspoImagesTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _techniqueMeta = const VerificationMeta(
    'technique',
  );
  @override
  late final GeneratedColumn<String> technique = GeneratedColumn<String>(
    'technique',
    aliasedName,
    false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    level,
    technique,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspo_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspoImage> instance, {
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
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('technique')) {
      context.handle(
        _techniqueMeta,
        technique.isAcceptableOrUnknown(data['technique']!, _techniqueMeta),
      );
    } else if (isInserting) {
      context.missing(_techniqueMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspoImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspoImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      technique: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technique'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $InspoImagesTable createAlias(String alias) {
    return $InspoImagesTable(attachedDatabase, alias);
  }
}

class InspoImage extends DataClass implements Insertable<InspoImage> {
  final int id;
  final String name;
  final String level;
  final String technique;
  final String? description;
  const InspoImage({
    required this.id,
    required this.name,
    required this.level,
    required this.technique,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['level'] = Variable<String>(level);
    map['technique'] = Variable<String>(technique);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  InspoImagesCompanion toCompanion(bool nullToAbsent) {
    return InspoImagesCompanion(
      id: Value(id),
      name: Value(name),
      level: Value(level),
      technique: Value(technique),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory InspoImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspoImage(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<String>(json['level']),
      technique: serializer.fromJson<String>(json['technique']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<String>(level),
      'technique': serializer.toJson<String>(technique),
      'description': serializer.toJson<String?>(description),
    };
  }

  InspoImage copyWith({
    int? id,
    String? name,
    String? level,
    String? technique,
    Value<String?> description = const Value.absent(),
  }) => InspoImage(
    id: id ?? this.id,
    name: name ?? this.name,
    level: level ?? this.level,
    technique: technique ?? this.technique,
    description: description.present ? description.value : this.description,
  );
  InspoImage copyWithCompanion(InspoImagesCompanion data) {
    return InspoImage(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      technique: data.technique.present ? data.technique.value : this.technique,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspoImage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('technique: $technique, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, level, technique, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspoImage &&
          other.id == this.id &&
          other.name == this.name &&
          other.level == this.level &&
          other.technique == this.technique &&
          other.description == this.description);
}

class InspoImagesCompanion extends UpdateCompanion<InspoImage> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> level;
  final Value<String> technique;
  final Value<String?> description;
  const InspoImagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.technique = const Value.absent(),
    this.description = const Value.absent(),
  });
  InspoImagesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String level,
    required String technique,
    this.description = const Value.absent(),
  }) : name = Value(name),
       level = Value(level),
       technique = Value(technique);
  static Insertable<InspoImage> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? level,
    Expression<String>? technique,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (technique != null) 'technique': technique,
      if (description != null) 'description': description,
    });
  }

  InspoImagesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? level,
    Value<String>? technique,
    Value<String?>? description,
  }) {
    return InspoImagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      technique: technique ?? this.technique,
      description: description ?? this.description,
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
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (technique.present) {
      map['technique'] = Variable<String>(technique.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspoImagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('technique: $technique, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $FeedbacksTable extends Feedbacks
    with TableInfo<$FeedbacksTable, Feedback> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedbacksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _drawingIdMeta = const VerificationMeta(
    'drawingId',
  );
  @override
  late final GeneratedColumn<int> drawingId = GeneratedColumn<int>(
    'drawing_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creationDateMeta = const VerificationMeta(
    'creationDate',
  );
  @override
  late final GeneratedColumn<DateTime> creationDate = GeneratedColumn<DateTime>(
    'creation_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feedbackTextMeta = const VerificationMeta(
    'feedbackText',
  );
  @override
  late final GeneratedColumn<String> feedbackText = GeneratedColumn<String>(
    'feedback_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    drawingId,
    creationDate,
    feedbackText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feedbacks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Feedback> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('drawing_id')) {
      context.handle(
        _drawingIdMeta,
        drawingId.isAcceptableOrUnknown(data['drawing_id']!, _drawingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_drawingIdMeta);
    }
    if (data.containsKey('creation_date')) {
      context.handle(
        _creationDateMeta,
        creationDate.isAcceptableOrUnknown(
          data['creation_date']!,
          _creationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creationDateMeta);
    }
    if (data.containsKey('feedback_text')) {
      context.handle(
        _feedbackTextMeta,
        feedbackText.isAcceptableOrUnknown(
          data['feedback_text']!,
          _feedbackTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Feedback map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Feedback(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      drawingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drawing_id'],
      )!,
      creationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creation_date'],
      )!,
      feedbackText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback_text'],
      ),
    );
  }

  @override
  $FeedbacksTable createAlias(String alias) {
    return $FeedbacksTable(attachedDatabase, alias);
  }
}

class Feedback extends DataClass implements Insertable<Feedback> {
  final int id;
  final int drawingId;
  final DateTime creationDate;
  final String? feedbackText;
  const Feedback({
    required this.id,
    required this.drawingId,
    required this.creationDate,
    this.feedbackText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['drawing_id'] = Variable<int>(drawingId);
    map['creation_date'] = Variable<DateTime>(creationDate);
    if (!nullToAbsent || feedbackText != null) {
      map['feedback_text'] = Variable<String>(feedbackText);
    }
    return map;
  }

  FeedbacksCompanion toCompanion(bool nullToAbsent) {
    return FeedbacksCompanion(
      id: Value(id),
      drawingId: Value(drawingId),
      creationDate: Value(creationDate),
      feedbackText: feedbackText == null && nullToAbsent
          ? const Value.absent()
          : Value(feedbackText),
    );
  }

  factory Feedback.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Feedback(
      id: serializer.fromJson<int>(json['id']),
      drawingId: serializer.fromJson<int>(json['drawingId']),
      creationDate: serializer.fromJson<DateTime>(json['creationDate']),
      feedbackText: serializer.fromJson<String?>(json['feedbackText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'drawingId': serializer.toJson<int>(drawingId),
      'creationDate': serializer.toJson<DateTime>(creationDate),
      'feedbackText': serializer.toJson<String?>(feedbackText),
    };
  }

  Feedback copyWith({
    int? id,
    int? drawingId,
    DateTime? creationDate,
    Value<String?> feedbackText = const Value.absent(),
  }) => Feedback(
    id: id ?? this.id,
    drawingId: drawingId ?? this.drawingId,
    creationDate: creationDate ?? this.creationDate,
    feedbackText: feedbackText.present ? feedbackText.value : this.feedbackText,
  );
  Feedback copyWithCompanion(FeedbacksCompanion data) {
    return Feedback(
      id: data.id.present ? data.id.value : this.id,
      drawingId: data.drawingId.present ? data.drawingId.value : this.drawingId,
      creationDate: data.creationDate.present
          ? data.creationDate.value
          : this.creationDate,
      feedbackText: data.feedbackText.present
          ? data.feedbackText.value
          : this.feedbackText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Feedback(')
          ..write('id: $id, ')
          ..write('drawingId: $drawingId, ')
          ..write('creationDate: $creationDate, ')
          ..write('feedbackText: $feedbackText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, drawingId, creationDate, feedbackText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Feedback &&
          other.id == this.id &&
          other.drawingId == this.drawingId &&
          other.creationDate == this.creationDate &&
          other.feedbackText == this.feedbackText);
}

class FeedbacksCompanion extends UpdateCompanion<Feedback> {
  final Value<int> id;
  final Value<int> drawingId;
  final Value<DateTime> creationDate;
  final Value<String?> feedbackText;
  const FeedbacksCompanion({
    this.id = const Value.absent(),
    this.drawingId = const Value.absent(),
    this.creationDate = const Value.absent(),
    this.feedbackText = const Value.absent(),
  });
  FeedbacksCompanion.insert({
    this.id = const Value.absent(),
    required int drawingId,
    required DateTime creationDate,
    this.feedbackText = const Value.absent(),
  }) : drawingId = Value(drawingId),
       creationDate = Value(creationDate);
  static Insertable<Feedback> custom({
    Expression<int>? id,
    Expression<int>? drawingId,
    Expression<DateTime>? creationDate,
    Expression<String>? feedbackText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (drawingId != null) 'drawing_id': drawingId,
      if (creationDate != null) 'creation_date': creationDate,
      if (feedbackText != null) 'feedback_text': feedbackText,
    });
  }

  FeedbacksCompanion copyWith({
    Value<int>? id,
    Value<int>? drawingId,
    Value<DateTime>? creationDate,
    Value<String?>? feedbackText,
  }) {
    return FeedbacksCompanion(
      id: id ?? this.id,
      drawingId: drawingId ?? this.drawingId,
      creationDate: creationDate ?? this.creationDate,
      feedbackText: feedbackText ?? this.feedbackText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (drawingId.present) {
      map['drawing_id'] = Variable<int>(drawingId.value);
    }
    if (creationDate.present) {
      map['creation_date'] = Variable<DateTime>(creationDate.value);
    }
    if (feedbackText.present) {
      map['feedback_text'] = Variable<String>(feedbackText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedbacksCompanion(')
          ..write('id: $id, ')
          ..write('drawingId: $drawingId, ')
          ..write('creationDate: $creationDate, ')
          ..write('feedbackText: $feedbackText')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DrawingsTable drawings = $DrawingsTable(this);
  late final $InspoImagesTable inspoImages = $InspoImagesTable(this);
  late final $FeedbacksTable feedbacks = $FeedbacksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    drawings,
    inspoImages,
    feedbacks,
  ];
}

typedef $$DrawingsTableCreateCompanionBuilder =
    DrawingsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String?> category,
      required DateTime date,
      required String imagePath,
    });
typedef $$DrawingsTableUpdateCompanionBuilder =
    DrawingsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> category,
      Value<DateTime> date,
      Value<String> imagePath,
    });

class $$DrawingsTableFilterComposer
    extends Composer<_$AppDatabase, $DrawingsTable> {
  $$DrawingsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DrawingsTableOrderingComposer
    extends Composer<_$AppDatabase, $DrawingsTable> {
  $$DrawingsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DrawingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrawingsTable> {
  $$DrawingsTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);
}

class $$DrawingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrawingsTable,
          Drawing,
          $$DrawingsTableFilterComposer,
          $$DrawingsTableOrderingComposer,
          $$DrawingsTableAnnotationComposer,
          $$DrawingsTableCreateCompanionBuilder,
          $$DrawingsTableUpdateCompanionBuilder,
          (Drawing, BaseReferences<_$AppDatabase, $DrawingsTable, Drawing>),
          Drawing,
          PrefetchHooks Function()
        > {
  $$DrawingsTableTableManager(_$AppDatabase db, $DrawingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrawingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrawingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrawingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
              }) => DrawingsCompanion(
                id: id,
                name: name,
                description: description,
                category: category,
                date: date,
                imagePath: imagePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                required DateTime date,
                required String imagePath,
              }) => DrawingsCompanion.insert(
                id: id,
                name: name,
                description: description,
                category: category,
                date: date,
                imagePath: imagePath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DrawingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrawingsTable,
      Drawing,
      $$DrawingsTableFilterComposer,
      $$DrawingsTableOrderingComposer,
      $$DrawingsTableAnnotationComposer,
      $$DrawingsTableCreateCompanionBuilder,
      $$DrawingsTableUpdateCompanionBuilder,
      (Drawing, BaseReferences<_$AppDatabase, $DrawingsTable, Drawing>),
      Drawing,
      PrefetchHooks Function()
    >;
typedef $$InspoImagesTableCreateCompanionBuilder =
    InspoImagesCompanion Function({
      Value<int> id,
      required String name,
      required String level,
      required String technique,
      Value<String?> description,
    });
typedef $$InspoImagesTableUpdateCompanionBuilder =
    InspoImagesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> level,
      Value<String> technique,
      Value<String?> description,
    });

class $$InspoImagesTableFilterComposer
    extends Composer<_$AppDatabase, $InspoImagesTable> {
  $$InspoImagesTableFilterComposer({
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

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technique => $composableBuilder(
    column: $table.technique,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspoImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $InspoImagesTable> {
  $$InspoImagesTableOrderingComposer({
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

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technique => $composableBuilder(
    column: $table.technique,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspoImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspoImagesTable> {
  $$InspoImagesTableAnnotationComposer({
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

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get technique =>
      $composableBuilder(column: $table.technique, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$InspoImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspoImagesTable,
          InspoImage,
          $$InspoImagesTableFilterComposer,
          $$InspoImagesTableOrderingComposer,
          $$InspoImagesTableAnnotationComposer,
          $$InspoImagesTableCreateCompanionBuilder,
          $$InspoImagesTableUpdateCompanionBuilder,
          (
            InspoImage,
            BaseReferences<_$AppDatabase, $InspoImagesTable, InspoImage>,
          ),
          InspoImage,
          PrefetchHooks Function()
        > {
  $$InspoImagesTableTableManager(_$AppDatabase db, $InspoImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspoImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspoImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspoImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> technique = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => InspoImagesCompanion(
                id: id,
                name: name,
                level: level,
                technique: technique,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String level,
                required String technique,
                Value<String?> description = const Value.absent(),
              }) => InspoImagesCompanion.insert(
                id: id,
                name: name,
                level: level,
                technique: technique,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspoImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspoImagesTable,
      InspoImage,
      $$InspoImagesTableFilterComposer,
      $$InspoImagesTableOrderingComposer,
      $$InspoImagesTableAnnotationComposer,
      $$InspoImagesTableCreateCompanionBuilder,
      $$InspoImagesTableUpdateCompanionBuilder,
      (
        InspoImage,
        BaseReferences<_$AppDatabase, $InspoImagesTable, InspoImage>,
      ),
      InspoImage,
      PrefetchHooks Function()
    >;
typedef $$FeedbacksTableCreateCompanionBuilder =
    FeedbacksCompanion Function({
      Value<int> id,
      required int drawingId,
      required DateTime creationDate,
      Value<String?> feedbackText,
    });
typedef $$FeedbacksTableUpdateCompanionBuilder =
    FeedbacksCompanion Function({
      Value<int> id,
      Value<int> drawingId,
      Value<DateTime> creationDate,
      Value<String?> feedbackText,
    });

class $$FeedbacksTableFilterComposer
    extends Composer<_$AppDatabase, $FeedbacksTable> {
  $$FeedbacksTableFilterComposer({
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

  ColumnFilters<int> get drawingId => $composableBuilder(
    column: $table.drawingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creationDate => $composableBuilder(
    column: $table.creationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedbackText => $composableBuilder(
    column: $table.feedbackText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeedbacksTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedbacksTable> {
  $$FeedbacksTableOrderingComposer({
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

  ColumnOrderings<int> get drawingId => $composableBuilder(
    column: $table.drawingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creationDate => $composableBuilder(
    column: $table.creationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedbackText => $composableBuilder(
    column: $table.feedbackText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedbacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedbacksTable> {
  $$FeedbacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get drawingId =>
      $composableBuilder(column: $table.drawingId, builder: (column) => column);

  GeneratedColumn<DateTime> get creationDate => $composableBuilder(
    column: $table.creationDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get feedbackText => $composableBuilder(
    column: $table.feedbackText,
    builder: (column) => column,
  );
}

class $$FeedbacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedbacksTable,
          Feedback,
          $$FeedbacksTableFilterComposer,
          $$FeedbacksTableOrderingComposer,
          $$FeedbacksTableAnnotationComposer,
          $$FeedbacksTableCreateCompanionBuilder,
          $$FeedbacksTableUpdateCompanionBuilder,
          (Feedback, BaseReferences<_$AppDatabase, $FeedbacksTable, Feedback>),
          Feedback,
          PrefetchHooks Function()
        > {
  $$FeedbacksTableTableManager(_$AppDatabase db, $FeedbacksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedbacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedbacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedbacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> drawingId = const Value.absent(),
                Value<DateTime> creationDate = const Value.absent(),
                Value<String?> feedbackText = const Value.absent(),
              }) => FeedbacksCompanion(
                id: id,
                drawingId: drawingId,
                creationDate: creationDate,
                feedbackText: feedbackText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int drawingId,
                required DateTime creationDate,
                Value<String?> feedbackText = const Value.absent(),
              }) => FeedbacksCompanion.insert(
                id: id,
                drawingId: drawingId,
                creationDate: creationDate,
                feedbackText: feedbackText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedbacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedbacksTable,
      Feedback,
      $$FeedbacksTableFilterComposer,
      $$FeedbacksTableOrderingComposer,
      $$FeedbacksTableAnnotationComposer,
      $$FeedbacksTableCreateCompanionBuilder,
      $$FeedbacksTableUpdateCompanionBuilder,
      (Feedback, BaseReferences<_$AppDatabase, $FeedbacksTable, Feedback>),
      Feedback,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DrawingsTableTableManager get drawings =>
      $$DrawingsTableTableManager(_db, _db.drawings);
  $$InspoImagesTableTableManager get inspoImages =>
      $$InspoImagesTableTableManager(_db, _db.inspoImages);
  $$FeedbacksTableTableManager get feedbacks =>
      $$FeedbacksTableTableManager(_db, _db.feedbacks);
}
