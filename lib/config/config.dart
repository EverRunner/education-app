class Config {
  // app名字
  static const String app_name = '易北教育';

  // API地址
  static late final String base_url;

  // 启用调试
  static late final bool debug_enabled;

  // 文件的根目录
  static late final String file_root;

  // 连接超时时间 60秒
  static const Duration connect_timeout = Duration(seconds: 60);

  // 响应超时时间 60秒
  static const Duration receive_timeout = Duration(seconds: 60);

  // vimeo的Access Tokens 设置地址https://developer.vimeo.com/
  static const String vimeo_access_token = '38daf74faab07c87f6ee813cdb0e4777';

  // 分页条数
  static const int page_size = 16;

  // 章节学习步骤
  static const Map<String, String> study_chapter_step = {
    "-1": "未开始",
    "0": "步骤1 视频课程",
    "1": "步骤2 中英文关键词卡",
    "2": "步骤4 英文关键词卡",
    "3": "步骤6 章节测试",
    "4": "已完成此章节",
    "5": "步骤3 中英文关键词测试",
    "6": "步骤5 英文关键词测试",
  };

// 用户详情，学习进度记录类型
  static const Map<int, String> study_type = {
    0: "章节测试",
    1: "关键词测试（中英）",
    2: "关键词测试（英）",
    3: "章节测试前（关键词）",
    4: "我的错题测试",
    5: "综合模拟测试",
    6: "高频模拟测试",
    7: "我的错题测前（关键词）",
    8: "综合模拟测前（关键词）",
    9: "高频模拟测前（关键词）",
    10: "应变测试前（关键词）",
    11: "应变测试",
  };

  // 综合测试、错误测试的随机题数
  static const int ERROR_RANDOM_TOPIC = 100;
}
