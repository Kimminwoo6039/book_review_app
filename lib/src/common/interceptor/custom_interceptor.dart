

import 'package:dio/dio.dart';

class CustomInterCeptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Naver-Client-Id'] = 'NvgpGjbT4Z3Mn8636T_u';
    options.headers['X-Naver-Client-Secret'] = 'nyIePAJ159';
    super.onRequest(options, handler);
  }
}