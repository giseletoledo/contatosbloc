import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'back4app_dio_interceptors.dart';

class Back4AppCustomDio {
  final _dio = Dio();

  Dio get dio => _dio;
//definindo cabeçalho com variável de ambiente
  Back4AppCustomDio() {
    _dio.options.headers["X-Parse-Application-Id"] =
        dotenv.get("BACK4APPAPPLICATIONID");
    _dio.options.headers["X-Parse-REST-API-Key"] =
        dotenv.get("BACK4APPRESTAPIKEY");
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = dotenv.get("BACK4APPBASEURL");
    _dio.interceptors.add(Back4AppDioInterceptor());
  }
}
