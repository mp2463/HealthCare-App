import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

class _aboutState extends State<about> {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'dishangkumarrana@gmail.com,kevinprajapati2112@gmail.com,harshivrana01@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Facing issues in HealthCare',
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                padding: EdgeInsets.only(left: 5, right: 5),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        ' HealthCare',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "\t\t\t\tHealthCare app is both side application i.e. doctor side and patient side. It's user-friendly app that allow patient to book their appoinment with their choice doctor.\n\n\t\t\t\tAt Doctor side doctor can easilt see their latest appoinment and confirm accordingly their busy schedule.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        ' Feature',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "» User-friendly interface for easy appointment booking\n» Doctor and Patient both can Add, Update, Delete appointment with ease\n» Patient and Doctor both can Upload the photo\n» Patient can rating the doctor as per treatment\n» Patient can message to doctor direclty",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "\t\t\t\tThe development team has used the latest technology and tools to ensure that the HealthCare app is secure, reliable, and easy to use. They have also incorporated  user feedback into the development process, ensuring that the app meets the needs of doctors and patient alike.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Facing issues?",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                textStyle: TextStyle(color: Colors.white)),
                            onPressed: () {
                              launchUrl(emailLaunchUri);
                            },
                            child: Text("SEND MAIL TO DEVELOPER"))),
                    SizedBox(
                      height: 5,
                    )
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Center(
                  child: Text(
                "© 2023 Rana Corporation, Inc.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              )),
            ),
          ],
        ),
      ),
    );
  }

  static encodeQueryParameters(Map<String, String> map) {
    return map.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
