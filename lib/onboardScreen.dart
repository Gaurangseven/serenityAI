import 'package:flutter/material.dart';

import 'constants.dart';
import 'homepage.dart';

class Onboard extends StatelessWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff004656),
        appBar: AppBar(
          backgroundColor: const Color(0xff012B34),
          title: const Center(
              child: Text(
                "Serenity AI",
                style: khead,
              )),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 200),
                Text('Lets beat depression with Serenity',style: h1,),
                Image.asset('assets/logo.png'),
                Text('AI voice based Depression detection ',style: h1,),
                // Text('Speak your heart',style: TextStyle(color: Colors.white,fontSize: 25),),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80.0, right: 80.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Serenity AI')),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        height: 50,
                        width: 400,
                        child: const Center(
                            child: Text(
                              "Speak you heart",
                              style: kbuttonhead,
                            )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
