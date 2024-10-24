import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
import 'package:yibei_app/config/config.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/provider/notifier_provider.dart';

class HttpUtil {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: Config.base_url, // 基础路径
      connectTimeout: Config.connect_timeout, // 连接超时时间
      receiveTimeout: Config.receive_timeout, // 响应超时时间
    ),
  );

  // 私有化构造函数，防止实例化
  HttpUtil._();

  /// 拦截器
  static void addInterceptors() {
    // 请求拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 在请求发出之前对请求做一些处理

        // 判断请求是否需要加载 loading
        bool showLoading = options.extra['showLoading'] ?? true;
        if (showLoading) {
          EasyLoading.show(
            status: '加载中...',
            maskType: EasyLoadingMaskType.black,
          );
        }

        // 获取 token
        String? token = CacheUtils.instance.get<String>('token');
        String? cookie = CacheUtils.instance.get<String>('cookie');

        // 设置请求头 token
        if (token != null) {
          options.headers['token'] = token;
        }

        // 设置请求头 cookie
        if (cookie != null) {
          options.headers['cookie'] = cookie;
        }

        return handler.next(options);
      },
      onError: (error, handler) {
        // 当请求失败时做一些预处理
        EasyLoading.dismiss();
        return handler.next(error);
      },
    ));

    // 响应拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        // 在请求响应后对响应做一些处理

        // 关闭loading
        EasyLoading.dismiss();

        // 获取响应中的 Set-Cookie 字段
        final List<String>? setCookie = response.headers['set-cookie'];

        // 将 Set-Cookie 中的内容保存为 Cookie
        if (setCookie != null && setCookie.isNotEmpty) {
          // 保存 Cookie 的字符串
          CacheUtils.instance
              .set<String>('cookie', setCookie[0].split(';').first);
        }

        // 状态
        switch (response.statusCode) {
          case 200:
            if (response.data['data']['status'] == false &&
                response.data['data']?['err'] != null) {
              ToastUtil.shortToast(
                response.data['data']['err'] ?? "出错了，请稍后重试",
              );
            }
            return handler.next(response);
          case 401:
            // 跳转到登录页面
            jumpPageProvider.value = 3;
            return;
          default:
            ToastUtil.shortToast("网络出错，请稍后重试");
        }
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // 跳转到登录页面
          jumpPageProvider.value = 3;
        } else {
          EasyLoading.dismiss();
          ToastUtil.shortToast(
            "网络出错，请稍后重试",
          );
          return handler.next(error);
        }
      },
    ));

    // 日志打印
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  /// GET 请求
  static Future<BaseEntity<T>> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    try {
      Response response = await dio.get(
        path,
        queryParameters: params,
        options: options,
      );
      BaseEntity<T> entity = BaseEntity<T>.fromJson(
        response.data,
      );
      return Future.value(entity);
    } on DioError catch (e) {
      EasyLoading.dismiss();
      throw e;
    }
  }

  /// POST 请求
  static Future<BaseEntity<T>> post<T>(
    String path, {
    Map<String, dynamic>? params,
    dynamic? data,
    Options? options,
  }) async {
    try {
      Response response = await dio.post(
        path,
        queryParameters: params,
        data: data,
        options: options,
      );
      BaseEntity<T> entity = BaseEntity<T>.fromJson(
        response.data,
      );
      return Future.value(entity);
    } on DioError catch (e) {
      EasyLoading.dismiss();
      throw e;
    }
  }

  /// 上传文件
  static Future<BaseEntity<T>> uploadFile<T>(
    String path, {
    required String filePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      Response response = await dio.post(
        path,
        data: formData,
      );
      BaseEntity<T> entity = BaseEntity<T>.fromJson(
        response.data,
      );
      return Future.value(entity);
    } catch (e) {
      EasyLoading.dismiss();
      throw e;
    }
  }
}
