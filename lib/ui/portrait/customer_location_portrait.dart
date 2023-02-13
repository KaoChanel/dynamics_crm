import 'package:flutter/material.dart';

import '../../models/customer.dart';

class CustomerLocationPortrait extends StatefulWidget {
  final Customer? customer;
  const CustomerLocationPortrait({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerLocationPortrait> createState() => _CustomerLocationPortraitState();
}

class _CustomerLocationPortraitState extends State<CustomerLocationPortrait> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
