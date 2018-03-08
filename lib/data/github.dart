import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GithubClient {
  static const String GITHUB_USERNAME = 'github_username';
  static const String GITHUB_AUTH_TOKEN = 'github_auth_token';

  static const String GITHUB_CLIENT_ID = 'e0c1640074d6e23acecd';
  static const String GITHUB_CLIENT_SECRET = '79537f81e49da27a7a219da617728a009a770ee1';

  final Client _client = new Client();
  bool _initialized;
  bool _loggedIn;
  String _username;
  String _token = "undefine";

  OauthClient _oauthClient;

  bool get initialized => _initialized;

  String get username => _username;

  String get token => _token;

  bool get loggedIn => _loggedIn;

  OauthClient get oauthClient => _oauthClient;

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(GITHUB_USERNAME);
    String oauthToken = prefs.getString(GITHUB_AUTH_TOKEN);

    if (username == null || oauthToken == null) {
      _loggedIn = false;
      await logout();
    } else {
      _loggedIn = true;
      _username = username;
      _oauthClient = new OauthClient(_client, oauthToken);
    }

    _initialized = true;
  }

  Future<bool> login(String username, String password) async {
    var basicToken = _getEncodedAuthorization(username, password);
    final requestHeader = {'Authorization': 'Basic $basicToken'};

    final requestBody = JSON.encode({
      'client_id': GITHUB_CLIENT_ID,
      'client_secret': GITHUB_CLIENT_SECRET,
      'scopes': ['user', 'repo', 'notifications']
    });

    final loginResponse = await _client.post(
      'https://api.github.com/authorizations',
      headers: requestHeader,
      body: requestBody
    ).whenComplete(_client.close);

    if (loginResponse.statusCode == 201) {
      final bodyJson = JSON.decode(loginResponse.body);
      _token = bodyJson['token'];
      await _saveTokens(username, bodyJson['token']);
      _loggedIn = true;
    } else {
      _loggedIn = false;
    }

    return _loggedIn;
  }

  Future logout() async {
    await _saveTokens(null, null);
    _loggedIn = false;
  }

  Future _saveTokens(String username, String oauthToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GITHUB_USERNAME, username);
    prefs.setString(GITHUB_AUTH_TOKEN, oauthToken);
    await prefs.commit();
    _username = username;
    _oauthClient = new OauthClient(_client, oauthToken);
  }

  String _getEncodedAuthorization(String username, String password) {
    final authorizationBytes = UTF8.encode('$username:$password');
    return BASE64.encode(authorizationBytes);
  }
}

class OauthClient extends _AuthClient {
  OauthClient(Client client, String token) : super(client, 'token $token');
}

abstract class _AuthClient extends BaseClient {

  final Client _client;
  final String _authorization;

  _AuthClient(this._client, this._authorization);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // TODO: implement send
    request.headers['Authorization'] = _authorization;
    return _client.send(request);
  }
}