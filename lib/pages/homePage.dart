import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/banner_entity.dart';
import 'package:wanandroid_flutter/httpUtil.dart';

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
          await Future.delayed(Duration(
            seconds: 1,
          ),
                  () {
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
              ),
                  () async {
                setState(() {
                  _page++;
                });
                getMoreData();
              }
          );
        },

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
}
