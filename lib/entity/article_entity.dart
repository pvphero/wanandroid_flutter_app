import 'package:wanandroid_flutter/generated/json/base/json_convert_content.dart';

class ArticleEntity with JsonConvert<ArticleEntity> {
  ArticleData data;
  int errorCode;
  String errorMsg;
}

class ArticleData with JsonConvert<ArticleData> {
  int curPage;
  List<ArticleDataData> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;
}

class ArticleDataData with JsonConvert<ArticleDataData> {
  String apkLink;
  int audit;
  String author;
  bool canEdit;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String descMd;
  String envelopePic;
  bool fresh;
  String host;
  int id;
  String link;
  String niceDate;
  String niceShareDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int realSuperChapterId;
  int selfVisible;
  int shareDate;
  String shareUser;
  int superChapterId;
  String superChapterName;
  List<dynamic> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;
}
