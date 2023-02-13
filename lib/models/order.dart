import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_order_line.dart';

class Order {
  late SalesOrder header;
  late List<SalesOrderLine> details;

  Order(this.header, this.details);
}