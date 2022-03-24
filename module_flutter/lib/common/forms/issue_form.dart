import 'package:module_flutter/common/utils/string_util.dart';

class IssueForm {
  final String? title;
  final String? body;

  IssueForm({this.title, this.body});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (StringUtil.isNotNull(title)) {
      data['title'] = title;
    }

    if (StringUtil.isNotNull(body)) {
      data['body'] = body;
    }
    return data;
  }
}
