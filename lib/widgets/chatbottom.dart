
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letschat/widgets/chatpage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'new_message.dart';

class chatbottom extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(


        body: new mybottom());
  }
}

class mybottom extends StatefulWidget {



  @override

  _mybottomState createState() => _mybottomState();
}

class _mybottomState extends State<mybottom> {




  int selectedPage = 0;
  final _pageOptions = [ChatPage(),selectpersonforchat()];
  double width;
  double height;


  @override


  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return  Scaffold(

          body: _pageOptions[selectedPage],
          bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.chat, title: 'Chat',),
              TabItem(icon: Icons.people, title: 'People'),



            ],
            backgroundColor: Colors.purpleAccent,
            initialActiveIndex: 0, //optional, default as 0
            // activeColor: Colors.purple,

            onTap: (int i) {
              setState(() {
                selectedPage = i;

              });
            },
          ),
        )
    ;
  }
}
