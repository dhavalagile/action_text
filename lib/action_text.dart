import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'actionDetection.dart';
import 'actionTextDetection.dart';

final _linkRegex = RegExp(r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)", caseSensitive: false);
final _tagRegex = RegExp(r"\B#\w*[a-zA-Z]+\w*", caseSensitive: false);
final _mensionUserRegex = RegExp(r"\B@\w*[a-zA-Z0-9]+\w*", caseSensitive: false);

/// Callback with URL to open
typedef StringCallback(String url);


/// convert text to list
List<ActionTextDetection> _smartify(String text, List<Map<String, StringCallback>> otherLinks) {
  final sentences = text.split('\n');
  List<ActionTextDetection> span = [];
  sentences.forEach((sentence) {
    final words = sentence.split(' ');
    words.forEach((word) {
      if (_linkRegex.hasMatch(word)) {
        span.add(LinkDetection(word));
      } else if (_tagRegex.hasMatch(word)) {
        span.add(HashTagDetection(word));
      } else if (_mensionUserRegex.hasMatch(word)) {
        span.add(TagUserDetection(word));
      } else {
        var arr = otherLinks.where((E) => E.keys.toList().contains(word)).toList();
        if (arr.length != 0) {
          span.add(CustomTextDetection(word));
        } else {
          span.add(TextDetection(word));
        }
        //span.add(TextDetection(word));
      }
      span.add(TextDetection(' '));
    });
    if (words.isNotEmpty) {
      span.removeLast();
    }
    span.add(TextDetection('\n'));
  });
  if (sentences.isNotEmpty) {
    span.removeLast();
  }
  return span;
}




class ActionText extends StatelessWidget {

  /// Text to be linkified
  final String text;

  /// Style for non-link text
  final TextStyle style;

  /// Style of link text
  final TextStyle linkStyle;

  /// Style of HashTag text
  final TextStyle tagStyle;

  /// Style of MentionUser text
  final TextStyle mentionUserStyle;

  /// Style of customTagStyle text
  final TextStyle customTagStyle;

  /// Callback for tapping a link
  final StringCallback onOpen;

  /// Callback for tapping a link
  final StringCallback onTagClick;

  /// Callback for tapping a link
  final StringCallback onUserMensionClick;

  final List<Map<String, StringCallback>> otherLinks;

  const ActionText({
    Key key,
    this.text,
    this.style,
    this.linkStyle,
    this.tagStyle,
    this.customTagStyle,
    this.mentionUserStyle,
    this.onOpen,
    this.onTagClick,
    this.onUserMensionClick,
    this.otherLinks
  }) : super(key: key);


  /// Raw TextSpan builder for more control on the RichText
  TextSpan _buildTextSpan(
      {String text,
        TextStyle style,
        TextStyle linkStyle,
        TextStyle tagStyle,
        TextStyle mentionUserStyle,
        TextStyle customTagStyle,
        StringCallback onOpen,
        StringCallback onTagClick,
        StringCallback onUserMensionClick,
        List<Map<String, StringCallback>> otherLinks
      }) {



    final elements = _smartify(text, otherLinks);

    void _handleCustomTextClick(String text) {
      var map = otherLinks.where((E) => E.keys.contains(text)).first;
      var callBack = map[text];
      callBack(text);
    }

    void _onOpen(String url) {
      if (onOpen != null) {
        onOpen(url);
      }
    }

    void _onTagClick(String url) {
      if (onTagClick != null) {
        onTagClick(url);
      }
    }

    void _onUserMensionClick(String url) {
      if (onUserMensionClick != null) {
        onUserMensionClick(url);
      }
    }

    return TextSpan(
        children: elements.map<TextSpan>((element) {
          if (element is TextDetection) {
            return TextSpan( text: element.text, style: style,);

          } else if (element is LinkDetection) {
            return LinkTextSpan(text: element.url, style: linkStyle, onPressed: () => _onOpen(element.url),);

          } else if (element is HashTagDetection) {
            return LinkTextSpan(text: element.tag, style: tagStyle, onPressed: () => _onTagClick(element.tag),);

          } else if (element is TagUserDetection) {
            return LinkTextSpan(text: element.tag, style: mentionUserStyle, onPressed: () => _onUserMensionClick(element.tag),);

          } else if (element is CustomTextDetection) {
            return LinkTextSpan(text: element.text, style: customTagStyle, onPressed: () => _handleCustomTextClick(element.text));
          }
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      softWrap: true,
      text: _buildTextSpan(
        text: text,
        style: Theme.of(context).textTheme.body1.merge(style),
        linkStyle: Theme.of(context).textTheme.body1.merge(style).copyWith(decoration: TextDecoration.underline,).merge(linkStyle),
        tagStyle: Theme.of(context).textTheme.body1.merge(style).merge(tagStyle),
        mentionUserStyle: Theme.of(context).textTheme.body1.merge(style).merge(mentionUserStyle),
        customTagStyle: Theme.of(context).textTheme.body1.merge(style).merge(customTagStyle),
        onOpen: onOpen,
        onTagClick: onTagClick,
        onUserMensionClick: onUserMensionClick,
        otherLinks: otherLinks,
      ),
    );
  }
}


class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, VoidCallback onPressed, String text})
      : super(
    style: style,
    text: text,
    recognizer: new TapGestureRecognizer()..onTap = onPressed,
  );
}


