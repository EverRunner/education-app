// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_buy_order_data_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBuyOrderDataRow _$MyBuyOrderDataRowFromJson(Map<String, dynamic> json) =>
    MyBuyOrderDataRow(
      id: json['id'] as int?,
      memberid: json['memberid'] as int?,
      category: json['category'] as int?,
      payfee: json['payfee'] as int?,
      year: json['year'] as int?,
      month: json['month'] as int?,
      day: json['day'] as int?,
      username: json['username'] as String?,
      age: json['age'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      cardnumber: json['cardnumber'] as int?,
      safenumber: json['safenumber'] as int?,
      endmonth: json['endmonth'] as int?,
      endyear: json['endyear'] as int?,
      paychannel: json['paychannel'] as String?,
      ordercode: json['ordercode'] as String?,
      payip: json['payip'] as String?,
      payipcity: json['payipcity'] as String?,
      navcity: json['navcity'] as String?,
      payjson: json['payjson'] as String?,
      sharecode: json['sharecode'] as String?,
      remark: json['remark'] as String?,
      paycategory: json['paycategory'] as int?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MyBuyOrderDataRowToJson(MyBuyOrderDataRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberid': instance.memberid,
      'category': instance.category,
      'payfee': instance.payfee,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'username': instance.username,
      'age': instance.age,
      'phone': instance.phone,
      'address': instance.address,
      'cardnumber': instance.cardnumber,
      'safenumber': instance.safenumber,
      'endmonth': instance.endmonth,
      'endyear': instance.endyear,
      'paychannel': instance.paychannel,
      'ordercode': instance.ordercode,
      'payip': instance.payip,
      'payipcity': instance.payipcity,
      'navcity': instance.navcity,
      'payjson': instance.payjson,
      'sharecode': instance.sharecode,
      'remark': instance.remark,
      'paycategory': instance.paycategory,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
