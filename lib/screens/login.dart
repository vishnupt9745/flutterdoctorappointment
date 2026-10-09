import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointmentapp/providers/authproviders.dart';
import 'package:doctor_appointmentapp/screens/diversion.dart';
import 'package:doctor_appointmentapp/screens/doctorview.dart';
import 'package:doctor_appointmentapp/screens/home.dart';
import 'package:doctor_appointmentapp/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final GlobalKey<FormState>formkey=GlobalKey<FormState>();

  final emailctr=TextEditingController();
  final passctr=TextEditingController();
  
  bool hidePassword=true;
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10)
            )
          ],
          gradient:LinearGradient(colors: [
                   Color(0xFF7ED6F7),
                  Color(0xFF4A90E2),
          ],
          begin:Alignment.topLeft,
          end: Alignment.bottomRight
          ) 
        ),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Icon(Icons.medical_services,size: 80,color: Colors.blue,),
                  SizedBox(height: 30,),
                  TextFormField(
                        controller:emailctr ,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator:(value) {
                          if(value==null || value.isEmpty){
                            return "Enter email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                  TextFormField(
                        controller: passctr,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(onPressed: () {
                              setState(() {
                                hidePassword=!hidePassword;
                              });
                          }, icon: Icon(hidePassword?Icons.visibility:Icons.visibility_off)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                          )
                        ),
                        validator: (value) {
                          if (value==null || value.isEmpty){
                            return "Enter Password";
                          }
                          if(value.length<6){
                            return "Password must be at least 6 numbers";
                          }
                          return null;
                        },
                      ),
                  SizedBox(height: 15,),
                  ElevatedButton(onPressed: () async{
                    bool success=await context.read<Authproviders>().userlogin(emailctr.text, passctr.text);
                     if(success){
                      final user=FirebaseAuth.instance.currentUser;
                      if(user==null){
                        return;
                      }
                      final doctordoc=await FirebaseFirestore.instance.collection("Doctors").doc(user.uid).get();

                      if(doctordoc.exists){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => doctoview(doctorid: user.uid),));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Welcome Doctor...."),backgroundColor:Colors.green ,));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => homepage(patientId: user.uid),));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Welcome....."),backgroundColor: Colors.green,)
                        );
                      }

                     }
                  }, child: Text("Login")),
                  SizedBox(height:15 ,),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => diversionpage(),));
                  }, child: Text("Signup here"))
                  
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}