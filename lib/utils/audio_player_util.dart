import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:dio/dio.dart';

/// 音频播放工具类
class AudioPlayerUtil {
  final downloader = Dio();
  final FlutterSoundPlayer _sound = FlutterSoundPlayer();

  // 播放
  Future<void> play(String url) async {
    // // 下载音频文件
    // final response = await downloader.get(url,
    //     options: Options(responseType: ResponseType.bytes));
    // // 转换成字节
    // Uint8List bytes = Uint8List.fromList(response.data);
    // // 播放
    // await _sound.startPlayer(fromDataBuffer: bytes);

    // 打开音频会话
    await _sound.openPlayer();

    // 开始播放
    await _sound.startPlayer(fromURI: url);
  }

  // 暂停播放
  Future<void> pause() async {
    await _sound.pausePlayer();
  }

  // 继续播放
  Future<void> resume() async {
    await _sound.resumePlayer();
  }

  // 停止播放
  Future<void> stop() async {
    await _sound.stopPlayer();
  }

  // 关闭音频会话
  Future<void> close() async {
    await _sound.closePlayer();
  }
}
