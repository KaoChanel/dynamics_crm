import 'package:dynamics_crm/models/customer.dart';
import 'package:dynamics_crm/models/employee.dart';
import 'package:dynamics_crm/models/employee_option.dart';
import 'package:flutter/material.dart';

import '../models/company.dart';

const String APP_NAME = 'SmartSales BIS';

// color for apps
const Color PRIMARY_COLOR = Color.fromRGBO(50, 54, 130, 1.0);
const Color ASSENT_COLOR = Color(0xFFe75f3f);

late Company MY_COMPANY;
String SERVER_ERP_URL = 'https://smartsalesbis.com/api/v2.0/companies(${MY_COMPANY.id})/';
String SERVER_BIS_URL = 'https://smartsalesbis.com/api/${MY_COMPANY.id}/';
String FCM_TOKEN = '';
late Customer? CUSTOMER;
late Employee? EMPLOYEE;
late EmployeeOption? EMPLOYEE_OPTION;

String COMPANY_API = "${SERVER_ERP_URL}companies";
String EMPLOYEE_API = "${SERVER_ERP_URL}employees";
String CUSTOMER_API = "${SERVER_ERP_URL}customers";
String MY_CUSTOMER_API = "${SERVER_ERP_URL}customers?\$filter=id=''";
String ALL_CUSTOMER_API = "${SERVER_ERP_URL}customers?\$expand=picture, currency, paymentMethod";
String QUOTATION_API = "${SERVER_ERP_URL}salesquote";
String ORDERS_API = "${SERVER_ERP_URL}salesorders";
String ITEM_LIST_API = "${SERVER_ERP_URL}item";

var companies = <Company>[
  Company(
    name: 'BioScience Animal Health',
  ),
  Company(
    name: 'Nutrition Improvement Company',
  ),
  Company(
    name: 'IDEXX',
  ),
  Company(
    name: 'PED EX',
  ),
  // Company(
  //   compCode: 'PEDEXTEST',
  //   compName: 'PED EX (Test)',
  // ),
  Company(
    name: 'Pro Test Kit',
  ),
  // Company(
  //   compCode: 'BIOTEST',
  //   compName: 'BioScience Animal Health (Test)',
  // ),
  // Company(
  //   compCode: 'NICTEST',
  //   compName: 'Nutrition Improvement (Test)',
  // ),
  // Company(
  //   compCode: 'IDEXXTEST',
  //   compName: 'IDEXX (Test)',
  // ),
  // Company(
  //   compCode: 'PEDEXTEST',
  //   compName: 'PED EX (Test)',
  // ),

  // Company(
  //   compCode: 'PTKTEST',
  //   compName: 'PROTEST KIT (Test)',
  // ),

  // Company(
  //   compCode: 'SISTEST',
  //   compName: 'Special Ingredient Services (Test)',
  // ),
  // Company(
  //   compCode: 'FAITHTEST',
  //   compName: 'Feed And Ingredients Technological Hub (Test)',
  // ),
];