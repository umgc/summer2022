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
        test('XML Builder Test', (){
            xml.XmlDocument doc = uspsAddressValidator.buildAddressXml('1004 SPA RD', 'APT 202', 'ANNAPOLIS', 'MD', '21403', '');
            print(doc.toString());
            expect(doc.toString(), '<?xml "version="1.0"?><AddressValidateRequest USERID="974UNIVE7445"><Revision>1</Revision><Address ID="0"><Address1>1004 SPA RD</Address1><Address2>APT 202</Address2><City>ANNAPOLIS</City><State>MD</State><Zip5>21403</Zip5><Zip4></Zip4></Address></AddressValidateRequest>');
        });
        test('Find Zip5 from long zip', (){
            final zip5 = uspsAddressValidator.findZip5('ANNAPOLIS MD 21403-5555');
            print(zip5);
            expect(zip5, '21403');
        });
        test('Find Zip5 from short zip', (){
            final zip5 = uspsAddressValidator.findZip5('ANNAPOLIS MD 21403');
            print(zip5);
            expect(zip5, '21403');
        });
        test('Find Zip5 from no zip', (){
            final zip5 = uspsAddressValidator.findZip5('ANNAPOLIS MD');
            print(zip5);
            expect(zip5, '');
        });
        test('Find Zip4 from long zip', (){
            final zip4 = uspsAddressValidator.findZip4('ANNAPOLIS MD 21403-5555');
            print(zip4);
            expect(zip4, '5555');
        });
        test('Find Zip4 from short zip', (){
            final zip4 = uspsAddressValidator.findZip4('ANNAPOLIS MD 21403');
            print(zip4);
            expect(zip4, '');
        });
        test('Find State from Short State', () {
            final state = uspsAddressValidator.findState('ANNAPOLIS MD 21403-5555');
            print(state);
            expect(state, 'MD');
        });
        test('Find State from Long State', () {
            final state = uspsAddressValidator.findState('ANNAPOLIS MARYLAND 21403');
            print(state);
            expect(state, 'MARYLAND');
        });
        test('Find State from Long State, with long zip', () {
            final state = uspsAddressValidator.findState('ANNAPOLIS MARYLAND 21403-5555');
            print(state);
            expect(state, 'MARYLAND');
        });
    });
}