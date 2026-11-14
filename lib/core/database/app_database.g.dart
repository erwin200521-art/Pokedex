// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PokemonsTable extends Pokemons
    with TableInfo<$PokemonsTable, PokemonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PokemonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nationalDexNumberMeta =
      const VerificationMeta('nationalDexNumber');
  @override
  late final GeneratedColumn<int> nationalDexNumber = GeneratedColumn<int>(
      'national_dex_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _spriteUrlMeta =
      const VerificationMeta('spriteUrl');
  @override
  late final GeneratedColumn<String> spriteUrl = GeneratedColumn<String>(
      'sprite_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artworkUrlMeta =
      const VerificationMeta('artworkUrl');
  @override
  late final GeneratedColumn<String> artworkUrl = GeneratedColumn<String>(
      'artwork_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        nationalDexNumber,
        height,
        weight,
        spriteUrl,
        artworkUrl,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pokemons';
  @override
  VerificationContext validateIntegrity(Insertable<PokemonRow> instance,
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
    if (data.containsKey('national_dex_number')) {
      context.handle(
          _nationalDexNumberMeta,
          nationalDexNumber.isAcceptableOrUnknown(
              data['national_dex_number']!, _nationalDexNumberMeta));
    } else if (isInserting) {
      context.missing(_nationalDexNumberMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('sprite_url')) {
      context.handle(_spriteUrlMeta,
          spriteUrl.isAcceptableOrUnknown(data['sprite_url']!, _spriteUrlMeta));
    } else if (isInserting) {
      context.missing(_spriteUrlMeta);
    }
    if (data.containsKey('artwork_url')) {
      context.handle(
          _artworkUrlMeta,
          artworkUrl.isAcceptableOrUnknown(
              data['artwork_url']!, _artworkUrlMeta));
    } else if (isInserting) {
      context.missing(_artworkUrlMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PokemonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PokemonRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nationalDexNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}national_dex_number'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight'])!,
      spriteUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sprite_url'])!,
      artworkUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artwork_url'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PokemonsTable createAlias(String alias) {
    return $PokemonsTable(attachedDatabase, alias);
  }
}

class PokemonRow extends DataClass implements Insertable<PokemonRow> {
  final int id;
  final String name;

  /// Número de Pokédex nacional (= id de especie = id del Pokémon por defecto).
  final int nationalDexNumber;

  /// Altura en decímetros y peso en hectogramos (unidades de PokeAPI).
  final int height;
  final int weight;
  final String spriteUrl;
  final String artworkUrl;
  final DateTime updatedAt;
  const PokemonRow(
      {required this.id,
      required this.name,
      required this.nationalDexNumber,
      required this.height,
      required this.weight,
      required this.spriteUrl,
      required this.artworkUrl,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['national_dex_number'] = Variable<int>(nationalDexNumber);
    map['height'] = Variable<int>(height);
    map['weight'] = Variable<int>(weight);
    map['sprite_url'] = Variable<String>(spriteUrl);
    map['artwork_url'] = Variable<String>(artworkUrl);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PokemonsCompanion toCompanion(bool nullToAbsent) {
    return PokemonsCompanion(
      id: Value(id),
      name: Value(name),
      nationalDexNumber: Value(nationalDexNumber),
      height: Value(height),
      weight: Value(weight),
      spriteUrl: Value(spriteUrl),
      artworkUrl: Value(artworkUrl),
      updatedAt: Value(updatedAt),
    );
  }

  factory PokemonRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PokemonRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nationalDexNumber: serializer.fromJson<int>(json['nationalDexNumber']),
      height: serializer.fromJson<int>(json['height']),
      weight: serializer.fromJson<int>(json['weight']),
      spriteUrl: serializer.fromJson<String>(json['spriteUrl']),
      artworkUrl: serializer.fromJson<String>(json['artworkUrl']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nationalDexNumber': serializer.toJson<int>(nationalDexNumber),
      'height': serializer.toJson<int>(height),
      'weight': serializer.toJson<int>(weight),
      'spriteUrl': serializer.toJson<String>(spriteUrl),
      'artworkUrl': serializer.toJson<String>(artworkUrl),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PokemonRow copyWith(
          {int? id,
          String? name,
          int? nationalDexNumber,
          int? height,
          int? weight,
          String? spriteUrl,
          String? artworkUrl,
          DateTime? updatedAt}) =>
      PokemonRow(
        id: id ?? this.id,
        name: name ?? this.name,
        nationalDexNumber: nationalDexNumber ?? this.nationalDexNumber,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        spriteUrl: spriteUrl ?? this.spriteUrl,
        artworkUrl: artworkUrl ?? this.artworkUrl,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PokemonRow copyWithCompanion(PokemonsCompanion data) {
    return PokemonRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nationalDexNumber: data.nationalDexNumber.present
          ? data.nationalDexNumber.value
          : this.nationalDexNumber,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
      spriteUrl: data.spriteUrl.present ? data.spriteUrl.value : this.spriteUrl,
      artworkUrl:
          data.artworkUrl.present ? data.artworkUrl.value : this.artworkUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PokemonRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nationalDexNumber: $nationalDexNumber, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('spriteUrl: $spriteUrl, ')
          ..write('artworkUrl: $artworkUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nationalDexNumber, height, weight,
      spriteUrl, artworkUrl, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PokemonRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.nationalDexNumber == this.nationalDexNumber &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.spriteUrl == this.spriteUrl &&
          other.artworkUrl == this.artworkUrl &&
          other.updatedAt == this.updatedAt);
}

class PokemonsCompanion extends UpdateCompanion<PokemonRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> nationalDexNumber;
  final Value<int> height;
  final Value<int> weight;
  final Value<String> spriteUrl;
  final Value<String> artworkUrl;
  final Value<DateTime> updatedAt;
  const PokemonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nationalDexNumber = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.spriteUrl = const Value.absent(),
    this.artworkUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PokemonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int nationalDexNumber,
    required int height,
    required int weight,
    required String spriteUrl,
    required String artworkUrl,
    required DateTime updatedAt,
  })  : name = Value(name),
        nationalDexNumber = Value(nationalDexNumber),
        height = Value(height),
        weight = Value(weight),
        spriteUrl = Value(spriteUrl),
        artworkUrl = Value(artworkUrl),
        updatedAt = Value(updatedAt);
  static Insertable<PokemonRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? nationalDexNumber,
    Expression<int>? height,
    Expression<int>? weight,
    Expression<String>? spriteUrl,
    Expression<String>? artworkUrl,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nationalDexNumber != null) 'national_dex_number': nationalDexNumber,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (spriteUrl != null) 'sprite_url': spriteUrl,
      if (artworkUrl != null) 'artwork_url': artworkUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PokemonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? nationalDexNumber,
      Value<int>? height,
      Value<int>? weight,
      Value<String>? spriteUrl,
      Value<String>? artworkUrl,
      Value<DateTime>? updatedAt}) {
    return PokemonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nationalDexNumber: nationalDexNumber ?? this.nationalDexNumber,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      spriteUrl: spriteUrl ?? this.spriteUrl,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (nationalDexNumber.present) {
      map['national_dex_number'] = Variable<int>(nationalDexNumber.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (spriteUrl.present) {
      map['sprite_url'] = Variable<String>(spriteUrl.value);
    }
    if (artworkUrl.present) {
      map['artwork_url'] = Variable<String>(artworkUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PokemonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nationalDexNumber: $nationalDexNumber, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('spriteUrl: $spriteUrl, ')
          ..write('artworkUrl: $artworkUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ElementTypesTable extends ElementTypes
    with TableInfo<$ElementTypesTable, ElementTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElementTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'element_types';
  @override
  VerificationContext validateIntegrity(Insertable<ElementTypeRow> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ElementTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ElementTypeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ElementTypesTable createAlias(String alias) {
    return $ElementTypesTable(attachedDatabase, alias);
  }
}

class ElementTypeRow extends DataClass implements Insertable<ElementTypeRow> {
  final int id;
  final String name;
  const ElementTypeRow({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ElementTypesCompanion toCompanion(bool nullToAbsent) {
    return ElementTypesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory ElementTypeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ElementTypeRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  ElementTypeRow copyWith({int? id, String? name}) => ElementTypeRow(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  ElementTypeRow copyWithCompanion(ElementTypesCompanion data) {
    return ElementTypeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ElementTypeRow(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ElementTypeRow &&
          other.id == this.id &&
          other.name == this.name);
}

class ElementTypesCompanion extends UpdateCompanion<ElementTypeRow> {
  final Value<int> id;
  final Value<String> name;
  const ElementTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ElementTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ElementTypeRow> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ElementTypesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ElementTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElementTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PokemonTypeLinksTable extends PokemonTypeLinks
    with TableInfo<$PokemonTypeLinksTable, PokemonTypeLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PokemonTypeLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pokemonIdMeta =
      const VerificationMeta('pokemonId');
  @override
  late final GeneratedColumn<int> pokemonId = GeneratedColumn<int>(
      'pokemon_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
      'type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
      'slot', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [pokemonId, typeId, slot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pokemon_type_links';
  @override
  VerificationContext validateIntegrity(Insertable<PokemonTypeLinkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pokemon_id')) {
      context.handle(_pokemonIdMeta,
          pokemonId.isAcceptableOrUnknown(data['pokemon_id']!, _pokemonIdMeta));
    } else if (isInserting) {
      context.missing(_pokemonIdMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
          _slotMeta, slot.isAcceptableOrUnknown(data['slot']!, _slotMeta));
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pokemonId, slot};
  @override
  PokemonTypeLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PokemonTypeLinkRow(
      pokemonId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pokemon_id'])!,
      typeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type_id'])!,
      slot: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot'])!,
    );
  }

  @override
  $PokemonTypeLinksTable createAlias(String alias) {
    return $PokemonTypeLinksTable(attachedDatabase, alias);
  }
}

class PokemonTypeLinkRow extends DataClass
    implements Insertable<PokemonTypeLinkRow> {
  final int pokemonId;
  final int typeId;
  final int slot;
  const PokemonTypeLinkRow(
      {required this.pokemonId, required this.typeId, required this.slot});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pokemon_id'] = Variable<int>(pokemonId);
    map['type_id'] = Variable<int>(typeId);
    map['slot'] = Variable<int>(slot);
    return map;
  }

  PokemonTypeLinksCompanion toCompanion(bool nullToAbsent) {
    return PokemonTypeLinksCompanion(
      pokemonId: Value(pokemonId),
      typeId: Value(typeId),
      slot: Value(slot),
    );
  }

  factory PokemonTypeLinkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PokemonTypeLinkRow(
      pokemonId: serializer.fromJson<int>(json['pokemonId']),
      typeId: serializer.fromJson<int>(json['typeId']),
      slot: serializer.fromJson<int>(json['slot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pokemonId': serializer.toJson<int>(pokemonId),
      'typeId': serializer.toJson<int>(typeId),
      'slot': serializer.toJson<int>(slot),
    };
  }

  PokemonTypeLinkRow copyWith({int? pokemonId, int? typeId, int? slot}) =>
      PokemonTypeLinkRow(
        pokemonId: pokemonId ?? this.pokemonId,
        typeId: typeId ?? this.typeId,
        slot: slot ?? this.slot,
      );
  PokemonTypeLinkRow copyWithCompanion(PokemonTypeLinksCompanion data) {
    return PokemonTypeLinkRow(
      pokemonId: data.pokemonId.present ? data.pokemonId.value : this.pokemonId,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      slot: data.slot.present ? data.slot.value : this.slot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PokemonTypeLinkRow(')
          ..write('pokemonId: $pokemonId, ')
          ..write('typeId: $typeId, ')
          ..write('slot: $slot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pokemonId, typeId, slot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PokemonTypeLinkRow &&
          other.pokemonId == this.pokemonId &&
          other.typeId == this.typeId &&
          other.slot == this.slot);
}

class PokemonTypeLinksCompanion extends UpdateCompanion<PokemonTypeLinkRow> {
  final Value<int> pokemonId;
  final Value<int> typeId;
  final Value<int> slot;
  final Value<int> rowid;
  const PokemonTypeLinksCompanion({
    this.pokemonId = const Value.absent(),
    this.typeId = const Value.absent(),
    this.slot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PokemonTypeLinksCompanion.insert({
    required int pokemonId,
    required int typeId,
    required int slot,
    this.rowid = const Value.absent(),
  })  : pokemonId = Value(pokemonId),
        typeId = Value(typeId),
        slot = Value(slot);
  static Insertable<PokemonTypeLinkRow> custom({
    Expression<int>? pokemonId,
    Expression<int>? typeId,
    Expression<int>? slot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pokemonId != null) 'pokemon_id': pokemonId,
      if (typeId != null) 'type_id': typeId,
      if (slot != null) 'slot': slot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PokemonTypeLinksCompanion copyWith(
      {Value<int>? pokemonId,
      Value<int>? typeId,
      Value<int>? slot,
      Value<int>? rowid}) {
    return PokemonTypeLinksCompanion(
      pokemonId: pokemonId ?? this.pokemonId,
      typeId: typeId ?? this.typeId,
      slot: slot ?? this.slot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pokemonId.present) {
      map['pokemon_id'] = Variable<int>(pokemonId.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PokemonTypeLinksCompanion(')
          ..write('pokemonId: $pokemonId, ')
          ..write('typeId: $typeId, ')
          ..write('slot: $slot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, FavoriteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pokemonIdMeta =
      const VerificationMeta('pokemonId');
  @override
  late final GeneratedColumn<int> pokemonId = GeneratedColumn<int>(
      'pokemon_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [pokemonId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pokemon_id')) {
      context.handle(_pokemonIdMeta,
          pokemonId.isAcceptableOrUnknown(data['pokemon_id']!, _pokemonIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pokemonId};
  @override
  FavoriteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRow(
      pokemonId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pokemon_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class FavoriteRow extends DataClass implements Insertable<FavoriteRow> {
  final int pokemonId;
  final DateTime createdAt;
  const FavoriteRow({required this.pokemonId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pokemon_id'] = Variable<int>(pokemonId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      pokemonId: Value(pokemonId),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRow(
      pokemonId: serializer.fromJson<int>(json['pokemonId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pokemonId': serializer.toJson<int>(pokemonId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteRow copyWith({int? pokemonId, DateTime? createdAt}) => FavoriteRow(
        pokemonId: pokemonId ?? this.pokemonId,
        createdAt: createdAt ?? this.createdAt,
      );
  FavoriteRow copyWithCompanion(FavoritesCompanion data) {
    return FavoriteRow(
      pokemonId: data.pokemonId.present ? data.pokemonId.value : this.pokemonId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRow(')
          ..write('pokemonId: $pokemonId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pokemonId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRow &&
          other.pokemonId == this.pokemonId &&
          other.createdAt == this.createdAt);
}

class FavoritesCompanion extends UpdateCompanion<FavoriteRow> {
  final Value<int> pokemonId;
  final Value<DateTime> createdAt;
  const FavoritesCompanion({
    this.pokemonId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.pokemonId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<FavoriteRow> custom({
    Expression<int>? pokemonId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (pokemonId != null) 'pokemon_id': pokemonId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int>? pokemonId, Value<DateTime>? createdAt}) {
    return FavoritesCompanion(
      pokemonId: pokemonId ?? this.pokemonId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pokemonId.present) {
      map['pokemon_id'] = Variable<int>(pokemonId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('pokemonId: $pokemonId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataEntriesTable extends SyncMetadataEntries
    with TableInfo<$SyncMetadataEntriesTable, SyncMetadataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _resourceKeyMeta =
      const VerificationMeta('resourceKey');
  @override
  late final GeneratedColumn<String> resourceKey = GeneratedColumn<String>(
      'resource_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('idle'));
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<int> cursor = GeneratedColumn<int>(
      'cursor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastSuccessAtMeta =
      const VerificationMeta('lastSuccessAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessAt =
      GeneratedColumn<DateTime>('last_success_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [resourceKey, status, cursor, lastSuccessAt, lastError, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata_entries';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetadataRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('resource_key')) {
      context.handle(
          _resourceKeyMeta,
          resourceKey.isAcceptableOrUnknown(
              data['resource_key']!, _resourceKeyMeta));
    } else if (isInserting) {
      context.missing(_resourceKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('cursor')) {
      context.handle(_cursorMeta,
          cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta));
    }
    if (data.containsKey('last_success_at')) {
      context.handle(
          _lastSuccessAtMeta,
          lastSuccessAt.isAcceptableOrUnknown(
              data['last_success_at']!, _lastSuccessAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {resourceKey};
  @override
  SyncMetadataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataRow(
      resourceKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resource_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      cursor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cursor'])!,
      lastSuccessAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_success_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncMetadataEntriesTable createAlias(String alias) {
    return $SyncMetadataEntriesTable(attachedDatabase, alias);
  }
}

class SyncMetadataRow extends DataClass implements Insertable<SyncMetadataRow> {
  final String resourceKey;
  final String status;
  final int cursor;
  final DateTime? lastSuccessAt;
  final String? lastError;
  final DateTime updatedAt;
  const SyncMetadataRow(
      {required this.resourceKey,
      required this.status,
      required this.cursor,
      this.lastSuccessAt,
      this.lastError,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['resource_key'] = Variable<String>(resourceKey);
    map['status'] = Variable<String>(status);
    map['cursor'] = Variable<int>(cursor);
    if (!nullToAbsent || lastSuccessAt != null) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncMetadataEntriesCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataEntriesCompanion(
      resourceKey: Value(resourceKey),
      status: Value(status),
      cursor: Value(cursor),
      lastSuccessAt: lastSuccessAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncMetadataRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataRow(
      resourceKey: serializer.fromJson<String>(json['resourceKey']),
      status: serializer.fromJson<String>(json['status']),
      cursor: serializer.fromJson<int>(json['cursor']),
      lastSuccessAt: serializer.fromJson<DateTime?>(json['lastSuccessAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'resourceKey': serializer.toJson<String>(resourceKey),
      'status': serializer.toJson<String>(status),
      'cursor': serializer.toJson<int>(cursor),
      'lastSuccessAt': serializer.toJson<DateTime?>(lastSuccessAt),
      'lastError': serializer.toJson<String?>(lastError),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncMetadataRow copyWith(
          {String? resourceKey,
          String? status,
          int? cursor,
          Value<DateTime?> lastSuccessAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          DateTime? updatedAt}) =>
      SyncMetadataRow(
        resourceKey: resourceKey ?? this.resourceKey,
        status: status ?? this.status,
        cursor: cursor ?? this.cursor,
        lastSuccessAt:
            lastSuccessAt.present ? lastSuccessAt.value : this.lastSuccessAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncMetadataRow copyWithCompanion(SyncMetadataEntriesCompanion data) {
    return SyncMetadataRow(
      resourceKey:
          data.resourceKey.present ? data.resourceKey.value : this.resourceKey,
      status: data.status.present ? data.status.value : this.status,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      lastSuccessAt: data.lastSuccessAt.present
          ? data.lastSuccessAt.value
          : this.lastSuccessAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataRow(')
          ..write('resourceKey: $resourceKey, ')
          ..write('status: $status, ')
          ..write('cursor: $cursor, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      resourceKey, status, cursor, lastSuccessAt, lastError, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataRow &&
          other.resourceKey == this.resourceKey &&
          other.status == this.status &&
          other.cursor == this.cursor &&
          other.lastSuccessAt == this.lastSuccessAt &&
          other.lastError == this.lastError &&
          other.updatedAt == this.updatedAt);
}

class SyncMetadataEntriesCompanion extends UpdateCompanion<SyncMetadataRow> {
  final Value<String> resourceKey;
  final Value<String> status;
  final Value<int> cursor;
  final Value<DateTime?> lastSuccessAt;
  final Value<String?> lastError;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncMetadataEntriesCompanion({
    this.resourceKey = const Value.absent(),
    this.status = const Value.absent(),
    this.cursor = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataEntriesCompanion.insert({
    required String resourceKey,
    this.status = const Value.absent(),
    this.cursor = const Value.absent(),
    this.lastSuccessAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : resourceKey = Value(resourceKey),
        updatedAt = Value(updatedAt);
  static Insertable<SyncMetadataRow> custom({
    Expression<String>? resourceKey,
    Expression<String>? status,
    Expression<int>? cursor,
    Expression<DateTime>? lastSuccessAt,
    Expression<String>? lastError,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (resourceKey != null) 'resource_key': resourceKey,
      if (status != null) 'status': status,
      if (cursor != null) 'cursor': cursor,
      if (lastSuccessAt != null) 'last_success_at': lastSuccessAt,
      if (lastError != null) 'last_error': lastError,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataEntriesCompanion copyWith(
      {Value<String>? resourceKey,
      Value<String>? status,
      Value<int>? cursor,
      Value<DateTime?>? lastSuccessAt,
      Value<String?>? lastError,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncMetadataEntriesCompanion(
      resourceKey: resourceKey ?? this.resourceKey,
      status: status ?? this.status,
      cursor: cursor ?? this.cursor,
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
      lastError: lastError ?? this.lastError,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (resourceKey.present) {
      map['resource_key'] = Variable<String>(resourceKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<int>(cursor.value);
    }
    if (lastSuccessAt.present) {
      map['last_success_at'] = Variable<DateTime>(lastSuccessAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
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
    return (StringBuffer('SyncMetadataEntriesCompanion(')
          ..write('resourceKey: $resourceKey, ')
          ..write('status: $status, ')
          ..write('cursor: $cursor, ')
          ..write('lastSuccessAt: $lastSuccessAt, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PokemonsTable pokemons = $PokemonsTable(this);
  late final $ElementTypesTable elementTypes = $ElementTypesTable(this);
  late final $PokemonTypeLinksTable pokemonTypeLinks =
      $PokemonTypeLinksTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $SyncMetadataEntriesTable syncMetadataEntries =
      $SyncMetadataEntriesTable(this);
  late final Index idxPokemonsName = Index(
      'idx_pokemons_name', 'CREATE INDEX idx_pokemons_name ON pokemons (name)');
  late final Index idxPokemonsDex = Index('idx_pokemons_dex',
      'CREATE INDEX idx_pokemons_dex ON pokemons (national_dex_number)');
  late final Index idxPokemonTypeLinksType = Index(
      'idx_pokemon_type_links_type',
      'CREATE INDEX idx_pokemon_type_links_type ON pokemon_type_links (type_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        pokemons,
        elementTypes,
        pokemonTypeLinks,
        favorites,
        syncMetadataEntries,
        idxPokemonsName,
        idxPokemonsDex,
        idxPokemonTypeLinksType
      ];
}

typedef $$PokemonsTableCreateCompanionBuilder = PokemonsCompanion Function({
  Value<int> id,
  required String name,
  required int nationalDexNumber,
  required int height,
  required int weight,
  required String spriteUrl,
  required String artworkUrl,
  required DateTime updatedAt,
});
typedef $$PokemonsTableUpdateCompanionBuilder = PokemonsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> nationalDexNumber,
  Value<int> height,
  Value<int> weight,
  Value<String> spriteUrl,
  Value<String> artworkUrl,
  Value<DateTime> updatedAt,
});

class $$PokemonsTableFilterComposer
    extends Composer<_$AppDatabase, $PokemonsTable> {
  $$PokemonsTableFilterComposer({
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

  ColumnFilters<int> get nationalDexNumber => $composableBuilder(
      column: $table.nationalDexNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spriteUrl => $composableBuilder(
      column: $table.spriteUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artworkUrl => $composableBuilder(
      column: $table.artworkUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PokemonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PokemonsTable> {
  $$PokemonsTableOrderingComposer({
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

  ColumnOrderings<int> get nationalDexNumber => $composableBuilder(
      column: $table.nationalDexNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spriteUrl => $composableBuilder(
      column: $table.spriteUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artworkUrl => $composableBuilder(
      column: $table.artworkUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PokemonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PokemonsTable> {
  $$PokemonsTableAnnotationComposer({
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

  GeneratedColumn<int> get nationalDexNumber => $composableBuilder(
      column: $table.nationalDexNumber, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get spriteUrl =>
      $composableBuilder(column: $table.spriteUrl, builder: (column) => column);

  GeneratedColumn<String> get artworkUrl => $composableBuilder(
      column: $table.artworkUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PokemonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PokemonsTable,
    PokemonRow,
    $$PokemonsTableFilterComposer,
    $$PokemonsTableOrderingComposer,
    $$PokemonsTableAnnotationComposer,
    $$PokemonsTableCreateCompanionBuilder,
    $$PokemonsTableUpdateCompanionBuilder,
    (PokemonRow, BaseReferences<_$AppDatabase, $PokemonsTable, PokemonRow>),
    PokemonRow,
    PrefetchHooks Function()> {
  $$PokemonsTableTableManager(_$AppDatabase db, $PokemonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PokemonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PokemonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PokemonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> nationalDexNumber = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<String> spriteUrl = const Value.absent(),
            Value<String> artworkUrl = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PokemonsCompanion(
            id: id,
            name: name,
            nationalDexNumber: nationalDexNumber,
            height: height,
            weight: weight,
            spriteUrl: spriteUrl,
            artworkUrl: artworkUrl,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int nationalDexNumber,
            required int height,
            required int weight,
            required String spriteUrl,
            required String artworkUrl,
            required DateTime updatedAt,
          }) =>
              PokemonsCompanion.insert(
            id: id,
            name: name,
            nationalDexNumber: nationalDexNumber,
            height: height,
            weight: weight,
            spriteUrl: spriteUrl,
            artworkUrl: artworkUrl,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PokemonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PokemonsTable,
    PokemonRow,
    $$PokemonsTableFilterComposer,
    $$PokemonsTableOrderingComposer,
    $$PokemonsTableAnnotationComposer,
    $$PokemonsTableCreateCompanionBuilder,
    $$PokemonsTableUpdateCompanionBuilder,
    (PokemonRow, BaseReferences<_$AppDatabase, $PokemonsTable, PokemonRow>),
    PokemonRow,
    PrefetchHooks Function()>;
typedef $$ElementTypesTableCreateCompanionBuilder = ElementTypesCompanion
    Function({
  Value<int> id,
  required String name,
});
typedef $$ElementTypesTableUpdateCompanionBuilder = ElementTypesCompanion
    Function({
  Value<int> id,
  Value<String> name,
});

class $$ElementTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ElementTypesTable> {
  $$ElementTypesTableFilterComposer({
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
}

class $$ElementTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ElementTypesTable> {
  $$ElementTypesTableOrderingComposer({
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
}

class $$ElementTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ElementTypesTable> {
  $$ElementTypesTableAnnotationComposer({
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
}

class $$ElementTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ElementTypesTable,
    ElementTypeRow,
    $$ElementTypesTableFilterComposer,
    $$ElementTypesTableOrderingComposer,
    $$ElementTypesTableAnnotationComposer,
    $$ElementTypesTableCreateCompanionBuilder,
    $$ElementTypesTableUpdateCompanionBuilder,
    (
      ElementTypeRow,
      BaseReferences<_$AppDatabase, $ElementTypesTable, ElementTypeRow>
    ),
    ElementTypeRow,
    PrefetchHooks Function()> {
  $$ElementTypesTableTableManager(_$AppDatabase db, $ElementTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElementTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ElementTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ElementTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              ElementTypesCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              ElementTypesCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ElementTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ElementTypesTable,
    ElementTypeRow,
    $$ElementTypesTableFilterComposer,
    $$ElementTypesTableOrderingComposer,
    $$ElementTypesTableAnnotationComposer,
    $$ElementTypesTableCreateCompanionBuilder,
    $$ElementTypesTableUpdateCompanionBuilder,
    (
      ElementTypeRow,
      BaseReferences<_$AppDatabase, $ElementTypesTable, ElementTypeRow>
    ),
    ElementTypeRow,
    PrefetchHooks Function()>;
typedef $$PokemonTypeLinksTableCreateCompanionBuilder
    = PokemonTypeLinksCompanion Function({
  required int pokemonId,
  required int typeId,
  required int slot,
  Value<int> rowid,
});
typedef $$PokemonTypeLinksTableUpdateCompanionBuilder
    = PokemonTypeLinksCompanion Function({
  Value<int> pokemonId,
  Value<int> typeId,
  Value<int> slot,
  Value<int> rowid,
});

class $$PokemonTypeLinksTableFilterComposer
    extends Composer<_$AppDatabase, $PokemonTypeLinksTable> {
  $$PokemonTypeLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get pokemonId => $composableBuilder(
      column: $table.pokemonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get typeId => $composableBuilder(
      column: $table.typeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slot => $composableBuilder(
      column: $table.slot, builder: (column) => ColumnFilters(column));
}

class $$PokemonTypeLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $PokemonTypeLinksTable> {
  $$PokemonTypeLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get pokemonId => $composableBuilder(
      column: $table.pokemonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get typeId => $composableBuilder(
      column: $table.typeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slot => $composableBuilder(
      column: $table.slot, builder: (column) => ColumnOrderings(column));
}

class $$PokemonTypeLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PokemonTypeLinksTable> {
  $$PokemonTypeLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get pokemonId =>
      $composableBuilder(column: $table.pokemonId, builder: (column) => column);

  GeneratedColumn<int> get typeId =>
      $composableBuilder(column: $table.typeId, builder: (column) => column);

  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);
}

class $$PokemonTypeLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PokemonTypeLinksTable,
    PokemonTypeLinkRow,
    $$PokemonTypeLinksTableFilterComposer,
    $$PokemonTypeLinksTableOrderingComposer,
    $$PokemonTypeLinksTableAnnotationComposer,
    $$PokemonTypeLinksTableCreateCompanionBuilder,
    $$PokemonTypeLinksTableUpdateCompanionBuilder,
    (
      PokemonTypeLinkRow,
      BaseReferences<_$AppDatabase, $PokemonTypeLinksTable, PokemonTypeLinkRow>
    ),
    PokemonTypeLinkRow,
    PrefetchHooks Function()> {
  $$PokemonTypeLinksTableTableManager(
      _$AppDatabase db, $PokemonTypeLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PokemonTypeLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PokemonTypeLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PokemonTypeLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> pokemonId = const Value.absent(),
            Value<int> typeId = const Value.absent(),
            Value<int> slot = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PokemonTypeLinksCompanion(
            pokemonId: pokemonId,
            typeId: typeId,
            slot: slot,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int pokemonId,
            required int typeId,
            required int slot,
            Value<int> rowid = const Value.absent(),
          }) =>
              PokemonTypeLinksCompanion.insert(
            pokemonId: pokemonId,
            typeId: typeId,
            slot: slot,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PokemonTypeLinksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PokemonTypeLinksTable,
    PokemonTypeLinkRow,
    $$PokemonTypeLinksTableFilterComposer,
    $$PokemonTypeLinksTableOrderingComposer,
    $$PokemonTypeLinksTableAnnotationComposer,
    $$PokemonTypeLinksTableCreateCompanionBuilder,
    $$PokemonTypeLinksTableUpdateCompanionBuilder,
    (
      PokemonTypeLinkRow,
      BaseReferences<_$AppDatabase, $PokemonTypeLinksTable, PokemonTypeLinkRow>
    ),
    PokemonTypeLinkRow,
    PrefetchHooks Function()>;
typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  Value<int> pokemonId,
  Value<DateTime> createdAt,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<int> pokemonId,
  Value<DateTime> createdAt,
});

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get pokemonId => $composableBuilder(
      column: $table.pokemonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get pokemonId => $composableBuilder(
      column: $table.pokemonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get pokemonId =>
      $composableBuilder(column: $table.pokemonId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTable,
    FavoriteRow,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (FavoriteRow, BaseReferences<_$AppDatabase, $FavoritesTable, FavoriteRow>),
    FavoriteRow,
    PrefetchHooks Function()> {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> pokemonId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              FavoritesCompanion(
            pokemonId: pokemonId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> pokemonId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              FavoritesCompanion.insert(
            pokemonId: pokemonId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTable,
    FavoriteRow,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (FavoriteRow, BaseReferences<_$AppDatabase, $FavoritesTable, FavoriteRow>),
    FavoriteRow,
    PrefetchHooks Function()>;
typedef $$SyncMetadataEntriesTableCreateCompanionBuilder
    = SyncMetadataEntriesCompanion Function({
  required String resourceKey,
  Value<String> status,
  Value<int> cursor,
  Value<DateTime?> lastSuccessAt,
  Value<String?> lastError,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SyncMetadataEntriesTableUpdateCompanionBuilder
    = SyncMetadataEntriesCompanion Function({
  Value<String> resourceKey,
  Value<String> status,
  Value<int> cursor,
  Value<DateTime?> lastSuccessAt,
  Value<String?> lastError,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncMetadataEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataEntriesTable> {
  $$SyncMetadataEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get resourceKey => $composableBuilder(
      column: $table.resourceKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cursor => $composableBuilder(
      column: $table.cursor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSuccessAt => $composableBuilder(
      column: $table.lastSuccessAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataEntriesTable> {
  $$SyncMetadataEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get resourceKey => $composableBuilder(
      column: $table.resourceKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cursor => $composableBuilder(
      column: $table.cursor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSuccessAt => $composableBuilder(
      column: $table.lastSuccessAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataEntriesTable> {
  $$SyncMetadataEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get resourceKey => $composableBuilder(
      column: $table.resourceKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessAt => $composableBuilder(
      column: $table.lastSuccessAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetadataEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataEntriesTable,
    SyncMetadataRow,
    $$SyncMetadataEntriesTableFilterComposer,
    $$SyncMetadataEntriesTableOrderingComposer,
    $$SyncMetadataEntriesTableAnnotationComposer,
    $$SyncMetadataEntriesTableCreateCompanionBuilder,
    $$SyncMetadataEntriesTableUpdateCompanionBuilder,
    (
      SyncMetadataRow,
      BaseReferences<_$AppDatabase, $SyncMetadataEntriesTable, SyncMetadataRow>
    ),
    SyncMetadataRow,
    PrefetchHooks Function()> {
  $$SyncMetadataEntriesTableTableManager(
      _$AppDatabase db, $SyncMetadataEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataEntriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> resourceKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> cursor = const Value.absent(),
            Value<DateTime?> lastSuccessAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataEntriesCompanion(
            resourceKey: resourceKey,
            status: status,
            cursor: cursor,
            lastSuccessAt: lastSuccessAt,
            lastError: lastError,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String resourceKey,
            Value<String> status = const Value.absent(),
            Value<int> cursor = const Value.absent(),
            Value<DateTime?> lastSuccessAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataEntriesCompanion.insert(
            resourceKey: resourceKey,
            status: status,
            cursor: cursor,
            lastSuccessAt: lastSuccessAt,
            lastError: lastError,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataEntriesTable,
    SyncMetadataRow,
    $$SyncMetadataEntriesTableFilterComposer,
    $$SyncMetadataEntriesTableOrderingComposer,
    $$SyncMetadataEntriesTableAnnotationComposer,
    $$SyncMetadataEntriesTableCreateCompanionBuilder,
    $$SyncMetadataEntriesTableUpdateCompanionBuilder,
    (
      SyncMetadataRow,
      BaseReferences<_$AppDatabase, $SyncMetadataEntriesTable, SyncMetadataRow>
    ),
    SyncMetadataRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PokemonsTableTableManager get pokemons =>
      $$PokemonsTableTableManager(_db, _db.pokemons);
  $$ElementTypesTableTableManager get elementTypes =>
      $$ElementTypesTableTableManager(_db, _db.elementTypes);
  $$PokemonTypeLinksTableTableManager get pokemonTypeLinks =>
      $$PokemonTypeLinksTableTableManager(_db, _db.pokemonTypeLinks);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$SyncMetadataEntriesTableTableManager get syncMetadataEntries =>
      $$SyncMetadataEntriesTableTableManager(_db, _db.syncMetadataEntries);
}
