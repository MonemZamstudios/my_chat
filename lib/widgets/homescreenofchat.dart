
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/chat_screen.dart';
import 'package:letschat/screens/groupscreen.dart';
import 'package:letschat/screens/login_screen.dart';
import 'package:letschat/widgets/chatbottom.dart';

import 'chatpage.dart';

class Homescreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Homescreen1(),
    );
  }
}

class Homescreen1 extends StatefulWidget {
 // Homescreen({Key key, this.chatmodels, this.sourchat}) : super(key: key);
  // final List<ChatModel> chatmodels;
  // final ChatModel sourchat;
  final _firestore = FirebaseFirestore.instance;
  User loggedInuser;
  @override
  _Homescreen1State createState() => _Homescreen1State();
}

class _Homescreen1State extends State<Homescreen1>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Chat"),
        backgroundColor: Colors.purpleAccent,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _auth.signOut();
             //  Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              }),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext contesxt) {
              return [
                PopupMenuItem(
                  child: Text("New group"),
                  value: "New group",
                ),
                PopupMenuItem(
                  child: Text("New broadcast"),
                  value: "New broadcast",
                ),
                PopupMenuItem(
                  child: Text("Whatsapp Web"),
                  value: "Whatsapp Web",
                ),
                PopupMenuItem(
                  child: Text("Starred messages"),
                  value: "Starred messages",
                ),
                PopupMenuItem(
                  child: Text("Settings"),
                  value: "Settings",
                ),
              ];
            },
          )
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: [

            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "GROUP CHAT",
            ),

          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          // CameraPage(),
          // ChatPage(
          //   chatmodels: widget.chatmodels,
          //   sourchat: widget.sourchat,
          // ),
          chatbottom(),
          group(),
        ],
      ),
    );
  }
}
