import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/components/new_text_box.dart';
import 'package:demo/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:demo/pages/home_page.dart';



class AccountPage extends StatefulWidget {
  final String userName;
  final String userEmail; 
  final String currentUserEmail ; // Define currentUserEmail as nullable
  final void Function(String, String) toggleFollow;


    const AccountPage({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.currentUserEmail, 
    // new
    required this.toggleFollow, // Make currentUserEmail nullable and accept it as a parameter
  });

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

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isFollowing = false;
  int followersCount = 0;

  @override
  void initState() {
    super.initState();
    fetchFollowersCount();
    checkIfFollowing();
  }


      


  void fetchFollowersCount() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection("Users").doc(widget.userEmail).get();
    setState(() {
      followersCount = (userSnapshot.data() as Map<String, dynamic>?)?['followers']?.length ?? 0;

    });
  }


  // void checkIfFollowing() {
  //   if (widget.currentUserEmail != null) {
  //     setState(() {
  //       isFollowing = widget.currentUserEmail!.contains(widget.userEmail);
  //     });
  //   }
  // }
    void checkIfFollowing() async {
    if (widget.currentUserEmail != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection("Users").doc(widget.currentUserEmail).get();
      setState(() {
        // isFollowing = (userSnapshot.data()?['following'] as List).contains(widget.userEmail);
        isFollowing = (userSnapshot.data() as Map<String, dynamic>?)?['following']?.contains(widget.userEmail) ?? false;

      });
    }
  }

  void toggleFollow() async {
    if (widget.currentUserEmail != null) {
      if (isFollowing) {
        // Unfollow the user
        await FirebaseFirestore.instance.collection("Users").doc(widget.currentUserEmail).update({
          "following": FieldValue.arrayRemove([widget.userEmail]),
        });
        await FirebaseFirestore.instance.collection("Users").doc(widget.userEmail).update({
          "followers": FieldValue.arrayRemove([widget.currentUserEmail!]),
        });
        setState(() {
          isFollowing = false;
          followersCount--;
        });
      } else {
        // Follow the user
        await FirebaseFirestore.instance.collection("Users").doc(widget.currentUserEmail).update({
          "following": FieldValue.arrayUnion([widget.userEmail]),
        });
        await FirebaseFirestore.instance.collection("Users").doc(widget.userEmail).update({
          "followers": FieldValue.arrayUnion([widget.currentUserEmail!]),
        });
        setState(() {
          isFollowing = true;
          followersCount++;
        });
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Profile  Page",
        style: 
        TextStyle(color: Colors.white,
        fontSize: 25,

        ),),
        backgroundColor: Colors.grey[900],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(widget.userEmail).snapshots(),
          builder: (context, snapshot) {
            //get user data
            if(snapshot.hasData && snapshot.data!.exists){
              final email2 = widget.userEmail;
              

              //check later
            

              final beforeAtSymbol = email2?.split('@')[0]; // Split by '@' and take the first part



              final userData = snapshot.data!.data() as Map<String, dynamic>;

              
              



              return ListView(
                children: [
                  const SizedBox(height: 50,),

                  //profile picture
                  const Icon(
                    Icons.person,
                    size: 90,
                    // color: Colors.grey[800],
                    ),
                  const SizedBox(height: 10,),
                  

                  //user email
                  Text(
                    widget.userEmail,     //CHECK LATER
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      ),
                  ),
                  const SizedBox(height: 50,),

                  //user details
                  Padding(
                    padding: const EdgeInsets.only(left:25.0),
                    child: Text('My Details',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  //username
                  NewTextBox(
                    text: userData['username'], //checklater
                    sectionName: 'username',
                    
                    ),

                  //bio
                  NewTextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    
                    ),
                  const SizedBox(height: 50,),
                  
        

                  // Follow button    
                  ElevatedButton(
  onPressed: () async {
    if (true) {
      widget.toggleFollow(widget.currentUserEmail, widget.userEmail);
      setState(() {
        isFollowing = !isFollowing;
        if (isFollowing) {
          followersCount++;
        } else {
          followersCount--;
        }
      });
    }
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.black45), // Set background color to blue
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Set border radius to create circular edges
      ),
    ),
  ),
  child: Text(
    isFollowing ? "Following ($followersCount)" : "Follow",
    style: TextStyle(
      color: Colors.white, // Set text color to white
      fontSize: 16, // Adjust font size if needed
    ),
  ),
)
                ],
              );
            } else if (snapshot.hasError){
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },),
    );
  }
}
