import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:flutter/material.dart';

class SalesQuoteView extends StatefulWidget {
  const SalesQuoteView({Key? key, required this.header}) : super(key: key);

  final SalesQuote header;

  @override
  State<SalesQuoteView> createState() => _SalesQuoteViewState();
}

class _SalesQuoteViewState extends State<SalesQuoteView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
