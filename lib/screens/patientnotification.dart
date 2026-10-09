import 'package:doctor_appointmentapp/models/appointment.dart';
import 'package:doctor_appointmentapp/providers/doctorprovider.dart';
import 'package:doctor_appointmentapp/screens/videocall.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class patientnotify extends StatefulWidget {
  final String patientId;
  const patientnotify({super.key,required this.patientId});

  @override
  State<patientnotify> createState() => _patientnotifyState();
}

class _patientnotifyState extends State<patientnotify> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 211, 231, 247),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 231, 247),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: 
        () {
          Navigator.pop(context);
        },
         ),
        title:Text("Your date") ,
        
       
      ),
      body: Consumer<Doctorprovider>(builder: (context,Provider,child){
        
        return  FutureBuilder(
          
          future: Provider.showpatientAppointment(widget.patientId),
           builder: (context, snapshot) {
             
             if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
             }

             final appointments=snapshot.data??[];

             if(appointments.isEmpty){
              return Center(
                child: Text("No Notifications"),
              );
             }
             return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder:(context, index) {
                final appointment=appointments[index];

                final bool isconfirmed=appointment.status.toLowerCase()=="confirmed";

                return Container(
                  color: const Color.fromARGB(255, 211, 231, 247),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.notifications),
                  
                      title: Text(appointment.status.toLowerCase()=="confirmed"?
                      "Appointment Confirmed"
                      :"Appointment Pending",style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.bold),),
                  
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12,),
                          Text("Dr.${appointment.doctorName}",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black87),),
                          Text("${appointment.specialization}",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey.shade700),),
                          SizedBox(height: 7,),
                          Text(
                            appointment.date==null? "Not Assigneed"
                            :" Date: ${appointment.date?.day}/"
                            "${appointment.date?.month}/"
                            "${appointment.date?.year}"
                          ),
                          Text("${appointment.time ?? "Not Assingned"} "),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 170,
                            height: 50,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.videocam),
                              onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Videocallpage(usersId: widget.patientId),));
                            }, label: Text("Answer")),
                          )
                          
                        ],
                      ),
                    ),
                  ),
                );
              }, );
           },);

       
      }));
  }
}