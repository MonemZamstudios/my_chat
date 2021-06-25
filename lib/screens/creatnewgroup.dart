import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/chat_screen.dart';
import 'package:multi_select_item/multi_select_item.dart';

final _firestore = FirebaseFirestore.instance;
class creatnewgroup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage1(),
    );
  }
}

class ChatPage1 extends StatefulWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  _ChatPage1State createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  List mainList = new List();
  MultiSelectController controller = new MultiSelectController();

  @override
  void initState() {
    super.initState();

    mainList.add({"key": "1"});
    mainList.add({"key": "2"});
    mainList.add({"key": "3"});
    mainList.add({"key": "4"});

    controller.disableEditingWhenNoneSelected = true;
    controller.set(mainList.length);
  }

  void add() {
    mainList.add({"key": mainList.length + 1});

    setState(() {
      controller.set(mainList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Selected ${controller.selectedIndexes.length}  ' +
            controller.selectedIndexes.toString()),
        actions: (controller.isSelecting)
            ? <Widget>[

          IconButton(
            icon: Icon(Icons.delete),
           // onPressed: delete,
          )
        ]
            : <Widget>[],
      ),

      body: SafeArea(
        child: StreamBuilder(
          stream: _firestore
              .collection('AllUsers')
          // Sort the messages by timestamp DESC because we want the newest messages on bottom.
              .orderBy("username", descending: true)

              .snapshots(),
          builder: (context, snapshot) {
            // If we do not have data yet, show a progress indicator.
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // Create the list of message widgets.

            // final messages = snapshot.data.documents.reversed;
            List<Widget> messageWidgets = snapshot.data.docs.map<Widget>((m) {
              final data = m.data();
              final uesrname = data['username'];
              final otheremail = data['useremail'];
              // final useremail = data['username'];
              final id = FirebaseAuth.instance.currentUser.uid;
              final email =FirebaseAuth.instance.currentUser.email;
              return MultiSelectItem(
                isSelecting: controller.isSelecting,
                onSelected: () {
                  setState(() {
                    controller.toggle(5);
                  });
                },
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},


                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          // child: SvgPicture.asset(
                          // chatModel.isGroup ? "assets/groups.svg" : "assets/person.svg",
                          //   color: Colors.white,
                          //   height: 36,
                          //   width: 36,
                          // ),
                          // backgroundColor: Colors.blueGrey,
                        ),
                        title: Text(
                          // chatModel.name,
                          uesrname.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(Icons.done_all),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              //  chatModel.currentMessage,
                              'Say Hi to '+ uesrname.toString(),
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        //  trailing: Text(chatModel.time),
                        trailing: Text('12:00'),
                      ),


                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, left: 80),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();

            return Container(
              child: Stack(
                children: [

                  Expanded(
                    child: ListView(
                      // reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      children: messageWidgets,
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

