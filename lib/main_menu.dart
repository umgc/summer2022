import 'package:flutter/material.dart';

class MainWidget extends StatefulWidget {
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                    label: Text("Digest Date Selection"),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_outlined),
                    label: const Text("Scan Mails"),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Latest Informed Delivery Digest"),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("All Other Mail"),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Settings",
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
