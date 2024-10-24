import 'dart:convert';
import 'package:yibei_app/utils/http/http.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/order/create_order/create_order.dart';
import 'package:yibei_app/models/order/pay_callback/pay_callback.dart';

// 订单
const String order = '/order';

/// 创建购买订单
Future<BaseEntity<CreateOrder>> createBuyOrder() async {
  dynamic entity = await HttpUtil.post<CreateOrder>(
    '$order/createpayinapppurchase',
  );
  return Future.value(entity);
}

/// 创建续费订单
Future<BaseEntity<CreateOrder>> createRenewOrder() async {
  dynamic entity = await HttpUtil.post<CreateOrder>(
    '$order/createxfpayinapppurchase',
  );
  return Future.value(entity);
}

/// 订单 - 支付回调
Future<BaseEntity<PayCallback>> payCallback({
  required String orderCode,
}) async {
  Map<String, dynamic> map = Map();
  map['ordercode'] = orderCode;

  dynamic entity = await HttpUtil.post<PayCallback>(
    '$order/inapppurchasewebhook',
    data: map,
  );
  return Future.value(entity);
}
