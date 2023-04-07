import 'package:dynamics_crm/models/sales_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesOrderDraft extends ConsumerStatefulWidget {
  const SalesOrderDraft({Key? key, required this.header}) : super(key: key);

  final SalesOrder header;

  @override
  _SalesOrderDraftState createState() => _SalesOrderDraftState();
}

class _SalesOrderDraftState extends ConsumerState<SalesOrderDraft> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
