import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:dynamics_crm/models/sales_quote_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesQuoteCopyPortrait extends ConsumerStatefulWidget {
  const SalesQuoteCopyPortrait({Key? key, required this.header, required this.detail}) : super(key: key);

  final SalesQuote header;
  final List<SalesQuoteLine> detail;

  @override
  _SalesQuoteCopyPortraitState createState() => _SalesQuoteCopyPortraitState();
}

class _SalesQuoteCopyPortraitState extends ConsumerState<SalesQuoteCopyPortrait> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
