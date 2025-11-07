// lib/models/saathi_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'saathi_models.g.dart';

@JsonSerializable()
class SaathiResponse {
  final String type; // e.g., "NameDescription"
  final List<SaathiItem> result;

  SaathiResponse({required this.type, required this.result});

  factory SaathiResponse.fromJson(Map<String, dynamic> json) => _$SaathiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SaathiResponseToJson(this);
}

@JsonSerializable()
class SaathiItem {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double? rating;
  final int? jobsCompleted;

  SaathiItem({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.rating,
    this.jobsCompleted,
  });

  factory SaathiItem.fromJson(Map<String, dynamic> json) => _$SaathiItemFromJson(json);
  Map<String, dynamic> toJson() => _$SaathiItemToJson(this);
}
