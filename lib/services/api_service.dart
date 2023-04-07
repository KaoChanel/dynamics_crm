import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamics_crm/models/google_autocomplete_place.dart';
import 'package:dynamics_crm/models/unit.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/company.dart';
import 'package:dynamics_crm/models/customer.dart';
import 'package:dynamics_crm/models/employee.dart';
import 'package:dynamics_crm/models/sales_order.dart';
import 'package:dynamics_crm/models/sales_quote.dart';
import 'package:uuid/uuid.dart';

import '../models/blog.dart';
import '../models/google_place.dart';
import '../models/item.dart';
import '../models/remark.dart';
import '../models/sales_order_line.dart';
import '../models/task_event.dart';
import '../models/employee_option.dart';

class ApiService {
  final dio = Dio();
  final httpClient = http.Client();
  final authorization = 'Basic';
  final username = 'nwth';
  final password = 'q7DmBHRJSRuUwFKC62X0JpID8wSwKnY+LdY0qA+enfI=';
  late String? accessToken;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // ApiService({
  //   this.accessToken,
  // }) : assert(accessToken != null);

  ApiService(){
    final bytes = utf8.encode('$username:$password');
    final base64Str = base64.encode(bytes);

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "$authorization $base64Str";
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
  }

  Future<List<Company>> getCompanies() async {
    try {
      // final uri = Uri.parse('http://app05.naviworldth.com:19028/BIS_Live/api/nwth/bis/v2.0/companies');
      // final response = await httpClient.get(uri, headers: {
      //   HttpHeaders.authorizationHeader: '$authorization $base64Str',
      // });

      final response = await dio.get(COMPANIES_API);

      if (response.statusCode != 200) {
        throw Exception('Failed to load company ${response.data}');
      }

      return companyListFromJson(json.encode(response.data['value']));
    }catch(error){
      developer.log(error.toString());
      throw Exception(error.toString());
    }
  }

  Future<Company> getCompany(String id) async {
    final response = await dio.get('$COMPANIES_API($id)');

    if (response.statusCode != 200) {
      throw Exception('Failed to load company ${response.data}');
    }
    return companyFromJson(json.encode(response.data));
  }

  Future<Employee> getEmployee(String username, String password) async {
    String url = "$EMPLOYEE_API?\$filter=code eq '$username' and password eq '$password'";

    final response = await dio.get(url);
    if (response.statusCode != 200) {
      // throw Exception('Failed to load employee');
      return Employee();
    }

    return employeeListFromJson(json.encode(response.data['value'])).first;
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

  Future<List<Item>> getItems() async {
    try {
      final response = await dio.get(ITEMS_API);

      if (response.statusCode != 200) {
        throw Exception('Failed to load items ${response.data}');
      }

      return itemListFromJson(json.encode(response.data['value']));
    }catch(error){
      developer.log(error.toString());
      throw Exception(error.toString());
    }
  }

  Future<List<Unit>> getUnits() async {
    try {
      final response = await dio.get(UNITS_API);

      if (response.statusCode != 200) {
        throw Exception('Failed to load units ${response.data}');
      }

      return unitListFromJson(json.encode(response.data['value']));
    }catch(error){
      // developer.log(error.toString());
      throw Exception(error.toString());
    }
  }

  Future<List<Remark>> getRemark() async {
    try{
      String? company = companies.firstWhere((e) => MY_COMPANY.displayName!.toLowerCase().contains(e.displayName!.toLowerCase()), orElse: () => Company()).name ?? '';
      final response = await dio.get('${REMARK_API}$company');

      if (response.statusCode != 200) {
        throw Exception('Failed to load remarks ${response.data}');
      }

      return remarkFromJson(json.encode(response.data));
    }catch(error){
      throw Exception(error.toString());
    }
  }

  Future<List<Blog>> getNews() async {
    try{
      String? company = companies.firstWhere((e) => MY_COMPANY.displayName!.toLowerCase().contains(e.displayName!.toLowerCase()), orElse: () => Company()).name ?? '';
      final response = await dio.get('${NEWS_API}');

      if (response.statusCode != 200) {
        // throw Exception('Failed to load news ${response.data}');

        return <Blog>[];
      }

      return blogListFromJson(json.encode(response.data));
    }catch(error){
      // throw Exception(error.toString());
      return <Blog>[];
    }
  }

  Future<List<SalesQuote>> getMyQuotes([String salesPersonCode = '']) async {
    final response = await dio.get("$ORDERS_API?\$filter=salespersonCode eq '$salesPersonCode'");

    if (response.statusCode != 200) {
      throw Exception('Failed to load my quotes.');
    }

    return salesQuoteListFromJson(json.encode(response.data['value']));
  }

  Future<List<SalesOrder>> getMyOrders([String salesPersonCode = '']) async {
    // var uri = Uri.parse(ORDERS_API);
    // if(salesPersonCode.isNotEmpty){
    //   uri = Uri.parse("$ORDERS_API?\$filter=salespersonCode eq '$salesPersonCode'");
    // }

    final response = await dio.get("$ORDERS_API?\$filter=salespersonCode eq '$salesPersonCode'");

    // final response = await httpClient.get(uri, headers: {
    //   HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    // });

    if (response.statusCode != 200) {
      throw Exception('Failed to load my orders.');
    }

    return salesOrderListFromJson(json.encode(response.data['value']));
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

  getFindPlace(String input, String sessionToken) async {
    String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
    String request = '$baseURL?input=$input&key=$GOOGLE_MAP_API&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      // log(json.decode(response.body)['predictions']);
      return googleAutocompletePlaceFromJson(response.body);
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  getTextSearch(String query) async {
    String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
    String request = '$baseURL?query=$query&key=$GOOGLE_MAP_API';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      // log(json.decode(response.body)['predictions']);
      return googlePlaceFromJson(response.body);
    } else {
      throw Exception('Failed to search place');
    }
  }

  getSuggestion(String input, String sessionToken) async {
    String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$GOOGLE_MAP_API&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      // log(json.decode(response.body)['predictions']);
      return googleAutocompletePlaceFromJson(response.body);
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  // https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJrTLr-GyuEmsRBfy61i59si0&key=AIzaSyCgCn4EebVBR3d0dXLFBwlXa8I1_WXSQDI
  getLocationByPlace(String placeId) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request = '$baseURL?place_id=$placeId&key=$GOOGLE_MAP_API';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      return json.decode(response.body)['geometry']['location'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<TaskEvent> createEmployeeOption(String emailAlertAppointment) async {
    try {
      EmployeeOption? employeeOption = EmployeeOption()
        ..empId = EMPLOYEE?.id
      // tbmEmployeeOption.empCode = EMPLOYEE.code;
        ..empName = EMPLOYEE?.name
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
        ..empCode = EMPLOYEE?.code
        ..empName = EMPLOYEE?.name
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

  Future<SalesOrder> getSalesOrder(SalesOrder obj) async {
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

  Future<List<SalesOrderLine>> getSalesOrderLine(String id) async {
    // final uri = Uri.parse(ORDERS_API);
    // final response = await httpClient.get(uri, headers: {
    //   HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    //   HttpHeaders.contentTypeHeader: 'application/json'
    // });

    // if (response.statusCode != 201) {
    //   throw Exception('Failed to get sales order lines');
    // }

    // return salesOrderLineListFromJson(response.body);

    return SALES_ORDER_LINES.where((e) => e.documentId == id).toList();
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
    final uri = Uri.parse(ORDERS_API);
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