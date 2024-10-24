import 'package:json_annotation/json_annotation.dart';

part 'create_order.g.dart';

@JsonSerializable()
class CreateOrder {
	bool? status;
	String? ordercode;

	CreateOrder({this.status, this.ordercode});

	factory CreateOrder.fromJson(Map<String, dynamic> json) {
		return _$CreateOrderFromJson(json);
	}

	Map<String, dynamic> toJson() => _$CreateOrderToJson(this);
}
