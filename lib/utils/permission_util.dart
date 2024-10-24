import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// 申请定位权限
/// 授予定位权限返回true， 否则返回false
Future<bool> requestLocationPermission() async {
  //获取当前的权限
  var status = await Permission.location.status;

  if (status.isDenied) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
  }
  if (!status.isGranted) {
    status = await Permission.location.status;
  }
  print('当前定位权限：${status.isGranted}');
  return status.isGranted;

  if (status == PermissionStatus.granted) {
    //已经授权
    return Future.value(true);
  } else {
    //未授权则发起一次申请
    var status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}

/// 申请存本地相册权限
Future<bool> getPhotoPormiation() async {
  if (Platform.isIOS) {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
      ].request();
    }
    if (!status.isGranted) {
      status = await Permission.photos.status;
    }
    return status.isGranted;
  } else {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
    if (!status.isGranted) {
      status = await Permission.storage.status;
    }
    return status.isGranted;
  }
}

/// 申请相机权限
Future<bool> getCameraPormiation() async {
  if (Platform.isIOS) {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
      ].request();
    }
    if (!status.isGranted) {
      status = await Permission.photos.status;
    }
    return status.isGranted;
  } else {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
    }
    if (!status.isGranted) {
      status = await Permission.camera.status;
    }
    return status.isGranted;
  }
}

/// 申请打电话权限
Future<bool> getCallPormiation() async {
  if (Platform.isAndroid) {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.phone,
      ].request();
    }
    if (!status.isGranted) {
      status = await Permission.phone.status;
    }
    return status.isGranted;
  }
  return true;
}

/// 通知权限
Future<bool> getNotificationPormiation() async {
  var status = await Permission.notification.status;
  if (status.isDenied) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();
  }
  return status.isGranted;
}

//申请麦克风权限
Future<bool> getMicrophonePormiation() async {
  if (Platform.isIOS) {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
      ].request();
    }
    if (!status.isGranted) {
      status = await Permission.microphone.status;
    }
    return status.isGranted;
  } else {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
      ].request();
    }
    if (!status.isGranted) {
      status = await Permission.microphone.status;
    }
    return status.isGranted;
  }
}
