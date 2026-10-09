import 'package:doctor_appointmentapp/screens/home.dart';
import 'package:doctor_appointmentapp/screens/doctorview.dart';
import 'package:doctor_appointmentapp/screens/login.dart';
import 'package:doctor_appointmentapp/screens/signin.dart';
import 'package:doctor_appointmentapp/screens/signindoctor.dart';
import 'package:flutter/material.dart';

class diversionpage extends StatefulWidget {
  const diversionpage({super.key});

  @override
  State<diversionpage> createState() => _diversionpageState();
}

class _diversionpageState extends State<diversionpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      width: double.infinity,
     color: Colors.blueAccent,
       child: Column(
        children: [
          SizedBox(height: 23,),
          Icon(Icons.medical_services,size: 80,color: const Color.fromARGB(255, 45, 150, 236),),
          SizedBox(height: 40,),

          Text("Welcome To Medicare",style: TextStyle(
            fontSize: 26,fontWeight: FontWeight.bold,color: Colors.white
          ),),
          SizedBox(height: 8,),
          Text("Choose how you want continue?",style: TextStyle(fontSize: 15,color: Colors.white70),),
          SizedBox(height: 18,),
          
          Container(
            height: 45,
            width: 400,
            child:ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>signinpage() ));        
            },
            icon: Icon(Icons.person),
             label: Text("PATIENT"))
          ),
          SizedBox(height: 20,),
          Container(
            height: 45,
            width: 400,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>doctorsignin() ));                     
            },
            icon: Icon(Icons.medical_services),
             label: Text("DOCTOR"))
          )
        ],
       ),
    ));
}}