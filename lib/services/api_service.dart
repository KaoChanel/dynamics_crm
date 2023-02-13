import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/company.dart';
import 'package:dynamics_crm/models/customer.dart';
import 'package:dynamics_crm/models/employee.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_quote.dart';

import '../models/task_event.dart';
import '../models/employee_option.dart';

class ApiService {
  final httpClient = http.Client();
  final String? accessToken;

  ApiService({
    this.accessToken,
  }) : assert(accessToken != null);

  Future<Company> getCompany() async {
    final uri = Uri.parse(COMPANY_API);
    final response = await httpClient.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to load company');
    }
    return companyFromJson(json.decode(response.body));
  }

  Future<Employee> getEmployee(String username) async {
    final uri = Uri.parse(EMPLOYEE_API);
    final response = await httpClient.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to load employee');
    }
    return employeeFromJson(json.decode(response.body));
  }

  Future<Customer> getCustomer() async {
    final uri = Uri.parse(CUSTOMER_API);
    final response = await httpClient.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to load customer.');
    }
    return customerFromJson(json.decode(response.body));
  }

  Future<List<Customer>> getMyCustomers() async {
    final uri = Uri.parse(CUSTOMER_API);
    final response = await httpClient.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to load my customers.');
    }

    return customerListFromJson(json.decode(response.body));
  }

  Future<List<SalesOrder>> getMyOrders(String employeeId) async {
    final uri = Uri.parse(CUSTOMER_API);
    final response = await httpClient.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to load my orders.');
    }

    return salesOrderListFromJson(json.decode(response.body));
  }

  Future<EmployeeOption?> getEmployeeOption() async {
    String strUrl = '$SERVER_BIS_URL/Option/TbmEmployeeOption/${MY_COMPANY.name}/${EMPLOYEE?.id}';
    //print(strUrl);
    var response = await http.get(Uri.parse(strUrl));
    if (response.statusCode == 200 && response.body != '[]') {
      EMPLOYEE_OPTION = employeeOptionFromJson(response.body);
      return employeeOptionFromJson(response.body);
    } else {
      EMPLOYEE_OPTION = null;
      return null;
    }
  }

  getCustomerLocation(String newCustomer, String custId) async {
  //   String strUrl = '$SERVER_BIS_URL/Customers/tblCustomersLocation/${MY_COMPANY.displayName}/$newCustomer/$custId';
  //   final response = await http.get(Uri.parse(strUrl));
  //   if (response.statusCode == 200 && response.body != '[]') {
  //
  //     List<CustomersLocation> resBody = customersLocationFromJson(response.body);
  //
  //     // resBody.map((item) {
  //     //
  //     //   globals.objCustomersLocation = CustomersLocation()
  //     //     ..rowId = item.rowId
  //     //     ..newCustomer = item.newCustomer
  //     //     ..custId = item.custId
  //     //     ..latitude = item.latitude
  //     //     ..longitude = item.longitude;
  //     //
  //     //   globals.customer_lat = item.latitude;
  //     //   globals.customer_lng = item.longitude;
  //     //
  //     // }).toList();
  //
  //     return customersLocationFromJson(response.body);
  //   }else{
  //     globals.objCustomersLocation = null;
  //     globals.customer_lat = null;
  //     globals.customer_lng = null;
  //     return null;
  //   }
  }

  Future<TaskEvent> createEmployeeOption(String emailAlertAppointment) async {
    try {
      EmployeeOption? employeeOption = EmployeeOption()
        ..empId = EMPLOYEE?.id
      // tbmEmployeeOption.empCode = EMPLOYEE.code;
        ..empName = EMPLOYEE?.displayName
        ..emailAlertAppointment = emailAlertAppointment
        ..createDate = DateTime.now()
        ..createBy = EMPLOYEE?.id
        ..updateDate = DateTime.now()
        ..updateBy = EMPLOYEE?.id;

      employeeOption = await addEmployeeOptions(employeeOption);
      //print('Add EmployeeOption result: EmpID :${tbmEmployeeOption.empId}');
      return TaskEvent(isComplete: true, eventCode: 0, title: 'Option Create', message: 'Create was complete: ${employeeOption?.empId}');
    } catch (e) {
      return TaskEvent(isComplete: false, eventCode: 0, title: 'Option Create Exception', message: e.toString());
    }
  }

  Future<EmployeeOption?> addEmployeeOptions(EmployeeOption data) async {
    String strUrl = '$SERVER_BIS_URL/Option/TbmEmployeeOption/${MY_COMPANY.displayName}/${EMPLOYEE?.id}';
    final response = await http.post(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
        "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: json.encode(data.toJson()),
    );

    print('Add status : ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 201) {
      return employeeOptionFromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<TaskEvent> putEmployeeOption(String emailAlertAppointment) async {
    try {
      var tbmEmployeeOption = EmployeeOption()
        ..rowId = EMPLOYEE_OPTION?.rowId
        ..empId = EMPLOYEE?.id
        // ..empCode = EMPLOYEE.empCode
        ..empName = EMPLOYEE?.displayName
        ..emailAlertAppointment = emailAlertAppointment
        ..createDate = EMPLOYEE_OPTION?.createDate
        ..createBy = EMPLOYEE_OPTION?.createBy
        ..updateDate = DateTime.now()
        ..updateBy = EMPLOYEE?.id;

      await updateEmployeeOption(tbmEmployeeOption);
      print('Update result: ${tbmEmployeeOption.empId}');
      return TaskEvent(isComplete: true, eventCode: 0, title: 'Option Update', message: 'Complete : ${tbmEmployeeOption.empId}');
    } catch (e) {
      return TaskEvent(isComplete: false, eventCode: 0, title: 'Option Update Exception', message: e.toString());
    }
  }

  Future<bool> updateEmployeeOption(EmployeeOption data) async {
    String strUrl = '$SERVER_BIS_URL/Option/TbmEmployeeOption/${MY_COMPANY.displayName}/${EMPLOYEE?.id}';
    final response = await http.put(
      Uri.parse(strUrl),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
        "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "PUT, OPTIONS"
      },
      body: json.encode(data.toJson()),
    );

    print('Status Code: ${response.statusCode}');
    print(response.headers);
    print(response.body);

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<Customer> createCustomer(Customer obj) async {
    final uri = Uri.parse(CUSTOMER_API);
    final response = await httpClient.post(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    }, body: json.encode(obj));

    if (response.statusCode != 201) {
      throw Exception('Failed to create customer');
    }

    return customerFromJson(response.body);
  }

  Future<SalesQuote> createQuote(SalesQuote obj) async {
    final uri = Uri.parse(QUOTATION_API);
    final response = await httpClient.post(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    }, body: json.encode(obj));

    if (response.statusCode != 201) {
      throw Exception('Failed to create quotation');
    }

    return salesQuoteFromJson(response.body);
  }

  Future<SalesOrder> createSalesOrder(SalesOrder obj) async {
    final uri = Uri.parse(ORDERS_API);
    final response = await httpClient.post(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    }, body: json.encode(obj));

    if (response.statusCode != 201) {
      throw Exception('Failed to create sales order');
    }

    return salesOrderFromJson(response.body);
  }

  Future<Customer> updateCustomer(Customer obj) async {
    final uri = Uri.parse("$CUSTOMER_API(${obj.id})");
    final response = await httpClient.put(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    }, body: json.encode(obj));

    if (response.statusCode != 200) {
      throw Exception('Failed to update customer');
    }

    return customerFromJson(response.body);
  }

  Future<SalesQuote> updateQuote(SalesQuote obj) async {
    final uri = Uri.parse("$QUOTATION_API(${obj.id})");
    final response = await httpClient.put(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    }, body: json.encode(obj));

    if (response.statusCode != 200) {
      throw Exception('Failed to update quotation');
    }

    return salesQuoteFromJson(response.body);
  }

  Future<SalesOrder> updateSalesOrder(SalesOrder obj) async {
    final uri = Uri.parse("$ORDERS_API(${obj.id})");
    final response = await httpClient.put(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    }, body: json.encode(obj));

    if (response.statusCode != 200) {
      throw Exception('Failed to update sales order');
    }

    return salesOrderFromJson(response.body);
  }

  Future<void> deleteQuote(SalesQuote obj) async {
    final uri = Uri.parse("$QUOTATION_API(${obj.id})");
    final response = await httpClient.delete(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

    if (response.statusCode != 204) {
      throw Exception('Failed to delete quotation');
    }
  }

  // Future<List<WishlistModel>> getWishlist(String sessionId, apiToken) async {
  //   var postData = {
  //     'session_id': sessionId
  //   };
  //   response = await dioConnect(WISHLIST_API, postData, apiToken);
  //   if(response.data['status'] == STATUS_OK){
  //     List responseList = response.data['data'];
  //     List<WishlistModel> listData = responseList.map((f) => WishlistModel.fromJson(f)).toList();
  //     return listData;
  //   } else {
  //     throw Exception(response.data['msg']);
  //   }
  // }
}