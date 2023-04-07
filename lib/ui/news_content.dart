import 'package:flutter/material.dart';

import '../models/attachment_news.dart';
import '../models/blog.dart';

class NewsContent extends StatefulWidget {
  const NewsContent({Key? key, required this.content, required this.attachment}) : super(key: key);

  final Blog content;
  final AttachmentNews attachment;

  @override
  State<NewsContent> createState() => _NewsContentState();
}

class _NewsContentState extends State<NewsContent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
