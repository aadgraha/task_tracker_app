import 'package:dio/dio.dart';

abstract class Api {
  static const String apiUrl =
      'http://192.168.18.71:8080';
      //TODO ubah base api sesuai ip device

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );
}