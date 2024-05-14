import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FirebaseFirestore;
import 'package:demo/components/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //all users
  final userCollection = FirebaseFirestore.instance.collection("Users");  
  

  //edit field
  Future<void> editField(String field) async{
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit "+ field,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
          
          ),
      ),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Enter new $field",
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        onChanged: (value){
          newValue = value;
        },
      ),
      actions: [
        //cancel button
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),

        //save button
        TextButton(
          child: Text(
            'Save',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(newValue),
        ),


      ],
    ),
    );
    //upate in firestore
    if(newValue.trim().length > 0){
      //only update if there is something in text field
      await userCollection.doc(currentUser.email).update({field: newValue});
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
          stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot) {
            //get user data
            // final userData = snapshot.data?.data() as Map<String, dynamic>;
            if(snapshot.hasData){
            
              final email = currentUser.email;
              

              //check later
            
              // final beforeAtSymbol = email?.substring(0, email?.indexOf('@'));
              // final beforeAtSymbol = email?.split('@')[0]; // Split by '@' and take the first part



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
                    currentUser.email!,
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
                  MyTextBox(
                    text: userData['username'],
                    // text: userData?['username'], //checklater
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                    
                    ),

                  //bio
                  MyTextBox(
                    text: userData['bio'],
                    // text: userData?['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                    
                    ),
                  const SizedBox(height: 50,),

                  //user profile
                  Padding(
                    padding: const EdgeInsets.only(left:25.0),
                    child: Text('My Posts', 
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );


            } else if (snapshot.hasError || !snapshot.hasData || snapshot.hasData == null){
              // return Center(
              //   child: Text('Error${snapshot.error}'),
              // );
              final userData = null;
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
                    currentUser.email!,
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
                  MyTextBox(
                    text: 'username not found',
                    

                    // text: userData['username'],
                    // text: userData?['username'], //checklater
                    sectionName: 'username',
                    // onPressed: () => editField('username'),
                    onPressed: () => {},
                    
                    
                    ),

                  //bio
                  MyTextBox(
                    text: 'bio mot found',
                    // text: userData['bio'],
                    // text: userData?['bio'],
                    sectionName: 'bio',
                    // onPressed: () => editField('bio'),
                    onPressed: () => {},
                    
                    ),
                  const SizedBox(height: 50,),

                  //user profile
                  Padding(
                    padding: const EdgeInsets.only(left:25.0),
                    child: Text('My Posts', 
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );

            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },),
    );
  }
}