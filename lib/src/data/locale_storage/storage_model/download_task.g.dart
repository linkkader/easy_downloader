// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetDownloadTaskCollection on Isar {
  IsarCollection<DownloadTask> get downloadTasks => this.collection();
}

const DownloadTaskSchema = CollectionSchema(
  name: r'DownloadTask',
  id: -8326932930248620171,
  properties: {
    r'blocks': PropertySchema(
      id: 0,
      name: r'blocks',
      type: IsarType.objectList,
      target: r'DownloadBlock',
    ),
    r'fileName': PropertySchema(
      id: 1,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'headers': PropertySchema(
      id: 3,
      name: r'headers',
      type: IsarType.object,
      target: r'IsarMapEntity',
    ),
    r'maxSplit': PropertySchema(
      id: 4,
      name: r'maxSplit',
      type: IsarType.long,
    ),
    r'outputFilePath': PropertySchema(
      id: 5,
      name: r'outputFilePath',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 6,
      name: r'path',
      type: IsarType.string,
    ),
    r'showNotification': PropertySchema(
      id: 7,
      name: r'showNotification',
      type: IsarType.bool,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.byte,
      enumMap: _DownloadTaskstatusEnumValueMap,
    ),
    r'totalDownloaded': PropertySchema(
      id: 9,
      name: r'totalDownloaded',
      type: IsarType.long,
    ),
    r'totalLength': PropertySchema(
      id: 10,
      name: r'totalLength',
      type: IsarType.long,
    ),
    r'url': PropertySchema(
      id: 11,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadTaskEstimateSize,
  serialize: _downloadTaskSerialize,
  deserialize: _downloadTaskDeserialize,
  deserializeProp: _downloadTaskDeserializeProp,
  idName: r'downloadId',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'DownloadBlock': DownloadBlockSchema,
    r'IsarMapEntity': IsarMapEntitySchema
  },
  getId: _downloadTaskGetId,
  getLinks: _downloadTaskGetLinks,
  attach: _downloadTaskAttach,
  version: '3.0.5',
);

int _downloadTaskEstimateSize(
  DownloadTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.blocks.length * 3;
  {
    final offsets = allOffsets[DownloadBlock]!;
    for (var i = 0; i < object.blocks.length; i++) {
      final value = object.blocks[i];
      bytesCount +=
          DownloadBlockSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.fileName.length * 3;
  bytesCount += 3 +
      IsarMapEntitySchema.estimateSize(
          object.headers, allOffsets[IsarMapEntity]!, allOffsets);
  bytesCount += 3 + object.outputFilePath.length * 3;
  bytesCount += 3 + object.path.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _downloadTaskSerialize(
  DownloadTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<DownloadBlock>(
    offsets[0],
    allOffsets,
    DownloadBlockSchema.serialize,
    object.blocks,
  );
  writer.writeString(offsets[1], object.fileName);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeObject<IsarMapEntity>(
    offsets[3],
    allOffsets,
    IsarMapEntitySchema.serialize,
    object.headers,
  );
  writer.writeLong(offsets[4], object.maxSplit);
  writer.writeString(offsets[5], object.outputFilePath);
  writer.writeString(offsets[6], object.path);
  writer.writeBool(offsets[7], object.showNotification);
  writer.writeByte(offsets[8], object.status.index);
  writer.writeLong(offsets[9], object.totalDownloaded);
  writer.writeLong(offsets[10], object.totalLength);
  writer.writeString(offsets[11], object.url);
}

DownloadTask _downloadTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadTask(
    blocks: reader.readObjectList<DownloadBlock>(
          offsets[0],
          DownloadBlockSchema.deserialize,
          allOffsets,
          DownloadBlock(),
        ) ??
        const [],
    downloadId: id,
    fileName: reader.readString(offsets[1]),
    headers: reader.readObjectOrNull<IsarMapEntity>(
          offsets[3],
          IsarMapEntitySchema.deserialize,
          allOffsets,
        ) ??
        IsarMapEntity(),
    maxSplit: reader.readLongOrNull(offsets[4]) ?? 0,
    path: reader.readString(offsets[6]),
    showNotification: reader.readBoolOrNull(offsets[7]) ?? false,
    status:
        _DownloadTaskstatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
            DownloadStatus.queuing,
    totalDownloaded: reader.readLongOrNull(offsets[9]) ?? 0,
    totalLength: reader.readLongOrNull(offsets[10]) ?? 0,
    url: reader.readString(offsets[11]),
  );
  return object;
}

P _downloadTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<DownloadBlock>(
            offset,
            DownloadBlockSchema.deserialize,
            allOffsets,
            DownloadBlock(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<IsarMapEntity>(
            offset,
            IsarMapEntitySchema.deserialize,
            allOffsets,
          ) ??
          IsarMapEntity()) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 8:
      return (_DownloadTaskstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          DownloadStatus.queuing) as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DownloadTaskstatusEnumValueMap = {
  'downloading': 0,
  'paused': 1,
  'completed': 2,
  'failed': 3,
  'appending': 4,
  'queuing': 5,
};
const _DownloadTaskstatusValueEnumMap = {
  0: DownloadStatus.downloading,
  1: DownloadStatus.paused,
  2: DownloadStatus.completed,
  3: DownloadStatus.failed,
  4: DownloadStatus.appending,
  5: DownloadStatus.queuing,
};

Id _downloadTaskGetId(DownloadTask object) {
  return object.downloadId;
}

List<IsarLinkBase<dynamic>> _downloadTaskGetLinks(DownloadTask object) {
  return [];
}

void _downloadTaskAttach(
    IsarCollection<dynamic> col, Id id, DownloadTask object) {}

extension DownloadTaskQueryWhereSort
    on QueryBuilder<DownloadTask, DownloadTask, QWhere> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterWhere> anyDownloadId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadTaskQueryWhere
    on QueryBuilder<DownloadTask, DownloadTask, QWhereClause> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause> downloadIdEqualTo(
      Id downloadId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: downloadId,
        upper: downloadId,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause>
      downloadIdNotEqualTo(Id downloadId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: downloadId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: downloadId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: downloadId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: downloadId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause>
      downloadIdGreaterThan(Id downloadId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: downloadId, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause>
      downloadIdLessThan(Id downloadId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: downloadId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterWhereClause> downloadIdBetween(
    Id lowerDownloadId,
    Id upperDownloadId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerDownloadId,
        includeLower: includeLower,
        upper: upperDownloadId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadTaskQueryFilter
    on QueryBuilder<DownloadTask, DownloadTask, QFilterCondition> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      blocksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      blocksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      blocksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      blocksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      blocksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      blocksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      downloadIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      downloadIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      downloadIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      downloadIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      maxSplitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxSplit',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      maxSplitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxSplit',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      maxSplitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxSplit',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      maxSplitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxSplit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outputFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outputFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outputFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outputFilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'outputFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'outputFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'outputFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'outputFilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outputFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      outputFilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'outputFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      showNotificationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showNotification',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> statusEqualTo(
      DownloadStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      statusGreaterThan(
    DownloadStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      statusLessThan(
    DownloadStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> statusBetween(
    DownloadStatus lower,
    DownloadStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalDownloadedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalDownloadedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalDownloadedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalDownloadedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDownloaded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalLengthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalLength',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalLengthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalLength',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalLengthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalLength',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      totalLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalLength',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition>
      urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension DownloadTaskQueryObject
    on QueryBuilder<DownloadTask, DownloadTask, QFilterCondition> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> blocksElement(
      FilterQuery<DownloadBlock> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'blocks');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterFilterCondition> headers(
      FilterQuery<IsarMapEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'headers');
    });
  }
}

extension DownloadTaskQueryLinks
    on QueryBuilder<DownloadTask, DownloadTask, QFilterCondition> {}

extension DownloadTaskQuerySortBy
    on QueryBuilder<DownloadTask, DownloadTask, QSortBy> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByMaxSplit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSplit', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByMaxSplitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSplit', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByOutputFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputFilePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByOutputFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputFilePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByShowNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotification', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByShowNotificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotification', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByTotalDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloaded', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByTotalDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloaded', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByTotalLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLength', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      sortByTotalLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLength', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension DownloadTaskQuerySortThenBy
    on QueryBuilder<DownloadTask, DownloadTask, QSortThenBy> {
  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByDownloadId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadId', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByDownloadIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadId', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByMaxSplit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSplit', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByMaxSplitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSplit', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByOutputFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputFilePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByOutputFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputFilePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByShowNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotification', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByShowNotificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotification', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByTotalDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloaded', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByTotalDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloaded', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByTotalLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLength', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy>
      thenByTotalLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLength', Sort.desc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension DownloadTaskQueryWhereDistinct
    on QueryBuilder<DownloadTask, DownloadTask, QDistinct> {
  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByFileName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByMaxSplit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSplit');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByOutputFilePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outputFilePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct>
      distinctByShowNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showNotification');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct>
      distinctByTotalDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDownloaded');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByTotalLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalLength');
    });
  }

  QueryBuilder<DownloadTask, DownloadTask, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadTaskQueryProperty
    on QueryBuilder<DownloadTask, DownloadTask, QQueryProperty> {
  QueryBuilder<DownloadTask, int, QQueryOperations> downloadIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadId');
    });
  }

  QueryBuilder<DownloadTask, List<DownloadBlock>, QQueryOperations>
      blocksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blocks');
    });
  }

  QueryBuilder<DownloadTask, String, QQueryOperations> fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<DownloadTask, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<DownloadTask, IsarMapEntity, QQueryOperations>
      headersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headers');
    });
  }

  QueryBuilder<DownloadTask, int, QQueryOperations> maxSplitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSplit');
    });
  }

  QueryBuilder<DownloadTask, String, QQueryOperations>
      outputFilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outputFilePath');
    });
  }

  QueryBuilder<DownloadTask, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<DownloadTask, bool, QQueryOperations>
      showNotificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showNotification');
    });
  }

  QueryBuilder<DownloadTask, DownloadStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DownloadTask, int, QQueryOperations> totalDownloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDownloaded');
    });
  }

  QueryBuilder<DownloadTask, int, QQueryOperations> totalLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalLength');
    });
  }

  QueryBuilder<DownloadTask, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const DownloadBlockSchema = Schema(
  name: r'DownloadBlock',
  id: -5345222825337418332,
  properties: {
    r'currentSplit': PropertySchema(
      id: 0,
      name: r'currentSplit',
      type: IsarType.long,
    ),
    r'downloaded': PropertySchema(
      id: 1,
      name: r'downloaded',
      type: IsarType.long,
    ),
    r'end': PropertySchema(
      id: 2,
      name: r'end',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 3,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.long,
    ),
    r'start': PropertySchema(
      id: 5,
      name: r'start',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 6,
      name: r'status',
      type: IsarType.byte,
      enumMap: _DownloadBlockstatusEnumValueMap,
    )
  },
  estimateSize: _downloadBlockEstimateSize,
  serialize: _downloadBlockSerialize,
  deserialize: _downloadBlockDeserialize,
  deserializeProp: _downloadBlockDeserializeProp,
);

