//Implementation of page that presents current users home page
//includes user info bar and their posts
import '../../../postWidgets/postsBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class HomeMainWidget extends StatefulWidget {
  const HomeMainWidget({Key? key, required this.user}) : super(key: key);
  final user;

  @override
  HomeMainWidgetState createState() => HomeMainWidgetState();
}

class HomeMainWidgetState extends State<HomeMainWidget> with AutomaticKeepAliveClientMixin<HomeMainWidget> {
  var username;
  @override
  bool get wantKeepAlive => true;

  Future<void> getUserInfo() async {
    await FirebaseFirestore.instance
        .collection('creators')
        .doc(widget.user.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      username = snapshot['username'];
    });
  }

  @override
  initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: getUserInfo(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Column(
              children: <Widget>[
                //user profile section
                Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                          child: CircleAvatar(
                              backgroundColor: Colors.lightBlueAccent,
                              foregroundColor: Colors.white,
                              radius: 50,
                              child: Text('${username[0].toUpperCase()}',
                                  style: TextStyle(fontSize: 30))),
                        ),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text("$username",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white))))

                      ])
                    ]),
                    decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 3,
                          spreadRadius: 5)
                    ])),
                Expanded(
                  child: DraggableScrollableSheet(
                      initialChildSize: 1,
                      builder: (context, scrollController) {
                        return PostsBuilder(userEmail: widget.user.email);
                      }),
                )
              ],
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
