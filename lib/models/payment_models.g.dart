// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      amount: (json['amount'] as num).toDouble(),
      receipt: json['receipt'] as String,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{'amount': instance.amount, 'receipt': instance.receipt};

CreateOrderResponse _$CreateOrderResponseFromJson(Map<String, dynamic> json) =>
    CreateOrderResponse(
      type: json['type'] as String?,
      result: json['result'] as String?,
    );

Map<String, dynamic> _$CreateOrderResponseToJson(
  CreateOrderResponse instance,
) => <String, dynamic>{'type': instance.type, 'result': instance.result};

RazorpayOrderDetails _$RazorpayOrderDetailsFromJson(
  Map<String, dynamic> json,
) => RazorpayOrderDetails(
  id: json['id'] as String?,
  entity: json['entity'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
  amountPaid: (json['amount_paid'] as num?)?.toInt(),
  amountDue: (json['amount_due'] as num?)?.toInt(),
  currency: json['currency'] as String?,
  receipt: json['receipt'] as String?,
  offerId: json['offer_id'] as String?,
  status: json['status'] as String?,
  attempts: (json['attempts'] as num?)?.toInt(),
  createdAt: (json['created_at'] as num?)?.toInt(),
  notes: json['notes'] as List<dynamic>?,
);

Map<String, dynamic> _$RazorpayOrderDetailsToJson(
  RazorpayOrderDetails instance,
) => <String, dynamic>{
  'id': instance.id,
  'entity': instance.entity,
  'amount': instance.amount,
  'amount_paid': instance.amountPaid,
  'amount_due': instance.amountDue,
  'currency': instance.currency,
  'receipt': instance.receipt,
  'offer_id': instance.offerId,
  'status': instance.status,
  'attempts': instance.attempts,
  'created_at': instance.createdAt,
  'notes': instance.notes,
};
