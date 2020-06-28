import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import '../helper/constants.dart';
import '../helper/net_utils.dart';
import '../helper/shared_preferences.dart';

class GithubService {
  Observable login() => get("user");
}

class GithubRepo {
  final GithubService _remote;

  final SpUtil _sp;

  GithubRepo(this._remote, this._sp);

  Observable login(String username, String password) {
    _sp.putString(
        KEY_TOKEN, "basic " + base64Encode(utf8.encode('$username:$password')));
    return _remote.login();
  }
}
