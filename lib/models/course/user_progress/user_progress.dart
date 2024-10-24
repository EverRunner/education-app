import 'package:json_annotation/json_annotation.dart';

import 'progress.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress {
  bool? status;
  bool? isprogress;
  Progress? progress;

  UserProgress({this.status, this.isprogress, this.progress});

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return _$UserProgressFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserProgressToJson(this);
}
