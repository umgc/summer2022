import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import './Address.dart';
import './Logo.dart';
import './Code.dart';
part 'MailResponse.g.dart';

@JsonSerializable(explicitToJson: true)
class MailResponse {
  List<AddressObject> addresses = [];
  List<LogoObject> logos = [];
  List<codeObject> codes = [];

  //MailResponse({required addresses, required logos, required codes});
  MailResponse({required this.addresses, required this.logos});

  // static fromJson(Map<String, dynamic> parsedJson) {
  //   return MailResponse(
  //       addresses: parsedJson['addresses'],
  //       logos: LogoObject.fromJson(parsedJson['logos']));
  //   //codes: codeObject.listFromJson(parsedJson['codes']));
  // }
  factory MailResponse.fromJson(Map<String, dynamic> mail) =>
      _$MailResponseFromJson(mail);
  Map<String, dynamic> toJson() => _$MailResponseToJson(this);
}


 
// class AddressObject {
//   String type;
//   String name;
//   String address;
//   bool validated;
//   AddressObject(
//       {this.type = '',
//       this.name = '',
//       this.address = '',
//       this.validated = false});
//   bool get getValidated {
//     return validated;
//   }

//   String get getType {
//     return type;
//   }

//   String get getAddress {
//     return address;
//   }

//   String get getName {
//     return name;
//   }

//   static listFromJson(List<Map<String, dynamic>> list) {
//     List<LogoObject> departments = [];
//     for (var value in list) {
//       departments.add(LogoObject.fromJson(value));
//     }
//     return departments;
//   }

//   static fromJson(Map<String, dynamic> parsedJson) {
//     return AddressObject(
//         type: parsedJson["type"],
//         name: parsedJson["name"],
//         address: parsedJson["address"],
//         validated: parsedJson["validated"]);
//   }
// }

// class LogoObject {
//   late String name;
//   LogoObject({required name});

//   String get getName {
//     return name;
//   }

//   static listFromJson(List<Map<String, dynamic>> list) {
//     List<LogoObject> logos = [];
//     for (var value in list) {
//       logos.add(LogoObject.fromJson(value));
//     }
//     return logos;
//   }

//   static fromJson(Map<String, dynamic> parsedJson) {
//     return LogoObject(name: parsedJson["name"]);
//   }
// }

// class codeObject {
//   String? type;
//   String? info;
//   codeObject({required info, required type});
  
//   static listFromJson(List<Map<String, dynamic>> list) {
//     List<codeObject> codes = [];
//     for (var value in list) {
//       codes.add(codeObject.fromJson(value));
//     }
//     return codes;
//   }

//   static fromJson(Map<String, dynamic> parsedJson) {
//     return codeObject(type: parsedJson["type"], info: parsedJson["info"]);
//   }
// }
