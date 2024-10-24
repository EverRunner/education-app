import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'my_buy_order_data.g.dart';

@JsonSerializable()
class MyBuyOrderData {
  bool? status;
  Data? data;

  MyBuyOrderData({this.status, this.data});

  factory MyBuyOrderData.fromJson(Map<String, dynamic> json) {
    return _$MyBuyOrderDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MyBuyOrderDataToJson(this);
}
