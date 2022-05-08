import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ImagePathMultipartMapper {
  static map(String filePath) async {
    return await MultipartFile.fromFile(filePath,
        filename: 'a.png', contentType: MediaType('image', 'jpg'));
  }
}
