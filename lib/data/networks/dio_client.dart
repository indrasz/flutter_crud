import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_crud/data/networks/network.dart';
import 'package:flutter_crud/models/models.dart';
import 'package:flutter_crud/data/networks/interceptors/interceptors.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: EndPoints.baseUrl,
            connectTimeout: EndPoints.connectionTimeOut,
            receiveTimeout: EndPoints.receiveTimeOut,
            responseType: ResponseType.json,
          ),
        )..interceptors.addAll([
            AuthorizationInterceptor(),
            LoggerInterceptor(),
          ]);

  late final Dio _dio;

  Future<User?> getUser({required int id}) async {
    try {
      final response = await _dio.get('${EndPoints.users}/$id');
      return User.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  Future<User?> createUser({required User user}) async {
    try {
      final response = await _dio.post(EndPoints.users, data: user.toJson());
      return User.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  Future<void> deleteUser({required int id}) async {
    try {
      await _dio.delete('${EndPoints.users}/$id');
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }
}