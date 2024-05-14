import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/components/drawer.dart';
import 'package:demo/components/home_post.dart';
import 'package:demo/components/text_field.dart';
import 'package:demo/helper/helper_methods.dart';
import 'package:demo/pages/account_page.dart';
import 'package:demo/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/src/material/icon_button.dart';

import 'package:demo/firebase_options.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //current user
  final currentUser = FirebaseAuth.instance.currentUser;
  //text controller
  final textController = TextEditingController();


  
get followersCount => followersCount == null ? [] : [followersCount.toString()];
// check this 
  late Stream<QuerySnapshot> postsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to fetch posts with follower counts
    postsStream = FirebaseFirestore.instance
        .collection("User Posts")
        .orderBy("TimeStamp", descending: false)
        .snapshots();
  }



  //sign out user
  void signOut() async {
    FirebaseAuth.instance.signOut();
  }

  //follow user
Future<String> followUser(String currentUserEmail, String userEmail) async {
  // Update following for the current user
  await FirebaseFirestore.instance.collection("Users").doc(currentUserEmail).update({
    "following": FieldValue.arrayUnion([userEmail]),
  });

  // Update followers for the user being followed
  await FirebaseFirestore.instance.collection("Users").doc(userEmail).update({
    "followers": FieldValue.arrayUnion([currentUserEmail]),
  });

  // Return the user's email as a confirmation
  return userEmail;
}





  //post message
  void postMessage() {
    //only post if something there in textfield

    if (textController.text.isNotEmpty){
      //add to firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser!.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
      //clear the text field
      textController.clear();
    }
  }

  //navigate to profile page
  void goToProfilePage(){
    // pop menu drawer
    Navigator.pop(context);
    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("        H O M E  🌙 ",
        style: TextStyle(color: Colors.grey[200],
        fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.grey[900],

      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignout: signOut,
      ),


      body: Center(
        child: Column(
          children: [
            //the lounge
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false, //check this
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //get the message
                            final post = snapshot.data!.docs[index];
                            // final followersCount = 0; 


                            final followersCount = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(post['UserEmail'])
                              .collection('followers')
                              .snapshots()
                              .length;
                            
                            return GestureDetector(
                              onTap: () {
                                // Check if the post's user is not the current user
                                if (post['UserEmail'] != currentUser!.email) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccountPage(
                                        userName: post['UserEmail'], // Pass user name as user email
                                        userEmail: post['UserEmail'], // Pass user email


                                        currentUserEmail: currentUser!.email!, // Pass current user email
                                        //CHECK LATER

                                        toggleFollow: followUser,
                                         // Pass followUser function
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: HomePost(
                                message: post['Message'],
                                user: post['UserEmail'],
                                postId: post.id,
                                likes: List<String>.from(post['Likes'] ?? []),
                                
                                time: formatDate(post['TimeStamp']),
                                
                              ),
                            );
                          },
                        );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
  
        
            //post message 
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  //text field
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hint: 'Write something!!',
                      obscureText: false,
                      ),
                  ),
                  //post button
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.send),
                  ),

                  
                ],
              ),
            ),
        
            //logged in as
            Text(
              "Logged in as ${currentUser!.email}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 25,),
        
        
          ],
        ),
      ),
      
    );
  }
}