import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Card(
      child: new Container(
        margin: const EdgeInsets.all(10.0),
        child: new Column(
          /*mainAxisSize: MainAxisSize.min,*/
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              controller: _controller,
              decoration: new InputDecoration(
                hintText: '请输入用户名',
              ),
            ),
            /*new TextField(
              controller: _controller,
              decoration: new InputDecoration(
                hintText: '请输入密码',
              ),
            ),*/
            new RaisedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text('您输入的内容是'),
                    content: new Text(_controller.text),
                  ),
                );
              },
              child: new Text('确认'),
            ),
          ],
        ),
      ),
    );
  }
}
