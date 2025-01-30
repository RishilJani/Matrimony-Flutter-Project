import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent,
        centerTitle: true,
        title: const Text(
          'About Us',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'StyleScript'
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)),
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
                    "Typing Tutor",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // region MeetOurTeam

              getTitleContainer("Meet Our Team"),
              Container(
                padding: const EdgeInsets.only(left: 5, top: 5),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 235, 245),
                    border: Border.all(
                      color: Colors.purple,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getRow("Developed by", "Rishil Jani (23010101105)"),
                      const SizedBox(
                        height: 10,
                      ),
                      getRow('Mentored by',
                          "Prof. Mehul Bhundiya (Computer Engineering Department),School of Computer Science "),
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
                  ),
                ),
              ),

              // endregion MeetOurTeam

              const SizedBox(height: 20,),

              // region AboutASWDC

              getTitleContainer("About ASWDC"),
              Container(
                padding: const EdgeInsets.only(left: 5, top: 5),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 235, 245),
                    border: Border.all(
                      color: Colors.purple,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
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
                      const SizedBox(height: 15,),

                      const Row(
                        children: [
                          Expanded( child: Text(
                                  'ASWDC is Application , Software and Website Development Center @ Darshan University run by Students and Staff of School of Computer Science.',
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              ), ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      const Row(
                        children: [
                          Expanded( child: Text(
                            'Sole purpose of Aswdc is to bridge gap between university curriculum & industry demands. Students learn cutting edge technologies, develop real world application & experience professional environment @ ASWDC under guidance of industry experts & faculty members.',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ), ),
                        ],
                      )

                    ],
                  ),
                ),
              ),

              // endregion AboutASWDC

              const SizedBox(height: 20,),

              // region ContactUs

              getTitleContainer('Contact Us'),
              Container(
                padding: const EdgeInsets.only(left: 5, top: 5),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 235, 245),
                    border: Border.all(
                      color: Colors.purple,
                    )),
                child: Column(
                  children: [
                    getInfo(Icons.mail, 'aswdc@darshan.ac.in'),
                    getInfo(Icons.phone, '+91-9727747317'),
                    getInfo(CupertinoIcons.globe, 'www.darshan.ac.in'),
                  ],
                ),
              ),

              // endregion ContactUs

              const SizedBox(height: 20,),


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
                    getInfo(CupertinoIcons.arrow_2_circlepath, 'Like us on Facebook'),
                  ],
                ),
              ),

              const SizedBox(height: 10,),
              const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copyright,size: 20,),
                      Text("2025 Darshan University"),],
                  ),
                  Text("All Rights Reserved - Privacy Policy"),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Made With "),
                      Icon(CupertinoIcons.heart_solid,color: Colors.red,),
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

  Widget getTitleContainer(String txt) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Text(
        txt,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  Widget getRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            left,
            style: const TextStyle(
              color: Colors.purple,
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            ":",
            style: TextStyle(
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
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget getInfo(IconData icon,String txt){
    return ListTile(
      leading: Icon(icon,color: Colors.purple,),
      title: Text(txt),
    );
  }
}
