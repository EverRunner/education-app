import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

class CacheUtils {
  static CacheUtils _instance = CacheUtils._();
  late SharedPreferences _prefs;

  CacheUtils._();

  /// 初始化
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 获取缓存
  T? get<T>(String key) {
    var value = _prefs.get(key);
    if (value == null) {
      return null;
    }
    if (T == bool) {
      return (value as bool) as T;
    }
    if (T == int) {
      return (value as int) as T;
    }
    if (T == double) {
      return (value as double) as T;
    }
    if (T == String) {
      return (value as String) as T;
    }
    if (T == UserInfo) {
      return UserInfo.fromJson(jsonDecode(value as String)) as T;
    }
    return null;
  }

  /// 设置缓存
  Future<bool> set<T>(String key, T value) {
    if (value is bool) {
      return _prefs.setBool(key, value);
    } else if (value is int) {
      return _prefs.setInt(key, value);
    } else if (value is double) {
      return _prefs.setDouble(key, value);
    } else if (value is String) {
      return _prefs.setString(key, value);
    } else if (value is UserInfo) {
      String jsonValue = jsonEncode(value.toJson());
      return _prefs.setString(key, jsonValue);
    }
    return Future.value(false);
  }

  /// 删除缓存
  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  /// 清除所有缓存
  Future<bool> clear() {
    return _prefs.clear();
  }

  /// 单例实例
  static CacheUtils get instance => _instance;
}

// // 保存一个布尔值
// CacheUtils.instance.set<bool>('isLogin', true);

// // 获取布尔值
// bool? isLogin = CacheUtils.instance.get<bool>('isLogin');

// // 删除键名为 isLogin 的缓存数据
// CacheUtils.instance.remove('isLogin');

// // 清空所有缓存数据
// CacheUtils.instance.clear();
