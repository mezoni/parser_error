part of parser_error;

class ParserErrorMessage {
  /// End position of error.
  final int end;

  /// Error message.
  final String message;

  /// Start position of error.
  final int start;

  ParserErrorMessage(this.message, this.start, this.end) {
    if (message == null) {
      throw new ArgumentError.notNull("message");
    }

    if (end == null || end < 0) {
      throw new ArgumentError.value(end, "end");
    }

    if (start == null || start < 0 || start > end) {
      throw new ArgumentError.value(start, "start");
    }
  }
}

class ParserErrorFormatter {
  /// Returns formatted error as strings.
  ///
  /// Parameters:
  ///   [String] source
  ///   Text of source code.
  ///
  ///   [List]<[ParserErrorMessage]> error
  ///   List of parser error messages.
  ///
  ///   [int] lineLimit
  ///   Length limit of the formatted line.
  ///
  ///   [int] offset
  ///   Offset to be added to the values "start" and "end".
  ///
  ///   [String] title
  ///   Title of parser error
  static List<String> format(String source, List<ParserErrorMessage> messages,
      {int lineLimit = 80, int offset = 0, String title = "Format exception"}) {
    if (source == null) {
      throw new ArgumentError.notNull("source");
    }

    if (messages == null) {
      throw new ArgumentError.notNull("messages");
    }

    if (lineLimit == null || lineLimit < 1) {
      throw new ArgumentError.value(lineLimit, "lineLimit");
    }

    if (offset == null || offset < 0) {
      throw new ArgumentError.value(offset, "offset");
    }

    if (title == null) {
      throw new ArgumentError.notNull("title");
    }

    var result = <String>[];
    var text = new Text(source);
    var sourceLength = source.length;
    for (var error in messages) {
      var position = error.end + offset;
      if (error.start != error.end) {
        position = error.start + offset;
      }

      Location location;
      Line line;
      var locationString = "";
      if (position < sourceLength) {
        line = text.lineAt(position);
        location = text.locationAt(position);
        locationString = " (${location.toString()})";
      }

      result.add("$title$locationString: ${error.message}");
      if (line != null) {
        var string = new String.fromCharCodes(line.characters);
        string = string.replaceAll("\n", "");
        string = string.replaceAll("\r", "");
        var indicatorLength = 1;
        var indicatorPosition = location.column - 1;
        if (error.end != error.start) {
          indicatorLength = error.end - error.start;
        }

        if (indicatorLength > lineLimit) {
          indicatorLength = lineLimit;
        }

        if (indicatorPosition + indicatorLength > lineLimit) {
          if (indicatorPosition < lineLimit || indicatorLength < lineLimit) {
            var delta = (indicatorPosition + indicatorLength) - lineLimit;
            string = string.substring(delta);
            indicatorPosition -= delta;
          } else {
            string = string.substring(indicatorPosition);
            indicatorPosition = 0;
          }
        }

        if (string.length > lineLimit) {
          string = string.substring(0, lineLimit);
        }

        var prefix = "".padRight(indicatorPosition, " ");
        var suffix = "".padRight(indicatorLength, "^");
        var indicator = "$prefix$suffix";
        result.add(string);
        result.add(indicator);
      }
    }

    return result;
  }
}
