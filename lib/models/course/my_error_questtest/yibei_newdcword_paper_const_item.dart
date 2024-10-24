import 'package:json_annotation/json_annotation.dart';

part 'yibei_newdcword_paper_const_item.g.dart';

@JsonSerializable()
class YibeiNewdcwordPaperConstItem {
  int? id;
  int? paperid;
  int? sort;
  String? atitle;
  String? btitle;
  String? voicepath;
  DateTime? createdAt;
  DateTime? updatedAt;

  YibeiNewdcwordPaperConstItem({
    this.id,
    this.paperid,
    this.sort,
    this.atitle,
    this.btitle,
    this.voicepath,
    this.createdAt,
    this.updatedAt,
  });

  factory YibeiNewdcwordPaperConstItem.fromJson(Map<String, dynamic> json) {
    return _$YibeiNewdcwordPaperConstItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiNewdcwordPaperConstItemToJson(this);
}
