import 'package:doctor_appointmentapp/screens/doctorview.dart';
import 'package:doctor_appointmentapp/screens/home.dart';
import 'package:doctor_appointmentapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointmentapp/providers/authproviders.dart';
import 'package:provider/provider.dart';

class doctorsignin extends StatefulWidget {
  const doctorsignin({super.key});

  @override
  State<doctorsignin> createState() => _doctorsigninState();

}

class _doctorsigninState extends State<doctorsignin> {

  final GlobalKey<FormState>formkey=GlobalKey<FormState>();

  String? selectedSpecialization;
  String? selectedqualification;

final namectr=TextEditingController();
final phonectr=TextEditingController();
final emailctr=TextEditingController();
final passctr=TextEditingController();
final confirmpass=TextEditingController();

bool hidePassword=true;
bool confirmhidepassword=true;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                      SizedBox(height: 30,),
                      TextFormField(controller: namectr,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      validator: (value) {
                        if(value==null ||value.isEmpty){
                          return "Please enter a Name";
                        }
                        if(value.length<3){
                          return "Please enter valid name";
                        }
                      },),
                      SizedBox(height: 20),
                      TextFormField(controller: phonectr,
                      decoration: InputDecoration(
                        labelText: "PhoneNumber",
                        prefixIcon: Icon(Icons.phone),
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
                      },
                      ),
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
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedSpecialization,
                        decoration: InputDecoration(
                          labelText: "specialization",
                          prefixIcon: Icon(Icons.medical_services),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )
                        ),
                        items: [
                          "Cardiologist",
                          "Dermatologist",
                          "Neurologist",
                          "Pediatrician",
                          "Psychiatrist",
                          "Orthopedic",
                          "Gynecologist",
                          "General Physician",
                        ].map((specilization){
                          return DropdownMenuItem<String>(
                            value: specilization,
                            child: Text(specilization),
                          );
                        }).toList(),onChanged: (value) {
                        setState(() {
                          selectedSpecialization=value;
                        });
                      },),
                      SizedBox(height: 20),
                      DropdownButtonFormField(
                        value: selectedqualification,
                        decoration: InputDecoration(
                          labelText: "Qualification",
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          "MBBS",
                          "MD",
                          "MS",
                          "DNB",
                          "BDS",
                          "MDS",
                          "DM",
                          "MCh",
                            ].map((qualification){
                              return DropdownMenuItem<String>(
                                value: qualification,
                                child: Text(qualification),
                              );
                            }).toList(),
                       onChanged: (value) {
                         setState(() {
                           selectedqualification=value;
                         });
                       },),

                      SizedBox(height: 30,),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(onPressed: ()async {
                          if (formkey.currentState!.validate()){
                                 bool success=await context.read<Authproviders>().doctorRegister(
                                  namectr.text,phonectr.text,emailctr.text,passctr.text,selectedSpecialization??"",selectedqualification??"");
                                  final user=FirebaseAuth.instance.currentUser!;
                                 if(success){
                                  emailctr.clear();
                                  passctr.clear();
                                  confirmpass.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Registration successful"),backgroundColor: Colors.green,));
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => doctoview(doctorid: user.uid)));

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