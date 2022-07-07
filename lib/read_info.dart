import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:summer2022/daily_digest_files.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'dart:io';

class ReadMail {
  bool dailyDigest;
  TextToSpeech tts;

  ReadMail(this.dailyDigest, this.tts) {
    tts = TextToSpeech();  
  }

  void readMailInfo() {
    if (dailyDigest) {
      DailyDigestFiles digest = DailyDigestFiles();
      List<DailyDigestFile> digestFiles = digest.getFiles();

      for (var digestFile in digestFiles) {
        for (var i = 0 ; i < digestFile.mailObjects.length; i++) {
          if (GlobalConfiguration().getValue("sender")) {
            String text = "The sender is '${digestFile.mailObjects[i].name}'";  
              tts.speak(text);  
            }
            // There isn't a recipient in the json but there is in settings
            //if (GlobalConfiguration().getValue("recipient")) {
            //  String text = "The sender is '${mailObject.recipient}'";  
            //  tts.speak(text);  
            //}
            if (GlobalConfiguration().getValue("address")) {
              String text = "The address is '${digestFile.mailObjects[i].address}'";  
              tts.speak(text);  
            }
            if (GlobalConfiguration().getValue("logos")) {
              String text = "The logo says '${digestFile.logoObjects[i].description.name}'";
              tts.speak(text);
            }
            if (GlobalConfiguration().getValue("links")) {
              String text = "There is a link that is a '${digestFile.codeObjects[i].codeType}'. The link is '${digestFile.codeObjects[i].codeType}'. Would you like to go to the link?";
              tts.speak(text);
              // TODO.. needs to listen for response and then display link 
            }
            if (GlobalConfiguration().getValue("validated")) {
              String validated = "was not";

              if (digestFile.mailObjects[i].validated == "true") {
                validated = "was";
              }
              String text = "The address $validated validated";  
              tts.speak(text);  
            }
          }
          if (GlobalConfiguration().getValue("autoplay")) {
            // TODO wait until user says next command
          } else {
            // Wait a few seconds before reading next mail
            sleep(const Duration(seconds: 5));
          }
      
      }
    } else { // Normal mail
      //TODO read out info
    }
  }
}