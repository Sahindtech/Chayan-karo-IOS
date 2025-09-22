// lib/models/customer_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'customer_models.g.dart';

@JsonSerializable()
class CustomerResponse {
  final String type;
  final Customer result;

  const CustomerResponse({
    required this.type,
    required this.result,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerResponseToJson(this);
}

@JsonSerializable()
class Customer {
  final String id;
  final String mobileNo;
  final String? emailId;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final double averageRating;
  final String? imgLink;
  final int status;

  const Customer({
    required this.id,
    required this.mobileNo,
    this.emailId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    required this.averageRating,
    this.imgLink,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  // Helper methods
  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((part) => part != null && part.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : '';
  }

  bool get isActive => status == 1;
  
  bool get hasCompleteProfile {
    return firstName != null && lastName != null && emailId != null;
  }

  String get displayName {
    if (fullName.isNotEmpty) return fullName;
    if (firstName != null && firstName!.isNotEmpty) return firstName!;
    return 'User';
  }

  String get statusText {
    switch (status) {
      case 1:
        return 'Active';
      case 0:
        return 'Inactive';
      case 2:
        return 'Suspended';
      default:
        return 'Unknown';
    }
  }

  String get formattedRating => averageRating.toStringAsFixed(1);

  String get profileCompleteness {
    int completed = 0;
    int total = 5;
    
    if (firstName != null && firstName!.isNotEmpty) completed++;
    if (lastName != null && lastName!.isNotEmpty) completed++;
    if (emailId != null && emailId!.isNotEmpty) completed++;
    if (gender != null && gender!.isNotEmpty) completed++;
    if (imgLink != null && imgLink!.isNotEmpty) completed++;
    
    return '${((completed / total) * 100).round()}%';
  }
}
