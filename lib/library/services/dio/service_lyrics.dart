import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

abstract class IServiceLyrics {
  IServiceLyrics();

  Future<String?> getLyrics(String link);
}

class ServiceLyrics extends IServiceLyrics {
  ServiceLyrics() : super();

  @override
  Future<String?> getLyrics(String link) async {
    var result = await Dio().get(link);

    if (result.statusCode != 200) return null;

    var document = parser.parse(result.data);

    var elements =
        document.getElementsByClassName("Lyrics__Container-sc-1ynbvzw-6 YYrds");

    StringBuffer text = StringBuffer();

    for (var item in elements) {
      var list = item.innerHtml.split("<br>");

      for (var element in list) {
        element = element.replaceAll("<i>", "");
        element = element.replaceAll("</i>", "");

        if (element.contains("<a href")) {
          String last = element.split('jAzSMw">').last;
          String first = last.split('</span>').first;

          int start = element.indexOf("<a href");
          int end = element.indexOf("</span></span>");

          if (start != -1 && end != -1) {
            element = element.replaceRange(start, end, " $first ");

            element = element.replaceAll("</span></span>", "");
          } else {
            element = first;
          }

          text.write("${element.trim()}\n");
        } else if (element.contains('</span></a><span tabindex="0"')) {
          element = element.split('</span></a><span tabindex="0"').first;

          text.write("$element\n");
        } else if (element.startsWith("<div data-exclude-from-selection")) {
          int start = element.indexOf("<div data-exclude-from-selection");
          int end = element.indexOf("</div></div>");

          if (start != -1 && end != -1) {
            element = element.replaceRange(start, end, "");
          }

          if (end != -1) {
            element = element.replaceAll("</div></div>", "");
          }

          text.write("$element\n");
        } else if (!element.startsWith("<span") &&
            !element.contains('span tabindex="0"')) {
          text.write("$element\n");
        }
      }
    }

    return text.toString();
  }
}
