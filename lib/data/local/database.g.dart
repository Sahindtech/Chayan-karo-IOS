// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ServiceCategoriesTableTable extends ServiceCategoriesTable
    with TableInfo<$ServiceCategoriesTableTable, ServiceCategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCategoriesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  List<GeneratedColumn> get $columns => [id, title, icon, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceCategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
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
  ServiceCategoriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceCategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServiceCategoriesTableTable createAlias(String alias) {
    return $ServiceCategoriesTableTable(attachedDatabase, alias);
  }
}

class ServiceCategoriesTableData extends DataClass
    implements Insertable<ServiceCategoriesTableData> {
  final int id;
  final String title;
  final String icon;
  final DateTime createdAt;
  const ServiceCategoriesTableData({
    required this.id,
    required this.title,
    required this.icon,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['icon'] = Variable<String>(icon);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServiceCategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return ServiceCategoriesTableCompanion(
      id: Value(id),
      title: Value(title),
      icon: Value(icon),
      createdAt: Value(createdAt),
    );
  }

  factory ServiceCategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceCategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      icon: serializer.fromJson<String>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'icon': serializer.toJson<String>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ServiceCategoriesTableData copyWith({
    int? id,
    String? title,
    String? icon,
    DateTime? createdAt,
  }) => ServiceCategoriesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    createdAt: createdAt ?? this.createdAt,
  );
  ServiceCategoriesTableData copyWithCompanion(
    ServiceCategoriesTableCompanion data,
  ) {
    return ServiceCategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoriesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, icon, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceCategoriesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt);
}

