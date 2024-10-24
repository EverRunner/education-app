import 'package:json_annotation/json_annotation.dart';

part 'common_return_states.g.dart';

@JsonSerializable()
class CommonReturnStates {
  bool? status;
  String? err;

  CommonReturnStates({this.status, this.err});

  factory CommonReturnStates.fromJson(Map<String, dynamic> json) {
    return _$CommonReturnStatesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CommonReturnStatesToJson(this);
}
