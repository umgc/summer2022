import 'package:flutter_test/flutter_test.dart';
import 'package:usps_informed_delivery_backend/usps_address_verification.dart';
import 'package:xml/xml.dart' as xml;

void main() async {
    bool result;
    final uspsAddressValidator = UspsAddressVerification();

    group('USPS Address Verification Tests', () { 
        test('Well Formatted Address', () async {
            const strAddress = r'1004 SPA RD, APT 202; ANNAPOLIS, MD 21403';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('Well Formatted Address, Without second Address', () async {
            const strAddress = r'13001 VANDALIA DR; ROCKVILLE, MD 20853-3348';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('Well Formatted Address, With full state name', () async {
            const strAddress = r'13001 VANDALIA DR; ROCKVILLE, MARYLAND 20853-3348';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('Well Formatted Address, With full state name and short zip', () async {
            const strAddress = r'13001 VANDALIA DR; ROCKVILLE, MARYLAND 20853';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('No comma address', () async {
            const strAddress = r'1004 SPA RD APT 202; ANNAPOLIS MD 21403';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('Second address is on second line', () async {
            const strAddress = r'1004 SPA RD; APT 202; ANNAPOLIS MD 21403';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('Second address is on first line', () async {
            const strAddress = r'APT 202; 1004 SPA RD; ANNAPOLIS MD 21403';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('Second address is on first line with comma after city', () async {
            const strAddress = r'APT 202; 1004 SPA RD; ANNAPOLIS, MD 21403';
            result = await uspsAddressValidator.verifyAddressString(strAddress);
            print(result);
            expect(result, true);
        });
        test('PO Box address', () async {
            const strAddress3 = r'PO Box 85149; Richmond, VA 23295-0001';
            result = await uspsAddressValidator.verifyAddressString(strAddress3);
            print(result);
            expect(result, true);
        });
        test('Bad Address', () async {
            try{
                const strAddress = r'22 zzzzzzzzzzzzz zzzzzzzz zzzzzzzzzzz zzzzzzzzzzzzzz zzzzzzzzzzz';
                result = await uspsAddressValidator.verifyAddressString(strAddress);
                print(result);
                expect(result, false);
            }
            catch(e){
                print(e.toString());
                expect(e, e);
            }
        });
    });

    group('USPS Address Validation Function Tests', () {
        test('Get URL', () {
           String url = uspsAddressValidator.getUrl();
           print(url);
           expect(url, 'https://secure.shippingapis.com/ShippingAPI.dll?API=Verify&XML=');
        });
        test('Get XML Version', () {
            String url = uspsAddressValidator.getXmlVersion();
            print(url);
            expect(url, '"version="1.0"');
        });
        test('Get UserID', () {
            String url = uspsAddressValidator.getUserID();
            print(url);
            expect(url, '974UNIVE7445');
        });
    });
}