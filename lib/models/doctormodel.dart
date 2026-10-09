import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Doctormodel {
  final String doctorid;
  final String name;
  final String PhoneNumber;
  final String email;
  final String specialization;
  final String qualification;
 
  Doctormodel({
    required this.doctorid,
    required this.name,
    required this.PhoneNumber,
    required this.email,
    required this.specialization,
    required this.qualification,

  });
  factory Doctormodel.fromJson(Map<String,dynamic>json,String doctorid){
    return Doctormodel(
      doctorid:doctorid,
      name: json["name"], 
      PhoneNumber: json["Phonenumber"],
       email: json["email"],
        specialization: json["specialization"],
         qualification: json["qualification"]);
  }
}