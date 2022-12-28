import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamics_crm/providers/data_provider.dart';

class SalesOrderCreatePortrait extends ConsumerStatefulWidget {
  const SalesOrderCreatePortrait({Key? key}) : super(key: key);

  @override
  _SalesOrderCreatePortraitState createState() => _SalesOrderCreatePortraitState();
}

class _SalesOrderCreatePortraitState extends ConsumerState<SalesOrderCreatePortrait> {

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(salesOrderLines);
  }

  @override
  Widget build(BuildContext context) {
    var orders = ref.watch(salesOrderLines);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: orders.map((e) => Text('${e.sequence ?? ''} ${e.itemId} ${e.quantity} ${e.unitPrice}')).toList() ?? [],
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(salesOrderLines.notifier).add(SalesOrderLine(id: '1001', sequence: '${orders.length + 1}', itemId: '5000', quantity: '1', unitPrice: '200', netAmount: '200'));
                },
                child: const Text('Add Order'))
          ]
        ),
      ),
    );
  }
}
