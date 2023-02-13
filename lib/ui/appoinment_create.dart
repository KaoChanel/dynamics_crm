import 'package:flutter/material.dart';

import '../models/customer.dart';

class AppointmentCreate extends StatefulWidget {
  final Customer customer;
  const AppointmentCreate({Key? key, required this.customer}) : super(key: key);

  @override
  State<AppointmentCreate> createState() => _AppointmentCreateState();
}

class _AppointmentCreateState extends State<AppointmentCreate> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
