import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

class ServiceVersion {
  Future<String?> fetchVersion() async {
    var result =
        await Dio().get("https://alikales.github.io/dlm");

    if (result.statusCode != 200) return null;

    var document = parser.parse(result.data);

    List<String> lines = document.head!.innerHtml.split("\n");

    String description =
        lines.firstWhere((element) => element.contains("description"));

    description = description.trim().substring(34, 39);

    return description;
  }
}
