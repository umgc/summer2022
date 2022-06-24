SWEN 670 Capstone Course. Summer Cohort

Google Vision Implementation

---------------------------------------------------------------------------------------------
v0.0.4 - June 23, 2022

- Consolidated redundant regular expressions code into functions

- Cleaned up block parsing function.

- Experienced few issues with the first 15 samples - Mostly Not following Mail Guidelines

- After sampling another 45. The issues resolve when blocks have 1 to 2 lines especially in png format(might be coincident)

    - png versions ended up separating content blocks even when close compared to jpeg equivalent. (again  might be coincident)

- Will need to parse by nesting into previous blocks to find what meets address guidelines.


-----------------------------------------------------------------------------------------------
v0.0.3 - June 21, 2022 

- Added additional logic to take into considerations different scenarios when parsing blocks
    - Additional Regular Expression Strings were used
    - Improved Block Parsing
    - Added some functions for redundant code.
    - All current images were parsed correctly.

-----------------------------------------------------------------------------------------------

v0.0.2 - June 20, 2022

- Added JSon Implementation.  search functions will return JSON objects.
- Tested more mail images.  Found some discrepancies as some blocks did not contain all Address content.
- Issues using WebCamera.  Does not focus; therefore, results were not accurate as different address placement/outcome arose   

-----------------------------------------------------------------------------------------------
v0.0.1 - June 17, 2022
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

-----------------------------------------------------------------------------------------------