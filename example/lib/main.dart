import 'package:flutter/material.dart';
import 'package:action_text/action_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';


void main() => runApp(MaterialApp(home: LinkPage(),));


class LinkPage extends StatefulWidget {
  @override
  _LinkPageState createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {

  BuildContext _scaffoldContext;


  @override
  Widget build(BuildContext context) {

    var appBar = AppBar(title: new Text('UrlLauchner'),);
    /*
    var gesture = TapGestureRecognizer()
      ..onTap = () {
        print("Ta[ Detected");
        launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
      };


    var textSpan1 = TextSpan(text: 'This is no Link, ', style: new TextStyle(color: Colors.black),);
    var textSpan2 = TextSpan(text: 'but this is', style: new TextStyle(color: Colors.blue), recognizer: gesture,);
    var richTextSpan1 = RichText(text: TextSpan(children: [textSpan1, textSpan2]));
    */

    List<Map<String, StringCallback>> otherLinks = [];
    var callBack = (text) { this.showSnakeBar(context: this._scaffoldContext, message: "Click On Text ${text}"); };
    otherLinks.add({"link": callBack});

    var richTextSpan2 = ActionText(
      text: 'Hi, this is an example for both link example http://www.google.com and hashtag example #helloWorld user @user one',
      style: TextStyle(color: Colors.black, fontSize: 20.0),
      linkStyle: TextStyle(color: Colors.blue),
      tagStyle: TextStyle(color: Colors.red),
      mentionUserStyle: TextStyle(color: Colors.red),
      customTagStyle: TextStyle(color: Colors.grey),
      onOpen: (url) => this.showSnakeBar(context: this._scaffoldContext, message: "Click On ${url}"),
      onTagClick: (tag) => this.showSnakeBar(context: this._scaffoldContext, message: "Click On ${tag}"),
      onUserMensionClick: (tag) => this.showSnakeBar(context: this._scaffoldContext, message: "Click On Tag user ${tag}"),
      otherLinks: otherLinks,
    );

    var padding = Padding(padding: EdgeInsets.only(top: 100),);
    var colums = Column(children: <Widget>[padding, richTextSpan2], crossAxisAlignment: CrossAxisAlignment.center,);

    return Scaffold(
        appBar: appBar,
        body: new Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return Center(
            child: colums,
          );
        })
    );
  }

  //region show snakeBar
  void showSnakeBar({BuildContext context, String message}) {
    var snackBarContent = Text(message);
    var snakeBar = SnackBar(content: snackBarContent, duration: Duration(seconds: 2), backgroundColor: Colors.black,);
    Scaffold.of(context).showSnackBar(snakeBar);

  }
//endregion
}
