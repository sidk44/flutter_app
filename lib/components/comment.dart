import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    super.key,
      required this.text,
      required this.user,
      required this.time,
    
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 234, 220, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          //comment
          Text(text),

          //user,time
          Column(
            children: [
                  const SizedBox(height: 5,),
                  Text(user, style: TextStyle(color: Colors.grey[500]),),
    
                  Text(time,style: TextStyle(color: Colors.grey[500]),),
    
            ],
          ),


        ],
      ),
    );
  }
}