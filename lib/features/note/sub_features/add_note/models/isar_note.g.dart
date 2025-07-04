// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'isar_note.dart';

// // **************************************************************************
// // IsarCollectionGenerator
// // **************************************************************************

// // coverage:ignore-file
// // ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

// extension GetIsarNoteCollection on Isar {
//   IsarCollection<IsarNote> get isarNotes => this.collection();
// }

// const IsarNoteSchema = CollectionSchema(
//   name: r'IsarNote',
//   id: -6588628299822617142,
//   properties: {
//     r'colorValue': PropertySchema(
//       id: 0,
//       name: r'colorValue',
//       type: IsarType.long,
//     ),
//     r'content': PropertySchema(
//       id: 1,
//       name: r'content',
//       type: IsarType.string,
//     ),
//     r'createdAt': PropertySchema(
//       id: 2,
//       name: r'createdAt',
//       type: IsarType.dateTime,
//     ),
//     r'isHidden': PropertySchema(
//       id: 3,
//       name: r'isHidden',
//       type: IsarType.bool,
//     ),
//     r'isPin': PropertySchema(
//       id: 4,
//       name: r'isPin',
//       type: IsarType.bool,
//     ),
//     r'pendingSync': PropertySchema(
//       id: 5,
//       name: r'pendingSync',
//       type: IsarType.bool,
//     ),
//     r'tags': PropertySchema(
//       id: 6,
//       name: r'tags',
//       type: IsarType.stringList,
//     ),
//     r'title': PropertySchema(
//       id: 7,
//       name: r'title',
//       type: IsarType.string,
//     ),
//     r'updatedAt': PropertySchema(
//       id: 8,
//       name: r'updatedAt',
//       type: IsarType.dateTime,
//     )
//   },
//   estimateSize: _isarNoteEstimateSize,
//   serialize: _isarNoteSerialize,
//   deserialize: _isarNoteDeserialize,
//   deserializeProp: _isarNoteDeserializeProp,
//   idName: r'id',
//   indexes: {},
//   links: {},
//   embeddedSchemas: {},
//   getId: _isarNoteGetId,
//   getLinks: _isarNoteGetLinks,
//   attach: _isarNoteAttach,
//   version: '3.1.0+1',
// );

// int _isarNoteEstimateSize(
//   IsarNote object,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   var bytesCount = offsets.last;
//   bytesCount += 3 + object.content.length * 3;
//   bytesCount += 3 + object.tags.length * 3;
//   {
//     for (var i = 0; i < object.tags.length; i++) {
//       final value = object.tags[i];
//       bytesCount += value.length * 3;
//     }
//   }
//   bytesCount += 3 + object.title.length * 3;
//   return bytesCount;
// }

// void _isarNoteSerialize(
//   IsarNote object,
//   IsarWriter writer,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   writer.writeLong(offsets[0], object.colorValue);
//   writer.writeString(offsets[1], object.content);
//   writer.writeDateTime(offsets[2], object.createdAt);
//   writer.writeBool(offsets[3], object.isHidden);
//   writer.writeBool(offsets[4], object.isPin);
//   writer.writeBool(offsets[5], object.pendingSync);
//   writer.writeStringList(offsets[6], object.tags);
//   writer.writeString(offsets[7], object.title);
//   writer.writeDateTime(offsets[8], object.updatedAt);
// }

// IsarNote _isarNoteDeserialize(
//   Id id,
//   IsarReader reader,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   final object = IsarNote();
//   object.colorValue = reader.readLongOrNull(offsets[0]);
//   object.content = reader.readString(offsets[1]);
//   object.createdAt = reader.readDateTime(offsets[2]);
//   object.id = id;
//   object.isHidden = reader.readBoolOrNull(offsets[3]);
//   object.isPin = reader.readBool(offsets[4]);
//   object.pendingSync = reader.readBool(offsets[5]);
//   object.tags = reader.readStringList(offsets[6]) ?? [];
//   object.title = reader.readString(offsets[7]);
//   object.updatedAt = reader.readDateTimeOrNull(offsets[8]);
//   return object;
// }

