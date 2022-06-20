SWEN 670 Capstone Course. Summer Cohort


Google Vision Implementation Version 0.0.1
Transferring Local Project to Github for visibility and testing.

This push contains the following features

CredentialsProvider class – gets connection using json credentials. See Cloud Vision guide on instructions

Cloud Vision Class – used to interface with Cloud Vision. It contains the Following functions

- 	Future<MailResponse> search(String image) – invokes cloud functions and consolidates objects for json response (In work)

-   Future<List<AddressObject>> searchImageForText(String image) async – sends Text request and retrieves and parses response to get Sender and Recipient Addresses.

-	List<AddressObject> parseBlocksForAddresses(List<Block> blocks, List<int> s) – Obtain both sender and recipient addresses and returns as a List of AddressObjects

-	List<int> findBlocksWithAddresses(List<Block> blocks) – Determines which blocks contain an address using regular expression to look for state and zip.

-	Future<List<LogoObject>> searchImageForLogo(String image) async – Sends Logo request and retrieves response.  Due to its simplicity, it parses and gets each logo present and returns a list of LogoObjects


Model classes – Response.dart -> AddressObject, LogoObject, CodeObject and MailResponse. Each of these classes contains functions to obtain a JSon Equivalent. These models allows search cloud search function to return a concise JSON file with is needed for Text-To-Speech.

It also contains a main screen to add features and to test their functionality. Please add your functionalities to the main window as some sort of widget/button object for execution.


