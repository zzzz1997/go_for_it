import 'package:dio/dio.dart';

///
/// 请求类
///
class Api {
  // 获取dio实例
  static Dio get dio => _dio;

  // dio实例
  static final _dio = Dio();

  // 基础url
  static final baseUrl = 'https://goforit.zzzz1997.com';

  ///
  /// get请求
  ///
  static get(url, {queryParameters, token}) async {
    try {
      Response response = await dio.get(
        baseUrl + url,
        queryParameters: queryParameters,
        options: token != null ? Options(headers: {'token': token}) : null,
      );
      if (response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw response.data['message'];
      }
    } catch (e) {
      throw e;
    }
  }

  ///
  /// post请求
  ///
  static post(url, {data, token}) async {
    try {
      Response response = await dio.post(
        baseUrl + url,
        data: FormData.fromMap(data),
        options: token != null ? Options(headers: {'token': token}) : null,
      );
      if (response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw response.data['message'];
      }
    } catch (e) {
      throw e;
    }
  }
}