int _downloadBlockEstimateSize(
  DownloadBlock object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _downloadBlockSerialize(
  DownloadBlock object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentSplit);
  writer.writeLong(offsets[1], object.downloaded);
  writer.writeLong(offsets[2], object.end);
  writer.writeLong(offsets[3], object.hashCode);
  writer.writeLong(offsets[4], object.id);
  writer.writeLong(offsets[5], object.start);
  writer.writeByte(offsets[6], object.status.index);
}

DownloadBlock _downloadBlockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadBlock(
    currentSplit: reader.readLongOrNull(offsets[0]) ?? 0,
    downloaded: reader.readLongOrNull(offsets[1]) ?? 0,
    end: reader.readLongOrNull(offsets[2]) ?? 0,
    id: reader.readLongOrNull(offsets[4]) ?? 0,
    start: reader.readLongOrNull(offsets[5]) ?? 0,
    status:
        _DownloadBlockstatusValueEnumMap[reader.readByteOrNull(offsets[6])] ??
            BlockStatus.downloading,
  );
  return object;
}

P _downloadBlockDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (_DownloadBlockstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          BlockStatus.downloading) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DownloadBlockstatusEnumValueMap = {
  'downloading': 0,
  'finished': 1,
  'failed': 2,
};
const _DownloadBlockstatusValueEnumMap = {
  0: BlockStatus.downloading,
  1: BlockStatus.finished,
  2: BlockStatus.failed,
};

