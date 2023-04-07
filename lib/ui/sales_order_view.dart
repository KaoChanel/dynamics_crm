import 'package:flutter/material.dart';

import '../models/sales_order.dart';

class SalesOrderView extends StatefulWidget {
  const SalesOrderView({Key? key, required this.header}) : super(key: key);

  final SalesOrder header;

  @override
  State<SalesOrderView> createState() => _SalesOrderViewState();
}

class _SalesOrderViewState extends State<SalesOrderView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
