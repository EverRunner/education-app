class VerifyUtil {
  // 正则表达式验证邮箱
  static bool isEmailValid(String email) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp emailRegExp = RegExp(emailRegex);
    return emailRegExp.hasMatch(email);
  }

  // 正则表达式验证手机号
  static bool isPhoneValid(String phone) {
    String phoneRegex = r'^[0-9]{10}$';
    RegExp phoneRegExp = RegExp(phoneRegex);
    return phoneRegExp.hasMatch(phone);
  }

  /// 验证密码（6到15位）
  /// [value] 内容
  static bool passwordValidation({
    required String value,
  }) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9_-]{6,15}$');
    return regExp.hasMatch(value);
  }
}
