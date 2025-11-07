import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'payment_models.g.dart';

// ============ CREATE ORDER REQUEST ============
@JsonSerializable()
class CreateOrderRequest {
  final double amount;
  final String receipt;

  CreateOrderRequest({
    required this.amount,
    required this.receipt,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

// ============ CREATE ORDER RESPONSE ============
@JsonSerializable()
class CreateOrderResponse {
  final String? type;
  final String? result;

  CreateOrderResponse({
    this.type,
    this.result,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);

  /// Parse the nested result string to get order details
  RazorpayOrderDetails? getOrderDetails() {
    if (result == null || result!.isEmpty) return null;
    
    try {
      final resultJson = jsonDecode(result!);
      return RazorpayOrderDetails.fromJson(resultJson);
    } catch (e) {
      print('Error parsing order details: $e');
      return null;
    }
  }
}

// ============ RAZORPAY ORDER DETAILS ============
@JsonSerializable()
class RazorpayOrderDetails {
  final String? id;
  final String? entity;
  
  @JsonKey(name: 'amount')
  final int? amount;
  
  @JsonKey(name: 'amount_paid')
  final int? amountPaid;
  
  @JsonKey(name: 'amount_due')
  final int? amountDue;
  
  final String? currency;
  final String? receipt;
  
  @JsonKey(name: 'offer_id')
  final String? offerId;
  
  final String? status;
  final int? attempts;
  
  @JsonKey(name: 'created_at')
  final int? createdAt;
  
  final List<dynamic>? notes;

  RazorpayOrderDetails({
    this.id,
    this.entity,
    this.amount,
    this.amountPaid,
    this.amountDue,
    this.currency,
    this.receipt,
    this.offerId,
    this.status,
    this.attempts,
    this.createdAt,
    this.notes,
  });

  factory RazorpayOrderDetails.fromJson(Map<String, dynamic> json) =>
      _$RazorpayOrderDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$RazorpayOrderDetailsToJson(this);
}
