import 'dart:io';

import 'package:dynamics_crm/models/unit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item.dart';
import '../models/sales_order.dart';
import '../models/sales_order_line.dart';
import '../models/sales_quote.dart';
import '../models/sales_quote_line.dart';

class FileNotifier extends StateNotifier<List<File>> {
  FileNotifier(): super([]);

  void add(File object) {
    state = [...state, object];
  }

  void edit(File object) {
    state = [
      for(var element in state)
        if(element.path == object.path)
          element = object
        else
          element
    ];
  }

  void remove(File object) {
    state = [
      for (final element in state)
        if (element.path != object.path) element,
    ];
  }
}

/// Sales Order
var items = StateNotifierProvider<ItemNotifier, List<Item>>((ref) => ItemNotifier([]));
var itemsCart = StateNotifierProvider<ItemNotifier, List<Item>>((ref) => ItemNotifier([]));
var itemsFilter = StateNotifierProvider<ItemNotifier, List<Item>>((ref) => ItemNotifier([]));
var units = StateNotifierProvider<UnitNotifier, List<Unit>>((ref) => UnitNotifier());
var salesOrder = StateNotifierProvider<SalesOrderNotifier, SalesOrder>((ref) => SalesOrderNotifier());
var salesOrderLines = StateNotifierProvider<SalesOrderLineNotifier, List<SalesOrderLine>>((ref) => SalesOrderLineNotifier());
var salesOrderDraft = StateNotifierProvider<SalesOrderNotifier, SalesOrder>((ref) => SalesOrderNotifier());
var salesOrderLinesDraft = StateNotifierProvider<SalesOrderLineNotifier, List<SalesOrderLine>>((ref) => SalesOrderLineNotifier());
var salesOrderCopy = StateNotifierProvider<SalesOrderNotifier, SalesOrder>((ref) => SalesOrderNotifier());
var salesOrderLinesCopy = StateNotifierProvider<SalesOrderLineNotifier, List<SalesOrderLine>>((ref) => SalesOrderLineNotifier());

/// Attachment
var salesOrderAttach = StateNotifierProvider<FileNotifier, List<File>>((ref) => FileNotifier());

/// Quotation
var salesQuote = StateNotifierProvider<SalesQuoteNotifier, List<SalesQuote>>((ref) => SalesQuoteNotifier([]));
var salesQuoteLines = StateNotifierProvider<SalesQuoteLineNotifier, List<SalesQuoteLine>>((ref) => SalesQuoteLineNotifier([]));
var salesQuoteDraft = StateNotifierProvider<SalesQuoteNotifier, List<SalesQuote>>((ref) => SalesQuoteNotifier([]));
var salesQuoteLinesDraft = StateNotifierProvider<SalesQuoteLineNotifier, List<SalesQuoteLine>>((ref) => SalesQuoteLineNotifier([]));
var salesQuoteCopy = StateNotifierProvider<SalesQuoteNotifier, List<SalesQuote>>((ref) => SalesQuoteNotifier([]));
var salesQuoteLinesCopy = StateNotifierProvider<SalesQuoteLineNotifier, List<SalesQuoteLine>>((ref) => SalesQuoteLineNotifier([]));

/// Utility
var keywordOfSalesOrder = StateProvider((ref) => '');
String loadingMessage = 'กำลังโหลด...';