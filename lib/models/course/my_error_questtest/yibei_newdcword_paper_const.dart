import 'package:json_annotation/json_annotation.dart';

import 'yibei_newdcword_paper_const_item.dart';

part 'yibei_newdcword_paper_const.g.dart';

@JsonSerializable()
class YibeiNewdcwordPaperConst {
  int? id;
  int? requestid;
  int? wordsid;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_newdcword_paper_const')
  YibeiNewdcwordPaperConstItem? yibeiNewdcwordPaperConstItem;

  YibeiNewdcwordPaperConst({
    this.id,
    this.requestid,
    this.wordsid,
    this.createdAt,
    this.updatedAt,
    this.yibeiNewdcwordPaperConstItem,
  });

  factory YibeiNewdcwordPaperConst.fromJson(Map<String, dynamic> json) {
    return _$YibeiNewdcwordPaperConstFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiNewdcwordPaperConstToJson(this);
}
