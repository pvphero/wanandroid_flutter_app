import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/pages/homePage.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/res/strings.dart';
import 'package:wanandroid_flutter/util/favoriteProvide.dart';
import 'package:wanandroid_flutter/util/themeProvide.dart';

void main() async {
  //runApp前调用，初始化 绑定 手势 渲染 服务等
  WidgetsFlutterBinding.ensureInitialized();

  //初始化
  var theme = ThemeProvide();
  var favorite = FavoriteProvide();
  var providers = Providers();

  //.. 相当于  Providers providers= Providers();
  //          providers.provide(...);
  //          providers.provide(...);
  providers
    ..provide(Provider.function((context) => theme))
    ..provide(Provider.function((context) => favorite));

  int themeIndex = await getTheme();

  runApp(ProviderNode(
    child: MyApp(themeIndex),
    providers: providers,
  ));
}

Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int themeIndex = sp.getInt("themeIndex");
  return null == themeIndex ? 0 : themeIndex;
}

/*
快捷键  stl
 */
class MyApp extends StatelessWidget {
  final int themeIndex;

  MyApp(this.themeIndex);

  @override
  Widget build(BuildContext context) {
    return Provide<ThemeProvide>(builder: (context, child, theme) {
      return MaterialApp(
        title: YString.appName,
        //除了primaryColor，还有brightness，iconTheme，textTheme等等可以设置
        theme: ThemeData(
            primaryColor: YColors
                    .themeColor[theme.value != null ? theme.value : themeIndex]
                ["primaryColor"],
            primaryColorDark: YColors
                    .themeColor[theme.value != null ? theme.value : themeIndex]
                ["primaryColorDark"],
            accentColor: YColors
                    .themeColor[theme.value != null ? theme.value : themeIndex]
                ["colorAccent"]
//              primaryColor: YColors.colorPrimary,
//              primaryColorDark: YColors.colorPrimaryDark,
//              accentColor: YColors.colorAccent,
//              dividerColor: YColors.dividerColor,
            ),
        home: MyHomePage(title: YString.appName),
      );
    });
  }
}

/**
 * 快捷键 stful
 */
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String title = YString.appName;

  var _pageController = PageController(initialPage: 0);

  var page = <Widget>[
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
