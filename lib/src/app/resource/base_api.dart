import 'package:dio/dio.dart';

abstract class Api {
  static const String apiUrl = 'http://10.0.3.2:8080';

/*TODO genymotion emulator use 'http://10.0.3.2:8080';
android studio emulator use 'http://10.0.2.2:8080';
physical device use machine ip (cmd : hostname -I), something like 192.168.x.x*/

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );
}
