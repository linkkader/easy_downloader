// Created by linkkader on 3/3/2023

import 'dart:collection';
import 'dart:convert';
import 'package:isar/isar.dart';


part 'isar_map_entity.g.dart';

@Embedded(inheritance: false)
class IsarMapEntity with MapMixin<String, dynamic> {
  @ignore
  Map<String, dynamic> _map = {};

  String get json => jsonEncode(_map);

  set json(String value) => _map = jsonDecode(value);

  @override
  dynamic operator [](Object? key) => _map[key];

  @override
  void operator []=(String key, value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @ignore
  @override
  Iterable<String> get keys => _map.keys;

  @override
  dynamic remove(Object? key) => _map.remove(key);

  IsarMapEntity();

  IsarMapEntity.fromJson(this._map);

  Map<String, dynamic> toJson() => _map;
}
