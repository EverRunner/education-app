// 手动生成修改过的 flutter packages pub run build_runner build
// 监视lib目录下的文件变化，自动运行代码生成器 flutter packages pub run build_runner watch

import 'package:yibei_app/models/common/json_convert/json_convert.dart';

class BaseEntity<T> {
  int? code;
  T? data;
  String? message;

  BaseEntity({this.code, this.data, this.message});

  BaseEntity.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) {
      code = json["code"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json['data'] != 'null') {
      data = JsonConvert.fromJsonAsT<T>(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["code"] = code;
    _data["data"] = data;
    _data["message"] = message;
    return _data;
  }
}
