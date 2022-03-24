import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/pages/tab_navigator.dart';
import 'package:module_flutter/common/constant/module_flutter_constants.dart';
import 'package:module_flutter/common/module_flutter_manager.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/utils/object_util.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      // todo
      // FlutterBoilerplateManager().user = user;
      //         await CacheUtil.setCache(
      //             FlutterBoilerplateConstants.authorizationEmail, data.name);
      //         await CacheUtil.setCache(
      //             FlutterBoilerplateConstants.authorizationPassword, data.password);
      //         NavigatorUtil.pushReplacement(context, const TabNavigator());
      NavigatorUtil.pushReplacement(context, const TabNavigator());
    } catch (e) {
      printErrorLog(e);
    }
    return null;
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      // todo
      // await CacheUtil.setCache(
      //     FlutterBoilerplateConstants.authorizationEmail, StringUtil.empty);
      // await CacheUtil.setCache(
      //     FlutterBoilerplateConstants.authorizationPassword, StringUtil.empty);
      // NavigatorUtil.pushReplacement(context, const LoginPage());
    } catch (e) {
      printErrorLog(e);
    }
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    if (ObjectUtil.isNull(data.name)) {
      return "email is empty";
    }
    if (ObjectUtil.isNull(data.password)) {
      return "password is empty";
    }
    try {
      // todo
      //FlutterBoilerplateManager().user = user;
      //         await CacheUtil.setCache(
      //             FlutterBoilerplateConstants.authorizationEmail, data.name);
      //         await CacheUtil.setCache(
      //             FlutterBoilerplateConstants.authorizationPassword, data.password);
      //         NavigatorUtil.pushReplacement(context, const TabNavigator());
    } catch (e) {
      printErrorLog(e);
    }
    return null;
  }

  Future<String?> _signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'flutter-sign-in-with-apple-example.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': appleCredential.authorizationCode,
        if (appleCredential.givenName != null)
          'firstName': appleCredential.givenName!,
        if (appleCredential.familyName != null)
          'lastName': appleCredential.familyName!,
        'useBundleId':
        Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
        if (appleCredential.state != null) 'state': appleCredential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    try {
      // FlutterBoilerplateManager().user = user;
      //         NavigatorUtil.pushReplacement(context, const TabNavigator());
    } catch (e) {
      printErrorLog(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return FlutterLogin(
      title: ModuleFlutterConstants.appName,
      theme: LoginTheme(
        pageColorDark: _theme.colorScheme.background,
        pageColorLight: _theme.colorScheme.background,
        titleStyle: TextStyle(fontSize: 24, color: _theme.primaryColor),
      ),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        if (Platform.isIOS) ...[
          LoginProvider(
            icon: FontAwesomeIcons.appleAlt,
            callback: _signInWithApple,
          ),
        ],
      ],
      onRecoverPassword: _recoverPassword,
      footer:
          '${ModuleFlutterManager().version}+${ModuleFlutterManager().buildNumber}\n',
    );
  }
}
