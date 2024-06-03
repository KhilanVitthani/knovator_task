import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';
import '../constants/color_constant.dart';
import '../constants/sizeConstant.dart';

class MethodType {
  static const String Post = "POST";
  static const String Get = "GET";
  static const String Put = "PUT";
  static const String Patch = "PATCH";
  static const String Delete = "DELETE";
}

class NetworkClient {
  static NetworkClient? _shared;

  NetworkClient._();

  static NetworkClient get getInstance =>
      _shared = _shared ?? NetworkClient._();

  Dio dio = Dio();

  Map<String, dynamic> getAuthHeaders({String? detailToken}) {
    Map<String, dynamic> authHeaders = Map<String, dynamic>();

    String token = "";

    if (!isNullEmptyOrFalse(token)) {
      authHeaders["Authorization"] = "Bearer " + token;
    } else if (!isNullEmptyOrFalse(detailToken)) {
      authHeaders['Authorization'] = detailToken;
    } else {
      authHeaders["Content-Type"] = "application/json";
    }
    return authHeaders;
  }

  Future callApi(
    BuildContext context,
    String baseUrl,
    String command,
    String method, {
    var params,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParameters,
    Function(dynamic response, String message)? successCallback,
    Function(dynamic message, dynamic statusCode)? failureCallback,
  }) async {
    await Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        failureCallback!("Failed", "No Internet Connection");
        return;
      }
    });

    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    dio.options.connectTimeout = Duration(seconds: 5); //5s
    dio.options.receiveTimeout = Duration(seconds: 5);

    dio.options.headers["Access-Control-Allow-Origin"] = "*";
    dio.options.headers["Content-Type"] = 'application/json';
    dio.options.headers["Accept"] = '*/*';
    if (header != null) {
      for (var key in header.keys) {
        dio.options.headers[key] = header[key];
      }
    }

    switch (method) {
      case MethodType.Post:
        Response response = await dio
            .post(baseUrl + command,
                data: params, queryParameters: queryParameters)
            .catchError((error) {
          print("Error : = $error");
          DioError dioError = error as DioError;
          if (dioError.type == DioErrorType.connectionTimeout ||
              dioError.type == DioErrorType.receiveTimeout) {
            failureCallback!("TimeOut", "Something went wrong.");
          } else {
            failureCallback!("Error", "Something went wrong.");
          }
        });
        parseResponse(context, response,
            successCallback: successCallback!,
            failureCallback: failureCallback!);
        break;

      case MethodType.Get:
        Response response = await dio
            .get(baseUrl + command, queryParameters: queryParameters)
            .catchError((error) {
          print("Error : = $error");
          DioError dioError = error as DioError;
          if (dioError.type == DioErrorType.connectionTimeout ||
              dioError.type == DioErrorType.receiveTimeout) {
            failureCallback!("TimeOut", "Something went wrong.");
          }
          if (dioError.message == "Http status error [500]") {
            failureCallback!("Error", "Internal Server Error");
          } else {
            failureCallback!("Error", "Something went wrong.");
          }
        });
        parseResponse(context, response,
            successCallback: successCallback!,
            failureCallback: failureCallback!);
        break;

      case MethodType.Put:
        Response response = await dio
            .put(baseUrl + command,
                data: params, queryParameters: queryParameters)
            .catchError((error) {
          print("Error : = $error");
          DioError dioError = error as DioError;
          if (dioError.type == DioErrorType.connectionTimeout ||
              dioError.type == DioErrorType.receiveTimeout) {
            failureCallback!("TimeOut", "Something went wrong.");
          } else {
            failureCallback!("Error", "Something went wrong.");
          }
        });
        ;
        parseResponse(context, response,
            successCallback: successCallback!,
            failureCallback: failureCallback!);
        break;
      case MethodType.Patch:
        Response response = await dio
            .patch(baseUrl + command,
                data: params, queryParameters: queryParameters)
            .catchError((error) {
          print("Error : = $error");
          DioError dioError = error as DioError;
          if (dioError.type == DioErrorType.connectionTimeout ||
              dioError.type == DioErrorType.receiveTimeout) {
            failureCallback!("TimeOut", "Something went wrong.");
          } else {
            failureCallback!("Error", "Something went wrong.");
          }
        });
        ;
        parseResponse(context, response,
            successCallback: successCallback!,
            failureCallback: failureCallback!);
        break;

      case MethodType.Delete:
        Response response = await dio
            .delete(baseUrl + command,
                data: params, queryParameters: queryParameters)
            .catchError((error) {
          print("Error : = $error");
          DioError dioError = error as DioError;
          if (dioError.type == DioErrorType.connectionTimeout ||
              dioError.type == DioErrorType.receiveTimeout) {
            failureCallback!("TimeOut", "Something went wrong.");
          } else {
            failureCallback!("Error", "Something went wrong.");
          }
        });
        ;
        parseResponse(context, response,
            successCallback: successCallback!,
            failureCallback: failureCallback!);
        break;

      default:
    }
  }

  parseResponse(BuildContext context, Response response,
      {Function(dynamic response, String message)? successCallback,
      Function(dynamic statusCode, dynamic message)? failureCallback}) {
    // app.resolve<CustomDialogs>().showCircularDialog(context);
    String statusCode = "response.data['code']";
    String message = "Something went wrong.";

    if (response.statusCode == 200 || response.statusCode == 201) {
      hideDialog(true, context);

      if (response.data is Map<String, dynamic> ||
          response.data is List<dynamic>) {
        successCallback!(response.data, message);
        return;
      } else if (response.data is List<Map<String, dynamic>>) {
        successCallback!(response.data, response.statusMessage.toString());
        return;
      } else if (!isNullEmptyOrFalse(response.data)) {
        successCallback!(response.data, response.statusMessage.toString());
        return;
      } else {
        failureCallback!(response.data, "Something went wrong.");
        return;
      }
    } else if (response.statusCode == 400) {
      if (!isNullEmptyOrFalse(response.data)) {
        hideDialog(true, context);

        failureCallback!(response.statusCode, response.data["error"]);
        return;
      } else {
        hideDialog(true, context);

        failureCallback!(response.statusCode, response.data["error"]);
        return;
      }
    } else if (response.statusCode == 401) {
      if (!isNullEmptyOrFalse(response.data)) {
        hideDialog(true, context);

        failureCallback!(response.statusCode, response.data["error"]);
        return;
      } else {
        hideDialog(true, context);

        failureCallback!(response.statusCode, response.data["error"]);
        return;
      }
    } else if (response.statusCode == 500) {
      failureCallback!(response.data, "Something went wrong.");
      return;
    } else {
      hideDialog(true, context);

      failureCallback!(response.statusCode, response.data);
      return;
    }
  }

  void hideDialog(bool isProgress, BuildContext context) {
    if (isProgress) {
      // app.resolve<CustomDialogs>().hideCircularDialog(context);
    }
  }

  getDialog(
      {String title = "Error", String desc = "Some Thing went wrong...."}) {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: title,
        content: Text(desc),
        buttonColor: appTheme.primaryTheme,
        textConfirm: "Ok",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        });
  }
}
