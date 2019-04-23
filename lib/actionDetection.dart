
import 'actionTextDetection.dart';

/// Represents an element containing a link
class LinkDetection extends ActionTextDetection {
  final String url;

  LinkDetection(this.url);

  @override
  String toString() {
    return "Link: $url";
  }
}

/// Represents an element containing a hastag
class HashTagDetection extends ActionTextDetection {
  final String tag;

  HashTagDetection(this.tag);

  @override
  String toString() {
    return "HashTag: $tag";
  }
}

/// Represents an element containing a hastag
class TagUserDetection extends ActionTextDetection {
  final String tag;

  TagUserDetection(this.tag);

  @override
  String toString() {
    return "HashTag: $tag";
  }
}

/// Represents an element containing text
class TextDetection extends ActionTextDetection {
  final String text;

  TextDetection(this.text);

  @override
  String toString() {
    return "Text: $text";
  }
}

/// Represents an element containing text
class CustomTextDetection extends ActionTextDetection {
  final String text;

  CustomTextDetection(this.text);

  @override
  String toString() {
    return "Text: $text";
  }
}