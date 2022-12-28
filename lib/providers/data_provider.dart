import 'package:dynamics_crm/models/item.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var salesOrder = StateNotifierProvider<SalesOrderNotifier, List<SalesOrder>>((ref) => SalesOrderNotifier([]));
var salesOrderLines = StateNotifierProvider<SalesOrderLineNotifier, List<SalesOrderLine>>((ref) => SalesOrderLineNotifier([]));
var items = StateNotifierProvider<ItemNotifier, List<Item>>((ref) => ItemNotifier([]));