import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DepremAPI {
  Future<String> getApi() async {
    Dio dio = Dio();

    dio.options.responseType = ResponseType.bytes;

    try {
      var response = await dio.get(
        "http://www.koeri.boun.edu.tr/scripts/lst0.asp",
      );

      String decodedData = latin1.decode(response.data, allowInvalid: true);

      return decodedData;
    } catch (e) {
      if (kDebugMode) {
        print('Veri alınırken bir hata oluştu: $e');
      }
      return 'Hata: Veri alınamadı';
    }
  }
}
