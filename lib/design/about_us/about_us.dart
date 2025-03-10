import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/utils/string_constants.dart';

import '../../utils/utils.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarBG(),
        centerTitle: true,
        title: Text(
          'About Us',
          style: TextStyle(
              fontSize: 50,
              color: Colors.pink.shade300,
              fontWeight: FontWeight.bold,
              fontFamily: 'StyleScript'),
        ),
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // region heading
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/images/two_rings.jpg",
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LoveSync",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: RobotoFlex,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              // endregion heading

              const SizedBox(
                height: 10,
              ),

              // region MeetOurTeam

              getContainers(
                  "Meet Our Team",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getRow("Developed by", "Rishil Jani (23010101105)"),
                      const SizedBox(
                        height: 10,
                      ),
                      getRow('Mentored by',
                          "Prof. Mehul Bhundiya ( Computer Engineering Department ) , School of Computer Science "),
                      const SizedBox(
                        height: 10,
                      ),
                      getRow('Explored by',
                          'ASWDC , School Of Computer Science, School of Computer Science'),
                      const SizedBox(
                        height: 10,
                      ),
                      getRow('Eulogized by',
                          'Darshan University, Rajkot, Gujarat - INDIA'),
                    ],
                  )),

              // endregion MeetOurTeam

              const SizedBox(
                height: 20,
              ),

              // region AboutASWDC

              getContainers(
                  "About ASWDC",
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              "assets/images/DU_Logo.jpg",
                              height: 80,
                            ),
                          ),
                          Expanded(
                            child: Image.asset(
                              "assets/images/ASWDC.jpg",
                              height: 75,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ASWDC is Application , Software and Website Development Center @ Darshan University run by Students and Staff of School of Computer Science.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Sole purpose of ASWDC is to bridge gap between university curriculum & industry demands. Students learn cutting edge technologies, develop real world application & experience professional environment @ ASWDC under guidance of industry experts & faculty members.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),

              // endregion AboutASWDC

              const SizedBox(
                height: 20,
              ),

              // region ContactUs

              getContainers(
                "Contact Us",
                Column(
                  children: [
                    getInfo(Icons.mail, 'aswdc@darshan.ac.in'),
                    getInfo(Icons.phone, '+91-9727747317'),
                    getInfo(CupertinoIcons.globe, 'www.darshan.ac.in'),
                  ],
                ),
              ),

              // endregion ContactUs

              const SizedBox(
                height: 20,
              ),

              Container(
                padding: const EdgeInsets.only(left: 5, top: 5),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 235, 245),
                    border: Border.all(
                      color: Colors.purple,
                    )),
                child: Column(
                  children: [
                    getInfo(Icons.share, 'Share App'),
                    getInfo(CupertinoIcons.circle_grid_3x3_fill, 'More Apps'),
                    getInfo(CupertinoIcons.star, 'Rate Us'),
                    getInfo(Icons.thumb_up, 'Like us on Facebook'),
                    getInfo(
                        CupertinoIcons.arrow_2_circlepath, 'Check for updates'),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copyright,
                        size: 20,
                      ),
                      Text("2025 Darshan University"),
                    ],
                  ),
                  Text("All Rights Reserved - Privacy Policy"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Made With "),
                      Icon(
                        CupertinoIcons.heart_solid,
                        color: Colors.red,
                      ),
                      Text(" in India")
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getContainers(String txt, item) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(
          txt,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: "RobotoFlex"),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 5, top: 5),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 235, 245),
            border: Border.all(
              color: Colors.purple,
            )),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: item,
        ),
      )
    ]);
  }

  Widget getRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            left,
            style: const TextStyle(
                color: Colors.purple, fontFamily: "RobotoFlex", fontSize: 15),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            ":",
            style: TextStyle(
              fontFamily: "RobotoFlex",
              color: Colors.purple,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            right,
            style: const TextStyle(
              fontFamily: "RobotoFlex",
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget getInfo(IconData icon, String txt) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.purple,
      ),
      title: Text(
        txt,
        style: const TextStyle(
          fontFamily: "RobotoFlex",
        ),
      ),
    );
  }
}
