import 'package:parser_error/parser_error.dart';

void main() {
  var messages = <ParserErrorMessage>[];
  var message = ParserErrorMessage("Malformed 'type'", 25, 30);
  messages.add(message);
  message = ParserErrorMessage("Expected ']' but found '`'", 29, 29);
  messages.add(message);
  var strings = ParserErrorFormatter.format(source, messages);
  print(strings.join('\n'));
  throw FormatException();
}

String source = '''
#if defined(FOO)
typedef int[`
#endif
''';
