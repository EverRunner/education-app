import 'package:json_annotation/json_annotation.dart';

part 'pay_callback.g.dart';

@JsonSerializable()
class PayCallback {
	bool? status;
	int? payCount;

	PayCallback({this.status, this.payCount});

	factory PayCallback.fromJson(Map<String, dynamic> json) {
		return _$PayCallbackFromJson(json);
	}

	Map<String, dynamic> toJson() => _$PayCallbackToJson(this);
}
