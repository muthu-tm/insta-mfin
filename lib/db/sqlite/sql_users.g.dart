// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) {
  return UserAddress(
    json['street'] as String,
    json['city'] as String,
    json['state'] as String,
    json['pincode'] as int,
  )..country = json['country'] as String ?? 'India';
}

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'pincode': instance.pincode,
    };

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String email;
  final int mobileNumber;
  final String password;
  final String gender;
  final String displayProfileLocal;
  final String displayProfileCloud;
  final DateTime dateOfBirth;
  final String createdAt;
  final String updatedAt;
  final String lastSignInTime;
  final UserAddress address;
  User(
      {this.id,
      this.name,
      @required this.email,
      this.mobileNumber,
      this.password,
      this.gender,
      this.displayProfileLocal,
      this.displayProfileCloud,
      this.dateOfBirth,
      this.createdAt,
      this.updatedAt,
      this.lastSignInTime,
      this.address});
  factory User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return User(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}user_name']),
      email:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}email']),
      mobileNumber: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}mobile_number']),
      password: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      gender:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}gender']),
      displayProfileLocal: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}display_profile_local']),
      displayProfileCloud: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}display_profile_cloud']),
      dateOfBirth: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_of_birth']),
      createdAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      lastSignInTime: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_signed_in_at']),
      address: $UserModelTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}address'])),
    );
  }
  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      mobileNumber: serializer.fromJson<int>(json['mobile_number']),
      password: serializer.fromJson<String>(json['password']),
      gender: serializer.fromJson<String>(json['gender']),
      displayProfileLocal:
          serializer.fromJson<String>(json['display_profile_local']),
      displayProfileCloud:
          serializer.fromJson<String>(json['display_profile_cloud']),
      dateOfBirth: serializer.fromJson<DateTime>(json['date_of_birth']),
      createdAt: serializer.fromJson<String>(json['created_at']),
      updatedAt: serializer.fromJson<String>(json['updated_at']),
      lastSignInTime: serializer.fromJson<String>(json['last_signed_in_at']),
      address: serializer.fromJson<UserAddress>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'user_name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'mobile_number': serializer.toJson<int>(mobileNumber),
      'password': serializer.toJson<String>(password),
      'gender': serializer.toJson<String>(gender),
      'display_profile_local': serializer.toJson<String>(displayProfileLocal),
      'display_profile_cloud': serializer.toJson<String>(displayProfileCloud),
      'date_of_birth': serializer.toJson<DateTime>(dateOfBirth),
      'created_at': serializer.toJson<String>(createdAt),
      'updated_at': serializer.toJson<String>(updatedAt),
      'last_signed_in_at': serializer.toJson<String>(lastSignInTime),
      'address': serializer.toJson<UserAddress>(address),
    };
  }

  @override
  UserModelCompanion createCompanion(bool nullToAbsent) {
    return UserModelCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      mobileNumber: mobileNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(mobileNumber),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      displayProfileLocal: displayProfileLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(displayProfileLocal),
      displayProfileCloud: displayProfileCloud == null && nullToAbsent
          ? const Value.absent()
          : Value(displayProfileCloud),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      lastSignInTime: lastSignInTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSignInTime),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
    );
  }

  User copyWith(
          {String id,
          String name,
          String email,
          int mobileNumber,
          String password,
          String gender,
          String displayProfileLocal,
          String displayProfileCloud,
          DateTime dateOfBirth,
          String createdAt,
          String updatedAt,
          String lastSignInTime,
          UserAddress address}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        password: password ?? this.password,
        gender: gender ?? this.gender,
        displayProfileLocal: displayProfileLocal ?? this.displayProfileLocal,
        displayProfileCloud: displayProfileCloud ?? this.displayProfileCloud,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSignInTime: lastSignInTime ?? this.lastSignInTime,
        address: address ?? this.address,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('password: $password, ')
          ..write('gender: $gender, ')
          ..write('displayProfileLocal: $displayProfileLocal, ')
          ..write('displayProfileCloud: $displayProfileCloud, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSignInTime: $lastSignInTime, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              email.hashCode,
              $mrjc(
                  mobileNumber.hashCode,
                  $mrjc(
                      password.hashCode,
                      $mrjc(
                          gender.hashCode,
                          $mrjc(
                              displayProfileLocal.hashCode,
                              $mrjc(
                                  displayProfileCloud.hashCode,
                                  $mrjc(
                                      dateOfBirth.hashCode,
                                      $mrjc(
                                          createdAt.hashCode,
                                          $mrjc(
                                              updatedAt.hashCode,
                                              $mrjc(lastSignInTime.hashCode,
                                                  address.hashCode)))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.mobileNumber == this.mobileNumber &&
          other.password == this.password &&
          other.gender == this.gender &&
          other.displayProfileLocal == this.displayProfileLocal &&
          other.displayProfileCloud == this.displayProfileCloud &&
          other.dateOfBirth == this.dateOfBirth &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSignInTime == this.lastSignInTime &&
          other.address == this.address);
}

class UserModelCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<int> mobileNumber;
  final Value<String> password;
  final Value<String> gender;
  final Value<String> displayProfileLocal;
  final Value<String> displayProfileCloud;
  final Value<DateTime> dateOfBirth;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> lastSignInTime;
  final Value<UserAddress> address;
  const UserModelCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.password = const Value.absent(),
    this.gender = const Value.absent(),
    this.displayProfileLocal = const Value.absent(),
    this.displayProfileCloud = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSignInTime = const Value.absent(),
    this.address = const Value.absent(),
  });
  UserModelCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    @required String email,
    this.mobileNumber = const Value.absent(),
    this.password = const Value.absent(),
    this.gender = const Value.absent(),
    this.displayProfileLocal = const Value.absent(),
    this.displayProfileCloud = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSignInTime = const Value.absent(),
    this.address = const Value.absent(),
  }) : email = Value(email);
  UserModelCompanion copyWith(
      {Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<int> mobileNumber,
      Value<String> password,
      Value<String> gender,
      Value<String> displayProfileLocal,
      Value<String> displayProfileCloud,
      Value<DateTime> dateOfBirth,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String> lastSignInTime,
      Value<UserAddress> address}) {
    return UserModelCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      displayProfileLocal: displayProfileLocal ?? this.displayProfileLocal,
      displayProfileCloud: displayProfileCloud ?? this.displayProfileCloud,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      address: address ?? this.address,
    );
  }
}

