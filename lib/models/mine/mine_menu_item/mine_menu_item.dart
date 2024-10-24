import 'package:json_annotation/json_annotation.dart';

part 'mine_menu_item.g.dart';

@JsonSerializable()
class MineMenuItem {
  String? title;
  String? path;
  String? icon;
  bool? display;

  MineMenuItem({
    this.title,
    this.path,
    this.icon,
    this.display,
  });

  factory MineMenuItem.fromJson(Map<String, dynamic> json) {
    return _$MineMenuItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MineMenuItemToJson(this);
}