extension DownloadBlockQueryFilter
    on QueryBuilder<DownloadBlock, DownloadBlock, QFilterCondition> {
  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      currentSplitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentSplit',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      currentSplitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentSplit',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      currentSplitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentSplit',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      currentSplitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentSplit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      downloadedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      downloadedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      downloadedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      downloadedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloaded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition> endEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      endGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition> endLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition> endBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'end',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      startEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      startGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      startLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      startBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'start',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      statusEqualTo(BlockStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      statusGreaterThan(
    BlockStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      statusLessThan(
    BlockStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadBlock, DownloadBlock, QAfterFilterCondition>
      statusBetween(
    BlockStatus lower,
    BlockStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadBlockQueryObject
    on QueryBuilder<DownloadBlock, DownloadBlock, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const IsarMapEntitySchema = Schema(
  name: r'IsarMapEntity',
  id: 4188544182411953616,
  properties: {
    r'json': PropertySchema(
      id: 0,
      name: r'json',
      type: IsarType.string,
    )
  },
  estimateSize: _isarMapEntityEstimateSize,
  serialize: _isarMapEntitySerialize,
  deserialize: _isarMapEntityDeserialize,
  deserializeProp: _isarMapEntityDeserializeProp,
);

int _isarMapEntityEstimateSize(
  IsarMapEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.json.length * 3;
  return bytesCount;
}

void _isarMapEntitySerialize(
  IsarMapEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.json);
}

IsarMapEntity _isarMapEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarMapEntity();
  object.json = reader.readString(offsets[0]);
  return object;
}

P _isarMapEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarMapEntityQueryFilter
    on QueryBuilder<IsarMapEntity, IsarMapEntity, QFilterCondition> {
  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition> jsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition>
      jsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition>
      jsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition> jsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'json',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition>
      jsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition>
      jsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition>
      jsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition> jsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'json',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition>
      jsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'json',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMapEntity, IsarMapEntity, QAfterFilterCondition>
      jsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'json',
        value: '',
      ));
    });
  }
}

extension IsarMapEntityQueryObject
    on QueryBuilder<IsarMapEntity, IsarMapEntity, QFilterCondition> {}