class ServiceCategoriesTableCompanion
    extends UpdateCompanion<ServiceCategoriesTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> icon;
  final Value<DateTime> createdAt;
  const ServiceCategoriesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ServiceCategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String icon,
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       icon = Value(icon);
  static Insertable<ServiceCategoriesTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ServiceCategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? icon,
    Value<DateTime>? createdAt,
  }) {
    return ServiceCategoriesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imgLinkMeta = const VerificationMeta(
    'imgLink',
  );
  @override
  late final GeneratedColumn<String> imgLink = GeneratedColumn<String>(
    'img_link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceCategoryMeta = const VerificationMeta(
    'serviceCategory',
  );
  @override
  late final GeneratedColumn<String> serviceCategory = GeneratedColumn<String>(
    'service_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    categoryId,
    categoryName,
    imgLink,
    serviceCategory,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('img_link')) {
      context.handle(
        _imgLinkMeta,
        imgLink.isAcceptableOrUnknown(data['img_link']!, _imgLinkMeta),
      );
    } else if (isInserting) {
      context.missing(_imgLinkMeta);
    }
    if (data.containsKey('service_category')) {
      context.handle(
        _serviceCategoryMeta,
        serviceCategory.isAcceptableOrUnknown(
          data['service_category']!,
          _serviceCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceCategoryMeta);
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
  Set<GeneratedColumn> get $primaryKey => {categoryId};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      imgLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}img_link'],
      )!,
      serviceCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_category'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String categoryId;
  final String categoryName;
  final String imgLink;
  final String serviceCategory;
  final DateTime createdAt;
  const CategoriesTableData({
    required this.categoryId,
    required this.categoryName,
    required this.imgLink,
    required this.serviceCategory,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<String>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['img_link'] = Variable<String>(imgLink);
    map['service_category'] = Variable<String>(serviceCategory);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      imgLink: Value(imgLink),
      serviceCategory: Value(serviceCategory),
      createdAt: Value(createdAt),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      imgLink: serializer.fromJson<String>(json['imgLink']),
      serviceCategory: serializer.fromJson<String>(json['serviceCategory']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'imgLink': serializer.toJson<String>(imgLink),
      'serviceCategory': serializer.toJson<String>(serviceCategory),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoriesTableData copyWith({
    String? categoryId,
    String? categoryName,
    String? imgLink,
    String? serviceCategory,
    DateTime? createdAt,
  }) => CategoriesTableData(
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    imgLink: imgLink ?? this.imgLink,
    serviceCategory: serviceCategory ?? this.serviceCategory,
    createdAt: createdAt ?? this.createdAt,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      imgLink: data.imgLink.present ? data.imgLink.value : this.imgLink,
      serviceCategory: data.serviceCategory.present
          ? data.serviceCategory.value
          : this.serviceCategory,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('imgLink: $imgLink, ')
          ..write('serviceCategory: $serviceCategory, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    categoryId,
    categoryName,
    imgLink,
    serviceCategory,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.imgLink == this.imgLink &&
          other.serviceCategory == this.serviceCategory &&
          other.createdAt == this.createdAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> categoryId;
  final Value<String> categoryName;
  final Value<String> imgLink;
  final Value<String> serviceCategory;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.imgLink = const Value.absent(),
    this.serviceCategory = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String categoryId,
    required String categoryName,
    required String imgLink,
    required String serviceCategory,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : categoryId = Value(categoryId),
       categoryName = Value(categoryName),
       imgLink = Value(imgLink),
       serviceCategory = Value(serviceCategory);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? imgLink,
    Expression<String>? serviceCategory,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (imgLink != null) 'img_link': imgLink,
      if (serviceCategory != null) 'service_category': serviceCategory,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? categoryId,
    Value<String>? categoryName,
    Value<String>? imgLink,
    Value<String>? serviceCategory,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imgLink: imgLink ?? this.imgLink,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (imgLink.present) {
      map['img_link'] = Variable<String>(imgLink.value);
    }
    if (serviceCategory.present) {
      map['service_category'] = Variable<String>(serviceCategory.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('imgLink: $imgLink, ')
          ..write('serviceCategory: $serviceCategory, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServicesTableTable extends ServicesTable
    with TableInfo<$ServicesTableTable, ServicesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, title, image, type, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServicesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
  ServicesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServicesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServicesTableTable createAlias(String alias) {
    return $ServicesTableTable(attachedDatabase, alias);
  }
}

class ServicesTableData extends DataClass
    implements Insertable<ServicesTableData> {
  final int id;
  final String title;
  final String image;
  final String type;
  final DateTime createdAt;
  const ServicesTableData({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['image'] = Variable<String>(image);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServicesTableCompanion toCompanion(bool nullToAbsent) {
    return ServicesTableCompanion(
      id: Value(id),
      title: Value(title),
      image: Value(image),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory ServicesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServicesTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      image: serializer.fromJson<String>(json['image']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'image': serializer.toJson<String>(image),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ServicesTableData copyWith({
    int? id,
    String? title,
    String? image,
    String? type,
    DateTime? createdAt,
  }) => ServicesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    image: image ?? this.image,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
  );
  ServicesTableData copyWithCompanion(ServicesTableCompanion data) {
    return ServicesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      image: data.image.present ? data.image.value : this.image,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServicesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, image, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServicesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.image == this.image &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class ServicesTableCompanion extends UpdateCompanion<ServicesTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> image;
  final Value<String> type;
  final Value<DateTime> createdAt;
  const ServicesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.image = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ServicesTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String image,
    required String type,
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       image = Value(image),
       type = Value(type);
  static Insertable<ServicesTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? image,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (image != null) 'image': image,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ServicesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? image,
    Value<String>? type,
    Value<DateTime>? createdAt,
  }) {
    return ServicesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('image: $image, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ApiServicesTableTable extends ApiServicesTable
    with TableInfo<$ApiServicesTableTable, ApiServicesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiServicesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imgLinkMeta = const VerificationMeta(
    'imgLink',
  );
  @override
  late final GeneratedColumn<String> imgLink = GeneratedColumn<String>(
    'img_link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>(
        'discount_percentage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    name,
    price,
    description,
    duration,
    imgLink,
    discountPercentage,
    categoryId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'api_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApiServicesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('img_link')) {
      context.handle(
        _imgLinkMeta,
        imgLink.isAcceptableOrUnknown(data['img_link']!, _imgLinkMeta),
      );
    } else if (isInserting) {
      context.missing(_imgLinkMeta);
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
        _discountPercentageMeta,
        discountPercentage.isAcceptableOrUnknown(
          data['discount_percentage']!,
          _discountPercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountPercentageMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
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
  ApiServicesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApiServicesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      imgLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}img_link'],
      )!,
      discountPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percentage'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ApiServicesTableTable createAlias(String alias) {
    return $ApiServicesTableTable(attachedDatabase, alias);
  }
}

class ApiServicesTableData extends DataClass
    implements Insertable<ApiServicesTableData> {
  final String id;
  final String name;
  final double price;
  final String description;
  final int duration;
  final String imgLink;
  final double discountPercentage;
  final String categoryId;
  final DateTime createdAt;
  const ApiServicesTableData({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.duration,
    required this.imgLink,
    required this.discountPercentage,
    required this.categoryId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['description'] = Variable<String>(description);
    map['duration'] = Variable<int>(duration);
    map['img_link'] = Variable<String>(imgLink);
    map['discount_percentage'] = Variable<double>(discountPercentage);
    map['category_id'] = Variable<String>(categoryId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ApiServicesTableCompanion toCompanion(bool nullToAbsent) {
    return ApiServicesTableCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      description: Value(description),
      duration: Value(duration),
      imgLink: Value(imgLink),
      discountPercentage: Value(discountPercentage),
      categoryId: Value(categoryId),
      createdAt: Value(createdAt),
    );
  }

  factory ApiServicesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApiServicesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      description: serializer.fromJson<String>(json['description']),
      duration: serializer.fromJson<int>(json['duration']),
      imgLink: serializer.fromJson<String>(json['imgLink']),
      discountPercentage: serializer.fromJson<double>(
        json['discountPercentage'],
      ),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'description': serializer.toJson<String>(description),
      'duration': serializer.toJson<int>(duration),
      'imgLink': serializer.toJson<String>(imgLink),
      'discountPercentage': serializer.toJson<double>(discountPercentage),
      'categoryId': serializer.toJson<String>(categoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ApiServicesTableData copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    int? duration,
    String? imgLink,
    double? discountPercentage,
    String? categoryId,
    DateTime? createdAt,
  }) => ApiServicesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    description: description ?? this.description,
    duration: duration ?? this.duration,
    imgLink: imgLink ?? this.imgLink,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    categoryId: categoryId ?? this.categoryId,
    createdAt: createdAt ?? this.createdAt,
  );
  ApiServicesTableData copyWithCompanion(ApiServicesTableCompanion data) {
    return ApiServicesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      description: data.description.present
          ? data.description.value
          : this.description,
      duration: data.duration.present ? data.duration.value : this.duration,
      imgLink: data.imgLink.present ? data.imgLink.value : this.imgLink,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApiServicesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('duration: $duration, ')
          ..write('imgLink: $imgLink, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    price,
    description,
    duration,
    imgLink,
    discountPercentage,
    categoryId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiServicesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.description == this.description &&
          other.duration == this.duration &&
          other.imgLink == this.imgLink &&
          other.discountPercentage == this.discountPercentage &&
          other.categoryId == this.categoryId &&
          other.createdAt == this.createdAt);
}

class ApiServicesTableCompanion extends UpdateCompanion<ApiServicesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String> description;
  final Value<int> duration;
  final Value<String> imgLink;
  final Value<double> discountPercentage;
  final Value<String> categoryId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ApiServicesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.description = const Value.absent(),
    this.duration = const Value.absent(),
    this.imgLink = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ApiServicesTableCompanion.insert({
    required String id,
    required String name,
    required double price,
    required String description,
    required int duration,
    required String imgLink,
    required double discountPercentage,
    required String categoryId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       price = Value(price),
       description = Value(description),
       duration = Value(duration),
       imgLink = Value(imgLink),
       discountPercentage = Value(discountPercentage),
       categoryId = Value(categoryId);
  static Insertable<ApiServicesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? description,
    Expression<int>? duration,
    Expression<String>? imgLink,
    Expression<double>? discountPercentage,
    Expression<String>? categoryId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (description != null) 'description': description,
      if (duration != null) 'duration': duration,
      if (imgLink != null) 'img_link': imgLink,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (categoryId != null) 'category_id': categoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ApiServicesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? price,
    Value<String>? description,
    Value<int>? duration,
    Value<String>? imgLink,
    Value<double>? discountPercentage,
    Value<String>? categoryId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ApiServicesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      imgLink: imgLink ?? this.imgLink,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (imgLink.present) {
      map['img_link'] = Variable<String>(imgLink.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiServicesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('description: $description, ')
          ..write('duration: $duration, ')
          ..write('imgLink: $imgLink, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  List<GeneratedColumn> get $columns => [key, value, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreferencesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserPreferencesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferencesTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
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
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreferencesTableData extends DataClass
    implements Insertable<UserPreferencesTableData> {
  final String key;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserPreferencesTableData({
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      key: Value(key),
      value: Value(value),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreferencesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferencesTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreferencesTableData copyWith({
    String? key,
    String? value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserPreferencesTableData(
    key: key ?? this.key,
    value: value ?? this.value,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserPreferencesTableData copyWithCompanion(
    UserPreferencesTableCompanion data,
  ) {
    return UserPreferencesTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferencesTableData &&
          other.key == this.key &&
          other.value == this.value &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesTableCompanion
    extends UpdateCompanion<UserPreferencesTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserPreferencesTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    required String key,
    required String value,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<UserPreferencesTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserPreferencesTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationDataTableTable extends LocationDataTable
    with TableInfo<$LocationDataTableTable, LocationDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _houseNumberMeta = const VerificationMeta(
    'houseNumber',
  );
  @override
  late final GeneratedColumn<String> houseNumber = GeneratedColumn<String>(
    'house_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _landmarkMeta = const VerificationMeta(
    'landmark',
  );
  @override
  late final GeneratedColumn<String> landmark = GeneratedColumn<String>(
    'landmark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    label,
    address,
    latitude,
    longitude,
    houseNumber,
    landmark,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'location_data';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationDataTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('house_number')) {
      context.handle(
        _houseNumberMeta,
        houseNumber.isAcceptableOrUnknown(
          data['house_number']!,
          _houseNumberMeta,
        ),
      );
    }
    if (data.containsKey('landmark')) {
      context.handle(
        _landmarkMeta,
        landmark.isAcceptableOrUnknown(data['landmark']!, _landmarkMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
  LocationDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationDataTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      houseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}house_number'],
      ),
      landmark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}landmark'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
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
  $LocationDataTableTable createAlias(String alias) {
    return $LocationDataTableTable(attachedDatabase, alias);
  }
}

class LocationDataTableData extends DataClass
    implements Insertable<LocationDataTableData> {
  final String id;
  final String label;
  final String address;
  final double latitude;
  final double longitude;
  final String? houseNumber;
  final String? landmark;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocationDataTableData({
    required this.id,
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.houseNumber,
    this.landmark,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['address'] = Variable<String>(address);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || houseNumber != null) {
      map['house_number'] = Variable<String>(houseNumber);
    }
    if (!nullToAbsent || landmark != null) {
      map['landmark'] = Variable<String>(landmark);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocationDataTableCompanion toCompanion(bool nullToAbsent) {
    return LocationDataTableCompanion(
      id: Value(id),
      label: Value(label),
      address: Value(address),
      latitude: Value(latitude),
      longitude: Value(longitude),
      houseNumber: houseNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(houseNumber),
      landmark: landmark == null && nullToAbsent
          ? const Value.absent()
          : Value(landmark),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocationDataTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationDataTableData(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      address: serializer.fromJson<String>(json['address']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      houseNumber: serializer.fromJson<String?>(json['houseNumber']),
      landmark: serializer.fromJson<String?>(json['landmark']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'address': serializer.toJson<String>(address),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'houseNumber': serializer.toJson<String?>(houseNumber),
      'landmark': serializer.toJson<String?>(landmark),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocationDataTableData copyWith({
    String? id,
    String? label,
    String? address,
    double? latitude,
    double? longitude,
    Value<String?> houseNumber = const Value.absent(),
    Value<String?> landmark = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocationDataTableData(
    id: id ?? this.id,
    label: label ?? this.label,
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    houseNumber: houseNumber.present ? houseNumber.value : this.houseNumber,
    landmark: landmark.present ? landmark.value : this.landmark,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocationDataTableData copyWithCompanion(LocationDataTableCompanion data) {
    return LocationDataTableData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      houseNumber: data.houseNumber.present
          ? data.houseNumber.value
          : this.houseNumber,
      landmark: data.landmark.present ? data.landmark.value : this.landmark,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationDataTableData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('houseNumber: $houseNumber, ')
          ..write('landmark: $landmark, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    address,
    latitude,
    longitude,
    houseNumber,
    landmark,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationDataTableData &&
          other.id == this.id &&
          other.label == this.label &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.houseNumber == this.houseNumber &&
          other.landmark == this.landmark &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocationDataTableCompanion
    extends UpdateCompanion<LocationDataTableData> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> address;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> houseNumber;
  final Value<String?> landmark;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocationDataTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.houseNumber = const Value.absent(),
    this.landmark = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationDataTableCompanion.insert({
    required String id,
    required String label,
    required String address,
    required double latitude,
    required double longitude,
    this.houseNumber = const Value.absent(),
    this.landmark = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       address = Value(address),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<LocationDataTableData> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? houseNumber,
    Expression<String>? landmark,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (houseNumber != null) 'house_number': houseNumber,
      if (landmark != null) 'landmark': landmark,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationDataTableCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? address,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String?>? houseNumber,
    Value<String?>? landmark,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocationDataTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      houseNumber: houseNumber ?? this.houseNumber,
      landmark: landmark ?? this.landmark,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (houseNumber.present) {
      map['house_number'] = Variable<String>(houseNumber.value);
    }
    if (landmark.present) {
      map['landmark'] = Variable<String>(landmark.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationDataTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('houseNumber: $houseNumber, ')
          ..write('landmark: $landmark, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTableTable extends CartItemsTable
    with TableInfo<$CartItemsTableTable, CartItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalPriceMeta = const VerificationMeta(
    'originalPrice',
  );
  @override
  late final GeneratedColumn<double> originalPrice = GeneratedColumn<double>(
    'original_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<String> rating = GeneratedColumn<String>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<int> discountPercentage = GeneratedColumn<int>(
    'discount_percentage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _sourcePageMeta = const VerificationMeta(
    'sourcePage',
  );
  @override
  late final GeneratedColumn<String> sourcePage = GeneratedColumn<String>(
    'source_page',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTitleMeta = const VerificationMeta(
    'sourceTitle',
  );
  @override
  late final GeneratedColumn<String> sourceTitle = GeneratedColumn<String>(
    'source_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    title,
    name,
    image,
    price,
    originalPrice,
    quantity,
    description,
    rating,
    duration,
    discountPercentage,
    type,
    sourcePage,
    sourceTitle,
    addedAt,
    dateAdded,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('original_price')) {
      context.handle(
        _originalPriceMeta,
        originalPrice.isAcceptableOrUnknown(
          data['original_price']!,
          _originalPriceMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
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
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
        _discountPercentageMeta,
        discountPercentage.isAcceptableOrUnknown(
          data['discount_percentage']!,
          _discountPercentageMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('source_page')) {
      context.handle(
        _sourcePageMeta,
        sourcePage.isAcceptableOrUnknown(data['source_page']!, _sourcePageMeta),
      );
    }
    if (data.containsKey('source_title')) {
      context.handle(
        _sourceTitleMeta,
        sourceTitle.isAcceptableOrUnknown(
          data['source_title']!,
          _sourceTitleMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
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
  CartItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      originalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}original_price'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rating'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      ),
      discountPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_percentage'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      sourcePage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_page'],
      ),
      sourceTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_title'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CartItemsTableTable createAlias(String alias) {
    return $CartItemsTableTable(attachedDatabase, alias);
  }
}

class CartItemsTableData extends DataClass
    implements Insertable<CartItemsTableData> {
  final String id;
  final String title;
  final String? name;
  final String image;
  final double price;
  final double? originalPrice;
  final int quantity;
  final String? description;
  final String? rating;
  final String? duration;
  final int discountPercentage;
  final String type;
  final String? sourcePage;
  final String? sourceTitle;
  final DateTime addedAt;
  final DateTime? dateAdded;
  final DateTime updatedAt;
  const CartItemsTableData({
    required this.id,
    required this.title,
    this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    required this.quantity,
    this.description,
    this.rating,
    this.duration,
    required this.discountPercentage,
    required this.type,
    this.sourcePage,
    this.sourceTitle,
    required this.addedAt,
    this.dateAdded,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['image'] = Variable<String>(image);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || originalPrice != null) {
      map['original_price'] = Variable<double>(originalPrice);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<String>(rating);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<String>(duration);
    }
    map['discount_percentage'] = Variable<int>(discountPercentage);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || sourcePage != null) {
      map['source_page'] = Variable<String>(sourcePage);
    }
    if (!nullToAbsent || sourceTitle != null) {
      map['source_title'] = Variable<String>(sourceTitle);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || dateAdded != null) {
      map['date_added'] = Variable<DateTime>(dateAdded);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CartItemsTableCompanion toCompanion(bool nullToAbsent) {
    return CartItemsTableCompanion(
      id: Value(id),
      title: Value(title),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      image: Value(image),
      price: Value(price),
      originalPrice: originalPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(originalPrice),
      quantity: Value(quantity),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      discountPercentage: Value(discountPercentage),
      type: Value(type),
      sourcePage: sourcePage == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePage),
      sourceTitle: sourceTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTitle),
      addedAt: Value(addedAt),
      dateAdded: dateAdded == null && nullToAbsent
          ? const Value.absent()
          : Value(dateAdded),
      updatedAt: Value(updatedAt),
    );
  }

  factory CartItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      name: serializer.fromJson<String?>(json['name']),
      image: serializer.fromJson<String>(json['image']),
      price: serializer.fromJson<double>(json['price']),
      originalPrice: serializer.fromJson<double?>(json['originalPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      description: serializer.fromJson<String?>(json['description']),
      rating: serializer.fromJson<String?>(json['rating']),
      duration: serializer.fromJson<String?>(json['duration']),
      discountPercentage: serializer.fromJson<int>(json['discountPercentage']),
      type: serializer.fromJson<String>(json['type']),
      sourcePage: serializer.fromJson<String?>(json['sourcePage']),
      sourceTitle: serializer.fromJson<String?>(json['sourceTitle']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      dateAdded: serializer.fromJson<DateTime?>(json['dateAdded']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'name': serializer.toJson<String?>(name),
      'image': serializer.toJson<String>(image),
      'price': serializer.toJson<double>(price),
      'originalPrice': serializer.toJson<double?>(originalPrice),
      'quantity': serializer.toJson<int>(quantity),
      'description': serializer.toJson<String?>(description),
      'rating': serializer.toJson<String?>(rating),
      'duration': serializer.toJson<String?>(duration),
      'discountPercentage': serializer.toJson<int>(discountPercentage),
      'type': serializer.toJson<String>(type),
      'sourcePage': serializer.toJson<String?>(sourcePage),
      'sourceTitle': serializer.toJson<String?>(sourceTitle),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'dateAdded': serializer.toJson<DateTime?>(dateAdded),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CartItemsTableData copyWith({
    String? id,
    String? title,
    Value<String?> name = const Value.absent(),
    String? image,
    double? price,
    Value<double?> originalPrice = const Value.absent(),
    int? quantity,
    Value<String?> description = const Value.absent(),
    Value<String?> rating = const Value.absent(),
    Value<String?> duration = const Value.absent(),
    int? discountPercentage,
    String? type,
    Value<String?> sourcePage = const Value.absent(),
    Value<String?> sourceTitle = const Value.absent(),
    DateTime? addedAt,
    Value<DateTime?> dateAdded = const Value.absent(),
    DateTime? updatedAt,
  }) => CartItemsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    name: name.present ? name.value : this.name,
    image: image ?? this.image,
    price: price ?? this.price,
    originalPrice: originalPrice.present
        ? originalPrice.value
        : this.originalPrice,
    quantity: quantity ?? this.quantity,
    description: description.present ? description.value : this.description,
    rating: rating.present ? rating.value : this.rating,
    duration: duration.present ? duration.value : this.duration,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    type: type ?? this.type,
    sourcePage: sourcePage.present ? sourcePage.value : this.sourcePage,
    sourceTitle: sourceTitle.present ? sourceTitle.value : this.sourceTitle,
    addedAt: addedAt ?? this.addedAt,
    dateAdded: dateAdded.present ? dateAdded.value : this.dateAdded,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CartItemsTableData copyWithCompanion(CartItemsTableCompanion data) {
    return CartItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      name: data.name.present ? data.name.value : this.name,
      image: data.image.present ? data.image.value : this.image,
      price: data.price.present ? data.price.value : this.price,
      originalPrice: data.originalPrice.present
          ? data.originalPrice.value
          : this.originalPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      description: data.description.present
          ? data.description.value
          : this.description,
      rating: data.rating.present ? data.rating.value : this.rating,
      duration: data.duration.present ? data.duration.value : this.duration,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      type: data.type.present ? data.type.value : this.type,
      sourcePage: data.sourcePage.present
          ? data.sourcePage.value
          : this.sourcePage,
      sourceTitle: data.sourceTitle.present
          ? data.sourceTitle.value
          : this.sourceTitle,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('price: $price, ')
          ..write('originalPrice: $originalPrice, ')
          ..write('quantity: $quantity, ')
          ..write('description: $description, ')
          ..write('rating: $rating, ')
          ..write('duration: $duration, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('type: $type, ')
          ..write('sourcePage: $sourcePage, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('addedAt: $addedAt, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    name,
    image,
    price,
    originalPrice,
    quantity,
    description,
    rating,
    duration,
    discountPercentage,
    type,
    sourcePage,
    sourceTitle,
    addedAt,
    dateAdded,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.name == this.name &&
          other.image == this.image &&
          other.price == this.price &&
          other.originalPrice == this.originalPrice &&
          other.quantity == this.quantity &&
          other.description == this.description &&
          other.rating == this.rating &&
          other.duration == this.duration &&
          other.discountPercentage == this.discountPercentage &&
          other.type == this.type &&
          other.sourcePage == this.sourcePage &&
          other.sourceTitle == this.sourceTitle &&
          other.addedAt == this.addedAt &&
          other.dateAdded == this.dateAdded &&
          other.updatedAt == this.updatedAt);
}

class CartItemsTableCompanion extends UpdateCompanion<CartItemsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> name;
  final Value<String> image;
  final Value<double> price;
  final Value<double?> originalPrice;
  final Value<int> quantity;
  final Value<String?> description;
  final Value<String?> rating;
  final Value<String?> duration;
  final Value<int> discountPercentage;
  final Value<String> type;
  final Value<String?> sourcePage;
  final Value<String?> sourceTitle;
  final Value<DateTime> addedAt;
  final Value<DateTime?> dateAdded;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CartItemsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.price = const Value.absent(),
    this.originalPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.description = const Value.absent(),
    this.rating = const Value.absent(),
    this.duration = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.type = const Value.absent(),
    this.sourcePage = const Value.absent(),
    this.sourceTitle = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartItemsTableCompanion.insert({
    required String id,
    required String title,
    this.name = const Value.absent(),
    required String image,
    required double price,
    this.originalPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.description = const Value.absent(),
    this.rating = const Value.absent(),
    this.duration = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.type = const Value.absent(),
    this.sourcePage = const Value.absent(),
    this.sourceTitle = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       image = Value(image),
       price = Value(price);
  static Insertable<CartItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? name,
    Expression<String>? image,
    Expression<double>? price,
    Expression<double>? originalPrice,
    Expression<int>? quantity,
    Expression<String>? description,
    Expression<String>? rating,
    Expression<String>? duration,
    Expression<int>? discountPercentage,
    Expression<String>? type,
    Expression<String>? sourcePage,
    Expression<String>? sourceTitle,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (price != null) 'price': price,
      if (originalPrice != null) 'original_price': originalPrice,
      if (quantity != null) 'quantity': quantity,
      if (description != null) 'description': description,
      if (rating != null) 'rating': rating,
      if (duration != null) 'duration': duration,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (type != null) 'type': type,
      if (sourcePage != null) 'source_page': sourcePage,
      if (sourceTitle != null) 'source_title': sourceTitle,
      if (addedAt != null) 'added_at': addedAt,
      if (dateAdded != null) 'date_added': dateAdded,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? name,
    Value<String>? image,
    Value<double>? price,
    Value<double?>? originalPrice,
    Value<int>? quantity,
    Value<String?>? description,
    Value<String?>? rating,
    Value<String?>? duration,
    Value<int>? discountPercentage,
    Value<String>? type,
    Value<String?>? sourcePage,
    Value<String?>? sourceTitle,
    Value<DateTime>? addedAt,
    Value<DateTime?>? dateAdded,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CartItemsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      type: type ?? this.type,
      sourcePage: sourcePage ?? this.sourcePage,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      addedAt: addedAt ?? this.addedAt,
      dateAdded: dateAdded ?? this.dateAdded,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (originalPrice.present) {
      map['original_price'] = Variable<double>(originalPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rating.present) {
      map['rating'] = Variable<String>(rating.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<int>(discountPercentage.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (sourcePage.present) {
      map['source_page'] = Variable<String>(sourcePage.value);
    }
    if (sourceTitle.present) {
      map['source_title'] = Variable<String>(sourceTitle.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('price: $price, ')
          ..write('originalPrice: $originalPrice, ')
          ..write('quantity: $quantity, ')
          ..write('description: $description, ')
          ..write('rating: $rating, ')
          ..write('duration: $duration, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('type: $type, ')
          ..write('sourcePage: $sourcePage, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('addedAt: $addedAt, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthDataTableTable extends AuthDataTable
    with TableInfo<$AuthDataTableTable, AuthDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  List<GeneratedColumn> get $columns => [key, value, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_data';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthDataTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AuthDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthDataTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
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
  $AuthDataTableTable createAlias(String alias) {
    return $AuthDataTableTable(attachedDatabase, alias);
  }
}

class AuthDataTableData extends DataClass
    implements Insertable<AuthDataTableData> {
  final String key;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AuthDataTableData({
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AuthDataTableCompanion toCompanion(bool nullToAbsent) {
    return AuthDataTableCompanion(
      key: Value(key),
      value: Value(value),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AuthDataTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthDataTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AuthDataTableData copyWith({
    String? key,
    String? value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AuthDataTableData(
    key: key ?? this.key,
    value: value ?? this.value,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AuthDataTableData copyWithCompanion(AuthDataTableCompanion data) {
    return AuthDataTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthDataTableData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthDataTableData &&
          other.key == this.key &&
          other.value == this.value &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AuthDataTableCompanion extends UpdateCompanion<AuthDataTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AuthDataTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthDataTableCompanion.insert({
    required String key,
    required String value,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AuthDataTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthDataTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AuthDataTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthDataTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServiceCategoriesTableTable serviceCategoriesTable =
      $ServiceCategoriesTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $ServicesTableTable servicesTable = $ServicesTableTable(this);
  late final $ApiServicesTableTable apiServicesTable = $ApiServicesTableTable(
    this,
  );
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  late final $LocationDataTableTable locationDataTable =
      $LocationDataTableTable(this);
  late final $CartItemsTableTable cartItemsTable = $CartItemsTableTable(this);
  late final $AuthDataTableTable authDataTable = $AuthDataTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serviceCategoriesTable,
    categoriesTable,
    servicesTable,
    apiServicesTable,
    userPreferencesTable,
    locationDataTable,
    cartItemsTable,
    authDataTable,
  ];
}

typedef $$ServiceCategoriesTableTableCreateCompanionBuilder =
    ServiceCategoriesTableCompanion Function({
      Value<int> id,
      required String title,
      required String icon,
      Value<DateTime> createdAt,
    });
typedef $$ServiceCategoriesTableTableUpdateCompanionBuilder =
    ServiceCategoriesTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> icon,
      Value<DateTime> createdAt,
    });

class $$ServiceCategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTableTable> {
  $$ServiceCategoriesTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiceCategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTableTable> {
  $$ServiceCategoriesTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceCategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTableTable> {
  $$ServiceCategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ServiceCategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceCategoriesTableTable,
          ServiceCategoriesTableData,
          $$ServiceCategoriesTableTableFilterComposer,
          $$ServiceCategoriesTableTableOrderingComposer,
          $$ServiceCategoriesTableTableAnnotationComposer,
          $$ServiceCategoriesTableTableCreateCompanionBuilder,
          $$ServiceCategoriesTableTableUpdateCompanionBuilder,
          (
            ServiceCategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $ServiceCategoriesTableTable,
              ServiceCategoriesTableData
            >,
          ),
          ServiceCategoriesTableData,
          PrefetchHooks Function()
        > {
  $$ServiceCategoriesTableTableTableManager(
    _$AppDatabase db,
    $ServiceCategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceCategoriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ServiceCategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ServiceCategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServiceCategoriesTableCompanion(
                id: id,
                title: title,
                icon: icon,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String icon,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServiceCategoriesTableCompanion.insert(
                id: id,
                title: title,
                icon: icon,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiceCategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceCategoriesTableTable,
      ServiceCategoriesTableData,
      $$ServiceCategoriesTableTableFilterComposer,
      $$ServiceCategoriesTableTableOrderingComposer,
      $$ServiceCategoriesTableTableAnnotationComposer,
      $$ServiceCategoriesTableTableCreateCompanionBuilder,
      $$ServiceCategoriesTableTableUpdateCompanionBuilder,
      (
        ServiceCategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $ServiceCategoriesTableTable,
          ServiceCategoriesTableData
        >,
      ),
      ServiceCategoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String categoryId,
      required String categoryName,
      required String imgLink,
      required String serviceCategory,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> categoryId,
      Value<String> categoryName,
      Value<String> imgLink,
      Value<String> serviceCategory,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imgLink => $composableBuilder(
    column: $table.imgLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceCategory => $composableBuilder(
    column: $table.serviceCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imgLink => $composableBuilder(
    column: $table.imgLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceCategory => $composableBuilder(
    column: $table.serviceCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imgLink =>
      $composableBuilder(column: $table.imgLink, builder: (column) => column);

  GeneratedColumn<String> get serviceCategory => $composableBuilder(
    column: $table.serviceCategory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $CategoriesTableTable,
              CategoriesTableData
            >,
          ),
          CategoriesTableData,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> categoryId = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> imgLink = const Value.absent(),
                Value<String> serviceCategory = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                categoryId: categoryId,
                categoryName: categoryName,
                imgLink: imgLink,
                serviceCategory: serviceCategory,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String categoryId,
                required String categoryName,
                required String imgLink,
                required String serviceCategory,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                categoryId: categoryId,
                categoryName: categoryName,
                imgLink: imgLink,
                serviceCategory: serviceCategory,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        >,
      ),
      CategoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$ServicesTableTableCreateCompanionBuilder =
    ServicesTableCompanion Function({
      Value<int> id,
      required String title,
      required String image,
      required String type,
      Value<DateTime> createdAt,
    });
typedef $$ServicesTableTableUpdateCompanionBuilder =
    ServicesTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> image,
      Value<String> type,
      Value<DateTime> createdAt,
    });

class $$ServicesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTableTable> {
  $$ServicesTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServicesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTableTable> {
  $$ServicesTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTableTable> {
  $$ServicesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ServicesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTableTable,
          ServicesTableData,
          $$ServicesTableTableFilterComposer,
          $$ServicesTableTableOrderingComposer,
          $$ServicesTableTableAnnotationComposer,
          $$ServicesTableTableCreateCompanionBuilder,
          $$ServicesTableTableUpdateCompanionBuilder,
          (
            ServicesTableData,
            BaseReferences<
              _$AppDatabase,
              $ServicesTableTable,
              ServicesTableData
            >,
          ),
          ServicesTableData,
          PrefetchHooks Function()
        > {
  $$ServicesTableTableTableManager(_$AppDatabase db, $ServicesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServicesTableCompanion(
                id: id,
                title: title,
                image: image,
                type: type,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String image,
                required String type,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServicesTableCompanion.insert(
                id: id,
                title: title,
                image: image,
                type: type,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServicesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTableTable,
      ServicesTableData,
      $$ServicesTableTableFilterComposer,
      $$ServicesTableTableOrderingComposer,
      $$ServicesTableTableAnnotationComposer,
      $$ServicesTableTableCreateCompanionBuilder,
      $$ServicesTableTableUpdateCompanionBuilder,
      (
        ServicesTableData,
        BaseReferences<_$AppDatabase, $ServicesTableTable, ServicesTableData>,
      ),
      ServicesTableData,
      PrefetchHooks Function()
    >;
typedef $$ApiServicesTableTableCreateCompanionBuilder =
    ApiServicesTableCompanion Function({
      required String id,
      required String name,
      required double price,
      required String description,
      required int duration,
      required String imgLink,
      required double discountPercentage,
      required String categoryId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ApiServicesTableTableUpdateCompanionBuilder =
    ApiServicesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> price,
      Value<String> description,
      Value<int> duration,
      Value<String> imgLink,
      Value<double> discountPercentage,
      Value<String> categoryId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ApiServicesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ApiServicesTableTable> {
  $$ApiServicesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imgLink => $composableBuilder(
    column: $table.imgLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ApiServicesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ApiServicesTableTable> {
  $$ApiServicesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imgLink => $composableBuilder(
    column: $table.imgLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApiServicesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApiServicesTableTable> {
  $$ApiServicesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get imgLink =>
      $composableBuilder(column: $table.imgLink, builder: (column) => column);

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ApiServicesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApiServicesTableTable,
          ApiServicesTableData,
          $$ApiServicesTableTableFilterComposer,
          $$ApiServicesTableTableOrderingComposer,
          $$ApiServicesTableTableAnnotationComposer,
          $$ApiServicesTableTableCreateCompanionBuilder,
          $$ApiServicesTableTableUpdateCompanionBuilder,
          (
            ApiServicesTableData,
            BaseReferences<
              _$AppDatabase,
              $ApiServicesTableTable,
              ApiServicesTableData
            >,
          ),
          ApiServicesTableData,
          PrefetchHooks Function()
        > {
  $$ApiServicesTableTableTableManager(
    _$AppDatabase db,
    $ApiServicesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApiServicesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApiServicesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApiServicesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<String> imgLink = const Value.absent(),
                Value<double> discountPercentage = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApiServicesTableCompanion(
                id: id,
                name: name,
                price: price,
                description: description,
                duration: duration,
                imgLink: imgLink,
                discountPercentage: discountPercentage,
                categoryId: categoryId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required double price,
                required String description,
                required int duration,
                required String imgLink,
                required double discountPercentage,
                required String categoryId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApiServicesTableCompanion.insert(
                id: id,
                name: name,
                price: price,
                description: description,
                duration: duration,
                imgLink: imgLink,
                discountPercentage: discountPercentage,
                categoryId: categoryId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ApiServicesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApiServicesTableTable,
      ApiServicesTableData,
      $$ApiServicesTableTableFilterComposer,
      $$ApiServicesTableTableOrderingComposer,
      $$ApiServicesTableTableAnnotationComposer,
      $$ApiServicesTableTableCreateCompanionBuilder,
      $$ApiServicesTableTableUpdateCompanionBuilder,
      (
        ApiServicesTableData,
        BaseReferences<
          _$AppDatabase,
          $ApiServicesTableTable,
          ApiServicesTableData
        >,
      ),
      ApiServicesTableData,
      PrefetchHooks Function()
    >;
typedef $$UserPreferencesTableTableCreateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      required String key,
      required String value,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UserPreferencesTableTableUpdateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
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
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
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
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPreferencesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData,
          $$UserPreferencesTableTableFilterComposer,
          $$UserPreferencesTableTableOrderingComposer,
          $$UserPreferencesTableTableAnnotationComposer,
          $$UserPreferencesTableTableCreateCompanionBuilder,
          $$UserPreferencesTableTableUpdateCompanionBuilder,
          (
            UserPreferencesTableData,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTableTable,
              UserPreferencesTableData
            >,
          ),
          UserPreferencesTableData,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesTableCompanion(
                key: key,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesTableCompanion.insert(
                key: key,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTableTable,
      UserPreferencesTableData,
      $$UserPreferencesTableTableFilterComposer,
      $$UserPreferencesTableTableOrderingComposer,
      $$UserPreferencesTableTableAnnotationComposer,
      $$UserPreferencesTableTableCreateCompanionBuilder,
      $$UserPreferencesTableTableUpdateCompanionBuilder,
      (
        UserPreferencesTableData,
        BaseReferences<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData
        >,
      ),
      UserPreferencesTableData,
      PrefetchHooks Function()
    >;
typedef $$LocationDataTableTableCreateCompanionBuilder =
    LocationDataTableCompanion Function({
      required String id,
      required String label,
      required String address,
      required double latitude,
      required double longitude,
      Value<String?> houseNumber,
      Value<String?> landmark,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocationDataTableTableUpdateCompanionBuilder =
    LocationDataTableCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> address,
      Value<double> latitude,
      Value<double> longitude,
      Value<String?> houseNumber,
      Value<String?> landmark,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocationDataTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocationDataTableTable> {
  $$LocationDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get houseNumber => $composableBuilder(
    column: $table.houseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landmark => $composableBuilder(
    column: $table.landmark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocationDataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationDataTableTable> {
  $$LocationDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get houseNumber => $composableBuilder(
    column: $table.houseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landmark => $composableBuilder(
    column: $table.landmark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$LocationDataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationDataTableTable> {
  $$LocationDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get houseNumber => $composableBuilder(
    column: $table.houseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get landmark =>
      $composableBuilder(column: $table.landmark, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocationDataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationDataTableTable,
          LocationDataTableData,
          $$LocationDataTableTableFilterComposer,
          $$LocationDataTableTableOrderingComposer,
          $$LocationDataTableTableAnnotationComposer,
          $$LocationDataTableTableCreateCompanionBuilder,
          $$LocationDataTableTableUpdateCompanionBuilder,
          (
            LocationDataTableData,
            BaseReferences<
              _$AppDatabase,
              $LocationDataTableTable,
              LocationDataTableData
            >,
          ),
          LocationDataTableData,
          PrefetchHooks Function()
        > {
  $$LocationDataTableTableTableManager(
    _$AppDatabase db,
    $LocationDataTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationDataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationDataTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String?> houseNumber = const Value.absent(),
                Value<String?> landmark = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationDataTableCompanion(
                id: id,
                label: label,
                address: address,
                latitude: latitude,
                longitude: longitude,
                houseNumber: houseNumber,
                landmark: landmark,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required String address,
                required double latitude,
                required double longitude,
                Value<String?> houseNumber = const Value.absent(),
                Value<String?> landmark = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationDataTableCompanion.insert(
                id: id,
                label: label,
                address: address,
                latitude: latitude,
                longitude: longitude,
                houseNumber: houseNumber,
                landmark: landmark,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocationDataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationDataTableTable,
      LocationDataTableData,
      $$LocationDataTableTableFilterComposer,
      $$LocationDataTableTableOrderingComposer,
      $$LocationDataTableTableAnnotationComposer,
      $$LocationDataTableTableCreateCompanionBuilder,
      $$LocationDataTableTableUpdateCompanionBuilder,
      (
        LocationDataTableData,
        BaseReferences<
          _$AppDatabase,
          $LocationDataTableTable,
          LocationDataTableData
        >,
      ),
      LocationDataTableData,
      PrefetchHooks Function()
    >;
typedef $$CartItemsTableTableCreateCompanionBuilder =
    CartItemsTableCompanion Function({
      required String id,
      required String title,
      Value<String?> name,
      required String image,
      required double price,
      Value<double?> originalPrice,
      Value<int> quantity,
      Value<String?> description,
      Value<String?> rating,
      Value<String?> duration,
      Value<int> discountPercentage,
      Value<String> type,
      Value<String?> sourcePage,
      Value<String?> sourceTitle,
      Value<DateTime> addedAt,
      Value<DateTime?> dateAdded,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CartItemsTableTableUpdateCompanionBuilder =
    CartItemsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> name,
      Value<String> image,
      Value<double> price,
      Value<double?> originalPrice,
      Value<int> quantity,
      Value<String?> description,
      Value<String?> rating,
      Value<String?> duration,
      Value<int> discountPercentage,
      Value<String> type,
      Value<String?> sourcePage,
      Value<String?> sourceTitle,
      Value<DateTime> addedAt,
      Value<DateTime?> dateAdded,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CartItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTableTable> {
  $$CartItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get originalPrice => $composableBuilder(
    column: $table.originalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePage => $composableBuilder(
    column: $table.sourcePage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CartItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTableTable> {
  $$CartItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get originalPrice => $composableBuilder(
    column: $table.originalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePage => $composableBuilder(
    column: $table.sourcePage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTableTable> {
  $$CartItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get originalPrice => $composableBuilder(
    column: $table.originalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get sourcePage => $composableBuilder(
    column: $table.sourcePage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CartItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartItemsTableTable,
          CartItemsTableData,
          $$CartItemsTableTableFilterComposer,
          $$CartItemsTableTableOrderingComposer,
          $$CartItemsTableTableAnnotationComposer,
          $$CartItemsTableTableCreateCompanionBuilder,
          $$CartItemsTableTableUpdateCompanionBuilder,
          (
            CartItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $CartItemsTableTable,
              CartItemsTableData
            >,
          ),
          CartItemsTableData,
          PrefetchHooks Function()
        > {
  $$CartItemsTableTableTableManager(
    _$AppDatabase db,
    $CartItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double?> originalPrice = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> rating = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<int> discountPercentage = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> sourcePage = const Value.absent(),
                Value<String?> sourceTitle = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> dateAdded = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartItemsTableCompanion(
                id: id,
                title: title,
                name: name,
                image: image,
                price: price,
                originalPrice: originalPrice,
                quantity: quantity,
                description: description,
                rating: rating,
                duration: duration,
                discountPercentage: discountPercentage,
                type: type,
                sourcePage: sourcePage,
                sourceTitle: sourceTitle,
                addedAt: addedAt,
                dateAdded: dateAdded,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> name = const Value.absent(),
                required String image,
                required double price,
                Value<double?> originalPrice = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> rating = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<int> discountPercentage = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> sourcePage = const Value.absent(),
                Value<String?> sourceTitle = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> dateAdded = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartItemsTableCompanion.insert(
                id: id,
                title: title,
                name: name,
                image: image,
                price: price,
                originalPrice: originalPrice,
                quantity: quantity,
                description: description,
                rating: rating,
                duration: duration,
                discountPercentage: discountPercentage,
                type: type,
                sourcePage: sourcePage,
                sourceTitle: sourceTitle,
                addedAt: addedAt,
                dateAdded: dateAdded,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CartItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartItemsTableTable,
      CartItemsTableData,
      $$CartItemsTableTableFilterComposer,
      $$CartItemsTableTableOrderingComposer,
      $$CartItemsTableTableAnnotationComposer,
      $$CartItemsTableTableCreateCompanionBuilder,
      $$CartItemsTableTableUpdateCompanionBuilder,
      (
        CartItemsTableData,
        BaseReferences<_$AppDatabase, $CartItemsTableTable, CartItemsTableData>,
      ),
      CartItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$AuthDataTableTableCreateCompanionBuilder =
    AuthDataTableCompanion Function({
      required String key,
      required String value,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AuthDataTableTableUpdateCompanionBuilder =
    AuthDataTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AuthDataTableTableFilterComposer
    extends Composer<_$AppDatabase, $AuthDataTableTable> {
  $$AuthDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
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
}

class $$AuthDataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthDataTableTable> {
  $$AuthDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
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
}

class $$AuthDataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthDataTableTable> {
  $$AuthDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AuthDataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthDataTableTable,
          AuthDataTableData,
          $$AuthDataTableTableFilterComposer,
          $$AuthDataTableTableOrderingComposer,
          $$AuthDataTableTableAnnotationComposer,
          $$AuthDataTableTableCreateCompanionBuilder,
          $$AuthDataTableTableUpdateCompanionBuilder,
          (
            AuthDataTableData,
            BaseReferences<
              _$AppDatabase,
              $AuthDataTableTable,
              AuthDataTableData
            >,
          ),
          AuthDataTableData,
          PrefetchHooks Function()
        > {
  $$AuthDataTableTableTableManager(_$AppDatabase db, $AuthDataTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthDataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthDataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthDataTableCompanion(
                key: key,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthDataTableCompanion.insert(
                key: key,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthDataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthDataTableTable,
      AuthDataTableData,
      $$AuthDataTableTableFilterComposer,
      $$AuthDataTableTableOrderingComposer,
      $$AuthDataTableTableAnnotationComposer,
      $$AuthDataTableTableCreateCompanionBuilder,
      $$AuthDataTableTableUpdateCompanionBuilder,
      (
        AuthDataTableData,
        BaseReferences<_$AppDatabase, $AuthDataTableTable, AuthDataTableData>,
      ),
      AuthDataTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServiceCategoriesTableTableTableManager get serviceCategoriesTable =>
      $$ServiceCategoriesTableTableTableManager(
        _db,
        _db.serviceCategoriesTable,
      );
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$ServicesTableTableTableManager get servicesTable =>
      $$ServicesTableTableTableManager(_db, _db.servicesTable);
  $$ApiServicesTableTableTableManager get apiServicesTable =>
      $$ApiServicesTableTableTableManager(_db, _db.apiServicesTable);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
  $$LocationDataTableTableTableManager get locationDataTable =>
      $$LocationDataTableTableTableManager(_db, _db.locationDataTable);
  $$CartItemsTableTableTableManager get cartItemsTable =>
      $$CartItemsTableTableTableManager(_db, _db.cartItemsTable);
  $$AuthDataTableTableTableManager get authDataTable =>
      $$AuthDataTableTableTableManager(_db, _db.authDataTable);
}
