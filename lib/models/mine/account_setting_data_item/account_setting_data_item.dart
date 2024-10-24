import 'package:json_annotation/json_annotation.dart';

part 'account_setting_data_item.g.dart';

@JsonSerializable()
class AccountSettingDataItem {
  String? title;
  String? value;
  String? path;
  bool? showIcon;

  AccountSettingDataItem({this.title, this.value, this.path, this.showIcon});

  factory AccountSettingDataItem.fromJson(Map<String, dynamic> json) {
    return _$AccountSettingDataItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AccountSettingDataItemToJson(this);
}
