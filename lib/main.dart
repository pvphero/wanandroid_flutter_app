import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  var pages = <Widget>[
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              tooltip: '搜索',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              })
        ],
      ),
      body: PageView.builder(
          onPageChanged: _pageChage,
          controller: _pageController,
          itemCount: pages.length,
          itemBuilder: (BuildContext context, int index) {
            return pages.elementAt(_selectedIndex);
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(YString.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            title: Text(YString.tree),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.low_priority),
            title: Text(YString.navi),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text(YString.project),
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: showToast,
        tooltip: '点击选中最后一个',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: showDrawer(),
    );
  }

  void _pageChage(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          title = YString.appName;
          break;
        case 1:
          title = YString.tree;
          break;
        case 2:
          title = YString.navi;
          break;
        case 3:
          title = YString.project;
          break;
      }
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "选中最后一个",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: YColors.colorPrimary,
        textColor: Colors.white,
        fontSize: 16.0);
    _onItemTapped(3);
  }

  Widget showDrawer() {}
}
