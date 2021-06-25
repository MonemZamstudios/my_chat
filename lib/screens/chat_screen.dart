import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letschat/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:letschat/components/colors.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';
import 'package:letschat/widgets/homescreenofchat.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInuser;
final focusNode = FocusNode();

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  final String myuid;
  final String othername;
  final String myemail;
  final String otheremail;
  ChatScreen({this.myuid,this.othername,this.myemail,this.otheremail});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  var messageText;


  @override
  void initState() {
    print(widget.myuid);
    print(widget.othername);
    print(widget.myemail);
    super.initState();
    getCurrentUser();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });

      if (isKeyboardVisible && isEmojiVisible) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }


  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  Future<bool> onBackPress() {
    if (isEmojiVisible) {
      toggleEmojiKeyboard();
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override


  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInuser = user;
        print(loggedInuser);
      }
    } catch (e) {
      print(e);
    }
  }

  void onEmojiSelected(String emoji) => setState(() {
    controller.text = controller.text + emoji;
  });

  @override
  Widget build(BuildContext context) {


    Widget buildSticker() {
      return EmojiPicker(
        rows: 3,
        columns: 7,
        buttonMode: ButtonMode.MATERIAL,
        recommendKeywords: ["racing", "horse"],
        numRecommended: 10,
        onEmojiSelected: (emoji, category) {
          onEmojiSelected(emoji.emoji);

        },
      );
    }



    return
      WillPopScope(
          onWillPop: () {
            return showDialog(
                context: context,
                builder: (context) => Homescreen()
            );
          },
  child:  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.purple,
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
             // Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen()));

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                CircleAvatar(

                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                ),
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   // widget.chatModel.name,
                    widget.othername.toString(),
                    style: TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "last seen today at 12:05",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          ),

          actions: [
            IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
            IconButton(icon: Icon(Icons.call), onPressed: () {}),
            PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("View Contact"),
                    value: "View Contact",
                  ),
                  PopupMenuItem(
                    child: Text("Media, links, and docs"),
                    value: "Media, links, and docs",
                  ),
                  PopupMenuItem(
                    child: Text("Whatsapp Web"),
                    value: "Whatsapp Web",
                  ),
                  PopupMenuItem(
                    child: Text("Search"),
                    value: "Search",
                  ),
                  PopupMenuItem(
                    child: Text("Mute Notification"),
                    value: "Mute Notification",
                  ),
                  PopupMenuItem(
                    child: Text("Wallpaper"),
                    value: "Wallpaper",
                  ),
                ];
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: onBackPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream( myemail :widget.myemail, otheremail:widget.otheremail),
              Container(
                width: double.infinity,
                height: 55.0,
                decoration: new BoxDecoration(
                    border: new Border(
                        top: new BorderSide(color: Colors.blueGrey, width: 0.5)),
                   // color: Colors.amber
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        //color: Colors.red,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                 // color:Colors.blue,
                                  width: MediaQuery.of(context).size.width * 0.85,
                                  height: MediaQuery.of(context).size.width * 0.15,
                                  child: Card(

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: TextField(

                                      textInputAction: TextInputAction.send,
                                      keyboardType: TextInputType.multiline,
                                      focusNode: focusNode,
                                      onSubmitted: (value) {
                                        controller.clear();
                                        _firestore.collection('messages').add({
                                          'sender': loggedInuser.email,
                                          'text': messageText,
                                          'timestamp': Timestamp.now(),
                                        });
                                      },
                                      maxLines: null,
                                      controller: controller,
                                      onChanged: (value) {
                                        messageText = value;
                                      },
                                      style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                                      // decoration: kMessageTextFieldDecoration,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,

                                        prefixIcon: IconButton(
                                          icon: Icon(isEmojiVisible
                                              ? Icons.keyboard_rounded
                                              :Icons.emoji_emotions),
                                          onPressed: onClickedEmoji,

                                        ),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.attach_file),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    context: context,
                                                    builder: (builder) =>
                                                        bottomSheet());
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.camera_alt),
                                              onPressed: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (builder) =>
                                                //             CameraApp()));
                                              },
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.all(5),
                                      ),


                                    ),


                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      child: new Container(
                        child: new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: () {
                            controller.clear();
                            _firestore.collection(widget.myemail+widget.otheremail).add({
                              'sender': loggedInuser.email,
                              'text': messageText,
                              'timestamp': Timestamp.now(),
                            });
                            _firestore.collection(widget.otheremail+widget.myemail).add({
                              'sender': loggedInuser.email,
                              'text': messageText,
                              'timestamp': Timestamp.now(),
                            });
                          },
                          color: Colors.blueGrey,
                        ),
                      ),
                      color: Colors.white,
                    ),

                  ],
                ),
              ),
              (isEmojiVisible ? buildSticker() : Container()),
            ],
          ),
        ),
      ),
    ));


  }
  void onClickedEmoji() async {
    if (isEmojiVisible) {
      focusNode.requestFocus();
    } else if (isKeyboardVisible) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(Duration(milliseconds: 100));
    }
    toggleEmojiKeyboard();
  }


}

String giveUsername(String email) {
  return email.replaceAll(new RegExp(r'@g(oogle)?mail\.com$'),'');
}

class MessagesStream extends StatelessWidget {
  final String myemail;
  final String otheremail;
  MessagesStream({this.myemail,this.otheremail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection(myemail+otheremail)
      // Sort the messages by timestamp DESC because we want the newest messages on bottom.
          .orderBy("timestamp", descending: true)
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
          final messageText = data['text'];
          final messageSender = data['sender'];
          final currentUser = loggedInuser.email;
          final timeStamp = data['timestamp'];
          return MessageBubble(
            sender: messageSender,
            text: messageText,
            timestamp: timeStamp,
            isMe: currentUser == messageSender,
          );
        }).toList();



        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.timestamp, this.isMe});
  final String sender;
  final String text;
   final Timestamp timestamp;
    //var timestamp;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${giveUsername(sender)}",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? PalletteColors.primaryGrey : PalletteColors.lightBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    text.toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: isMe ? Colors.white : Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:6.0),
                     child: Text("${DateFormat('h:mm a').format(dateTime)}",style: TextStyle(
                    // child: Text(dateTime.toString(),style: TextStyle(
                      fontSize: 9.0,
                      color: isMe ? Colors.white.withOpacity(0.5) : Colors.black54.withOpacity(0.5),
                    ),),
                  ),],
              ),
            ),
          ),
        ],
      ),
    );

  }



}

Widget bottomSheet() {
  return Container(
    height: 278,
    // width: MediaQuery.of(context).size.width,
    child: Card(
      margin: const EdgeInsets.all(18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconCreation(
                    Icons.insert_drive_file, Colors.indigo, "Document"),
                SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconCreation(Icons.headset, Colors.orange, "Audio"),
                SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.location_pin, Colors.teal, "Location"),
                SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.person, Colors.blue, "Contact"),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
Widget iconCreation(IconData icons, Color color, String text) {
  return InkWell(
    onTap: () {},
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(
            icons,
            // semanticLabel: "Help",
            size: 29,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w100,
          ),
        )
      ],
    ),
  );
}