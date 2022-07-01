import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MailWidget extends StatefulWidget {
  @override
  _MailWidgetState createState() => _MailWidgetState();
}

class _MailWidgetState extends State<MailWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator MailWidget - FRAME

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(children: [
                Expanded(
                  child: Center(
                    child: Container(
                      child: Text(
                        style: TextStyle(fontSize: 20),
                        "Mail",
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Row(children: [
              Expanded(
                child: Center(
                  child: Container(
                      child: Image.asset(
                          'assets/Image1.png')), //This will eventually be populated with the downloaded image from the digest
                ),
              ),
            ]),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    //padding: EdgeInsets.only(left: 20),
                    child: Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          "Links",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shadowColor: Colors.grey,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    //: EdgeInsets.only(right: 10),
                    child: Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          "All Details",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shadowColor: Colors.grey,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.skip_previous, size: 50),
                    Text("1/6"),
                    Icon(Icons.skip_next, size: 50)
                  ]),
            )
          ],
        ),
      ),
    );

    /*Container(
        width: 375,
        height: 760,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(textDirection: TextDirection.ltr, children: <Widget>[
          Positioned(
              top: 119,
              left: 0,
              child: Container(
                  width: 375,
                  height: 501,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromRGBO(228, 228, 228, 0.6000000238418579),
                  ))),
          Positioned(
              top: 498,
              left: 56,
              child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 4),
                          blurRadius: 4)
                    ],
                    color: Color.fromRGBO(210, 208, 208, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(80, 80)),
                  ))),
          Positioned(
              top: 650,
              left: 18,
              child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 4),
                          blurRadius: 4)
                    ],
                    color: Color.fromRGBO(242, 242, 242, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(90, 90)),
                  ))),
          Positioned(
              top: 650,
              left: 140,
              child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 4),
                          blurRadius: 4)
                    ],
                    color: Color.fromRGBO(242, 242, 242, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(90, 90)),
                  ))),
          Positioned(
              top: 650,
              left: 261,
              child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 4),
                          blurRadius: 4)
                    ],
                    color: Color.fromRGBO(242, 242, 242, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(90, 90)),
                  ))),
          Positioned(
              top: 498,
              left: 226,
              child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 4),
                          blurRadius: 4)
                    ],
                    color: Color.fromRGBO(210, 207, 207, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(80, 80)),
                  ))),
          Positioned(
              top: 37,
              left: 161,
              child: Text(
                textDirection: TextDirection.ltr,
                'Mail',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 36,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1.5 /*PERCENT not supported*/
                    ),
              )),
          Positioned(
              top: 200,
              left: 14,
              child: Container(
                  width: 348,
                  height: 107,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                          offset: Offset(0, 4),
                          blurRadius: 4)
                    ],
                    image: DecorationImage(
                        image: AssetImage('assets/images/Image1.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
            top: 418,
            left: 28,
            child: SvgPicture.asset('assets/images/rectangle4.svg',
                semanticsLabel: 'rectangle4'),
          ),
          Positioned(
              top: 429.5,
              left: 59,
              child: Text(
                textDirection: TextDirection.ltr,
                'Links',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
            top: 418,
            left: 180,
            child: SvgPicture.asset('assets/images/rectangle5.svg',
                semanticsLabel: 'rectangle5'),
          ),
          Positioned(
              top: 429.5,
              left: 189,
              child: Text(
                textDirection: TextDirection.ltr,
                'All DetAILS',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 267,
              left: 21,
              child: Container(
                  width: 341,
                  height: 126,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromRGBO(232, 240, 244, 0.8999999761581421),
                  ))),
          Positioned(
              top: 293,
              left: -12,
              child: Text(
                textDirection: TextDirection.ltr,
                ' QR: https://ww.A.web.site',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 325,
              left: -12,
              child: Text(
                textDirection: TextDirection.ltr,
                'Bar: https://www.OTherWebSite.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 354,
              left: -9,
              child: Text(
                textDirection: TextDirection.ltr,
                'URL: https://www.Example.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
        ]));*/
  }
}
