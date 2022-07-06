SWEN 670 Capstone Course. Summer Cohor


---------------------------------------------------------------------------------------------
v0.0.8 - June 26, 2022

    - One line blocks for sender - Added special character detection and removed | and replaced with ;
    - added '; ' to separate the address line with the city,state, zip
    - Fixed bugs with Block two use case
    - Fixed bugs with Block one use case
    - Cleaned up code; removed old code comments.
    - Included BOX exclusion to findcitystatezip logic
    - Lots mores
    - Ready for merging with TeamArch branch.

---------------------------------------------------------------------------------------------
v0.0.7 - June 25, 2022 rev2
 - Fixed some bugs

 ---------------------------------------------------------------------------------------------
v0.0.6 - June 25, 2022
- Fixed some bugs
---------------------------------------------------------------------------------------------
Google Vision Implementation
v0.0.5 - June 24, 2022

 - Added additional lines to block 1. It takes into consideration the previous 2 blocks to get the address and name if separated into three.

 - Updated Regular Expressions used to validate address and zip

 - Current on pic 62
---------------------------------------------------------------------------------------------
v0.0.4 - June 23, 2022

- Consolidated redundant regular expressions code into functions

- Cleaned up block parsing function.

- Experienced few issues with the first 15 samples - Mostly Mail guidelines not being followed.

- After sampling another 45. The issues revolved when blocks have 1 to 2 lines especially in png format(might be coincident)

    - png versions ended up separating content into more blocks even when  compared to jpg equivalent. (again  might be coincident)

- Will need to parse by nesting into previous blocks to find what meets address guidelines - mostly focused on block 1 and 2.


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
