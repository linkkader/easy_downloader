// Created by linkkader on 5/12/2022

import 'package:isar/isar.dart';

part 'pref_isar.g.dart';

@Collection()

///class to store key value pair for date time
///[key] key
///[value] value
///[id] id
///[DateTimeIsar] DateTimeIsar
class DateTimeIsar {
  const DateTimeIsar(this.key, this.value, {this.id = Isar.autoIncrement});
  final Id id;
  final DateTime value;
  @Index(unique: true, replace: true)
  final String key;
}

@Collection()

///class to store key value pair for int
///[key] key
///[value] value
///[id] id
///[IntIsar] int isar
class IntIsar {
  const IntIsar(this.key, this.value, {this.id = Isar.autoIncrement});
  final Id id;
  final int value;
  @Index(unique: true, replace: true)
  final String key;
}

@Collection()

///class to store key value pair for string
///[key] key
///[value] value
///[id] id
///[StringIsar] string isar
///[StringIsar] string isar
class StringIsar {
  const StringIsar(this.key, this.value, {this.id = Isar.autoIncrement});
  final Id id;
  final String value;
  @Index(unique: true, replace: true)
  final String key;
}
