import 'package:json_annotation/json_annotation.dart';

part 'word_audio.g.dart';

@JsonSerializable()
class WordAudio {
  bool? status;
  String? path;

  WordAudio({this.status, this.path});

  factory WordAudio.fromJson(Map<String, dynamic> json) {
    return _$WordAudioFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WordAudioToJson(this);
}
