import 'package:doctor_appointmentapp/models/appointment.dart';
import 'package:doctor_appointmentapp/models/doctormodel.dart';
import 'package:doctor_appointmentapp/providers/doctorprovider.dart';
import 'package:doctor_appointmentapp/providers/authproviders.dart';
import 'package:doctor_appointmentapp/screens/videocall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class doctoview extends StatefulWidget {
  final doctorid;
  const doctoview({super.key,required this.doctorid});

  @override
  State<doctoview> createState() => _doctoviewState();
}

class _doctoviewState extends State<doctoview> {
  final datectr=TextEditingController();
  final timectr=TextEditingController();

  DateTime? selectedDate;

  String selectedstatus="pending";
  @override
  void initState() {
    // TODO: implement initState
    Future.microtask((){
      context.read<Doctorprovider>().loadappointments(widget.doctorid);
    });
    
  }
  @override
  Widget build(BuildContext context) {
      // final provider = context.watch<Doctorprovider>();
    return Scaffold(
      backgroundColor:  Color(0xffF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          "Doctor Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // logout later
            },
            icon:  Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding:  EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Greeting
             Text(
              "Good Morning, Doctor 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
               ),
              

             SizedBox(height: 8),

             Text(
              "Here is your appointment for today.",
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
                  "Today's Appointment",
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
                  FutureBuilder<List<appointmentmodel>>(
                    future: Provider.of<Doctorprovider>(context,
                    listen: false).showappointment(widget.doctorid),
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

                                final appointments = snapshot.data!;
                                
                          return Column(
                            children: appointments.map((appointment) {
                           
                          //  final String status = patient.status.trim().toLowerCase();
                           
                              return InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: Text("Appointment Details"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(controller: datectr,
                                          decoration: InputDecoration(
                                            labelText: "Date",
                                            border: OutlineInputBorder(),
                                            suffixIcon: Icon(Icons.calendar_today)
                                          ),
                                          onTap: ()async {
                                            DateTime? pickedDate=await showDatePicker(context: context,
                                            initialDate: DateTime.now(),
                                             firstDate: DateTime.now(),
                                              lastDate: DateTime(2030),
                                              builder: (context, child) {
                                                return  Transform.scale(
                                                  scale: 0.75,
                                                  child: child!,
                                                );
                                              },);

                                              if(pickedDate!=null){
                                               setState(() {
                                                 selectedDate=pickedDate;
                                                 datectr.text= datectr.text="${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                               });
                                              }
                                            
                                          },
                                          ),
                                          SizedBox(height: 12,),
                                          TextFormField(controller: timectr,
                                          decoration: InputDecoration(
                                            labelText: "Time",
                                            border: OutlineInputBorder(),
                                            suffixIcon: Icon(Icons.access_time),
                                          ),
                                          onTap: () async{
                                            TimeOfDay? pickedTime=await showTimePicker(context: context,
                                             initialTime: TimeOfDay.now(),
                                             builder:  (context, child) {
                                               return Transform.scale(
                                                scale: 0.7,
                                                child: child!,
                                               );
                                             },);
                                             if(pickedTime!=null){
                                              timectr.text=pickedTime.format(context);
                                             }
                                            
                                          },
                                          ),
                                          SizedBox(height: 12,),
                                          DropdownButtonFormField<String>(
                                            value: selectedstatus,
                                            decoration: InputDecoration(
                                              labelText: "status",
                                              border: OutlineInputBorder()
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                value: "pending",
                                                child: Text("Pending")),
                                              DropdownMenuItem(
                                                value: "confirmed",
                                                child: Text("Confirm")),
                                              DropdownMenuItem(
                                                value: "cancelled",
                                                child: Text("Cancel"))
                                            ],
                                             onChanged:  (value) {
                                              setState(() {
                                                selectedstatus=value!;
                                              });
                                            },),
                                            SizedBox(height: 12,),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(onPressed: () async{
                                                
                                                  print("save Clicked");
                                                  bool sucess= await Provider.of<Doctorprovider>(context,listen: false).
                                                  updateAppointment(appointment.patientId, widget.doctorid, selectedDate!, timectr.text, selectedstatus);
                                                
                                                  print("success $sucess");
                                                  if(sucess){
                                                    print("Appointment updated succesfully");
                                                
                                                     await context.read<Doctorprovider>().loadappointments(widget.doctorid);
                                                     Navigator.pop(context);
                                                     setState(() {
                                                       
                                                     });
                                                
                                                  }else{
                                                    print(" appointment Failed");
                                                  }
                                                
                                                
                                                  
                                                  // datectr.clear();
                                                  // timectr.clear();
                                                  // selectedstatus="pending";
                                                
                                                  
                                                }, child: Text("Save")),
                                                ElevatedButton(onPressed: () {
                                                  Navigator.pop(context);
                                                }, child: Text("Cancel")),
                                              ],
                                            )
                                          
                                        ],
                                      ),
                                    );
                                    
                                  },);
                                },
                                child: Card(
                                  margin:  EdgeInsets.only(bottom: 15),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 27,
                                              backgroundColor: Colors.blue.shade50,
                                              child: Icon(
                                                Icons.person,
                                                size: 28,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                            SizedBox(width: 15,),
                                             Expanded(
                                               child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Text("Patient Name: ${appointment.patientName}",
                                                     style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
                                                     SizedBox(height: 6,),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.phone,size: 16,color: Colors.grey.shade700,),
                                                        SizedBox(width: 5,),  
                                                        Text("Phone Number:${appointment.phoneNumber}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                                      ],
                                                    ), 
                                                 
                              
                                                    Text("Current Status: ${appointment.status}",
                                                    style: TextStyle(color: Colors.grey.shade600),),
                                                    
                                                   
                                                 ],
                                               ),
                                               
                                             ),
                                            
                                          ],
                                        ),
                                        SizedBox(height: 18,),
                                        Divider(),
                                        SizedBox(height: 12,),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                            size: 20,color: Colors.blue.shade700,),
                                            SizedBox(width: 10,),
                                             Text("Appointment Date",style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.bold
                                             ),),
                                             Spacer(),
                                              Text(
                                                appointment.date==null? "Not Assigned":
                                                "${appointment.date!.day}/${appointment.date!.month}/${appointment.date!.year}",
                                              style: TextStyle(color: Colors.grey.shade700),),
                                          ],
                                        ),

///time
                                        Row(
                                          children: [
                                            Icon(Icons.access_time,size: 20,color: Colors.blue.shade700,),
                                            SizedBox(width: 10,),
                                            Text("Appointment Time",style: TextStyle(color: Colors.blue.shade700),),
                                            Spacer(),
                                            Text("${appointment.time ?? "Not assigned"}"),
                                          ],
                                        ),
                                           SizedBox(height: 10),
                                            SizedBox(
                                              width: 170,
                                              height: 50,
                                              
                                              child: ElevatedButton.icon(
                                                icon: Icon(Icons.videocam),
                                                onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Videocallpage(usersId: widget.doctorid),));
                                              }, label: Text("Call")),
                                            )


                                        
                                      
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                    }
                  ),


             

                  // Video call
               
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