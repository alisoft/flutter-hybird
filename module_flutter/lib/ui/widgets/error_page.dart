import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';

class ErrorPage extends StatelessWidget {
  final Function reload;

  const ErrorPage({Key? key, required this.reload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        reload();
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 24,
            ),
            Text(
                ModuleFlutterLocalizations.of(context)!.error,
            ),
          ],
        ),
      ),
    );
  }
}