class $UserModelTable extends UserModel with TableInfo<$UserModelTable, User> {
  final GeneratedDatabase _db;
  final String _alias;
  $UserModelTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'user_name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _emailMeta = const VerificationMeta('email');
  GeneratedTextColumn _email;
  @override
  GeneratedTextColumn get email => _email ??= _constructEmail();
  GeneratedTextColumn _constructEmail() {
    return GeneratedTextColumn(
      'email',
      $tableName,
      false,
    );
  }

  final VerificationMeta _mobileNumberMeta =
      const VerificationMeta('mobileNumber');
  GeneratedIntColumn _mobileNumber;
  @override
  GeneratedIntColumn get mobileNumber =>
      _mobileNumber ??= _constructMobileNumber();
  GeneratedIntColumn _constructMobileNumber() {
    return GeneratedIntColumn(
      'mobile_number',
      $tableName,
      true,
    );
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  GeneratedTextColumn _password;
  @override
  GeneratedTextColumn get password => _password ??= _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn(
      'password',
      $tableName,
      true,
    );
  }

  final VerificationMeta _genderMeta = const VerificationMeta('gender');
  GeneratedTextColumn _gender;
  @override
  GeneratedTextColumn get gender => _gender ??= _constructGender();
  GeneratedTextColumn _constructGender() {
    return GeneratedTextColumn(
      'gender',
      $tableName,
      true,
    );
  }

  final VerificationMeta _displayProfileLocalMeta =
      const VerificationMeta('displayProfileLocal');
  GeneratedTextColumn _displayProfileLocal;
  @override
  GeneratedTextColumn get displayProfileLocal =>
      _displayProfileLocal ??= _constructDisplayProfileLocal();
  GeneratedTextColumn _constructDisplayProfileLocal() {
    return GeneratedTextColumn('display_profile_local', $tableName, true,
        defaultValue: Constant(''));
  }

  final VerificationMeta _displayProfileCloudMeta =
      const VerificationMeta('displayProfileCloud');
  GeneratedTextColumn _displayProfileCloud;
  @override
  GeneratedTextColumn get displayProfileCloud =>
      _displayProfileCloud ??= _constructDisplayProfileCloud();
  GeneratedTextColumn _constructDisplayProfileCloud() {
    return GeneratedTextColumn('display_profile_cloud', $tableName, true,
        defaultValue: Constant(''));
  }

