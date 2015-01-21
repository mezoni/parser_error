#parser_error
==========

Version: 0.0.1

**Main purpose**

- Use with parsers

Example:

```dart
import "package:parser_error/parser_error.dart";

void main() {
  var messages = [];
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
```

Output:


```
Format exception (2:9): Malformed 'type'
typedef int[`
        ^^^^^
Format exception (2:13): Expected ']' but found '`'
typedef int[`
            ^
Breaking on exception: object of type FormatException: FormatException

```
