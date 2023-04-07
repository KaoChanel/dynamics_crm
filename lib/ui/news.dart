import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/ui/news_content.dart';
import 'package:flutter/material.dart';

import '../models/blog.dart';
import '../services/api_service.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool isLoading = true;
  late Orientation isPortrait;
  double width = 0;
  // List<FileAttachNews> attachs;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Orientation isPortrait = MediaQuery.of(context).orientation;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {

        });
      },
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: ApiService().getNews(),
            builder: (BuildContext context, AsyncSnapshot snapShot) {
              if (snapShot.hasData) {
                return allNews(snapShot.data);
              }
              else {
                return Expanded(
                  child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator())
                  ),
                );
              }
            }
        ),
      ),
    );
  }

  Widget allNews(List<Blog> dataList) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Wrap(
        runSpacing: 15.0,
        children: dataList.map((e) {
          // List<FileAttachNews> attachments = globals.attachNews.where((x) => x.newsId == e.newsId && x.useType == 'COVER').toList();
          // String url = attachments.firstWhere((x) => x.newsId == e.newsId && x.useType == 'COVER', orElse: () => null).url ?? '/images/bis.jpg';

          String url = '';

          return InkWell(
            onTap: () async {
              // await Navigator.push(context, MaterialPageRoute(builder: (context) => NewsContent(content: e, attachment: attachments)));
              setState(() {

              });
            },
            child: Container(
              width: isPortrait == Orientation.portrait ? width : width / 2.2, height: 280,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network('$NEWS_API$url', width: isPortrait == Orientation.portrait ? width : width / 1.5, height: 180, fit: BoxFit.cover,),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'เขียนเมื่อ ${e.createDate != null ? DATE_FORMAT_TH.formatInBuddhistCalendarThai(e.createDate!) : ''}',
                                style: const TextStyle(color: Colors.black45, fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: Text(
                            e.title ?? '',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        ).toList(),
      ),
    );
  }
}
