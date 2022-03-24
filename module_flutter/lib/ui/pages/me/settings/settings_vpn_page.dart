import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:module_flutter/common/constant/me_constants.dart';
import 'package:module_flutter/common/utils/cache_util.dart';
import 'package:module_flutter/common/utils/logger_util.dart';

import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';
// import 'package:flutter_vpn/flutter_vpn.dart';

class SettingsVpnPage extends StatefulWidget {
  final String headerTitle;

  const SettingsVpnPage({Key? key, required this.headerTitle})
      : super(key: key);

  @override
  _SettingsVpnPageState createState() => _SettingsVpnPageState();
}

class _SettingsVpnPageState extends State<SettingsVpnPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  static const sizedBoxSpace = SizedBox(height: 24);

  @override
  void initState() {
    super.initState();
    CacheUtil.getCache(MeConstants.vpnAddress, checkValidTimes: false)
        .then((value) => {
              if (StringUtil.isNotBlank(value))
                {_addressController.text = value}
            });
    CacheUtil.getCache(MeConstants.vpnUsername, checkValidTimes: false)
        .then((value) => {
              if (StringUtil.isNotBlank(value))
                {_usernameController.text = value}
            });
    CacheUtil.getCache(MeConstants.vpnPassword, checkValidTimes: false)
        .then((value) => {
              if (StringUtil.isNotBlank(value))
                {_passwordController.text = value}
            });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => NavigatorUtil.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: Text(
          widget.headerTitle,
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          restorationId: 'text_field_demo_scroll_view',
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              sizedBoxSpace,
              TextFormField(
                controller: _addressController,
                restorationId: 'address_field',
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Address',
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              sizedBoxSpace,
              TextFormField(
                controller: _usernameController,
                restorationId: 'username_field',
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              sizedBoxSpace,
              PasswordField(
                restorationId: 'password_field',
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                fieldKey: _passwordFieldKey,
                helperText: 'Password',
                labelText: 'Password',
                onFieldSubmitted: (value) {},
              ),
              sizedBoxSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _handleConnect,
                    child: const Text('Connect'),
                  ),
                  ElevatedButton(
                    onPressed: _handleDisconnect,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                    ),
                    child: const Text('DisConnect'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleConnect() {
    printWarningLog(
        '${_addressController.text}-${_usernameController.text}-${_passwordController.text}');
    if (StringUtil.isBlank(_addressController.text)) {
      _showInSnackBar('地址不允许为空');
      return;
    }
    if (StringUtil.isBlank(_usernameController.text)) {
      _showInSnackBar('用户名不允许为空');
      return;
    }
    if (StringUtil.isBlank(_passwordController.text)) {
      _showInSnackBar('密码不允许为空');
      return;
    }
    CacheUtil.setCache(MeConstants.vpnAddress, _addressController.text);
    CacheUtil.setCache(MeConstants.vpnUsername, _usernameController.text);
    CacheUtil.setCache(MeConstants.vpnPassword, _passwordController.text);
    // FlutterVpn.simpleConnect(
    //   _addressController.text,
    //   _usernameController.text,
    //   _passwordController.text,
    // );
  }

  void _handleDisconnect() {
    // FlutterVpn.disconnect();
  }

  void _showInSnackBar(String value) {
    BotToast.showCustomNotification(
      toastBuilder: (cancelFunc) => Container(
        margin: const EdgeInsets.only(left: 16, right: 8),
        decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: ProfileItem(
          content: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
          leading: Container(
            padding: const EdgeInsets.only(left: 4, right: 6),
            child: const Icon(
              Icons.error,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.restorationId,
    required this.controller,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
  }) : super(key: key);

  final String restorationId;
  final TextEditingController controller;
  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> with RestorationMixin {
  final RestorableBool _obscureText = RestorableBool(true);

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      key: widget.fieldKey,
      restorationId: 'password_text_field',
      obscureText: _obscureText.value,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText.value = !_obscureText.value;
            });
          },
          child: Icon(
            _obscureText.value ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText.value ? '显示密码' : '隐藏密码',
          ),
        ),
      ),
    );
  }
}
