import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Authproviders extends ChangeNotifier{
  Future<bool>patientregister(String name,String number,String email,String password,)async{
    try{
      final registerdata=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, 
      password: password,
      );
      final uid=registerdata.user!.uid;

      await FirebaseFirestore.instance.collection("Patients").doc(uid).set({
        "name":name,
        "phonenumber":number,
        "email":email,
        
      });
   
   return true;
    }on FirebaseAuthException catch(e){
      if(e.code=="weak-password"){
        print("The password provided is too weak .");
      }
      else if(e.code=="email-already-in-use"){
        print("The account is already exists for that email.");
      }
    }catch(e){
      print(e);
    }

return false;
  }


Future<bool>doctorRegister(String name,String number,String email,String password,String speci,String quali)async{
  try{
   final registerdata=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

   final uid=registerdata.user!.uid;
   await FirebaseFirestore.instance.collection("Doctors").doc(uid).set({
    "name":name,
    "phonenumber":number,
    "email":email,
    "specialization":speci,
    "qualification":quali,
   });
   return true;

  }on FirebaseAuthException catch(e){
    if(e.code=="weak-password"){
      print("The password provided is too weak. ");
    }
    else if(e.code=="email-already-in-use"){
        print("The account is already exists for that email.");
       
    }
  }
  catch(e){
    print(e);
  }

return false;
}


Future<bool>userlogin(String email,String password)async{
  try{
    final logindata=await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
       password: password);
    return true;

  }on FirebaseAuthException catch(e){
    if(e.code=="user-not-found"){
      print('No user found at that email.');

    }else if(e.code=="wrong-password"){
      print('wrong password provide that user');
    }
    else{
      print(e.message);
    }
  }

  return false;
}  
}