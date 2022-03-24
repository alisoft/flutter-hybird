import 'package:module_flutter/common/utils/string_util.dart';

class UserForm {
  final String? name;
  final String? email;
  final String? blog;
  final String? company;
  final String? location;
  final bool hireable;
  final String? bio;

  UserForm(
      {this.name,
      this.email,
      this.blog,
      this.company,
      this.location,
      this.hireable = false,
      this.bio});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (StringUtil.isNotNull(name)) {
      data['name'] = name;
    }

    if (StringUtil.isNotNull(email)) {
      data['email'] = email;
    }

    if (StringUtil.isNotNull(blog)) {
      data['blog'] = blog;
    }

    if (StringUtil.isNotNull(company)) {
      data['company'] = company;
    }

    if (StringUtil.isNotNull(location)) {
      data['location'] = location;
    }

    if (StringUtil.isNotNull(bio)) {
      data['bio'] = bio;
    }

    data['hireable'] = hireable;

    return data;
  }
}
