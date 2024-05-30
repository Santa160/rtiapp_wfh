import 'package:html/parser.dart';

Map<String, dynamic> parseHtmlToJson(String html) {
  final document = parse(html);
  final title = document.querySelector('h1')?.text;
  final guidelines = <String>[];

  // Loop through list items and extract text
  for (final element in document.querySelectorAll('li')) {
    guidelines.add(element.text.trim());
  }

  // Loop through sub-list items and extract text (nested list)
  final subList = document.querySelectorAll('.sub-list li');
  final paymentModes = subList.map((e) => e.text.trim()).toList();

  return {
    'title': title,
    'guidelines': guidelines,
    'paymentModes': paymentModes,
  };
}