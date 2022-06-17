import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/vision/v1.dart';
import './models/Logo.dart';
import './models/Response.dart';

class CredentialsProvider {
  CredentialsProvider();

  Future<ServiceAccountCredentials> get _credentials async {
    String _file = await rootBundle.loadString('assets/credentials.json');
    return ServiceAccountCredentials.fromJson(_file);
  }

  Future<AutoRefreshingAuthClient> get client async {
    AutoRefreshingAuthClient _client = await clientViaServiceAccount(
        await _credentials, [VisionApi.cloudVisionScope]);
    // await _credentials, [VisionApi.CloudVisionScope]).then((c) => c);
    return _client;
  }
}

class Block {
  List<String> list = [];
  Block();
  void add(String s) {
    list.add(s);
  }

  List<String> getList() {
    return list;
  }
}

class CloudVisionApi {
  final _client = CredentialsProvider().client;

  // Future<WebLabel> search(String image) async {
  //   var _vision = VisionApi(await _client);
  //   var _api = _vision.images;

  //   var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
  //     "requests": [
  //       // {
  //       //   "features": [
  //       //     {"type": "TEXT_DETECTION"}
  //       //   ],
  //       //   "image": {
  //       //     "source": {
  //       //       "imageUri":
  //       //           //"gs://mybucket_20220607/28a705a8-0868-4770-9f57-3f59960869997954911254635801631.jpg"
  //       //           "gs://visionbucket_20220609/unnamed.jpg"
  //       //     }
  //       //   },
  //       // }
  //     ]
  //   }));
  //   WebLabel _bestGuessLabel;
  //   //print(1);
  //   //print(_response.toJson());
  //   // _response.responses.forEach((data) {
  //   //   print(data.fullTextAnnotation.toJson().toString());
  //   // });
  //   // print(2);

  //   return _bestGuessLabel;
  // }
  Future<MailResponse> search(String image) async {
    List<AddressObject>? addresses = await searchImageForText(image);
    List<LogoObject>? logos = await searchImageForLogo(image);
    MailResponse response = MailResponse(addresses: addresses, logos: logos);
    return response;
  }

