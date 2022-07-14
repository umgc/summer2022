import 'package:googleapis/vision/v1.dart';
import 'models/MailResponse.dart';
import './models/Address.dart';
import './models/Logo.dart';
import 'credentials_provider.dart';

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
  Future<MailResponse> search(String image) async {
    List<AddressObject>? addresses = await searchImageForText(image);
    List<LogoObject>? logos = await searchImageForLogo(image);
    MailResponse response = MailResponse(addresses: addresses, logos: logos);
    // print(response.toJson().toString());
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
    // print("Image to Text Search");
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
            // print("No Pages were found");
          }
        } else {
          // print("No Full Text Annotation Object Found");
        }
      });
    } else {
      // print("Image Text Search failed.");
    }
    // print("Text Search done");
    // for (int x = 0; x < blocks.length; x++) {
    //   print("---------Block $x---------");
    //   for (int y = 0; y < blocks.elementAt(x).getList().length; y++) {
    //     print(blocks.elementAt(x).getList().elementAt(y));
    //   }
    //   print("--------------------------");
    // }
    List<int> sB = findBlocksWithAddresses(blocks);
    for (int sb = 0; sb < sB.length; sb++) {
      int z = sB[sb];
      if (blockHasPostage(blocks.elementAt(z))) {
        sB.removeAt(sb);
      }
    }

    List<AddressObject> pB = parseBlocksForAddresses2(blocks, sB);

    // pB.forEach((a) {
    //   print("--------Address----------");
    //   print('name: ${a.name}');
    //   print('address: ${a.address}');
    //   print('type: ${a.type}');
    //   print('validation: ${a.validated}');
    //   print("-------------------------");
    // });

    //print(s);
    return pB;
  }

  // //This function goes through all blocks using the index provided to find all addresses and put them into a List of AddressObject
  List<AddressObject> parseBlocksForAddresses2(
      List<Block> blocks, List<int> b) {
    List<AddressObject> addresses = [];
    // print(b.length);
    for (int x = 0; x < b.length; x++) {
      String name1 = '';
      String address1 = '';
      String type1 = x == 0 ? 'sender' : 'recipient';
      int cityStateZipIndex =
          findLineWithCityStateZip(blocks.elementAt(b.elementAt(x)));
      try {
        if (validateCityStateZip(blocks
            .elementAt(b.elementAt(x))
            .getList()
            .elementAt(cityStateZipIndex + 1))) cityStateZipIndex++;
      } catch (e) {}
      int addy1 = findLineWithAddress1(blocks.elementAt(b.elementAt(x)));
      // 1 line block
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
                  .elementAt(cityStateZipIndex)) {
            if (blocks
                .elementAt(b.elementAt(x))
                .getList()
                .elementAt(addy1)
                .contains(" | ")) {
              address1 = blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(addy1)
                  .replaceFirst(r' | ', '; ');
            } else if (RegExp(r'^.+\sBOX\s\d{3,6}').hasMatch(blocks
                    .elementAt(b.elementAt(x))
                    .getList()
                    .elementAt(addy1)
                    .toUpperCase()) &&
                RegExp(r'^.+\sBOX\s\d{3,6}').firstMatch(blocks
                        .elementAt(b.elementAt(x))
                        .getList()
                        .elementAt(addy1)
                        .toUpperCase()) !=
                    null) {
              var result = RegExp(r'^.+\sBOX\s\d{3,6}').firstMatch(blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(addy1)
                  .toUpperCase())!;
              var result2 = RegExp(r'^[^.+\sBOX\s\d{3,6}]').firstMatch(blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(addy1)
                  .toUpperCase())!;
              address1 = result[0].toString() +
                  '; ' +
                  result.input.substring(result.end + 1, result.input.length);
            } else if (validateAddress1(
                blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1))) {
              address1 =
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1);
            }
          } else {
            address1 = '; ' +
                blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1);
          }

          if (addy1 == 0 &&
              validateNameHasNoSpecialSymbols(
                  blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
            name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
          } else {
            if (validateNameHasNoSpecialSymbols(blocks
                .elementAt(b.elementAt(x))
                .getList()
                .elementAt(addy1 - 1))) {
              name1 = blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(addy1 - 1);
            }
          }
        }

        if (cityStateZipIndex >= 0 && addy1 == -1) {
          int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;

          address1 = blocks
                  .elementAt(b.elementAt(x) - 1)
                  .getList()
                  .elementAt(size - 1) +
              '; ' +
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
        if (address1.isEmpty) {
          int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;
          if (size >= 2) {
            address1 = blocks
                    .elementAt(b.elementAt(x) - 1)
                    .getList()
                    .elementAt(size - 1) +
                '; ' +
                blocks.elementAt(b.elementAt(x)).getList().elementAt(addy1);
            name1 = blocks
                .elementAt(b.elementAt(x) - 1)
                .getList()
                .elementAt(size - 2);
          }
        }
      } // 2 Line Block
      else if (blocks.elementAt(b.elementAt(x)).getList().length == 2) {
        if (cityStateZipIndex != -1 && addy1 != -1) {
          for (int z = addy1; z <= cityStateZipIndex; z++) {
            if (z == cityStateZipIndex) {
              address1 += "; " +
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            } else {
              address1 +=
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            }

            if (addy1 == 0 && b.elementAt(x) != 0) {
              if (validateNameHasNoSpecialSymbols(
                  blocks.elementAt(b.elementAt(x) - 1).getList().last)) {
                name1 = blocks.elementAt(b.elementAt(x) - 1).getList().last;
              }
            }
          }
        } else if (cityStateZipIndex > 0 && addy1 == -1) {
          for (int y = cityStateZipIndex; y >= 0; y--) {
            if (y == cityStateZipIndex) {
              address1 += "; " +
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(y);
            } else {
              address1 =
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(y) +
                      ' ' +
                      address1;
            }
          }

          int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;
          int prevAddrIndex =
              findLineWithAddress1(blocks.elementAt(b.elementAt(x) - 1));
          if (prevAddrIndex != -1) {
            for (int z = prevAddrIndex; z <= size; z++) {
              if (z == prevAddrIndex &&
                  validateAddress1(blocks
                      .elementAt(b.elementAt(x) - 1)
                      .getList()
                      .elementAt(z))) {
                address1 = blocks
                        .elementAt(b.elementAt(x) - 1)
                        .getList()
                        .elementAt(z) +
                    ', ' +
                    address1;
              }
              if (prevAddrIndex == 0) {
                name1 = blocks.elementAt(b.elementAt(x) - 2).getList().last;
              } else if (prevAddrIndex == 1) {
                name1 = blocks
                    .elementAt(b.elementAt(x) - 1)
                    .getList()
                    .elementAt(prevAddrIndex - 1);
              }
            }
          } else {
            address1 = '';
          }
        } else if (cityStateZipIndex == 0 && addy1 == -1) {
          address1 = "; " +
              blocks
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
              validateAddress1(blocks
                  .elementAt(b.elementAt(x) - 1)
                  .getList()
                  .elementAt(size - 1))) {
            address1 = blocks
                    .elementAt(b.elementAt(x) - 1)
                    .getList()
                    .elementAt(size - 1) +
                address1;
            if (validateNameHasNoSpecialSymbols(blocks
                .elementAt(b.elementAt(x) - 1)
                .getList()
                .elementAt(size - 1))) {
              name1 = blocks.elementAt(b.elementAt(x) - 2).getList().last;
            }
          }
        }
        if (address1.isEmpty) {
          int size = blocks.elementAt(b.elementAt(x) - 1).getList().length;
          if (size >= 1 && cityStateZipIndex > 0) {
            address1 = blocks
                    .elementAt(b.elementAt(x))
                    .getList()
                    .elementAt(cityStateZipIndex - 1) +
                '; ' +
                blocks
                    .elementAt(b.elementAt(x))
                    .getList()
                    .elementAt(cityStateZipIndex);
            name1 = blocks
                .elementAt(b.elementAt(x) - 1)
                .getList()
                .elementAt(size - 1);
          }
        }
      } // 3 Line Block
      else if (blocks.elementAt(b.elementAt(x)).getList().length == 3) {
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
        if (cityStateZipIndex != -1 && addy1 != -1) {
          for (int z = addy1; z <= cityStateZipIndex; z++) {
            if (z == cityStateZipIndex) {
              address1 += "; " +
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            } else {
              address1 +=
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            }
          }
        }
        if (address1.isEmpty) {
          address1 = blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(cityStateZipIndex - 1) +
              '; ' +
              blocks
                  .elementAt(b.elementAt(x))
                  .getList()
                  .elementAt(cityStateZipIndex);
          name1 = blocks
              .elementAt(b.elementAt(x))
              .getList()
              .elementAt(cityStateZipIndex - 2);
        }
      } // 4 Line Block
      else if (blocks.elementAt(b.elementAt(x)).getList().length == 4) {
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
            if (z == cityStateZipIndex) {
              address1 += "; " +
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            } else {
              address1 +=
                  ' ' + blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            }
          }
        }
      } // 5 Line Block
      else if (blocks.elementAt(b.elementAt(x)).getList().length == 5) {
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
            if (z == cityStateZipIndex) {
              address1 += "; " +
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            } else {
              address1 +=
                  blocks.elementAt(b.elementAt(x)).getList().elementAt(z);
            }
          }
        }
      } else {
        // print("did not fit into mail category");
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

  // Validates whether a block contains a postage stamp
  bool blockHasPostage(Block block) {
    RegExp regExp1 = new RegExp(r'U.S. POSTAGE');
    RegExp regExp2 = new RegExp(r'US POSTAGE');
    RegExp regExp3 = new RegExp(r'USPOSTAGE');
    RegExp regExp4 = new RegExp(r'MAILED FROM ZIP CODE\s\d{5}$');
    RegExp regExp5 = new RegExp(r'MAILED FROM\s\d{5}$');

    for (int y = 0; y < block.getList().length; y++) {
      if (regExp1.hasMatch(block.getList().elementAt(y).toUpperCase()) ||
          regExp2.hasMatch(block.getList().elementAt(y).toUpperCase()) ||
          regExp3.hasMatch(block.getList().elementAt(y).toUpperCase()) ||
          regExp4.hasMatch(block.getList().elementAt(y).toUpperCase()) ||
          regExp5.hasMatch(block.getList().elementAt(y).toUpperCase())) {
        return true;
      }
    }
    return false;
  }

  // Validates name has no special Symbols
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

  // Validates city follows city, state, zip guidelines
  bool validateCityStateZip(String line) {
    RegExp regExp1 = new RegExp(r'\w+\s[A-z]+\s\d{5}$');
    RegExp regExp2 = new RegExp(r'\w+\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp3 = new RegExp(r'\w+,\s[A-z]+\s\d{5}$');
    RegExp regExp4 = new RegExp(r'\w+,\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp5 = new RegExp(r'\w+,\s[A-z]+\.\s\d{5}$');
    RegExp regExp6 = new RegExp(r'\w+\s[A-z]+\.\s\d{5}$');
    RegExp regExp7 = new RegExp(r'[A-z]+\,\s[A-z]+\,\s\d{5}-\d{4}$');
    RegExp regExp8 = new RegExp(r'[A-z]+\,\s[A-z]+\,\s\d{5}$');
    if (regExp1.hasMatch(line) ||
        regExp2.hasMatch(line) ||
        regExp3.hasMatch(line) ||
        regExp4.hasMatch(line) ||
        regExp5.hasMatch(line) ||
        regExp6.hasMatch(line) ||
        regExp7.hasMatch(line) ||
        regExp8.hasMatch(line)) {
      return true;
    }
    return false;
  }

  // Find line that contains city state zip within a block and returns the line index
  int findLineWithCityStateZip(Block block) {
    RegExp regExp1 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}$');
    RegExp regExp2 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp3 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}$');
    RegExp regExp4 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp5 = new RegExp(r'[A-z]+,\s[A-z]+\.\s\d{5}$');
    RegExp regExp6 = new RegExp(r'[A-z]+\s[A-z]+\.\s\d{5}$');
    RegExp regExp7 = new RegExp(r'[A-z]+\,\s[A-z]+\,\s\d{5}-\d{4}$');
    RegExp regExp8 = new RegExp(r'[A-z]+\,\s[A-z]+\,\s\d{5}$');
    RegExp regExp9 = new RegExp(r'[A-z]+\.\s[A-z]+\s\d{5}$');
    RegExp regExp10 = new RegExp(r'[A-z]+\.\s[A-z]+\s\d{5}-\d{4}$');
    RegExp regExp11 = new RegExp(r'BOX');

    for (int x = 0; x < block.getList().length; x++) {
      if ((regExp1.hasMatch(block.getList().elementAt(x)) ||
              regExp2.hasMatch(block.getList().elementAt(x)) ||
              regExp3.hasMatch(block.getList().elementAt(x)) ||
              regExp4.hasMatch(block.getList().elementAt(x)) ||
              regExp5.hasMatch(block.getList().elementAt(x)) ||
              regExp6.hasMatch(block.getList().elementAt(x)) ||
              regExp7.hasMatch(block.getList().elementAt(x)) ||
              regExp8.hasMatch(block.getList().elementAt(x)) ||
              regExp9.hasMatch(block.getList().elementAt(x)) ||
              regExp10.hasMatch(block.getList().elementAt(x)))
          // && !regExp11.hasMatch(block.getList().elementAt(x).toUpperCase())
          ) {
        return x;
      }
    }
    return -1;
  }

  // Validates address has follows mail guidelines
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
    RegExp regExp3 = new RegExp(r'Street');
    RegExp regExp4 = new RegExp(r'St');
    RegExp regExp5 = new RegExp(r'St.');
    RegExp regExp6 = new RegExp(r'Avenue');
    RegExp regExp7 = new RegExp(r'Ave');
    RegExp regExp8 = new RegExp(r'Ave.');

    for (int x = 0; x < block.getList().length; x++) {
      if (regExp1.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp2.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp3.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp4.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp5.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp6.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp7.hasMatch(block.getList().elementAt(x).toUpperCase()) ||
          regExp8.hasMatch(block.getList().elementAt(x).toUpperCase())) {
        return x;
      }
    }
    return -1;
  }

  // This function checks and determines which blocks contains zip and returns a list of potential blocks with addresses.
  List<int> findBlocksWithAddresses(List<Block> blocks) {
    RegExp regExp1 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}$');
    RegExp regExp2 = new RegExp(r'[A-z]+\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp3 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}$');
    RegExp regExp4 = new RegExp(r'[A-z]+,\s[A-z]+\s\d{5}-(\d{4})$');
    RegExp regExp5 = new RegExp(r'[A-z]+,\s[A-z]+\.\s\d{5}$');
    RegExp regExp6 = new RegExp(r'[A-z]+\s[A-z]+\.\s\d{5}$');
    RegExp regExp7 = new RegExp(r'[A-z]+\,\s[A-z]+\,\s\d{5}-\d{4}$');
    RegExp regExp8 = new RegExp(r'[A-z]+\,\s[A-z]+\,\s\d{5}$');
    RegExp regExp9 = new RegExp(r'[A-z]+\.\s[A-z]+\s\d{5}$');
    RegExp regExp10 = new RegExp(r'[A-z]+\.\s[A-z]+\s\d{5}-\d{4}$');

    List<int> s = [];
    for (int x = 0; x < blocks.length; x++) {
      // print("---------Block $x---------");
      bool zip = false;
      for (int y = 0; y < blocks.elementAt(x).getList().length; y++) {
        if (regExp1.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp2.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp3.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp4.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp5.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp6.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp7.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp8.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp9.hasMatch(blocks.elementAt(x).getList().elementAt(y)) ||
            regExp10.hasMatch(blocks.elementAt(x).getList().elementAt(y))) {
          zip = true;
        }
        //print('$y:' + blocks.elementAt(x).getList().elementAt(y) + ' $zip');
      }
      // print("--------------------------");
      if (zip) s.add(x);
    }
    return s;
  }

  // This function checks and determines which blocks contains an address line and returns a list of potential blocks with addresses.
  List<int> findBlocksWithAddresses1(List<Block> blocks) {
    RegExp regExp1 = new RegExp(r'^\d+\s\w+');
    RegExp regExp2 = new RegExp(r'\BOX\s\d+');
    List<int> s = [];
    for (int x = 0; x < blocks.length; x++) {
      // print("---------Block $x---------");
      bool zip = false;
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
    // print("Image Search for Logo");
    _response.responses!.forEach((data) {
      if (data.logoAnnotations != null) {
        data.logoAnnotations!.forEach((element) {
          //print(element.description);
          logos.add(LogoObject(name: element.description as String));
        });
      }
      // else {
      //   logos.add(LogoObject(name: "None"));
      //   print(logos.elementAt(0).getName);
      //   print("No Logos were found");
      // }
    });
    //print("Logo Search Done");

    return logos;
  }
}
