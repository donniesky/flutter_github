import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_github/data/github.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final GithubClient _client = new GithubClient();

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState(_client);
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  final GithubClient _client;

  _MyHomePageState(this._client);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    await _client.init();
  }

  void _handleLogin(BuildContext context) {
    _client
        .login(_usernameController.text, _passwordController.text)
        .then((success) {
      if (success) {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(_client.token)));
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('get token error !')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      backgroundColor: Colors.green[500],
      body: new Container(
        margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 30.0),
        alignment: Alignment.bottomCenter,
        child: new Card(
          child: new Container(
            margin: const EdgeInsets.all(10.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new TextField(
                  controller: _usernameController,
                  decoration: new InputDecoration(
                    hintText: '请输入用户名',
                  ),
                ),
                new TextField(
                  controller: _passwordController,
                  decoration: new InputDecoration(
                    hintText: '请输入密码',
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  alignment: Alignment.centerRight,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new FlatButton(
                        onPressed: () => _handleLogin(context),
                        child: new Text(
                          '登录',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      new FlatButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            child: new AlertDialog(
                              title: new Text('您输入的内容是'),
                              content: new Text(_passwordController.text),
                            ),
                          );
                        },
                        child: new Text(
                          '注册',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
