// Created by linkkader on 3/3/2023

import 'dart:collection';
import 'dart:convert';
import 'package:isar/isar.dart';

part 'isar_map_entity.g.dart';

@Embedded(inheritance: false)

///class to store map
///[json] json
///[map] map
///[keys] keys
///[remove] remove
///[clear] clear
class IsarMapEntityEasyDownloader with MapMixin<String, dynamic> {
  @ignore
  Map<String, dynamic> _map = {};

  ///convert to json
  String get json => jsonEncode(_map);

  ///set json
  set json(String value) => _map = jsonDecode(value);

  ///get map
  @override
  dynamic operator [](Object? key) => _map[key];

  ///set map
  @override
  void operator []=(String key, value) => _map[key] = value;

  ///clear map
  @override
  void clear() => _map.clear();

  ///get keys
  @ignore
  @override
  Iterable<String> get keys => _map.keys;

  ///remove key
  @override
  dynamic remove(Object? key) => _map.remove(key);

  ///get values
  IsarMapEntityEasyDownloader();

  ///from json
  IsarMapEntityEasyDownloader.fromJson(this._map);

  ///to json
  Map<String, dynamic> toJson() => _map;
}
