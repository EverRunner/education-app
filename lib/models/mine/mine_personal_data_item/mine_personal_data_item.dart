import 'package:json_annotation/json_annotation.dart';

part 'mine_personal_data_item.g.dart';

@JsonSerializable()
class MinePersonalDataItem {
  String? title;
  String? value;
  String? path;

  MinePersonalDataItem({this.title, this.value, this.path});

  factory MinePersonalDataItem.fromJson(Map<String, dynamic> json) {
    return _$MinePersonalDataItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MinePersonalDataItemToJson(this);
}