  Future<List<AddressObject>> searchImageForText(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    String s = '';
    List<Block> blocks = [];

    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image},
          "features": [
            {"type": "TEXT_DETECTION"},
          ]
        }
      ]
    }));
    print("Image to Text Search");
    if (_response.responses != null) {
      _response.responses!.forEach((data) {
        //print(data.fullTextAnnotation!.text);
        if (data.fullTextAnnotation != null) {
          if (data.fullTextAnnotation!.pages != null) {
            data.fullTextAnnotation!.pages!.forEach((page) {
              if (page.blocks != null) {
                if (page.blocks != null) {
                  page.blocks!.forEach((block) {
                    if (block.paragraphs != null) {
                      block.paragraphs!.forEach((paragraph) {
                        s += "-----------\n";
                        String p = '';
                        Block block = Block();
                        bool isBlockComplete = false;
                        if (paragraph.property?.detectedBreak?.type != null) {
                          if (paragraph.property?.detectedBreak?.type ==
                              "LINE_BREAK") {
                            s += '\n';
                            block.add(p);
                            p = '';
                          }
                        }
                        if (paragraph.words != null) {
                          paragraph.words!.forEach((word) {
                            //s += ' ';
                            if (word.symbols != null) {
                              word.symbols!.forEach((symbol) {
                                if (symbol.property?.detectedBreak!.type !=
                                    null) {
                                  if (symbol.property!.detectedBreak!.type ==
                                          "SURE_SPACE" ||
                                      symbol.property!.detectedBreak!.type ==
                                          "SPACE") {
                                    s += symbol.text.toString() + " ";
                                    p += symbol.text.toString() + " ";
                                  }
                                  if (symbol.property!.detectedBreak!.type ==
                                          "LINE_BREAK" ||
                                      symbol.property!.detectedBreak!.type ==
                                          "EOL_SURE_SPACE" ||
                                      symbol.property!.detectedBreak!.type ==
                                          "UNKNOWN") {
                                    s += symbol.text.toString() + "\n";
                                    p += symbol.text.toString();
                                    block.add(p);
                                    p = '';
                                  }
                                } else {
                                  s += symbol.text.toString();
                                  p += symbol.text.toString();
                                }
                              });
                            }
                          });
                        }
                        blocks.add(block);
                      });
                    }
                  });
                } else {}
              } else {}
            });
          } else {
            print("No Pages were found");
          }
        } else {
          print("No Full Text Annotation Object Found");
        }
      });
    } else {
      print("Image Text Search failed.");
    }
    print("Text Search done");
    // for (int x = 0; x < blocks.length; x++) {
    //   print("---------Block-----------");
    //   for (int y = 0; y < blocks.elementAt(x).getList().length; y++) {
    //     print(blocks.elementAt(x).getList().elementAt(y));
    //   }
    //   print("--------------------------");
    // }
    List<AddressObject> pB =
        parseBlocksForAddresses(blocks, findBlocksWithAddresses(blocks));
    pB.forEach((a) {
      print("--------Address----------");
      print('name: ${a.name}');
      print('address: ${a.address}');
      print('type: ${a.type}');
      print('validation: ${a.validated}');
      print("-------------------------");
    });

    //print(s);
    return pB;
  }

  List<AddressObject> parseBlocksForAddresses(List<Block> blocks, List<int> s) {
    List<AddressObject> addresses = [];
    print(s.length);
    for (int x = 0; x < s.length; x++) {
      String name1 = '';
      String address1 = '';
      String type1 = x == 0 ? 'sender' : 'recipient';
      if (blocks.elementAt(s.elementAt(x)).getList().length == 3) {
        name1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(0);
        address1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(1) +
            ', ' +
            blocks.elementAt(s.elementAt(x)).getList().elementAt(2);
      } else if (blocks.elementAt(s.elementAt(x)).getList().length == 4) {
        name1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(0);
        address1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(1) +
            ' ' +
            blocks.elementAt(s.elementAt(x)).getList().elementAt(2) +
            ', ' +
            blocks.elementAt(s.elementAt(x)).getList().elementAt(3);
      } else {
        print("did not fit into mail category");
      }
      AddressObject aO = AddressObject(
          type: type1, name: name1, address: address1, validated: false);
      addresses.add(aO);
    }

    return addresses;
  }

  // This function checks and determines which blocks contains an address
  List<int> findBlocksWithAddresses(List<Block> blocks) {
    RegExp regExp1 = new RegExp(r'\s\w{2}\s\d{5}$');
    RegExp regExp2 =
        new RegExp(r'\s\w{2}\s(\d{5})-(\d{4})$'); //ex MD 21144-1245
    List<int> s = [];
    for (int x = 0; x < blocks.length; x++) {
      // print("---------Block $x---------");
      bool zip = false;
      for (int y = 0; y < blocks.elementAt(x).getList().length; y++) {
        if (regExp1.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp2.hasMatch(blocks.elementAt(x).getList().elementAt(y))) {
          zip = true;
        }
        //print('$y:' + blocks.elementAt(x).getList().elementAt(y) + ' $zip');
      }
      // print("--------------------------");
      if (zip) s.add(x);
    }
    return s;
  }

  Future<List<LogoObject>> searchImageForLogo(String image) async {
    List<LogoObject> logos = [];
    var _vision = VisionApi(await _client);
    var _api = _vision.images;

    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image},
          "features": [
            {"type": "LOGO_DETECTION"},
          ]
        }
      ]
    }));
    print("Image Search for Logo");
    _response.responses!.forEach((data) {
      if (data.logoAnnotations != null) {
        data.logoAnnotations!.forEach((element) {
          print(element.description);
          logos.add(LogoObject(name: element.description as String));
        });
      } else {
        logos.add(LogoObject(name: "None"));
        print(logos.elementAt(0).getName);
        print("No Logos were found");
      }
    });
    print("Logo Search Done");

    return logos;
  }
}
