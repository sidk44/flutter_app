import 'package:flutter/material.dart';
class NewTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  const NewTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left:15,bottom:15),
      margin: const EdgeInsets.only(left: 20,right:20,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //section name
              Text(
                sectionName,
                style: TextStyle(
                  // fontSize: 20,
                  color: Colors.grey[600],
                  ),),

            ],
          ),

          //text
          Text(text),

        ],),
    );
  }
}