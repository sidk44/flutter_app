import 'package:demo/components/square_tile.dart';
import 'package:demo/components/text_field.dart';
import 'package:demo/pages/button.dart';
import 'package:demo/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'package:login_page_flutter/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  //sign in user
  void signIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
    ),
  );


    //try sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      // pop loading circle
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      // pop loading circle
      Navigator.pop(context);
      // Display error message based on the error code
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password';
      } else {
        errorMessage = 'Invalid email or password';
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
                const SizedBox(height: 70,),
                //logo
                const Icon(
                  Icons.lock,
                  size: 125,
                ),
                const SizedBox(height: 50,),
                //welcome back message
                const Text(
                  'Welcome Back!',
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

                const SizedBox(height: 15,),

                //password textfield
                MyTextField(
                  controller: passwordTextController,
                  hint: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10,),

                //sign in button
                MyButton(
                  onTap: signIn,
                  text: 'Sign In',
                ),
                const SizedBox(height: 10,),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              // google sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(onTap: () => AuthService().signInWithGoogle(), 
                  imagePath: 'lib/images/google.png',
                  ),

                  SizedBox(width: 25),
                ],
              ),
              const SizedBox(height: 30,),


                //go to register page
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Colors.grey[700],
                        /// `fontSize: 15,` is setting the font size of the text to 15 pixels.
                        fontSize: 16,
                      ), // TextStyle
                    ), // Text const SizedBox(width: 4),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register now",
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
