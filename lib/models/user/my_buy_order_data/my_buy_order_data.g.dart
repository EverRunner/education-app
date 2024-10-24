// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_buy_order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBuyOrderData _$MyBuyOrderDataFromJson(Map<String, dynamic> json) =>
    MyBuyOrderData(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyBuyOrderDataToJson(MyBuyOrderData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
