import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'Code.g.dart';

@JsonSerializable()
class codeObject {
  String type;
  String info;
  codeObject({this.info = '', this.type = ''});
  String get getType {
    return type;
  }

  String get getInfo {
    return info;
  }
  // }
  // static listFromJson(List<Map<String, dynamic>> list) {
  //   List<codeObject> codes = [];
  //   for (var value in list) {
  //     codes.add(codeObject.fromJson(value));
  //   }
  //   return codes;
  // }

  // static fromJson(Map<String, dynamic> parsedJson) {
  //   return codeObject(type: parsedJson["type"], info: parsedJson["info"]);
  // }
  factory codeObject.fromJson(Map<String, dynamic> code) =>
      _$codeObjectFromJson(code);
  Map<String, dynamic> toJson() => _$codeObjectToJson(this);
}