// P _isarNoteDeserializeProp<P>(
//   IsarReader reader,
//   int propertyId,
//   int offset,
//   Map<Type, List<int>> allOffsets,
// ) {
//   switch (propertyId) {
//     case 0:
//       return (reader.readLongOrNull(offset)) as P;
//     case 1:
//       return (reader.readString(offset)) as P;
//     case 2:
//       return (reader.readDateTime(offset)) as P;
//     case 3:
//       return (reader.readBoolOrNull(offset)) as P;
//     case 4:
//       return (reader.readBool(offset)) as P;
//     case 5:
//       return (reader.readBool(offset)) as P;
//     case 6:
//       return (reader.readStringList(offset) ?? []) as P;
//     case 7:
//       return (reader.readString(offset)) as P;
//     case 8:
//       return (reader.readDateTimeOrNull(offset)) as P;
//     default:
//       throw IsarError('Unknown property with id $propertyId');
//   }
// }

// Id _isarNoteGetId(IsarNote object) {
//   return object.id;
// }

// List<IsarLinkBase<dynamic>> _isarNoteGetLinks(IsarNote object) {
//   return [];
// }

// void _isarNoteAttach(IsarCollection<dynamic> col, Id id, IsarNote object) {
//   object.id = id;
// }

// extension IsarNoteQueryWhereSort on QueryBuilder<IsarNote, IsarNote, QWhere> {
//   QueryBuilder<IsarNote, IsarNote, QAfterWhere> anyId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(const IdWhereClause.any());
//     });
//   }
// }

