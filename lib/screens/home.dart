import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointmentapp/models/doctormodel.dart';
import 'package:doctor_appointmentapp/providers/doctorprovider.dart';
import 'package:doctor_appointmentapp/screens/patientnotification.dart';
import 'package:doctor_appointmentapp/screens/videocall.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  final String patientId;

  const homepage({super.key,required this.patientId,});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF5F7FA),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          "Patients Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
           IconButton(onPressed: () {
             showGeneralDialog(context: context,
             barrierDismissible: true,
             barrierLabel: "Profile",
             transitionDuration:const Duration(microseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
               return Align(
                alignment: Alignment.centerRight,
                child: Material(
                  child: Container(
                    width: 300,
                    height: double.infinity,
                    color: Colors.white,
                    child: FutureBuilder<Map<String,dynamic>?>(future: Provider.of<Doctorprovider>(context,listen: false).
                    patientprofile(widget.patientId),
                     builder: (context, snapshot) {
                       
                       if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                       }

                       if(!snapshot.hasData){
                        return Center(
                          child: Text("Patient details not found"),
                        );
                       }

                       final patient=snapshot.data!;

                       return  Column(
                          children: [
                            SizedBox(height: 50,),

                            CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.person,size: 40,),
                            ),
                            SizedBox(height: 15,),

                            Text(patient["name"]??"No name",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),),

                            SizedBox(height: 30,),

                            ListTile(
                              leading: Icon(Icons.person_outlined),
                              title: Text("Name"),
                              subtitle: Text(patient["name"]??""),
                            ),

                            ListTile(
                              leading: Icon(Icons.phone_outlined),
                              title: Text("Phone"),
                              subtitle: Text(patient["phonenumber"]??""),
                            ),

                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text("Email"),
                              subtitle: Text(patient["email"]??""),
                            ),
                            SizedBox(height: 14),
                            ElevatedButton(onPressed: () {
                              
                            }, child: Text("Logout"))
                          ],
                       );
                     }, )
                  ),
                ),
               );
             },
             transitionBuilder: (context, animation, secondaryAnimation, child) {
               return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset.zero,).animate(animation),
                  child: child,);
             },
             );
           }, icon: Icon(Icons.account_circle_outlined,size: 30,color: Colors.black,))
        ],
      ),

      body: SingleChildScrollView(
        padding:  EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Greeting
             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                  "Welcome to Our Page 👋",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                   ),
                  FutureBuilder<int>(future: Provider.of<Doctorprovider>(context).
                  getNotifications(widget.patientId), builder: (context, snapshot) {
                    final count=snapshot.data??0;

                    return Stack(
                      children: [
                        IconButton(onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => 
                           patientnotify(patientId: widget.patientId),));
                          
                        }, icon: Icon(Icons.notifications,size: 28,)),
                        

                        if(count>0)
                        Positioned(child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),

                          child: Text("$count", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        ))
                      ],
                    );
                  },)
               ],
             ),
              

             SizedBox(height: 8),

             Text(
              "Find the right doctor for your needs.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

           SizedBox(height: 30),

            // Appointment title
             Row(
               children: [
                 Text(
                  "Available doctors ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                             ),
                           
               ],
             ),

             SizedBox(height: 15),

            // Appointment Card
            Container(
              width: double.infinity,
              padding:  EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset:  Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Patient
                  FutureBuilder<List<Doctormodel>>(
                    future: Provider.of<Doctorprovider>(context,
                    listen: false).showDoctors(),
                    builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                }

                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Text("No Doctors");
                                }

                                final doctor = snapshot.data!;
                                
                          return Column(
                            children: doctor.map((doctors) {
                           
                          //  final String status = do.status.trim().toLowerCase();
                           
                              return Card(
                                margin:  EdgeInsets.only(bottom: 15),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(18),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Name:Dr. ${doctors.name}",style: TextStyle(
                                            fontSize: 16,fontWeight: FontWeight.bold
                                          ),),
                                          Text("Specialization:${doctors.specialization}",style: TextStyle(
                                            color: Colors.black
                                          ),),
                                          Text("Qualification: ${doctors.qualification}",style: TextStyle(
                                            color: Colors.black
                                          ),),
                                          SizedBox(height: 20,),
                                            ElevatedButton(onPressed: () async{


                                                bool sucess= await Provider.of<Doctorprovider>(
                                                  context,
                                                  listen: false,
                                                 ).createAppointment(widget.patientId,doctors.doctorid);

                                                 if(sucess){
                                                  
                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Appointment Request Sent Succesfully"),
                                                    backgroundColor: Colors.green,)
                                                   );
                                                 }
                                                 else{
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Faild to Create Appointment"),
                                                    backgroundColor: Colors.red,)
                                                  );
                                                 }
                                                
                                            }, child: Text("Add Appointment",style: TextStyle(fontSize: 16),)),
                                                              
                                        ],
                                      ),
                                      SizedBox(width: 10,),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: CircleAvatar(child: Icon(Icons.person)))
                                      
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                    }
                  ),

               
                ],
              ),
            ),

             SizedBox(height: 30),

            // Notes
           Text(
              "Session Notes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

             SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding:  EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child:  Row(
                children: [

                  Icon(
                    Icons.note_alt_outlined,
                    size: 35,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      "Add or view patient session notes",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
