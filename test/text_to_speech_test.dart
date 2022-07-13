import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/content/v2_1.dart';
import 'package:summer2022/models/Address.dart';
import 'package:summer2022/models/Code.dart';
import 'package:summer2022/models/Logo.dart';
import 'package:summer2022/models/MailResponse.dart';
import 'package:summer2022/read_info.dart';
import 'dart:io' as io;

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;
  AddressObject address1 = AddressObject.fromJson({"type": "sender", "name": "GEICO", "address": "2563 Forest Dr; Annapolis, MD 21401", "validated": false});
  AddressObject address2 = AddressObject.fromJson({"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true});
  MailResponse mail = MailResponse.fromJson({"addresses": [{"type": "sender", "name": "GEICO", "address": "2563 Forest Dr; Annapolis, MD 21401", "validated": false}, {"type": "recipient", "name": "Deborah Keenan", "address": "1006 Morgan Station Dr; Severn, MD 21144-1245", "validated": true}], "logos": [{"name": "GEICO"}, {"name": "GEICO"}], "codes": [{"type": "url", "info": "https://geico.com"}]});
  

  group("ReadDigestMail Tests", () {
    
    test("getSenderAndRecipient", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.getSenderAndRecipient([address1, address2]);
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
      expect(readMail.sender, address1);
      expect(readMail.recipient, address2);
    });

    test("Read Digest Sender Name", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestSenderName();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Digest Recipient Name", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestRecipientName();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Digest Sender Address", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestSenderAddress();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Digest Recipient Address", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestRecipientAddress();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Digest Logos", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestLogos();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Digest Links", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestLinks();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Digest Sender Address Validated", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestSenderAddressValidated();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Digest Recipient Address Validated", () {
      String error = '';
      ReadDigestMail readMail = ReadDigestMail(mail);
      try {
        readMail.readDigestRecipientAddressValidated();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });
  });

  group("ReadMail Tests", () {
    test("Read Sender", () {
      String error = '';
      ReadMail readMail = ReadMail();
      try {
        readMail.readEmailSender();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Subject", () {
      String error = '';
      ReadMail readMail = ReadMail();
      try {
        readMail.readEmailSubject();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Text", () {
      String error = '';
      ReadMail readMail = ReadMail();
      try {
        readMail.readEmailText();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

    test("Read Recipients", () {
      String error = '';
      ReadMail readMail = ReadMail();
      try {
        readMail.readEmailRecipients();
      } catch (e) {
        error = e.toString();
      }
      expect(error, '');
    });

  });
}