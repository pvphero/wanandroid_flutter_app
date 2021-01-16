import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/banner_entity.dart';
import 'package:wanandroid_flutter/entity/common_entity.dart';
import 'package:wanandroid_flutter/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

import 'loginPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerData> bannerData = List();
  List<ArticleDataData> articleDates = List();
  ScrollController _scrollController;
  SwiperController _swiperController;

  int _page = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() {});
    _swiperController = SwiperController();

    getHttp();
  }

  void getHttp() async {
    try {
      //banner
      var bannerResponse = await HttpUtil().get(Api.BANNER);
      Map bannerMap = json.decode(bannerResponse.toString());
      var bannerEntity = BannerEntity.fromJosn(bannerMap);

      //article
      var articleResponse =
          await HttpUtil().get(Api.ARTICLE_LIST + "$_page/json");
      Map articlemap = json.decode(articleResponse.toString());
      var articleEntity = ArticleEntity().fromJson(articlemap);

      setState(() {
        bannerData = bannerEntity.data;
        articleDates = articleEntity.data.datas;
      });
      _swiperController.startAutoplay();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        header: PhoenixHeader(),
        footer: PhoenixFooter(),
        onRefresh: () async {
          await Future.delayed(
              Duration(
                seconds: 1,
              ), () {
            setState(() {
              _page = 0;
            });
            getHttp();
          });
        },
        onLoad: () async {
          await Future.delayed(
              Duration(
                seconds: 1,
              ), () async {
            setState(() {
              _page++;
            });
            getMoreData();
          });
        },
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return getBanner();
              }
              if (index < articleDates.length - 1) {
                return getRow(index);
              }
              return null;
            },
            childCount: articleDates.length + 1,
          )),
        ],
      ),
    );
  }

  void getMoreData() async {
    var response = await HttpUtil().get(Api.ARTICLE_LIST + "$_page/josn");
    Map map = json.decode(response.toString());
    var articleEntity = ArticleEntity().fromJson(map);
    setState(() {
      articleDates.addAll(articleEntity.data.datas);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    super.dispose();
  }

  Widget getBanner() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.8 * 0.8,
      child: Swiper(
        itemCount: bannerData.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(bannerData[index].imagePath),
              fit: BoxFit.fill,
            )),
          );
        },
        loop: false,
        autoplay: false,
        autoplayDelay: 30000,
        //触发时 是否停止播放
        autoplayDisableOnInteraction: true,
        duration: 600,
        //默认的分页按钮
        controller: _swiperController,
        //默认指示器
        pagination: SwiperPagination(
          //SwiperPagination。fraction 数字 1/5,默认点
          builder: DotSwiperPaginationBuilder(size: 6, activeSize: 9),
        ),
        // 视图的宽度，即显示的item的宽度屏占比
        viewportFraction: 0.8,
        //两侧item的缩放比
        scale: 0.9,

        onTap: (int index) {
          print("index-----$index");
        },
      ),
    );
  }

  Widget getRow(int i) {
    //返回一个手势识别的
    return GestureDetector(
      //容器布局
      child: Container(
        //距离边缘 对称  垂直10  水平5
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        //容器的子布局，相当于LinearLayout布局内部 包裹的布局
        child: ListTile(
          //最前部 是个IconButton
          leading: IconButton(
            icon: articleDates[i].collect
                ? Icon(
              Icons.favorite,
              color: Theme
                  .of(context)
                  .primaryColor,
            )
                : Icon(Icons.favorite_border),
            tooltip: '收藏',
            //IconButton的点击事件
            onPressed: () {
              if (articleDates[i].collect) {
                cancelConllect(articleDates[i].id);
              } else {
                addCollect(articleDates[i].id);
              }
            },
          ),
          //title 部分是个TextView
          title: Text(
            //textView应该显示的文字
            articleDates[i].title,
            //最大两行
            maxLines: 2,
            //多余的省略
            overflow: TextOverflow.ellipsis,
          ),
          //副标题
          subtitle: Padding(
            //只距离顶部边缘10
            padding: EdgeInsets.only(top: 10.0),
            //副标题的  child
            child: Row(
              children: <Widget>[
                Container(
                  //水平边缘对称padding 6
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  //盒子装饰  用来实现圆形空心长方框效果
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0), //圆角度
                  ),

                  child: Text(
                    articleDates[i].superChapterName,
                    style: TextStyle(color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                ),
                Container(
                  //只对左边边缘margin
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    articleDates[i].author,
                  ),
                )
              ],
            ),
          ),
          //最后的位置 是个右侧的箭头
          trailing: Icon(Icons.chevron_right),
        ),
      ),

      onTap: () {
        if (0 == 1) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ArticleDetail(
                      title: articleDates[i].title, url: articleDates[i].link)),
        );
      },
    );
  }

  Future cancelConllect(int id) async {
    var collectResponse =
    await HttpUtil().post(Api.UN_COLLECT_ORIGIN_ID + "$id/json");
    Map map = json.decode(collectResponse);
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.show(context: context, msg: "取消成功");
      getHttp();
    }
  }

  Future addCollect(int id) async {
    var collectResponse = await HttpUtil().post(Api.COLLECT + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.show(context: context, msg: "收藏成功");
      getHttp();
    }
  }
}
