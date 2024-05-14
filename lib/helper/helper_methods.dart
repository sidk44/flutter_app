//return a formatted data as string
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  //Timestamp is the object we receive from firebase
  //so to display it lets comvert it to a string

  DateTime dateTime = timestamp.toDate();
  //get year
  String year = dateTime.year.toString();

  //get month
  String month = dateTime.month.toString();

  //get day
  String day = dateTime.day.toString();

  //final formatted date
  String formattedDate = "$day/$month/$year";
  return formattedDate;


}