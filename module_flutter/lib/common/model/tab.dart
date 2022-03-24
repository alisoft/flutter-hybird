import 'package:json_annotation/json_annotation.dart';
part 'tab.g.dart';

@JsonSerializable()
class Tab {
  int? iconData;
  String? text;

  Tab({this.iconData, this.text});

  factory Tab.fromJson(Map<String, dynamic> json) => _$TabFromJson(json);
  Map<String, dynamic> toJson() => _$TabToJson(this);
}
