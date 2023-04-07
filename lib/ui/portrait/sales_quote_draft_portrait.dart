import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesQuoteDraftPortrait extends ConsumerStatefulWidget {
  const SalesQuoteDraftPortrait({Key? key, required this.header}) : super(key: key);

  final SalesQuote header;

  @override
  _SalesQuoteDraftPortraitState createState() => _SalesQuoteDraftPortraitState();
}

class _SalesQuoteDraftPortraitState extends ConsumerState<SalesQuoteDraftPortrait> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
