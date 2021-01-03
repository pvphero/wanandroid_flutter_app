import 'package:flutter/material.dart';
import 'package:wanandroid_flutter_app/util/favoriteProvide.dart';
import 'package:wanandroid_flutter_app/util/themeProvide.dart';

void main() async {
  //runApp前调用，初始化 绑定 手势 渲染 服务等
  WidgetsFlutterBinding.ensureInitialized();

  //初始化
  var theme = ThemeProvide();
  var favorite = FavoriteProvide();
}