  final VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  GeneratedDateTimeColumn _dateOfBirth;
  @override
  GeneratedDateTimeColumn get dateOfBirth =>
      _dateOfBirth ??= _constructDateOfBirth();
  GeneratedDateTimeColumn _constructDateOfBirth() {
    return GeneratedDateTimeColumn(
      'date_of_birth',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedTextColumn _createdAt;
  @override
  GeneratedTextColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedTextColumn _constructCreatedAt() {
    return GeneratedTextColumn(
      'created_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedTextColumn _updatedAt;
  @override
  GeneratedTextColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedTextColumn _constructUpdatedAt() {
    return GeneratedTextColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _lastSignInTimeMeta =
      const VerificationMeta('lastSignInTime');
  GeneratedTextColumn _lastSignInTime;
  @override
  GeneratedTextColumn get lastSignInTime =>
      _lastSignInTime ??= _constructLastSignInTime();
  GeneratedTextColumn _constructLastSignInTime() {
    return GeneratedTextColumn(
      'last_signed_in_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _addressMeta = const VerificationMeta('address');
  GeneratedTextColumn _address;
  @override
  GeneratedTextColumn get address => _address ??= _constructAddress();
  GeneratedTextColumn _constructAddress() {
    return GeneratedTextColumn(
      'address',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        mobileNumber,
        password,
        gender,
        displayProfileLocal,
        displayProfileCloud,
        dateOfBirth,
        createdAt,
        updatedAt,
        lastSignInTime,
        address
      ];
  @override
  $UserModelTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'user_model';
  @override
  final String actualTableName = 'user_model';
  @override
  VerificationContext validateIntegrity(UserModelCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    }
    if (d.email.present) {
      context.handle(
          _emailMeta, email.isAcceptableValue(d.email.value, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (d.mobileNumber.present) {
      context.handle(
          _mobileNumberMeta,
          mobileNumber.isAcceptableValue(
              d.mobileNumber.value, _mobileNumberMeta));
    }
    if (d.password.present) {
      context.handle(_passwordMeta,
          password.isAcceptableValue(d.password.value, _passwordMeta));
    }
    if (d.gender.present) {
      context.handle(
          _genderMeta, gender.isAcceptableValue(d.gender.value, _genderMeta));
    }
    if (d.displayProfileLocal.present) {
      context.handle(
          _displayProfileLocalMeta,
          displayProfileLocal.isAcceptableValue(
              d.displayProfileLocal.value, _displayProfileLocalMeta));
    }
    if (d.displayProfileCloud.present) {
      context.handle(
          _displayProfileCloudMeta,
          displayProfileCloud.isAcceptableValue(
              d.displayProfileCloud.value, _displayProfileCloudMeta));
    }
    if (d.dateOfBirth.present) {
      context.handle(_dateOfBirthMeta,
          dateOfBirth.isAcceptableValue(d.dateOfBirth.value, _dateOfBirthMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.lastSignInTime.present) {
      context.handle(
          _lastSignInTimeMeta,
          lastSignInTime.isAcceptableValue(
              d.lastSignInTime.value, _lastSignInTimeMeta));
    }
    context.handle(_addressMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  User map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return User.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(UserModelCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.name.present) {
      map['user_name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.email.present) {
      map['email'] = Variable<String, StringType>(d.email.value);
    }
    if (d.mobileNumber.present) {
      map['mobile_number'] = Variable<int, IntType>(d.mobileNumber.value);
    }
    if (d.password.present) {
      map['password'] = Variable<String, StringType>(d.password.value);
    }
    if (d.gender.present) {
      map['gender'] = Variable<String, StringType>(d.gender.value);
    }
    if (d.displayProfileLocal.present) {
      map['display_profile_local'] =
          Variable<String, StringType>(d.displayProfileLocal.value);
    }
    if (d.displayProfileCloud.present) {
      map['display_profile_cloud'] =
          Variable<String, StringType>(d.displayProfileCloud.value);
    }
    if (d.dateOfBirth.present) {
      map['date_of_birth'] =
          Variable<DateTime, DateTimeType>(d.dateOfBirth.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<String, StringType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<String, StringType>(d.updatedAt.value);
    }
    if (d.lastSignInTime.present) {
      map['last_signed_in_at'] =
          Variable<String, StringType>(d.lastSignInTime.value);
    }
    if (d.address.present) {
      final converter = $UserModelTable.$converter0;
      map['address'] =
          Variable<String, StringType>(converter.mapToSql(d.address.value));
    }
    return map;
  }

  @override
  $UserModelTable createAlias(String alias) {
    return $UserModelTable(_db, alias);
  }

  static TypeConverter<UserAddress, String> $converter0 =
      const AddressConverter();
}

abstract class _$UserDatabase extends GeneratedDatabase {
  _$UserDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $UserModelTable _userModel;
  $UserModelTable get userModel => _userModel ??= $UserModelTable(this);
  UserDao _userDao;
  UserDao get userDao => _userDao ??= UserDao(this as UserDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userModel];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$UserDaoMixin on DatabaseAccessor<UserDatabase> {
  $UserModelTable get userModel => db.userModel;
}
