import 'package:doctor_appointmentapp/providers/authproviders.dart';
import 'package:doctor_appointmentapp/screens/home.dart';
import 'package:doctor_appointmentapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class signinpage extends StatefulWidget {
  const signinpage({super.key});

  @override
  State<signinpage> createState() => _signinpageState();
}

class _signinpageState extends State<signinpage> {
  final GlobalKey<FormState>formkey=GlobalKey<FormState>();


final namectr=TextEditingController();
final emailctr=TextEditingController();
final passctr=TextEditingController();
final confirmpass=TextEditingController();
final phonectr=TextEditingController();

bool hidePassword=true;
bool confirmhidepassword=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
            gradient: LinearGradient(colors: [
                Color(0xFF7ED6F7),
    Color(0xFF4A90E2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Form(
                  key:formkey,
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                      Icon(Icons.medical_services,size: 80,color: Colors.blue,),
                      SizedBox(height: 40,),
                      TextFormField(controller: namectr,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      validator: (value) {
                        if(value==null|| value.isEmpty){
                          return "Please Enter Name";
                        }
                        if(value.length<3){
                           return "Please Enter Valid name";
                        }
                        return null;
                      },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(controller: phonectr,
                      decoration: InputDecoration(
                        labelText: "PhoneNumber",
                        prefixIcon: Icon(Icons.phone_android),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      validator: (value) {
                        if(value==null|| value.isEmpty){
                          return "Please Enter Phonenumber";
                        }
                        if(value.length!=10){
                          return "Please Enter valid Phonenumber";
                        }
                        return null;
                      },),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: emailctr,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator:(value) {
                          if(value==null || value.isEmpty ){
                            return "Enter email";
                          }
                          if(!value.contains("@")||!value.contains(".")){
                             return "Enter a Valid Email";
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
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: confirmpass,
                        obscureText: confirmhidepassword,
                        decoration: InputDecoration(
                          labelText: "Confirm password",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                              confirmhidepassword=!confirmhidepassword;
                            });
                          }, icon: Icon(confirmhidepassword?Icons.visibility:Icons.visibility_off)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                          )
                        ),
                        validator: (value) {
                          if(value==null || value.isEmpty){
                            return "Confirm your Password";
                          }
                          if(value!=passctr.text){
                            return "Password do not match";
                          }
                          return null;
                        },
                        
                      ),
                      SizedBox(height: 30,),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(onPressed: ()async {
                          if (formkey.currentState!.validate()){
                                 bool success=await context.read<Authproviders>().patientregister(
                                  namectr.text,phonectr.text,emailctr.text,passctr.text,);
                                 if(success){
                                  emailctr.clear();
                                  passctr.clear();
                                  confirmpass.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Registration successful"),backgroundColor: Colors.green,));
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => homepage(patientId: FirebaseAuth.instance.currentUser!.uid),));

                                 }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Registration Faild"),backgroundColor: Colors.red,));
                                 }
                          }
                        }, child: Text("Signup")),
                      ),
                      SizedBox(height: 15),
                      TextButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => loginpage(),));
                      }, child: Text("Already you have an account?"))
                
                     ],
                )),
              ),
            ),
          ),
        ),
      )
    );
  }
}