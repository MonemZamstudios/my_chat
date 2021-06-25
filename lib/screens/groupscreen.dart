
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:letschat/widgets/new_message.dart';
import 'package:letschat/widgets/try.dart';

import 'creatnewgroup.dart';
import 'group_chat_screen.dart';

class group extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: abc(),
    );
  }
}
class abc extends StatefulWidget {

  @override
  _abcState createState() => _abcState();
}

class _abcState extends State<abc> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
       Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => groupchatpage()));
            },
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
                'My Group',
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
                    'Say Hi to All Friends',
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
      Align(
        alignment: Alignment.bottomRight,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purpleAccent

          ),
//  color: Colors.red,
          margin: EdgeInsets.all(35),
          child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.add,
                size: 33,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => creatnewgroup()));
              }),
        ),
      ),
    ]
    );
  }
}
