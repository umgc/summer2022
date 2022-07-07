// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_digest_files.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MailObject _$MailObjectFromJson(Map<String, dynamic> json) => MailObject(
      json['type'] as String,
      json['name'] as String,
      json['recipient'] as String,
      json['address'] as String,
      json['validated'] as String,
    );

Map<String, dynamic> _$MailObjectToJson(MailObject instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'address': instance.address,
      'validated': instance.validated,
    };

DescriptionObject _$DescriptionObjectFromJson(Map<String, dynamic> json) =>
    DescriptionObject(
      json['name'] as String,
    );

Map<String, dynamic> _$DescriptionObjectToJson(DescriptionObject instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

LogoObject _$LogoObjectFromJson(Map<String, dynamic> json) => LogoObject(
      DescriptionObject.fromJson(json['description'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LogoObjectToJson(LogoObject instance) =>
    <String, dynamic>{
      'description': instance.description.toJson(),
    };

CodeObject _$CodeObjectFromJson(Map<String, dynamic> json) => CodeObject(
      json['codeType'] as String,
      json['link'] as String,
    );

Map<String, dynamic> _$CodeObjectToJson(CodeObject instance) =>
    <String, dynamic>{
      'codeType': instance.codeType,
      'link': instance.link,
    };

DailyDigestFile _$DailyDigestFileFromJson(Map<String, dynamic> json) =>
    DailyDigestFile(
      (json['mailObjects'] as List<dynamic>)
          .map((e) => MailObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['logoObjects'] as List<dynamic>)
          .map((e) => LogoObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['codeObjects'] as List<dynamic>)
          .map((e) => CodeObject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyDigestFileToJson(DailyDigestFile instance) =>
    <String, dynamic>{
      'mailObject': instance.mailObjects.map((e) => e.toJson()).toList(),
      'logoObject': instance.logoObjects.map((e) => e.toJson()).toList(),
      'codeObject': instance.codeObjects.map((e) => e.toJson()).toList(),
    };
