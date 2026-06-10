// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalDistanceKmMeta =
      const VerificationMeta('totalDistanceKm');
  @override
  late final GeneratedColumn<double> totalDistanceKm = GeneratedColumn<double>(
      'total_distance_km', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxSpeedKmhMeta =
      const VerificationMeta('maxSpeedKmh');
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
      'max_speed_kmh', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _avgSpeedKmhMeta =
      const VerificationMeta('avgSpeedKmh');
  @override
  late final GeneratedColumn<double> avgSpeedKmh = GeneratedColumn<double>(
      'avg_speed_kmh', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxGForceMeta =
      const VerificationMeta('maxGForce');
  @override
  late final GeneratedColumn<double> maxGForce = GeneratedColumn<double>(
      'max_g_force', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        startTime,
        endTime,
        totalDistanceKm,
        maxSpeedKmh,
        avgSpeedKmh,
        maxGForce,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(Insertable<Trip> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('total_distance_km')) {
      context.handle(
          _totalDistanceKmMeta,
          totalDistanceKm.isAcceptableOrUnknown(
              data['total_distance_km']!, _totalDistanceKmMeta));
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
          _maxSpeedKmhMeta,
          maxSpeedKmh.isAcceptableOrUnknown(
              data['max_speed_kmh']!, _maxSpeedKmhMeta));
    }
    if (data.containsKey('avg_speed_kmh')) {
      context.handle(
          _avgSpeedKmhMeta,
          avgSpeedKmh.isAcceptableOrUnknown(
              data['avg_speed_kmh']!, _avgSpeedKmhMeta));
    }
    if (data.containsKey('max_g_force')) {
      context.handle(
          _maxGForceMeta,
          maxGForce.isAcceptableOrUnknown(
              data['max_g_force']!, _maxGForceMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      totalDistanceKm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_distance_km'])!,
      maxSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_speed_kmh'])!,
      avgSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_speed_kmh'])!,
      maxGForce: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_g_force'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final int id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalDistanceKm;
  final double maxSpeedKmh;
  final double avgSpeedKmh;
  final double maxGForce;
  final String status;
  const Trip(
      {required this.id,
      required this.userId,
      required this.startTime,
      this.endTime,
      required this.totalDistanceKm,
      required this.maxSpeedKmh,
      required this.avgSpeedKmh,
      required this.maxGForce,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['total_distance_km'] = Variable<double>(totalDistanceKm);
    map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh);
    map['max_g_force'] = Variable<double>(maxGForce);
    map['status'] = Variable<String>(status);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      userId: Value(userId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      totalDistanceKm: Value(totalDistanceKm),
      maxSpeedKmh: Value(maxSpeedKmh),
      avgSpeedKmh: Value(avgSpeedKmh),
      maxGForce: Value(maxGForce),
      status: Value(status),
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      totalDistanceKm: serializer.fromJson<double>(json['totalDistanceKm']),
      maxSpeedKmh: serializer.fromJson<double>(json['maxSpeedKmh']),
      avgSpeedKmh: serializer.fromJson<double>(json['avgSpeedKmh']),
      maxGForce: serializer.fromJson<double>(json['maxGForce']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'totalDistanceKm': serializer.toJson<double>(totalDistanceKm),
      'maxSpeedKmh': serializer.toJson<double>(maxSpeedKmh),
      'avgSpeedKmh': serializer.toJson<double>(avgSpeedKmh),
      'maxGForce': serializer.toJson<double>(maxGForce),
      'status': serializer.toJson<String>(status),
    };
  }

  Trip copyWith(
          {int? id,
          String? userId,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          double? totalDistanceKm,
          double? maxSpeedKmh,
          double? avgSpeedKmh,
          double? maxGForce,
          String? status}) =>
      Trip(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
        maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
        avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
        maxGForce: maxGForce ?? this.maxGForce,
        status: status ?? this.status,
      );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      totalDistanceKm: data.totalDistanceKm.present
          ? data.totalDistanceKm.value
          : this.totalDistanceKm,
      maxSpeedKmh:
          data.maxSpeedKmh.present ? data.maxSpeedKmh.value : this.maxSpeedKmh,
      avgSpeedKmh:
          data.avgSpeedKmh.present ? data.avgSpeedKmh.value : this.avgSpeedKmh,
      maxGForce: data.maxGForce.present ? data.maxGForce.value : this.maxGForce,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxGForce: $maxGForce, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, startTime, endTime,
      totalDistanceKm, maxSpeedKmh, avgSpeedKmh, maxGForce, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.totalDistanceKm == this.totalDistanceKm &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.avgSpeedKmh == this.avgSpeedKmh &&
          other.maxGForce == this.maxGForce &&
          other.status == this.status);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<double> totalDistanceKm;
  final Value<double> maxSpeedKmh;
  final Value<double> avgSpeedKmh;
  final Value<double> maxGForce;
  final Value<String> status;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.totalDistanceKm = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.avgSpeedKmh = const Value.absent(),
    this.maxGForce = const Value.absent(),
    this.status = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.totalDistanceKm = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.avgSpeedKmh = const Value.absent(),
    this.maxGForce = const Value.absent(),
    this.status = const Value.absent(),
  })  : userId = Value(userId),
        startTime = Value(startTime);
  static Insertable<Trip> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? totalDistanceKm,
    Expression<double>? maxSpeedKmh,
    Expression<double>? avgSpeedKmh,
    Expression<double>? maxGForce,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (totalDistanceKm != null) 'total_distance_km': totalDistanceKm,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (avgSpeedKmh != null) 'avg_speed_kmh': avgSpeedKmh,
      if (maxGForce != null) 'max_g_force': maxGForce,
      if (status != null) 'status': status,
    });
  }

  TripsCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<double>? totalDistanceKm,
      Value<double>? maxSpeedKmh,
      Value<double>? avgSpeedKmh,
      Value<double>? maxGForce,
      Value<String>? status}) {
    return TripsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
      maxGForce: maxGForce ?? this.maxGForce,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (totalDistanceKm.present) {
      map['total_distance_km'] = Variable<double>(totalDistanceKm.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (avgSpeedKmh.present) {
      map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh.value);
    }
    if (maxGForce.present) {
      map['max_g_force'] = Variable<double>(maxGForce.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxGForce: $maxGForce, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $RoutePointsTable extends RoutePoints
    with TableInfo<$RoutePointsTable, RoutePoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutePointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
      'trip_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES trips (id)'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _speedKmhMeta =
      const VerificationMeta('speedKmh');
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
      'speed_kmh', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tripId, latitude, longitude, speedKmh, recordedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'route_points';
  @override
  VerificationContext validateIntegrity(Insertable<RoutePoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(_speedKmhMeta,
          speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutePoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutePoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trip_id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      speedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed_kmh'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
    );
  }

  @override
  $RoutePointsTable createAlias(String alias) {
    return $RoutePointsTable(attachedDatabase, alias);
  }
}

class RoutePoint extends DataClass implements Insertable<RoutePoint> {
  final int id;
  final int tripId;
  final double latitude;
  final double longitude;
  final double speedKmh;
  final DateTime recordedAt;
  const RoutePoint(
      {required this.id,
      required this.tripId,
      required this.latitude,
      required this.longitude,
      required this.speedKmh,
      required this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<int>(tripId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['speed_kmh'] = Variable<double>(speedKmh);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  RoutePointsCompanion toCompanion(bool nullToAbsent) {
    return RoutePointsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      speedKmh: Value(speedKmh),
      recordedAt: Value(recordedAt),
    );
  }

  factory RoutePoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutePoint(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<int>(json['tripId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      speedKmh: serializer.fromJson<double>(json['speedKmh']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<int>(tripId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'speedKmh': serializer.toJson<double>(speedKmh),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  RoutePoint copyWith(
          {int? id,
          int? tripId,
          double? latitude,
          double? longitude,
          double? speedKmh,
          DateTime? recordedAt}) =>
      RoutePoint(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        speedKmh: speedKmh ?? this.speedKmh,
        recordedAt: recordedAt ?? this.recordedAt,
      );
  RoutePoint copyWithCompanion(RoutePointsCompanion data) {
    return RoutePoint(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutePoint(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tripId, latitude, longitude, speedKmh, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutePoint &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.speedKmh == this.speedKmh &&
          other.recordedAt == this.recordedAt);
}

class RoutePointsCompanion extends UpdateCompanion<RoutePoint> {
  final Value<int> id;
  final Value<int> tripId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> speedKmh;
  final Value<DateTime> recordedAt;
  const RoutePointsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  RoutePointsCompanion.insert({
    this.id = const Value.absent(),
    required int tripId,
    required double latitude,
    required double longitude,
    this.speedKmh = const Value.absent(),
    required DateTime recordedAt,
  })  : tripId = Value(tripId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        recordedAt = Value(recordedAt);
  static Insertable<RoutePoint> custom({
    Expression<int>? id,
    Expression<int>? tripId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? speedKmh,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  RoutePointsCompanion copyWith(
      {Value<int>? id,
      Value<int>? tripId,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? speedKmh,
      Value<DateTime>? recordedAt}) {
    return RoutePointsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speedKmh: speedKmh ?? this.speedKmh,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutePointsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $TelemetryLogsTable extends TelemetryLogs
    with TableInfo<$TelemetryLogsTable, TelemetryLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelemetryLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
      'trip_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES trips (id)'));
  static const VerificationMeta _speedKmhMeta =
      const VerificationMeta('speedKmh');
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
      'speed_kmh', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avgSpeedKmhMeta =
      const VerificationMeta('avgSpeedKmh');
  @override
  late final GeneratedColumn<double> avgSpeedKmh = GeneratedColumn<double>(
      'avg_speed_kmh', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxSpeedKmhMeta =
      const VerificationMeta('maxSpeedKmh');
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
      'max_speed_kmh', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _distanceKmMeta =
      const VerificationMeta('distanceKm');
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
      'distance_km', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _gForceXMeta =
      const VerificationMeta('gForceX');
  @override
  late final GeneratedColumn<double> gForceX = GeneratedColumn<double>(
      'g_force_x', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _gForceYMeta =
      const VerificationMeta('gForceY');
  @override
  late final GeneratedColumn<double> gForceY = GeneratedColumn<double>(
      'g_force_y', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _gForceMagnitudeMeta =
      const VerificationMeta('gForceMagnitude');
  @override
  late final GeneratedColumn<double> gForceMagnitude = GeneratedColumn<double>(
      'g_force_magnitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _compassBearingMeta =
      const VerificationMeta('compassBearing');
  @override
  late final GeneratedColumn<double> compassBearing = GeneratedColumn<double>(
      'compass_bearing', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tripId,
        speedKmh,
        avgSpeedKmh,
        maxSpeedKmh,
        distanceKm,
        gForceX,
        gForceY,
        gForceMagnitude,
        compassBearing,
        latitude,
        longitude,
        recordedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telemetry_logs';
  @override
  VerificationContext validateIntegrity(Insertable<TelemetryLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(_speedKmhMeta,
          speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta));
    } else if (isInserting) {
      context.missing(_speedKmhMeta);
    }
    if (data.containsKey('avg_speed_kmh')) {
      context.handle(
          _avgSpeedKmhMeta,
          avgSpeedKmh.isAcceptableOrUnknown(
              data['avg_speed_kmh']!, _avgSpeedKmhMeta));
    } else if (isInserting) {
      context.missing(_avgSpeedKmhMeta);
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
          _maxSpeedKmhMeta,
          maxSpeedKmh.isAcceptableOrUnknown(
              data['max_speed_kmh']!, _maxSpeedKmhMeta));
    } else if (isInserting) {
      context.missing(_maxSpeedKmhMeta);
    }
    if (data.containsKey('distance_km')) {
      context.handle(
          _distanceKmMeta,
          distanceKm.isAcceptableOrUnknown(
              data['distance_km']!, _distanceKmMeta));
    } else if (isInserting) {
      context.missing(_distanceKmMeta);
    }
    if (data.containsKey('g_force_x')) {
      context.handle(_gForceXMeta,
          gForceX.isAcceptableOrUnknown(data['g_force_x']!, _gForceXMeta));
    } else if (isInserting) {
      context.missing(_gForceXMeta);
    }
    if (data.containsKey('g_force_y')) {
      context.handle(_gForceYMeta,
          gForceY.isAcceptableOrUnknown(data['g_force_y']!, _gForceYMeta));
    } else if (isInserting) {
      context.missing(_gForceYMeta);
    }
    if (data.containsKey('g_force_magnitude')) {
      context.handle(
          _gForceMagnitudeMeta,
          gForceMagnitude.isAcceptableOrUnknown(
              data['g_force_magnitude']!, _gForceMagnitudeMeta));
    } else if (isInserting) {
      context.missing(_gForceMagnitudeMeta);
    }
    if (data.containsKey('compass_bearing')) {
      context.handle(
          _compassBearingMeta,
          compassBearing.isAcceptableOrUnknown(
              data['compass_bearing']!, _compassBearingMeta));
    } else if (isInserting) {
      context.missing(_compassBearingMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TelemetryLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelemetryLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trip_id'])!,
      speedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed_kmh'])!,
      avgSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_speed_kmh'])!,
      maxSpeedKmh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_speed_kmh'])!,
      distanceKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance_km'])!,
      gForceX: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}g_force_x'])!,
      gForceY: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}g_force_y'])!,
      gForceMagnitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}g_force_magnitude'])!,
      compassBearing: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}compass_bearing'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
    );
  }

  @override
  $TelemetryLogsTable createAlias(String alias) {
    return $TelemetryLogsTable(attachedDatabase, alias);
  }
}

class TelemetryLog extends DataClass implements Insertable<TelemetryLog> {
  final int id;
  final int tripId;
  final double speedKmh;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final double distanceKm;
  final double gForceX;
  final double gForceY;
  final double gForceMagnitude;
  final double compassBearing;
  final double? latitude;
  final double? longitude;
  final DateTime recordedAt;
  const TelemetryLog(
      {required this.id,
      required this.tripId,
      required this.speedKmh,
      required this.avgSpeedKmh,
      required this.maxSpeedKmh,
      required this.distanceKm,
      required this.gForceX,
      required this.gForceY,
      required this.gForceMagnitude,
      required this.compassBearing,
      this.latitude,
      this.longitude,
      required this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<int>(tripId);
    map['speed_kmh'] = Variable<double>(speedKmh);
    map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh);
    map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    map['distance_km'] = Variable<double>(distanceKm);
    map['g_force_x'] = Variable<double>(gForceX);
    map['g_force_y'] = Variable<double>(gForceY);
    map['g_force_magnitude'] = Variable<double>(gForceMagnitude);
    map['compass_bearing'] = Variable<double>(compassBearing);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  TelemetryLogsCompanion toCompanion(bool nullToAbsent) {
    return TelemetryLogsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      speedKmh: Value(speedKmh),
      avgSpeedKmh: Value(avgSpeedKmh),
      maxSpeedKmh: Value(maxSpeedKmh),
      distanceKm: Value(distanceKm),
      gForceX: Value(gForceX),
      gForceY: Value(gForceY),
      gForceMagnitude: Value(gForceMagnitude),
      compassBearing: Value(compassBearing),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      recordedAt: Value(recordedAt),
    );
  }

  factory TelemetryLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelemetryLog(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<int>(json['tripId']),
      speedKmh: serializer.fromJson<double>(json['speedKmh']),
      avgSpeedKmh: serializer.fromJson<double>(json['avgSpeedKmh']),
      maxSpeedKmh: serializer.fromJson<double>(json['maxSpeedKmh']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      gForceX: serializer.fromJson<double>(json['gForceX']),
      gForceY: serializer.fromJson<double>(json['gForceY']),
      gForceMagnitude: serializer.fromJson<double>(json['gForceMagnitude']),
      compassBearing: serializer.fromJson<double>(json['compassBearing']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<int>(tripId),
      'speedKmh': serializer.toJson<double>(speedKmh),
      'avgSpeedKmh': serializer.toJson<double>(avgSpeedKmh),
      'maxSpeedKmh': serializer.toJson<double>(maxSpeedKmh),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'gForceX': serializer.toJson<double>(gForceX),
      'gForceY': serializer.toJson<double>(gForceY),
      'gForceMagnitude': serializer.toJson<double>(gForceMagnitude),
      'compassBearing': serializer.toJson<double>(compassBearing),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  TelemetryLog copyWith(
          {int? id,
          int? tripId,
          double? speedKmh,
          double? avgSpeedKmh,
          double? maxSpeedKmh,
          double? distanceKm,
          double? gForceX,
          double? gForceY,
          double? gForceMagnitude,
          double? compassBearing,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          DateTime? recordedAt}) =>
      TelemetryLog(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        speedKmh: speedKmh ?? this.speedKmh,
        avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
        maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
        distanceKm: distanceKm ?? this.distanceKm,
        gForceX: gForceX ?? this.gForceX,
        gForceY: gForceY ?? this.gForceY,
        gForceMagnitude: gForceMagnitude ?? this.gForceMagnitude,
        compassBearing: compassBearing ?? this.compassBearing,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        recordedAt: recordedAt ?? this.recordedAt,
      );
  TelemetryLog copyWithCompanion(TelemetryLogsCompanion data) {
    return TelemetryLog(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      avgSpeedKmh:
          data.avgSpeedKmh.present ? data.avgSpeedKmh.value : this.avgSpeedKmh,
      maxSpeedKmh:
          data.maxSpeedKmh.present ? data.maxSpeedKmh.value : this.maxSpeedKmh,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      gForceX: data.gForceX.present ? data.gForceX.value : this.gForceX,
      gForceY: data.gForceY.present ? data.gForceY.value : this.gForceY,
      gForceMagnitude: data.gForceMagnitude.present
          ? data.gForceMagnitude.value
          : this.gForceMagnitude,
      compassBearing: data.compassBearing.present
          ? data.compassBearing.value
          : this.compassBearing,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelemetryLog(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('gForceX: $gForceX, ')
          ..write('gForceY: $gForceY, ')
          ..write('gForceMagnitude: $gForceMagnitude, ')
          ..write('compassBearing: $compassBearing, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tripId,
      speedKmh,
      avgSpeedKmh,
      maxSpeedKmh,
      distanceKm,
      gForceX,
      gForceY,
      gForceMagnitude,
      compassBearing,
      latitude,
      longitude,
      recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelemetryLog &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.speedKmh == this.speedKmh &&
          other.avgSpeedKmh == this.avgSpeedKmh &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.distanceKm == this.distanceKm &&
          other.gForceX == this.gForceX &&
          other.gForceY == this.gForceY &&
          other.gForceMagnitude == this.gForceMagnitude &&
          other.compassBearing == this.compassBearing &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.recordedAt == this.recordedAt);
}

class TelemetryLogsCompanion extends UpdateCompanion<TelemetryLog> {
  final Value<int> id;
  final Value<int> tripId;
  final Value<double> speedKmh;
  final Value<double> avgSpeedKmh;
  final Value<double> maxSpeedKmh;
  final Value<double> distanceKm;
  final Value<double> gForceX;
  final Value<double> gForceY;
  final Value<double> gForceMagnitude;
  final Value<double> compassBearing;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<DateTime> recordedAt;
  const TelemetryLogsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.avgSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.gForceX = const Value.absent(),
    this.gForceY = const Value.absent(),
    this.gForceMagnitude = const Value.absent(),
    this.compassBearing = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  TelemetryLogsCompanion.insert({
    this.id = const Value.absent(),
    required int tripId,
    required double speedKmh,
    required double avgSpeedKmh,
    required double maxSpeedKmh,
    required double distanceKm,
    required double gForceX,
    required double gForceY,
    required double gForceMagnitude,
    required double compassBearing,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required DateTime recordedAt,
  })  : tripId = Value(tripId),
        speedKmh = Value(speedKmh),
        avgSpeedKmh = Value(avgSpeedKmh),
        maxSpeedKmh = Value(maxSpeedKmh),
        distanceKm = Value(distanceKm),
        gForceX = Value(gForceX),
        gForceY = Value(gForceY),
        gForceMagnitude = Value(gForceMagnitude),
        compassBearing = Value(compassBearing),
        recordedAt = Value(recordedAt);
  static Insertable<TelemetryLog> custom({
    Expression<int>? id,
    Expression<int>? tripId,
    Expression<double>? speedKmh,
    Expression<double>? avgSpeedKmh,
    Expression<double>? maxSpeedKmh,
    Expression<double>? distanceKm,
    Expression<double>? gForceX,
    Expression<double>? gForceY,
    Expression<double>? gForceMagnitude,
    Expression<double>? compassBearing,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (avgSpeedKmh != null) 'avg_speed_kmh': avgSpeedKmh,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (gForceX != null) 'g_force_x': gForceX,
      if (gForceY != null) 'g_force_y': gForceY,
      if (gForceMagnitude != null) 'g_force_magnitude': gForceMagnitude,
      if (compassBearing != null) 'compass_bearing': compassBearing,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  TelemetryLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? tripId,
      Value<double>? speedKmh,
      Value<double>? avgSpeedKmh,
      Value<double>? maxSpeedKmh,
      Value<double>? distanceKm,
      Value<double>? gForceX,
      Value<double>? gForceY,
      Value<double>? gForceMagnitude,
      Value<double>? compassBearing,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<DateTime>? recordedAt}) {
    return TelemetryLogsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      speedKmh: speedKmh ?? this.speedKmh,
      avgSpeedKmh: avgSpeedKmh ?? this.avgSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      distanceKm: distanceKm ?? this.distanceKm,
      gForceX: gForceX ?? this.gForceX,
      gForceY: gForceY ?? this.gForceY,
      gForceMagnitude: gForceMagnitude ?? this.gForceMagnitude,
      compassBearing: compassBearing ?? this.compassBearing,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (avgSpeedKmh.present) {
      map['avg_speed_kmh'] = Variable<double>(avgSpeedKmh.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (gForceX.present) {
      map['g_force_x'] = Variable<double>(gForceX.value);
    }
    if (gForceY.present) {
      map['g_force_y'] = Variable<double>(gForceY.value);
    }
    if (gForceMagnitude.present) {
      map['g_force_magnitude'] = Variable<double>(gForceMagnitude.value);
    }
    if (compassBearing.present) {
      map['compass_bearing'] = Variable<double>(compassBearing.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelemetryLogsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('avgSpeedKmh: $avgSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('gForceX: $gForceX, ')
          ..write('gForceY: $gForceY, ')
          ..write('gForceMagnitude: $gForceMagnitude, ')
          ..write('compassBearing: $compassBearing, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $MediaFilesTable extends MediaFiles
    with TableInfo<$MediaFilesTable, MediaFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
      'trip_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES trips (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbnailPathMeta =
      const VerificationMeta('thumbnailPath');
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
      'thumbnail_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _overlayConfigMeta =
      const VerificationMeta('overlayConfig');
  @override
  late final GeneratedColumn<String> overlayConfig = GeneratedColumn<String>(
      'overlay_config', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _capturedAtMeta =
      const VerificationMeta('capturedAt');
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
      'captured_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tripId, type, filePath, thumbnailPath, overlayConfig, capturedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_files';
  @override
  VerificationContext validateIntegrity(Insertable<MediaFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
          _thumbnailPathMeta,
          thumbnailPath.isAcceptableOrUnknown(
              data['thumbnail_path']!, _thumbnailPathMeta));
    }
    if (data.containsKey('overlay_config')) {
      context.handle(
          _overlayConfigMeta,
          overlayConfig.isAcceptableOrUnknown(
              data['overlay_config']!, _overlayConfigMeta));
    }
    if (data.containsKey('captured_at')) {
      context.handle(
          _capturedAtMeta,
          capturedAt.isAcceptableOrUnknown(
              data['captured_at']!, _capturedAtMeta));
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trip_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      thumbnailPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_path']),
      overlayConfig: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overlay_config']),
      capturedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}captured_at'])!,
    );
  }

  @override
  $MediaFilesTable createAlias(String alias) {
    return $MediaFilesTable(attachedDatabase, alias);
  }
}

class MediaFile extends DataClass implements Insertable<MediaFile> {
  final int id;
  final int tripId;
  final String type;
  final String filePath;
  final String? thumbnailPath;
  final String? overlayConfig;
  final DateTime capturedAt;
  const MediaFile(
      {required this.id,
      required this.tripId,
      required this.type,
      required this.filePath,
      this.thumbnailPath,
      this.overlayConfig,
      required this.capturedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<int>(tripId);
    map['type'] = Variable<String>(type);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || overlayConfig != null) {
      map['overlay_config'] = Variable<String>(overlayConfig);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    return map;
  }

  MediaFilesCompanion toCompanion(bool nullToAbsent) {
    return MediaFilesCompanion(
      id: Value(id),
      tripId: Value(tripId),
      type: Value(type),
      filePath: Value(filePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      overlayConfig: overlayConfig == null && nullToAbsent
          ? const Value.absent()
          : Value(overlayConfig),
      capturedAt: Value(capturedAt),
    );
  }

  factory MediaFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFile(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<int>(json['tripId']),
      type: serializer.fromJson<String>(json['type']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      overlayConfig: serializer.fromJson<String?>(json['overlayConfig']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<int>(tripId),
      'type': serializer.toJson<String>(type),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'overlayConfig': serializer.toJson<String?>(overlayConfig),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
    };
  }

  MediaFile copyWith(
          {int? id,
          int? tripId,
          String? type,
          String? filePath,
          Value<String?> thumbnailPath = const Value.absent(),
          Value<String?> overlayConfig = const Value.absent(),
          DateTime? capturedAt}) =>
      MediaFile(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        type: type ?? this.type,
        filePath: filePath ?? this.filePath,
        thumbnailPath:
            thumbnailPath.present ? thumbnailPath.value : this.thumbnailPath,
        overlayConfig:
            overlayConfig.present ? overlayConfig.value : this.overlayConfig,
        capturedAt: capturedAt ?? this.capturedAt,
      );
  MediaFile copyWithCompanion(MediaFilesCompanion data) {
    return MediaFile(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      type: data.type.present ? data.type.value : this.type,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      overlayConfig: data.overlayConfig.present
          ? data.overlayConfig.value
          : this.overlayConfig,
      capturedAt:
          data.capturedAt.present ? data.capturedAt.value : this.capturedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFile(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('overlayConfig: $overlayConfig, ')
          ..write('capturedAt: $capturedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, tripId, type, filePath, thumbnailPath, overlayConfig, capturedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFile &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.type == this.type &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.overlayConfig == this.overlayConfig &&
          other.capturedAt == this.capturedAt);
}

class MediaFilesCompanion extends UpdateCompanion<MediaFile> {
  final Value<int> id;
  final Value<int> tripId;
  final Value<String> type;
  final Value<String> filePath;
  final Value<String?> thumbnailPath;
  final Value<String?> overlayConfig;
  final Value<DateTime> capturedAt;
  const MediaFilesCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.type = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.overlayConfig = const Value.absent(),
    this.capturedAt = const Value.absent(),
  });
  MediaFilesCompanion.insert({
    this.id = const Value.absent(),
    required int tripId,
    required String type,
    required String filePath,
    this.thumbnailPath = const Value.absent(),
    this.overlayConfig = const Value.absent(),
    required DateTime capturedAt,
  })  : tripId = Value(tripId),
        type = Value(type),
        filePath = Value(filePath),
        capturedAt = Value(capturedAt);
  static Insertable<MediaFile> custom({
    Expression<int>? id,
    Expression<int>? tripId,
    Expression<String>? type,
    Expression<String>? filePath,
    Expression<String>? thumbnailPath,
    Expression<String>? overlayConfig,
    Expression<DateTime>? capturedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (type != null) 'type': type,
      if (filePath != null) 'file_path': filePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (overlayConfig != null) 'overlay_config': overlayConfig,
      if (capturedAt != null) 'captured_at': capturedAt,
    });
  }

  MediaFilesCompanion copyWith(
      {Value<int>? id,
      Value<int>? tripId,
      Value<String>? type,
      Value<String>? filePath,
      Value<String?>? thumbnailPath,
      Value<String?>? overlayConfig,
      Value<DateTime>? capturedAt}) {
    return MediaFilesCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      overlayConfig: overlayConfig ?? this.overlayConfig,
      capturedAt: capturedAt ?? this.capturedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (overlayConfig.present) {
      map['overlay_config'] = Variable<String>(overlayConfig.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaFilesCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('overlayConfig: $overlayConfig, ')
          ..write('capturedAt: $capturedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $RoutePointsTable routePoints = $RoutePointsTable(this);
  late final $TelemetryLogsTable telemetryLogs = $TelemetryLogsTable(this);
  late final $MediaFilesTable mediaFiles = $MediaFilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [trips, routePoints, telemetryLogs, mediaFiles];
}

typedef $$TripsTableCreateCompanionBuilder = TripsCompanion Function({
  Value<int> id,
  required String userId,
  required DateTime startTime,
  Value<DateTime?> endTime,
  Value<double> totalDistanceKm,
  Value<double> maxSpeedKmh,
  Value<double> avgSpeedKmh,
  Value<double> maxGForce,
  Value<String> status,
});
typedef $$TripsTableUpdateCompanionBuilder = TripsCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<double> totalDistanceKm,
  Value<double> maxSpeedKmh,
  Value<double> avgSpeedKmh,
  Value<double> maxGForce,
  Value<String> status,
});

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, Trip> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutePointsTable, List<RoutePoint>>
      _routePointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.routePoints,
          aliasName: $_aliasNameGenerator(db.trips.id, db.routePoints.tripId));

  $$RoutePointsTableProcessedTableManager get routePointsRefs {
    final manager = $$RoutePointsTableTableManager($_db, $_db.routePoints)
        .filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_routePointsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TelemetryLogsTable, List<TelemetryLog>>
      _telemetryLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.telemetryLogs,
              aliasName:
                  $_aliasNameGenerator(db.trips.id, db.telemetryLogs.tripId));

  $$TelemetryLogsTableProcessedTableManager get telemetryLogsRefs {
    final manager = $$TelemetryLogsTableTableManager($_db, $_db.telemetryLogs)
        .filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_telemetryLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MediaFilesTable, List<MediaFile>>
      _mediaFilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.mediaFiles,
          aliasName: $_aliasNameGenerator(db.trips.id, db.mediaFiles.tripId));

  $$MediaFilesTableProcessedTableManager get mediaFilesRefs {
    final manager = $$MediaFilesTableTableManager($_db, $_db.mediaFiles)
        .filter((f) => f.tripId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaFilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalDistanceKm => $composableBuilder(
      column: $table.totalDistanceKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxGForce => $composableBuilder(
      column: $table.maxGForce, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  Expression<bool> routePointsRefs(
      Expression<bool> Function($$RoutePointsTableFilterComposer f) f) {
    final $$RoutePointsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routePoints,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutePointsTableFilterComposer(
              $db: $db,
              $table: $db.routePoints,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> telemetryLogsRefs(
      Expression<bool> Function($$TelemetryLogsTableFilterComposer f) f) {
    final $$TelemetryLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.telemetryLogs,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TelemetryLogsTableFilterComposer(
              $db: $db,
              $table: $db.telemetryLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mediaFilesRefs(
      Expression<bool> Function($$MediaFilesTableFilterComposer f) f) {
    final $$MediaFilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mediaFiles,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MediaFilesTableFilterComposer(
              $db: $db,
              $table: $db.mediaFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalDistanceKm => $composableBuilder(
      column: $table.totalDistanceKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxGForce => $composableBuilder(
      column: $table.maxGForce, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get totalDistanceKm => $composableBuilder(
      column: $table.totalDistanceKm, builder: (column) => column);

  GeneratedColumn<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => column);

  GeneratedColumn<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => column);

  GeneratedColumn<double> get maxGForce =>
      $composableBuilder(column: $table.maxGForce, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> routePointsRefs<T extends Object>(
      Expression<T> Function($$RoutePointsTableAnnotationComposer a) f) {
    final $$RoutePointsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routePoints,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutePointsTableAnnotationComposer(
              $db: $db,
              $table: $db.routePoints,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> telemetryLogsRefs<T extends Object>(
      Expression<T> Function($$TelemetryLogsTableAnnotationComposer a) f) {
    final $$TelemetryLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.telemetryLogs,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TelemetryLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.telemetryLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> mediaFilesRefs<T extends Object>(
      Expression<T> Function($$MediaFilesTableAnnotationComposer a) f) {
    final $$MediaFilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mediaFiles,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MediaFilesTableAnnotationComposer(
              $db: $db,
              $table: $db.mediaFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TripsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, $$TripsTableReferences),
    Trip,
    PrefetchHooks Function(
        {bool routePointsRefs, bool telemetryLogsRefs, bool mediaFilesRefs})> {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<double> totalDistanceKm = const Value.absent(),
            Value<double> maxSpeedKmh = const Value.absent(),
            Value<double> avgSpeedKmh = const Value.absent(),
            Value<double> maxGForce = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              TripsCompanion(
            id: id,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            totalDistanceKm: totalDistanceKm,
            maxSpeedKmh: maxSpeedKmh,
            avgSpeedKmh: avgSpeedKmh,
            maxGForce: maxGForce,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            Value<double> totalDistanceKm = const Value.absent(),
            Value<double> maxSpeedKmh = const Value.absent(),
            Value<double> avgSpeedKmh = const Value.absent(),
            Value<double> maxGForce = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              TripsCompanion.insert(
            id: id,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            totalDistanceKm: totalDistanceKm,
            maxSpeedKmh: maxSpeedKmh,
            avgSpeedKmh: avgSpeedKmh,
            maxGForce: maxGForce,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TripsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {routePointsRefs = false,
              telemetryLogsRefs = false,
              mediaFilesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routePointsRefs) db.routePoints,
                if (telemetryLogsRefs) db.telemetryLogs,
                if (mediaFilesRefs) db.mediaFiles
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routePointsRefs)
                    await $_getPrefetchedData<Trip, $TripsTable, RoutePoint>(
                        currentTable: table,
                        referencedTable:
                            $$TripsTableReferences._routePointsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TripsTableReferences(db, table, p0)
                                .routePointsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tripId == item.id),
                        typedResults: items),
                  if (telemetryLogsRefs)
                    await $_getPrefetchedData<Trip, $TripsTable, TelemetryLog>(
                        currentTable: table,
                        referencedTable:
                            $$TripsTableReferences._telemetryLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TripsTableReferences(db, table, p0)
                                .telemetryLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tripId == item.id),
                        typedResults: items),
                  if (mediaFilesRefs)
                    await $_getPrefetchedData<Trip, $TripsTable, MediaFile>(
                        currentTable: table,
                        referencedTable:
                            $$TripsTableReferences._mediaFilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TripsTableReferences(db, table, p0)
                                .mediaFilesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tripId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TripsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, $$TripsTableReferences),
    Trip,
    PrefetchHooks Function(
        {bool routePointsRefs, bool telemetryLogsRefs, bool mediaFilesRefs})>;
typedef $$RoutePointsTableCreateCompanionBuilder = RoutePointsCompanion
    Function({
  Value<int> id,
  required int tripId,
  required double latitude,
  required double longitude,
  Value<double> speedKmh,
  required DateTime recordedAt,
});
typedef $$RoutePointsTableUpdateCompanionBuilder = RoutePointsCompanion
    Function({
  Value<int> id,
  Value<int> tripId,
  Value<double> latitude,
  Value<double> longitude,
  Value<double> speedKmh,
  Value<DateTime> recordedAt,
});

final class $$RoutePointsTableReferences
    extends BaseReferences<_$AppDatabase, $RoutePointsTable, RoutePoint> {
  $$RoutePointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips
      .createAlias($_aliasNameGenerator(db.routePoints.tripId, db.trips.id));

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager($_db, $_db.trips)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoutePointsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutePointsTable> {
  $$RoutePointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get speedKmh => $composableBuilder(
      column: $table.speedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableFilterComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutePointsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutePointsTable> {
  $$RoutePointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get speedKmh => $composableBuilder(
      column: $table.speedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableOrderingComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutePointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutePointsTable> {
  $$RoutePointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableAnnotationComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutePointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutePointsTable,
    RoutePoint,
    $$RoutePointsTableFilterComposer,
    $$RoutePointsTableOrderingComposer,
    $$RoutePointsTableAnnotationComposer,
    $$RoutePointsTableCreateCompanionBuilder,
    $$RoutePointsTableUpdateCompanionBuilder,
    (RoutePoint, $$RoutePointsTableReferences),
    RoutePoint,
    PrefetchHooks Function({bool tripId})> {
  $$RoutePointsTableTableManager(_$AppDatabase db, $RoutePointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutePointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutePointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutePointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tripId = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<double> speedKmh = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
          }) =>
              RoutePointsCompanion(
            id: id,
            tripId: tripId,
            latitude: latitude,
            longitude: longitude,
            speedKmh: speedKmh,
            recordedAt: recordedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tripId,
            required double latitude,
            required double longitude,
            Value<double> speedKmh = const Value.absent(),
            required DateTime recordedAt,
          }) =>
              RoutePointsCompanion.insert(
            id: id,
            tripId: tripId,
            latitude: latitude,
            longitude: longitude,
            speedKmh: speedKmh,
            recordedAt: recordedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RoutePointsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                if (tripId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tripId,
                    referencedTable:
                        $$RoutePointsTableReferences._tripIdTable(db),
                    referencedColumn:
                        $$RoutePointsTableReferences._tripIdTable(db).id,
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

typedef $$RoutePointsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutePointsTable,
    RoutePoint,
    $$RoutePointsTableFilterComposer,
    $$RoutePointsTableOrderingComposer,
    $$RoutePointsTableAnnotationComposer,
    $$RoutePointsTableCreateCompanionBuilder,
    $$RoutePointsTableUpdateCompanionBuilder,
    (RoutePoint, $$RoutePointsTableReferences),
    RoutePoint,
    PrefetchHooks Function({bool tripId})>;
typedef $$TelemetryLogsTableCreateCompanionBuilder = TelemetryLogsCompanion
    Function({
  Value<int> id,
  required int tripId,
  required double speedKmh,
  required double avgSpeedKmh,
  required double maxSpeedKmh,
  required double distanceKm,
  required double gForceX,
  required double gForceY,
  required double gForceMagnitude,
  required double compassBearing,
  Value<double?> latitude,
  Value<double?> longitude,
  required DateTime recordedAt,
});
typedef $$TelemetryLogsTableUpdateCompanionBuilder = TelemetryLogsCompanion
    Function({
  Value<int> id,
  Value<int> tripId,
  Value<double> speedKmh,
  Value<double> avgSpeedKmh,
  Value<double> maxSpeedKmh,
  Value<double> distanceKm,
  Value<double> gForceX,
  Value<double> gForceY,
  Value<double> gForceMagnitude,
  Value<double> compassBearing,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<DateTime> recordedAt,
});

final class $$TelemetryLogsTableReferences
    extends BaseReferences<_$AppDatabase, $TelemetryLogsTable, TelemetryLog> {
  $$TelemetryLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips
      .createAlias($_aliasNameGenerator(db.telemetryLogs.tripId, db.trips.id));

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager($_db, $_db.trips)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TelemetryLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TelemetryLogsTable> {
  $$TelemetryLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get speedKmh => $composableBuilder(
      column: $table.speedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gForceX => $composableBuilder(
      column: $table.gForceX, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gForceY => $composableBuilder(
      column: $table.gForceY, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gForceMagnitude => $composableBuilder(
      column: $table.gForceMagnitude,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get compassBearing => $composableBuilder(
      column: $table.compassBearing,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableFilterComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TelemetryLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TelemetryLogsTable> {
  $$TelemetryLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get speedKmh => $composableBuilder(
      column: $table.speedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gForceX => $composableBuilder(
      column: $table.gForceX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gForceY => $composableBuilder(
      column: $table.gForceY, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gForceMagnitude => $composableBuilder(
      column: $table.gForceMagnitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get compassBearing => $composableBuilder(
      column: $table.compassBearing,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableOrderingComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TelemetryLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelemetryLogsTable> {
  $$TelemetryLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<double> get avgSpeedKmh => $composableBuilder(
      column: $table.avgSpeedKmh, builder: (column) => column);

  GeneratedColumn<double> get maxSpeedKmh => $composableBuilder(
      column: $table.maxSpeedKmh, builder: (column) => column);

  GeneratedColumn<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => column);

  GeneratedColumn<double> get gForceX =>
      $composableBuilder(column: $table.gForceX, builder: (column) => column);

  GeneratedColumn<double> get gForceY =>
      $composableBuilder(column: $table.gForceY, builder: (column) => column);

  GeneratedColumn<double> get gForceMagnitude => $composableBuilder(
      column: $table.gForceMagnitude, builder: (column) => column);

  GeneratedColumn<double> get compassBearing => $composableBuilder(
      column: $table.compassBearing, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableAnnotationComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TelemetryLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TelemetryLogsTable,
    TelemetryLog,
    $$TelemetryLogsTableFilterComposer,
    $$TelemetryLogsTableOrderingComposer,
    $$TelemetryLogsTableAnnotationComposer,
    $$TelemetryLogsTableCreateCompanionBuilder,
    $$TelemetryLogsTableUpdateCompanionBuilder,
    (TelemetryLog, $$TelemetryLogsTableReferences),
    TelemetryLog,
    PrefetchHooks Function({bool tripId})> {
  $$TelemetryLogsTableTableManager(_$AppDatabase db, $TelemetryLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelemetryLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelemetryLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelemetryLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tripId = const Value.absent(),
            Value<double> speedKmh = const Value.absent(),
            Value<double> avgSpeedKmh = const Value.absent(),
            Value<double> maxSpeedKmh = const Value.absent(),
            Value<double> distanceKm = const Value.absent(),
            Value<double> gForceX = const Value.absent(),
            Value<double> gForceY = const Value.absent(),
            Value<double> gForceMagnitude = const Value.absent(),
            Value<double> compassBearing = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
          }) =>
              TelemetryLogsCompanion(
            id: id,
            tripId: tripId,
            speedKmh: speedKmh,
            avgSpeedKmh: avgSpeedKmh,
            maxSpeedKmh: maxSpeedKmh,
            distanceKm: distanceKm,
            gForceX: gForceX,
            gForceY: gForceY,
            gForceMagnitude: gForceMagnitude,
            compassBearing: compassBearing,
            latitude: latitude,
            longitude: longitude,
            recordedAt: recordedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tripId,
            required double speedKmh,
            required double avgSpeedKmh,
            required double maxSpeedKmh,
            required double distanceKm,
            required double gForceX,
            required double gForceY,
            required double gForceMagnitude,
            required double compassBearing,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            required DateTime recordedAt,
          }) =>
              TelemetryLogsCompanion.insert(
            id: id,
            tripId: tripId,
            speedKmh: speedKmh,
            avgSpeedKmh: avgSpeedKmh,
            maxSpeedKmh: maxSpeedKmh,
            distanceKm: distanceKm,
            gForceX: gForceX,
            gForceY: gForceY,
            gForceMagnitude: gForceMagnitude,
            compassBearing: compassBearing,
            latitude: latitude,
            longitude: longitude,
            recordedAt: recordedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TelemetryLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                if (tripId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tripId,
                    referencedTable:
                        $$TelemetryLogsTableReferences._tripIdTable(db),
                    referencedColumn:
                        $$TelemetryLogsTableReferences._tripIdTable(db).id,
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

typedef $$TelemetryLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TelemetryLogsTable,
    TelemetryLog,
    $$TelemetryLogsTableFilterComposer,
    $$TelemetryLogsTableOrderingComposer,
    $$TelemetryLogsTableAnnotationComposer,
    $$TelemetryLogsTableCreateCompanionBuilder,
    $$TelemetryLogsTableUpdateCompanionBuilder,
    (TelemetryLog, $$TelemetryLogsTableReferences),
    TelemetryLog,
    PrefetchHooks Function({bool tripId})>;
typedef $$MediaFilesTableCreateCompanionBuilder = MediaFilesCompanion Function({
  Value<int> id,
  required int tripId,
  required String type,
  required String filePath,
  Value<String?> thumbnailPath,
  Value<String?> overlayConfig,
  required DateTime capturedAt,
});
typedef $$MediaFilesTableUpdateCompanionBuilder = MediaFilesCompanion Function({
  Value<int> id,
  Value<int> tripId,
  Value<String> type,
  Value<String> filePath,
  Value<String?> thumbnailPath,
  Value<String?> overlayConfig,
  Value<DateTime> capturedAt,
});

final class $$MediaFilesTableReferences
    extends BaseReferences<_$AppDatabase, $MediaFilesTable, MediaFile> {
  $$MediaFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips
      .createAlias($_aliasNameGenerator(db.mediaFiles.tripId, db.trips.id));

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<int>('trip_id')!;

    final manager = $$TripsTableTableManager($_db, $_db.trips)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MediaFilesTableFilterComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overlayConfig => $composableBuilder(
      column: $table.overlayConfig, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => ColumnFilters(column));

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableFilterComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overlayConfig => $composableBuilder(
      column: $table.overlayConfig,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => ColumnOrderings(column));

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableOrderingComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableAnnotationComposer({
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

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath, builder: (column) => column);

  GeneratedColumn<String> get overlayConfig => $composableBuilder(
      column: $table.overlayConfig, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.trips,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TripsTableAnnotationComposer(
              $db: $db,
              $table: $db.trips,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaFilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MediaFilesTable,
    MediaFile,
    $$MediaFilesTableFilterComposer,
    $$MediaFilesTableOrderingComposer,
    $$MediaFilesTableAnnotationComposer,
    $$MediaFilesTableCreateCompanionBuilder,
    $$MediaFilesTableUpdateCompanionBuilder,
    (MediaFile, $$MediaFilesTableReferences),
    MediaFile,
    PrefetchHooks Function({bool tripId})> {
  $$MediaFilesTableTableManager(_$AppDatabase db, $MediaFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tripId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> thumbnailPath = const Value.absent(),
            Value<String?> overlayConfig = const Value.absent(),
            Value<DateTime> capturedAt = const Value.absent(),
          }) =>
              MediaFilesCompanion(
            id: id,
            tripId: tripId,
            type: type,
            filePath: filePath,
            thumbnailPath: thumbnailPath,
            overlayConfig: overlayConfig,
            capturedAt: capturedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tripId,
            required String type,
            required String filePath,
            Value<String?> thumbnailPath = const Value.absent(),
            Value<String?> overlayConfig = const Value.absent(),
            required DateTime capturedAt,
          }) =>
              MediaFilesCompanion.insert(
            id: id,
            tripId: tripId,
            type: type,
            filePath: filePath,
            thumbnailPath: thumbnailPath,
            overlayConfig: overlayConfig,
            capturedAt: capturedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MediaFilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                if (tripId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tripId,
                    referencedTable:
                        $$MediaFilesTableReferences._tripIdTable(db),
                    referencedColumn:
                        $$MediaFilesTableReferences._tripIdTable(db).id,
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

typedef $$MediaFilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MediaFilesTable,
    MediaFile,
    $$MediaFilesTableFilterComposer,
    $$MediaFilesTableOrderingComposer,
    $$MediaFilesTableAnnotationComposer,
    $$MediaFilesTableCreateCompanionBuilder,
    $$MediaFilesTableUpdateCompanionBuilder,
    (MediaFile, $$MediaFilesTableReferences),
    MediaFile,
    PrefetchHooks Function({bool tripId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$RoutePointsTableTableManager get routePoints =>
      $$RoutePointsTableTableManager(_db, _db.routePoints);
  $$TelemetryLogsTableTableManager get telemetryLogs =>
      $$TelemetryLogsTableTableManager(_db, _db.telemetryLogs);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db, _db.mediaFiles);
}