// extension IsarNoteQueryWhere on QueryBuilder<IsarNote, IsarNote, QWhereClause> {
//   QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idEqualTo(Id id) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: id,
//         upper: id,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idNotEqualTo(Id id) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             )
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             );
//       } else {
//         return query
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             )
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             );
//       }
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idGreaterThan(Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.greaterThan(lower: id, includeLower: include),
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idLessThan(Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.lessThan(upper: id, includeUpper: include),
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterWhereClause> idBetween(
//     Id lowerId,
//     Id upperId, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: lowerId,
//         includeLower: includeLower,
//         upper: upperId,
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension IsarNoteQueryFilter
//     on QueryBuilder<IsarNote, IsarNote, QFilterCondition> {
//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorValueIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNull(
//         property: r'colorValue',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition>
//       colorValueIsNotNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNotNull(
//         property: r'colorValue',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorValueEqualTo(
//       int? value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'colorValue',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorValueGreaterThan(
//     int? value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'colorValue',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorValueLessThan(
//     int? value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'colorValue',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> colorValueBetween(
//     int? lower,
//     int? upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'colorValue',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'content',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'content',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'content',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'content',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'content',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'content',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentContains(
//       String value,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'content',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentMatches(
//       String pattern,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'content',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'content',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> contentIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'content',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtEqualTo(
//       DateTime value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'createdAt',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtGreaterThan(
//     DateTime value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'createdAt',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtLessThan(
//     DateTime value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'createdAt',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> createdAtBetween(
//     DateTime lower,
//     DateTime upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'createdAt',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idEqualTo(Id value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idGreaterThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idLessThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> idBetween(
//     Id lower,
//     Id upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'id',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> isHiddenIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNull(
//         property: r'isHidden',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> isHiddenIsNotNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNotNull(
//         property: r'isHidden',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> isHiddenEqualTo(
//       bool? value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'isHidden',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> isPinEqualTo(
//       bool value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'isPin',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> pendingSyncEqualTo(
//       bool value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'pendingSync',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'tags',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition>
//       tagsElementGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'tags',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'tags',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'tags',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'tags',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'tags',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementContains(
//       String value,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'tags',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementMatches(
//       String pattern,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'tags',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsElementIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'tags',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition>
//       tagsElementIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'tags',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsLengthEqualTo(
//       int length) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'tags',
//         length,
//         true,
//         length,
//         true,
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'tags',
//         0,
//         true,
//         0,
//         true,
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'tags',
//         0,
//         false,
//         999999,
//         true,
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsLengthLessThan(
//     int length, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'tags',
//         0,
//         true,
//         length,
//         include,
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsLengthGreaterThan(
//     int length, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'tags',
//         length,
//         include,
//         999999,
//         true,
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> tagsLengthBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'tags',
//         lower,
//         includeLower,
//         upper,
//         includeUpper,
//       );
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'title',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleContains(
//       String value,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleMatches(
//       String pattern,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'title',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'title',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> titleIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'title',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNull(
//         property: r'updatedAt',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtIsNotNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNotNull(
//         property: r'updatedAt',
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtEqualTo(
//       DateTime? value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'updatedAt',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtGreaterThan(
//     DateTime? value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'updatedAt',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtLessThan(
//     DateTime? value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'updatedAt',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterFilterCondition> updatedAtBetween(
//     DateTime? lower,
//     DateTime? upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'updatedAt',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension IsarNoteQueryObject
//     on QueryBuilder<IsarNote, IsarNote, QFilterCondition> {}

// extension IsarNoteQueryLinks
//     on QueryBuilder<IsarNote, IsarNote, QFilterCondition> {}

// extension IsarNoteQuerySortBy on QueryBuilder<IsarNote, IsarNote, QSortBy> {
//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByColorValue() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'colorValue', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByColorValueDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'colorValue', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByContent() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'content', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByContentDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'content', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByCreatedAt() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'createdAt', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByCreatedAtDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'createdAt', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByIsHidden() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isHidden', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByIsHiddenDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isHidden', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByIsPin() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isPin', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByIsPinDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isPin', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByPendingSync() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'pendingSync', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByPendingSyncDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'pendingSync', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByTitle() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByTitleDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByUpdatedAt() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'updatedAt', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> sortByUpdatedAtDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'updatedAt', Sort.desc);
//     });
//   }
// }

// extension IsarNoteQuerySortThenBy
//     on QueryBuilder<IsarNote, IsarNote, QSortThenBy> {
//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByColorValue() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'colorValue', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByColorValueDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'colorValue', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByContent() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'content', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByContentDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'content', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByCreatedAt() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'createdAt', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByCreatedAtDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'createdAt', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenById() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIsHidden() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isHidden', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIsHiddenDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isHidden', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIsPin() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isPin', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByIsPinDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isPin', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByPendingSync() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'pendingSync', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByPendingSyncDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'pendingSync', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByTitle() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByTitleDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.desc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByUpdatedAt() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'updatedAt', Sort.asc);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QAfterSortBy> thenByUpdatedAtDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'updatedAt', Sort.desc);
//     });
//   }
// }

// extension IsarNoteQueryWhereDistinct
//     on QueryBuilder<IsarNote, IsarNote, QDistinct> {
//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByColorValue() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'colorValue');
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByContent(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByCreatedAt() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'createdAt');
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByIsHidden() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'isHidden');
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByIsPin() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'isPin');
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByPendingSync() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'pendingSync');
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByTags() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'tags');
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByTitle(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<IsarNote, IsarNote, QDistinct> distinctByUpdatedAt() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'updatedAt');
//     });
//   }
// }

// extension IsarNoteQueryProperty
//     on QueryBuilder<IsarNote, IsarNote, QQueryProperty> {
//   QueryBuilder<IsarNote, int, QQueryOperations> idProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'id');
//     });
//   }

//   QueryBuilder<IsarNote, int?, QQueryOperations> colorValueProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'colorValue');
//     });
//   }

//   QueryBuilder<IsarNote, String, QQueryOperations> contentProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'content');
//     });
//   }

//   QueryBuilder<IsarNote, DateTime, QQueryOperations> createdAtProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'createdAt');
//     });
//   }

//   QueryBuilder<IsarNote, bool?, QQueryOperations> isHiddenProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'isHidden');
//     });
//   }

//   QueryBuilder<IsarNote, bool, QQueryOperations> isPinProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'isPin');
//     });
//   }

//   QueryBuilder<IsarNote, bool, QQueryOperations> pendingSyncProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'pendingSync');
//     });
//   }

//   QueryBuilder<IsarNote, List<String>, QQueryOperations> tagsProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'tags');
//     });
//   }

//   QueryBuilder<IsarNote, String, QQueryOperations> titleProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'title');
//     });
//   }

//   QueryBuilder<IsarNote, DateTime?, QQueryOperations> updatedAtProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'updatedAt');
//     });
//   }
// }
