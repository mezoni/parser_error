import "package:parser_error/parser_error.dart";

void main() {
  var messages = <ParserErrorMessage>[];
  var message = new ParserErrorMessage("Malformed 'type'", 25, 30);
  messages.add(message);
  message = new ParserErrorMessage("Expected ']' but found '`'", 29, 29);
  messages.add(message);
  var strings = ParserErrorFormatter.format(source, messages);
  print(strings.join("\n"));
  throw new FormatException();
}

String source = '''
#if defined(FOO)
typedef int[`
#endif
''';
