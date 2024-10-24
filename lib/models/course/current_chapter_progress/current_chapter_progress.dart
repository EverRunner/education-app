import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'current_chapter_progress.g.dart';

@JsonSerializable()
class CurrentChapterProgress {
  bool? status;
  Data? data;

  CurrentChapterProgress({this.status, this.data});

  factory CurrentChapterProgress.fromJson(Map<String, dynamic> json) {
    return _$CurrentChapterProgressFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CurrentChapterProgressToJson(this);
}
