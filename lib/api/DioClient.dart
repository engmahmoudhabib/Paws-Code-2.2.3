import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/config/env/Env.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'retry/RetryOnConnectionChangeInterceptor.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient {
  late Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Env.value.baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.headers = {'Accept': 'application/json'};
    updateHeader();

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
    }

    /*
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onError: (DioError e, handler) {
      // Do something with response error
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
    }));*/

    /*  _dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetry: DioConnectivityRequestRetry(
          dio: _dio,
        ),
      ),
    );*/
  }

  setHeader(String key, String value) {
    if (!_dio.options.headers.keys.contains(key) ||
        _dio.options.headers[key] != value) _dio.options.headers[key] = value;
  }

  updateHeader({String url = ''}) async {
    setHeader('A-Instance', GetStorage().read('uuid'));
    setHeader('A-Platform', 'mobile');

    if (GetStorage().hasData('token')) {
      setHeader('Authorization', 'Bearer ' + GetStorage().read('token'));
    } else {
      removeHeader('Authorization');
    }

    if (GetStorage().hasData('lang'))
      setHeader('Accept-Language', GetStorage().read('lang'));
    else
      removeHeader('Accept-Language');
  }

  removeHeader(String key) {
    try {
      _dio.options.headers.remove(key);
    } catch (e) {}
  }

  Future<dynamic> get(
    String uri, {
    required Map<String, dynamic> queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await updateHeader(url: uri);
      queryParameters.remove('method');
      queryParameters.remove('url');
      queryParameters.remove('full-url');
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> delete(
    String uri, {
    data,
    required Map<String, dynamic> queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await updateHeader(url: uri);
      queryParameters.remove('method');
      queryParameters.remove('url');
      queryParameters.remove('full-url');
      data.remove('method');
      data.remove('url');
      data.remove('full-url');

      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> put(
    String uri, {
    data,
    required Map<String, dynamic> queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await updateHeader(url: uri);
      queryParameters.remove('method');
      queryParameters.remove('url');
      queryParameters.remove('full-url');
      data.remove('method');
      data.remove('url');
      data.remove('full-url');

      var response = await _dio.put(
        uri,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    required Map<String, dynamic> queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await updateHeader(url: uri);
      queryParameters.remove('method');
      queryParameters.remove('url');
      queryParameters.remove('full-url');
      data.remove('method');
      data.remove('url');
      data.remove('full-url');

      var response = await _dio.post(
        uri,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}
