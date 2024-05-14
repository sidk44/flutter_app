

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/components/comment.dart';
import 'package:demo/components/comment_button.dart';
import 'package:demo/components/like_button.dart';
import 'package:demo/helper/helper_methods.dart';
import 'package:demo/pages/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


/// The HomePost class is a stateless widget in Dart.
class HomePost extends StatefulWidget {
  final String user;
  final String message;
  final String postId;
  final List<String> likes;
  final String time;
  // final List<String> followers;

  const HomePost({
    super.key,
    required this.user,
    required this.message,
    required this.postId,
    required this.likes,
    required this.time,
    // required this.followers,

    });

  @override
  State<HomePost> createState() => _HomePostState();
}

class _HomePostState extends State<HomePost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser;

  //comment text controller
  final _commentTextController = TextEditingController();
  
  bool isLiked = false;
  bool isFollowing = false; //new 

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser?.email);
    //new
    // isFollowing = widget.followers.contains(currentUser?.email);

  }

 


void toggleFollow() {
  setState(() {
    // isFollowing = !isFollowing;
  });

  // Access document in firebase
  DocumentReference postRef = FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

  if (isFollowing) {
    // If following, add the current user's email to the followers list of the post
    postRef.update({
      "followers": FieldValue.arrayUnion([currentUser?.email]),
    });
  } else {
    // If unfollowing, remove the current user's email from the followers list of the post
    postRef.update({
      "followers": FieldValue.arrayRemove([currentUser?.email]),
    });
  }
}



  //toggle like
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });
    //Access document in firebase
    DocumentReference postRef = 
      FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

      if(isLiked){
        //if liked , add user email to 'Likes' field in db
        postRef.update({
          "Likes": FieldValue.arrayUnion([currentUser?.email]),
        });
      } else {
        //if now unliked , remove user email to 'Likes' field in db
        postRef.update({
          "Likes": FieldValue.arrayRemove([currentUser?.email]),
        });
      }


  }

  //add a comment 
  void addComment(String commentText){
    //write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
          "CommentText": commentText,
          "CommentBy": currentUser!.email, //check later
          "CommentTime": Timestamp.now(), // remember to format this while displaying
    });
  }

  //show dialog box for adding comment 
  void showCommentDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add a comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintText: "Write a comment...",
          ),
        ),
        actions: [

          //cancel button
          TextButton(
            onPressed: ()  {
              //pop the box
              Navigator.pop(context);
              //clear the text field
              _commentTextController.clear();
            
            },
            child: Text("Cancel"),
          ),
          //post button
          TextButton(
            onPressed: ()  {
              //add the comment to firestore
              addComment(_commentTextController.text);
              //pop the box
              Navigator.pop(context);
              //clear the text field
              _commentTextController.clear();
            
            },
            child: Text("Post"),
          ),
          

        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 237, 218, 173),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(top: 25, left: 25, right: 25),
          padding: EdgeInsets.only(top:10,bottom:20,left:20,right:15),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //message and user mail
              const SizedBox( width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5, right: 10),
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[800],
                                size: 30,
                              ),
                            ),
                          
                            Text(
                              widget.user,
                              style: TextStyle(color: Colors.grey[600],fontSize: 14,)
                            ),
                          ],
                        ),
                  const SizedBox(height: 10,),
                  Text(
                    widget.message,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox( height: 10,),

                      const SizedBox( width: 10,),

                      //LIKE 

                      // like button
                      LikeButton(
                        isLiked:isLiked, 
                        onTap: toggleLike,
                        
                        ),

                      //like count
                      const SizedBox( height: 5,),
                      Text(
                        widget.likes.length.toString(),
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),


                    ],
                  ),
                  const SizedBox( width: 10,),
                  Column(
                    children: [
 
                      const SizedBox( height: 10,),
  
                      const SizedBox( width: 10,),

                      //COMMENT
                
                      CommentButton(onTap: () => showCommentDialog(context)),  //check later 

                      //comment count
                      const SizedBox( height: 5,),
                      Text(
                        "0",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),


                    ],
                  ),
                ],
              ),

              //comments under the post
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: (context,snapshot) {
                  //show loading circle
                  if(!snapshot.hasData){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    shrinkWrap: true, //for nested lists 
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((document) {

                      final commentData = document.data() as Map<String, dynamic>;
                      return Comment(
                        text: commentData["CommentText"],
                        user: commentData["CommentBy"],
                        time: formatDate(commentData["CommentTime"]),
                      ); 
                    }).toList(),

                  );



                },
              )


              
            ],
          ),
        ),
      );
    
  }
}