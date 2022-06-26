import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/vision/v1.dart';
import 'models/MailResponse.dart';
import './models/Address.dart';
import './models/Logo.dart';
import 'dart:convert';

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
  //Combines Addresses and logos into a mailObject for UI to parse.
  Future<MailResponse> search(String image) async {
    List<AddressObject>? addresses = await searchImageForText(image);
    //print(addresses[0].toJson());
    //print(addresses[1].toJson());
    List<LogoObject>? logos = await searchImageForLogo(image);
    //print(logos[0].toJson());
    // if (logos.first == null) {
    //   logos.add(LogoObject("none"));
    // }
    MailResponse response = MailResponse(addresses: addresses, logos: logos);
    print(response.toJson().toString());
    return response;
  }

  //This function looks for text in image and returns a List of Addresses Found
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
    for (int x = 0; x < blocks.length; x++) {
      print("---------Block $x---------");
      for (int y = 0; y < blocks.elementAt(x).getList().length; y++) {
        print(blocks.elementAt(x).getList().elementAt(y));
      }
      print("--------------------------");
    }
    List<int> sB = findBlocksWithAddresses(blocks);
    for (int sb = 0; sb < sB.length; sb++) {
      int z = sB[sb];
      if (blockHasPostage(blocks.elementAt(z))) {
        sB.removeAt(sb);
      }
    }

    List<AddressObject> pB =
        // parseBlocksForAddresses(blocks, findBlocksWithAddresses(blocks));

        parseBlocksForAddresses2(blocks, sB);

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

  // //This function goes through all blocks using the index provided to find all addresses and put them into a List of AddressObject
  // List<AddressObject> parseBlocksForAddresses(List<Block> blocks, List<int> s) {
  //   List<AddressObject> addresses = [];
  //   print(s.length);
  //   for (int x = 0; x < s.length; x++) {
  //     String name1 = '';
  //     String address1 = '';
  //     String type1 = x == 0 ? 'sender' : 'recipient';
  //     if (blocks.elementAt(s.elementAt(x)).getList().length == 3) {
  //       int cityStateZipIndex =
  //           findLineWithCityStateZip(blocks.elementAt(s.elementAt(x)));
  //       int addy1 = findLineWithAddress1(blocks.elementAt(s.elementAt(x)));

  //       // print('cityStateZip: ' + cityStateZipIndex.toString());
  //       // print('addy1: ' + addy1.toString());
  //       name1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(0);
  //       if (addy1 == 0 &&
  //           RegExp(r'^[A-Z][A-Za-z]+\s\w+').hasMatch(
  //               blocks.elementAt(s.elementAt(x) - 1).getList().last)) {
  //         name1 = blocks.elementAt(s.elementAt(x) - 1).getList().last;
  //       }
  //       if (cityStateZipIndex != -1 || addy1 != -1) {
  //         for (int z = addy1; z <= cityStateZipIndex; z++) {
  //           address1 +=
  //               blocks.elementAt(s.elementAt(x)).getList().elementAt(z) + ' ';
  //         }
  //       }
  //       // print('test: ' +
  //       //     findLineWithCityStateZip(blocks.elementAt(s.elementAt(x)))
  //       //         .toString());
  //     } else if (blocks.elementAt(s.elementAt(x)).getList().length == 4) {
  //       name1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(0);
  //       address1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(1) +
  //           ' ' +
  //           blocks.elementAt(s.elementAt(x)).getList().elementAt(2) +
  //           ', ' +
  //           blocks.elementAt(s.elementAt(x)).getList().elementAt(3);
  //     } else if (blocks.elementAt(s.elementAt(x)).getList().length == 2) {
  //       // name1 = 'Name not Found ' +
  //       //     blocks.elementAt(s.elementAt(x)).getList().length.toString();

  //       int cityStateZipIndex =
  //           findLineWithCityStateZip(blocks.elementAt(s.elementAt(x)));
  //       int addy1 = findLineWithAddress1(blocks.elementAt(s.elementAt(x)));
  //       if (addy1 == 0 &&
  //           RegExp(r'^[A-Z][A-Za-z]+\s\w+').hasMatch(
  //               blocks.elementAt(s.elementAt(x) - 1).getList().last)) {
  //         name1 = blocks.elementAt(s.elementAt(x) - 1).getList().last;
  //       }
  //       // print("index" + x.toString());
  //       // print('cityStateZip: ' + cityStateZipIndex.toString());
  //       // print('addy1: ' + addy1.toString());
  //       if (cityStateZipIndex != -1 || addy1 != -1) {
  //         for (int z = addy1; z <= cityStateZipIndex; z++) {
  //           address1 +=
  //               blocks.elementAt(s.elementAt(x)).getList().elementAt(z) + ' ';
  //         }
  //       }
  //       // address1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(0) +
  //       //     ' ' +
  //       //     blocks.elementAt(s.elementAt(x)).getList().elementAt(1);
  //     } else if (blocks.elementAt(s.elementAt(x)).getList().length == 1) {
  //       // name1 = 'Name not found ' +
  //       //     blocks.elementAt(s.elementAt(x)).getList().length.toString();
  //       //address1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(0);
  //       int cityStateZipIndex =
  //           findLineWithCityStateZip(blocks.elementAt(s.elementAt(x)));
  //       int addy1 = findLineWithAddress1(blocks.elementAt(s.elementAt(x)));
  //       print("index" + x.toString());
  //       print('cityStateZip: ' + cityStateZipIndex.toString());
  //       print('addy1: ' + addy1.toString());
  //       if (addy1 == 0 &&
  //           RegExp(r'^[A-Z][A-Za-z]+\s\w+').hasMatch(
  //               blocks.elementAt(s.elementAt(x) - 1).getList().last)) {
  //         name1 = blocks.elementAt(s.elementAt(x) - 1).getList().last;
  //       }
  //       if (addy1 == -1 &&
  //           RegExp(r'\sBOX\s\d{1,}').hasMatch(blocks
  //               .elementAt(s.elementAt(x) - 1)
  //               .getList()
  //               .last
  //               .toUpperCase()) &&
  //           cityStateZipIndex != -1) {
  //         address1 = blocks.elementAt(s.elementAt(x) - 1).getList().last +
  //             ', ' +
  //             blocks.elementAt(s.elementAt(x)).getList().last;
  //       }
  //       if (addy1 == cityStateZipIndex) {
  //         address1 =
  //             blocks.elementAt(s.elementAt(x)).getList().elementAt(addy1);
  //       }
  //     } else {
  //       print("did not fit into mail category");
  //     }
  //     AddressObject aO = AddressObject(
  //         type: (s.length == 1) ? 'recipient' : type1,
  //         name: name1,
  //         address: address1,
  //         validated: false);
  //     addresses.add(aO);
  //   }
  //   if (addresses.length > 2) {
  //     for (int x = 0; x < addresses.length - 1; x++) {
  //       addresses.elementAt(x).type = 'sender';
  //     }
  //     addresses.last.type = 'recipient';
  //   }

  //   return addresses;
  // }

  List<AddressObject> parseBlocksForAddresses2(
      List<Block> blocks, List<int> b) {
    List<AddressObject> addresses = [];
    print(b.length);
    for (int x = 0; x < b.length; x++) {
      String name1 = '';
      String address1 = '';
      String type1 = x == 0 ? 'sender' : 'recipient';
      int cityStateZipIndex =
          findLineWithCityStateZip(blocks.elementAt(b.elementAt(x)));
      int addy1 = findLineWithAddress1(blocks.elementAt(b.elementAt(x)));
      if (blocks.elementAt(b.elementAt(x)).getList().length == 1) {
        if (addy1 == 0 &&
            validateNameHasNoSpecialSymbols(
                blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
          if (x > 0) {
            name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
          }
        }
        if (addy1 == -1 &&
            (validateAddress1(
                blocks.elementAt(b.elementAt(x) - 1).getList().last)) &&
            cityStateZipIndex != -1) {
          address1 = blocks.elementAt(b.elementAt(x) - 1).getList().last +
              ' ' +
              blocks.elementAt(b.elementAt(x)).getList().last;
          int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;
          if (size >= 2) {
            name1 = blocks
                .elementAt(b.elementAt(x) - 1)
                .getList()
                .elementAt(size - 2);
          }
        }
        if (addy1 == cityStateZipIndex &&
            (addy1 != -1 || cityStateZipIndex != -1)) {
          if (blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1) ==
              blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(cityStateZipIndex))
            address1 =
                blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1);
        }
        if (cityStateZipIndex >= 0 && addy1 == -1) {
          int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;

          address1 = blocks
                  .elementAt(b.elementAt(x) - 1)
                  .getList()
                  .elementAt(size - 1) +
              " " +
              blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(cityStateZipIndex);
          if (size > 2 &&
              validateNameHasNoSpecialSymbols(blocks
                  .elementAt(b.elementAt(x) - 1)
                  .getList()
                  .elementAt(size - 2))) {
            name1 = blocks
                .elementAt(b.elementAt(x) - 1)
                .getList()
                .elementAt(size - 2);
          }
          if (size == 1 &&
              validateNameHasNoSpecialSymbols(
                  blocks.elementAt(b.elementAt(x) - 2).getList().last)) {
            name1 = blocks.elementAt(b.elementAt(x) - 2).getList().last;
          }
        }
        // if (cityStateZipIndex != -1 || addy1 != -1) {
        //   for (int z = addy1; z <= cityStateZipIndex; z++) {
        //     address1 +=
        //         blocks.elementAt(b.elementAt(x)).getList().elementAt(z) + ' ';
        //   }
        // }
      } else if (blocks.elementAt(b.elementAt(x)).getList().length == 2) {
        // bool nameVal = validateNameHasNoSpecialSymbols(
        //     blocks.elementAt(b.elementAt(x) - 1).getList().last);
        // if (addy1 == 0 && validateNameHasNoSpecialSymbols(
        //      blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
        //   name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
        // } else if (addy1 == -1) {
        // } else if (nameVal) {
        //   name1 = blocks.elementAt(b.elementAt(x)).getList().elementAt(0);
        // } else {}

        if (cityStateZipIndex != -1 && addy1 != -1) {
          for (int z = addy1; z <= cityStateZipIndex; z++) {
            address1 +=
                blocks.elementAt(b.elementAt(x)).getList().elementAt(z) + ' ';

            if (addy1 == 0 && b.elementAt(0) != 0) {
              if (validateNameHasNoSpecialSymbols(
                  blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
                name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
              }
            }
          }
        }
        //need to look into
        //  else if (cityStateZipIndex > 0 && addy1 == -1) {
        //   for (int y = cityStateZipIndex; y >= 0; y--) {
        //     int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;
        //      address1 =
        //           blocks.elementAt(b.elementAt(x)).getList().elementAt(y) +
        //               ' ' +
        //               address1;
        //     if (validateAddress1(
        //         blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
        //       address1 =
        //           blocks.elementAt(b.elementAt(x)).getList().elementAt(y) +
        //               ' ' +
        //               address1;
        //     }
        //   }
        // }
        else if (cityStateZipIndex == 0 && addy1 == -1) {
          address1 = blocks
              .elementAt(b.elementAt(x))
              .getList()
              .elementAt(cityStateZipIndex);
          int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;
          if (size == 2 &&
              validateAddress1(blocks
                  .elementAt(b.elementAt(x) - 1)
                  .getList()
                  .elementAt(size - 1))) {
            address1 = blocks
                    .elementAt(b.elementAt(x) - 1)
                    .getList()
                    .elementAt(size - 1) +
                ' ' +
                address1;
            if (validateNameHasNoSpecialSymbols(blocks
                .elementAt(b.elementAt(x) - 1)
                .getList()
                .elementAt(size - 1))) {
              name1 = blocks
                  .elementAt(b.elementAt(x) - 1)
                  .getList()
                  .elementAt(size - 2);
            }
          }

          if (size == 1 &&
              validateNameHasNoSpecialSymbols(
                  blocks.elementAt(b.elementAt(x) - 2).getList().last)) {
            name1 = blocks.elementAt(b.elementAt(x) - 2).getList().last;
          }
          // if(size == 2 && validateNameHasNoSpecialSymbols(line))
          // {

          // }
        }

        // address1 = blocks.elementAt(s.elementAt(x)).getList().elementAt(0) +
        //     ' ' +
        //     blocks.elementAt(s.elementAt(x)).getList().elementAt(1);
      } else if (blocks.elementAt(b.elementAt(x)).getList().length == 3) {
        // print('cityStateZip: ' + cityStateZipIndex.toString());
        // print('addy1: ' + addy1.toString());
        //name1 = blocks.elementAt(b.elementAt(x)).getList().elementAt(0);
        if (addy1 == 0 &&
            validateNameHasNoSpecialSymbols(
                blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
          name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
        } else if (addy1 >= 1 &&
            validateNameHasNoSpecialSymbols(blocks
                .elementAt(b.elementAt(x))
                .getList()
                .elementAt(addy1 - 1))) {
          name1 =
              blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1 - 1);
        }
        if (cityStateZipIndex != -1 || addy1 != -1) {
          for (int z = addy1; z <= cityStateZipIndex; z++) {
            address1 +=
                blocks.elementAt(b.elementAt(x)).getList().elementAt(z) + ' ';
          }
        }
        // print('test: ' +
        //     findLineWithCityStateZip(blocks.elementAt(s.elementAt(x)))
        //         .toString());
      } else if (blocks.elementAt(b.elementAt(x)).getList().length == 4) {
        if (addy1 == 0 &&
            validateAddress1(
                blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
          name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
        } else if (addy1 >= 1 &&
            validateNameHasNoSpecialSymbols(blocks
                .elementAt(b.elementAt(x))
                .getList()
                .elementAt(addy1 - 1))) {
          name1 =
              blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1 - 1);
        }
        if (cityStateZipIndex != -1 || addy1 != -1) {
          for (int z = addy1; z <= cityStateZipIndex; z++) {
            address1 +=
                blocks.elementAt(b.elementAt(x)).getList().elementAt(z) + ' ';
          }
        }
      } else if (blocks.elementAt(b.elementAt(x)).getList().length == 5) {
        if (addy1 == 0 &&
            validateAddress1(
                blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
          name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
        } else if (addy1 >= 1 &&
            validateNameHasNoSpecialSymbols(blocks
                .elementAt(b.elementAt(x))
                .getList()
                .elementAt(addy1 - 1))) {
          name1 =
              blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1 - 1);
        }
        if (cityStateZipIndex != -1 || addy1 != -1) {
          for (int z = addy1; z <= cityStateZipIndex; z++) {
            address1 +=
                blocks.elementAt(b.elementAt(x)).getList().elementAt(z) + ' ';
          }
        }
      } else {
        print("did not fit into mail category");
      }
      if (name1.isNotEmpty || address1.isNotEmpty) {
        AddressObject aO = AddressObject(
            type: (b.length == 1) ? 'recipient' : type1,
            name: name1,
            address: address1,
            validated: false);
        addresses.add(aO);
      }
    }
    if (addresses.length > 2) {
      for (int x = 0; x < addresses.length - 1; x++) {
        addresses.elementAt(x).type = 'sender';
      }
      addresses.last.type = 'recipient';
    }

    return addresses;
  }

  bool blockHasPostage(Block block) {
    RegExp regExp1 = new RegExp(r'U.S. POSTAGE');
    RegExp regExp2 = new RegExp(r'US POSTAGE');
    RegExp regExp3 = new RegExp(r'USPOSTAGE');

    for (int y = 0; y < block.getList().length; y++) {
      if (regExp1.hasMatch(block.getList().elementAt(y).toUpperCase()) ||
          regExp2.hasMatch(block.getList().elementAt(y).toUpperCase()) ||
          regExp3.hasMatch(block.getList().elementAt(y).toUpperCase())) {
        return true;
      }
    }
    return false;
  }

  bool validateNameHasNoSpecialSymbols(String line) {
    RegExp regExp1 = new RegExp(r'[a-zA-Z0-9.\ ]+$');
    RegExp regExp3 = new RegExp(r'[\!\@\#\$\%\^\&\*\(\)\{\}\[\]\<\>\/\?\~\+]');
    if (regExp3.hasMatch(line.toUpperCase())) {
      return false;
    }
    if (regExp1.hasMatch(line)) {
      return true;
    }
    return false;
  }

  bool validateCityStateZip(String line) {
    RegExp regExp1 = new RegExp(r'\w+\s[A-z]+\s\d{5}$');
    RegExp regExp2 = new RegExp(r'\w+\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp3 = new RegExp(r'\w+,\s[A-z]+\s\d{5}$');
    RegExp regExp4 = new RegExp(r'\w+,\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp5 = new RegExp(r'\w+,\s[A-z]+\.\s\d{5}$');
    RegExp regExp6 = new RegExp(r'\w+\s[A-z]+\.\s\d{5}$');
    if (regExp1.hasMatch(line) ||
        regExp2.hasMatch(line) ||
        regExp3.hasMatch(line) ||
        regExp4.hasMatch(line) ||
        regExp5.hasMatch(line) ||
        regExp6.hasMatch(line)) {
      return true;
    }
    return false;
  }

  int findLineWithCityStateZip(Block block) {
    RegExp regExp1 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}$');
    RegExp regExp2 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp3 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}$');
    RegExp regExp4 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp5 = new RegExp(r'[A-z]+,\s[A-z]+\.\s\d{5}$');
    RegExp regExp6 = new RegExp(r'[A-z]+\s[A-z]+\.\s\d{5}$');

    for (int x = 0; x < block.getList().length; x++) {
      if (regExp1.hasMatch(block.getList().elementAt(x)) ||
          regExp2.hasMatch(block.getList().elementAt(x)) ||
          regExp3.hasMatch(block.getList().elementAt(x)) ||
          regExp4.hasMatch(block.getList().elementAt(x)) ||
          regExp5.hasMatch(block.getList().elementAt(x)) ||
          regExp6.hasMatch(block.getList().elementAt(x))) {
        return x;
      }
    }
    return -1;
  }

  bool validateAddress1(String line) {
    RegExp regExp1 = new RegExp(r'^\d+\s[a-zA-Z]+');
    RegExp regExp2 = new RegExp(r'BOX\s\d+');
    RegExp regExp3 = new RegExp(r'[\!\@\#\$\%\^\&\*\(\)\{\}\[\]\<\>\/\?\~\+]');
    if (regExp3.hasMatch(line.toUpperCase())) {
      return false;
    } else if (regExp1.hasMatch(line.toUpperCase()) ||
        regExp2.hasMatch(line.toUpperCase())) {
      return true;
    } else
      return false;
  }

  int findLineWithAddress1(Block block) {
    RegExp regExp1 = new RegExp(r'^\d+\s[a-zA-Z]+');
    RegExp regExp2 = new RegExp(r'BOX\s\d+');
    RegExp regExp3 = new RegExp(r'[\!\#\$\%\^\&\*\(\)\{\}\[\]\<\>\/\?\~\+]');

    for (int x = 0; x < block.getList().length; x++) {
      if (regExp1.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp2.hasMatch(block.getList().elementAt(x).toUpperCase())) {
        return x;
      }
      // if (regExp3.hasMatch(block.getList().elementAt(x).toUpperCase())) {
      //   return -1;
      // }
    }
    return -1;
    // for (int x = 0; x < block.getList().length; x++) {
    //   if (validateAddress1(block.getList().elementAt(x))) {
    //     return x;
    //   }
    // }
    // return -1;
  }

  // This function checks and determines which blocks contains zip
  List<int> findBlocksWithAddresses(List<Block> blocks) {
    // RegExp regExp1 = new RegExp(r'\w+\s\w+\s\d{5}$');
    // RegExp regExp2 = new RegExp(r'\w+\s\w+\s\d{5}-(\d{4})$'); //ex MD 21144-1245
    // RegExp regExp3 = new RegExp(r'\w+,\s\w+\s\d{5}$');
    // RegExp regExp4 = new RegExp(r'\w+,\s\w+\s\d{5}-(\d{4})$');
    // RegExp regExp5 = new RegExp(r'\w+,\s\w+\.\s\d{5}$');
    // RegExp regExp6 = new RegExp(r'\w+\s\w+\.\s\d{5}$');
    RegExp regExp1 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}$');
    RegExp regExp2 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp3 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}$');
    RegExp regExp4 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp5 = new RegExp(r'[A-z]+,\s[A-z]+\.\s\d{5}$');
    RegExp regExp6 = new RegExp(r'[A-z]+\s[A-z]+\.\s\d{5}$');
    List<int> s = [];
    for (int x = 0; x < blocks.length; x++) {
      // print("---------Block $x---------");
      bool zip = false;
      int f = findLineWithCityStateZip(blocks.elementAt(x));
      for (int y = 0; y < blocks.elementAt(x).getList().length; y++) {
        if (regExp1.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp2.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp3.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp4.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp5.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp6.hasMatch(blocks.elementAt(x).getList().elementAt(y))) {
          zip = true;
        }
        //print('$y:' + blocks.elementAt(x).getList().elementAt(y) + ' $zip');
      }
      // print("--------------------------");
      if (zip) s.add(x);
    }
    return s;
  }

  List<int> findBlocksWithAddresses1(List<Block> blocks) {
    RegExp regExp1 = new RegExp(r'^\d+\s\w+');
    RegExp regExp2 = new RegExp(r'\BOX\s\d+');
    List<int> s = [];
    for (int x = 0; x < blocks.length; x++) {
      // print("---------Block $x---------");
      bool zip = false;
      int f = findLineWithCityStateZip(blocks.elementAt(x));
      for (int y = 0; y < blocks.elementAt(x).getList().length; y++) {
        if (regExp1.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp2.hasMatch(
                blocks.elementAt(x).getList().elementAt(y).toUpperCase())) {
          zip = true;
        }
        //print('$y:' + blocks.elementAt(x).getList().elementAt(y) + ' $zip');
      }
      // print("--------------------------");
      if (zip) s.add(x);
    }
    return s;
  }

  //This function searches for Logos. If none are found, it returns a List of LogoObject with one Object with the 'None' value.
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
