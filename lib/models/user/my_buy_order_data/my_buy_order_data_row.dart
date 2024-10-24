import 'package:json_annotation/json_annotation.dart';

part 'my_buy_order_data_row.g.dart';

@JsonSerializable()
class MyBuyOrderDataRow {
  int? id;
  int? memberid;
  int? category;
  int? payfee;
  int? year;
  int? month;
  int? day;
  String? username;
  String? age;
  String? phone;
  String? address;
  int? cardnumber;
  int? safenumber;
  int? endmonth;
  int? endyear;
  String? paychannel;
  String? ordercode;
  String? payip;
  String? payipcity;
  String? navcity;
  String? payjson;
  String? sharecode;
  String? remark;
  int? paycategory;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  MyBuyOrderDataRow({
    this.id,
    this.memberid,
    this.category,
    this.payfee,
    this.year,
    this.month,
    this.day,
    this.username,
    this.age,
    this.phone,
    this.address,
    this.cardnumber,
    this.safenumber,
    this.endmonth,
    this.endyear,
    this.paychannel,
    this.ordercode,
    this.payip,
    this.payipcity,
    this.navcity,
    this.payjson,
    this.sharecode,
    this.remark,
    this.paycategory,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MyBuyOrderDataRow.fromJson(Map<String, dynamic> json) =>
      _$MyBuyOrderDataRowFromJson(json);

  Map<String, dynamic> toJson() => _$MyBuyOrderDataRowToJson(this);
}
