// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saathi_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaathiResponse _$SaathiResponseFromJson(Map<String, dynamic> json) =>
    SaathiResponse(
      type: json['type'] as String,
      result: (json['result'] as List<dynamic>)
          .map((e) => SaathiItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SaathiResponseToJson(SaathiResponse instance) =>
    <String, dynamic>{'type': instance.type, 'result': instance.result};

SaathiItem _$SaathiItemFromJson(Map<String, dynamic> json) => SaathiItem(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  jobsCompleted: (json['jobsCompleted'] as num?)?.toInt(),
);

Map<String, dynamic> _$SaathiItemToJson(SaathiItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'jobsCompleted': instance.jobsCompleted,
    };
