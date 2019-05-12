import 'package:dio/dio.dart';

///
/// 请求类
///
class Api {
  // 获取dio实例
  static Dio get dio => _getDio();

  // dio实例
  static Dio _dio;

  // 基础url
  static final baseUrl = 'http://113.55.46.211:8080';

  ///
  /// 获取单例dio
  ///
  static Dio _getDio() {
    if (_dio == null) {
      _dio = Dio();
    }
    return _dio;
  }

  ///
  /// get请求
  ///
  static get(url, {queryParameters, token}) async {
    try {
      Response response = await dio.get(baseUrl + url,
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
      Response response = await dio.post(baseUrl + url,
        data: FormData.from(data),
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
