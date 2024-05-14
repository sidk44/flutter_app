import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/components/text_field.dart';
import 'package:demo/pages/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'pages/login_page.dart';
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmpasswordTextController = TextEditingController();

  //sign up user
  Future<void> signUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // passwords should match
    if(passwordTextController.text != confirmpasswordTextController.text){
      // pop loading circle
      Navigator.pop(context);
      // Use ScaffoldMessenger to show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
  }
  // try creating the user
  try {

    //create the user
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailTextController.text,
      password: passwordTextController.text,
    );

    //after creating the user, create new doc in cloud firestore called Users

    FirebaseFirestore.instance
    .collection("Users")
    .doc(userCredential.user!.email)
    .set({
      'username': emailTextController.text.split('@')[0], //initial username
      'bio': 'Empty Bio...', //intially empty bio
      
      //add additional fields here

    });

    // pop loading circle
    if(context.mounted) Navigator.pop(context);
  } on FirebaseAuthException catch (e){
    // pop loading circle 
    Navigator.pop(context);
    // Display error message based on the error code
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'The account already exists for that email.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      default:
        errorMessage = 'Error creating user: ${e.message}';
    }

    // Use ScaffoldMessenger to show a snackbar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
      ),
    );
  }
}


  //diplay a dialogue box 
  void displayMessage(String message){
    showDialog(context: context,
    builder: (context) => AlertDialog(
      title: Text(message) ,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.lock,
                  size: 125,
                ),
                const SizedBox(height: 50,),
                //welcome back message
                const Text(
                  'Let\'s create a new account for you!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 55, 52, 52),
                  ),
                ),
                const SizedBox(height: 25,),

                //email textfield
                MyTextField(
                  controller: emailTextController,
                  hint: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10,),

                //password textfield
                MyTextField(
                  controller: passwordTextController,
                  hint: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10,),

                //confirm password textfield
                MyTextField(
                  controller: confirmpasswordTextController,
                  hint: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10,),

                //sign up button
                MyButton(
                  onTap: signUp,
                  text: 'Sign Up',
                ),
                const SizedBox(height: 10,),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.grey[700],
                        /// `fontSize: 15,` is setting the font size of the text to 15 pixels.
                        fontSize: 16,
                      ), // TextStyle
                    ), // Text const SizedBox(width: 4),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ), // TextStyle
                      ),
                    ), // Text
                  ],
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
