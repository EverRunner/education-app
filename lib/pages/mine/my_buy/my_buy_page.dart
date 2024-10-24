import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:yibei_app/api/order.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/user/login_user_info/login_user_info.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/models/user/my_buy_order_data/my_buy_order_data.dart';
import 'package:yibei_app/models/user/my_buy_order_data/my_buy_order_data_row.dart';
import 'package:yibei_app/models/order/create_order/create_order.dart';
import 'package:yibei_app/models/order/pay_callback/pay_callback.dart';

import 'package:yibei_app/api/user.dart';

// const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'subscription_silver';
// const String _kGoldSubscriptionId = 'subscription_gold';
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   _kUpgradeId,
//   _kSilverSubscriptionId,
//   _kGoldSubscriptionId,
// ];

const List<String> _kProductIds = <String>[
  'yb_goods_1',
  'yb_goods_2',
];

class MyBuyPage extends StatefulWidget {
  const MyBuyPage({super.key});

  @override
  State<MyBuyPage> createState() => _MyBuyPageState();
}

class _MyBuyPageState extends State<MyBuyPage> {
  /// 购买列表
  List<MyBuyOrderDataRow> _buyList = [];

  /// 是否为新购
  bool _isBuy = true;

  /// 订单号
  late String _orderCode;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  /// 获取购买列表
  _queryBuyList() async {
    BaseEntity<MyBuyOrderData> entity = await getMyOrderPageList(
      pageIndex: 1,
      pageSize: 100,
      status: 1,
    );
    if (entity.data?.status != true ||
        entity.data?.data == null ||
        entity.data?.data?.rows == null) {
      return;
    }
    setState(() {
      _buyList = entity.data!.data!.rows!;
      _isBuy = entity.data!.data!.rows!.isNotEmpty ? true : false;
    });
  }

  /// 创建订单
  Future<void> _handleCreateBuyOrder() async {
    BaseEntity<CreateOrder> entity;

    if (_isBuy) {
      entity = await createBuyOrder();
    } else {
      entity = await createRenewOrder();
    }

    if (entity.data?.status == true && entity.data!.ordercode != null) {
      _orderCode = entity.data!.ordercode!;
    }
  }

  /// 处理支付回调
  Future<void> _handlePayCallback(BuildContext context) async {
    BaseEntity<PayCallback> entity = await payCallback(orderCode: _orderCode);
    if (entity.data?.status != true) {
      return;
    }
    _queryBuyList();
    _queryLoginUserInfo();
    onShowAlertDialog(
      context: context,
      title: '成功提示',
      detail: const Text('恭喜您，已购买成功了！'),
    );
  }

  /// 获取登录用户的信息
  _queryLoginUserInfo() async {
    BaseEntity<LoginUserInfo> entity = await getLoginUserInfo(
      showLoading: false,
    );
    if (entity.data?.status != true || entity.data?.userInfo == null) {
      return;
    }

    // 获取最新的用户信息，覆盖用户缓存信息
    CacheUtils.instance.set<UserInfo>(
      'userInfo',
      (entity.data!.userInfo!)..studytimeavg = entity.data?.studytimeavg,
    );
  }

  /// 监听苹果服务器的回调
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 等待购买中
      } else {
        EasyLoading.dismiss();
        if (purchaseDetails.status == PurchaseStatus.error) {
          // 购买出错
          onShowAlertDialog(
            context: context,
            title: '错误提示',
            detail: const Text('很抱歉，购买出错，请您稍后重试！'),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // 购买成功
          _handlePayCallback(context);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          // 完成支付流程回调函数（可能是未支付）
          print('完成支付流程');

          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  // 初始化Store信息
  Future<void> initStoreInfo() async {
    // 连接到底层存储，是否在应用中购买
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // 是否为IOS系统
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    // 获取商品是否在苹果服务器上注册了
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.notFoundIDs.isNotEmpty) {
      ToastUtil.shortToast('App Store 初始化错误');
    }

    // 情况1: 查询不到说明没注册
    if (productDetailResponse.error != null) {
      ToastUtil.shortToast('获取商品信息失败');
      return;
    }

    // 情况2: 查询不到商品详情说明没注册
    if (productDetailResponse.productDetails.isEmpty) {
      ToastUtil.shortToast('商品未找到');
      return;
    }

    setState(() {
      _products = productDetailResponse.productDetails;
    });
  }

  /// 处理支付
  void _handlePay() async {
    if (_products.isEmpty) {
      ToastUtil.shortToast('未到相关商品');
      return;
    }

    Navigator.pop(context); // 关闭弹窗

    await _handleCreateBuyOrder();

    EasyLoading.show(
      status: '加载中...',
      maskType: EasyLoadingMaskType.black,
    );

    // 恢复之前的购买
    await InAppPurchase.instance.restorePurchases();

    // 商品详情
    final ProductDetails productDetails = _isBuy ? _products[0] : _products[1];

    // purchaseParam 向苹果服务器发起支付请求时传递的参数，可以设置自定义参数
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    // 类型是不是消耗品
    if (productDetails.id != null) {
      // 向苹果服务器发起支付请求（消耗品）
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      // 向苹果服务器发起支付请求（非消耗品）
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;

    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print('完成了');
      _subscription.cancel();
    }, onError: (Object error) {
      print('发生错误：$error');
    });

    initStoreInfo();

    _queryBuyList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    // level为1时，已经购买过会员了
    _isBuy = userInfo?.level == 1 ? false : true;

    /// 课程状态
    bool courseStatus = false;

    DateTime currentDate = DateTime.now();

    if (userInfo?.endhydate != null &&
        userInfo!.endhydate!.isAfter(currentDate)) {
      courseStatus = true;
    }

    return YbScaffold(
      appBarTitle: ('我的购买'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onShowAlertDialog(
                    context: context,
                    title: _isBuy ? '购买课程' : '续费课程',
                    detail: Column(
                      mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_isBuy
                            ? '如果您想继续学习，请立即前往续费。'
                            : '如果您想开通正式课程，请立即前往购买。'),
                        _isBuy
                            ? const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  '学习时长：105天 \n总价格：\$1558.00 \n支付方式：分为两次支付，每次支付\$779.00',
                                  style: TextStyle(height: 1.5),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  '学习时长：60天 \n价格：\$259.99',
                                  style: TextStyle(height: 1.6),
                                ),
                              ),
                      ],
                    ),
                    actions: [
                      YbButton(
                        text: _isBuy ? '立即购买' : '立即续费',
                        onPressed: () {
                          _handlePay();
                        },
                      ),
                      TextButton(
                        child: const Text('关闭'),
                        onPressed: () {
                          Navigator.pop(context); // 关闭弹窗
                        },
                      ),
                    ]);
              },
              child: Container(
                color: AppColors.colorFBFCFF,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '联邦按摩辅导课程',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.color1A1C1E,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: AppColors.color1A1C1E,
                          size: 18,
                        ),
                      ],
                    ),
                    if (_buyList.length == 0) BuyText(text: '无购买纪录'),
                    if (_buyList.length > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buyList.map((item) {
                            return BuyText(
                                text:
                                    '购买日期：${item.year}年${item.month}月${item.day}日（${item.category == 1 ? "续费" : "第一购买"}）');
                          }),
                          BuyText(
                              text: '课程状态期：${courseStatus ? "学习中" : "已到期"}'),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// 购买文字
class BuyText extends StatelessWidget {
  late String text;

  BuyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.color43474E,
        height: 1.4,
      ),
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
