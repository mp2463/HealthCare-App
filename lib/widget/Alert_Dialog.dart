import 'package:flutter/material.dart';

class AdvanceCustomAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Turn on Internet Connection.',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10, left: 15, right: 15),
                          child: Text("Okay", style: TextStyle(fontSize: 18)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -15,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Image.asset('assets/images/network.png'),
                )),
          ],
        ));
  }
}
