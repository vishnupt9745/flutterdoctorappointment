import 'package:cloud_firestore/cloud_firestore.dart';

class appointmentmodel{
  final String appointmentId;
  final String patientId;
  final String DoctorId;
  final DateTime? date;
  final String? time;
  final String status;
  final String patientName;
  final String phoneNumber;
  final String doctorName;
  final String specialization;

  appointmentmodel({
    required this.appointmentId,
    required this.patientId,
    required this.DoctorId,
    required this.date,
    required this.time,
    required this.status,
    required this.patientName,
    required this.phoneNumber,
    required this.doctorName,
    required this.specialization,

  });

  factory appointmentmodel.fromJson(
    String Id,
    Map<String,dynamic>json){
      DateTime? appointmentDate; 
      if(json["date"] is Timestamp){
        appointmentDate=(json["date"] as Timestamp).toDate();
      }
      else if(json["date"] is String){
        final parts=json["date"].split("/");

        appointmentDate=DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
          
        );

      }
    return appointmentmodel(
      appointmentId:Id,
      patientId: json["patientId"]??"",
       DoctorId: json["doctorId"]??"", 
       date: appointmentDate,
        time: json["time"]?.toString(),
         status: json["status"]??"Pending",
         patientName: json["patientName"]??"",
         phoneNumber: json["phoneNumber"]??"",
         doctorName:json["doctorName"]?? "",
         specialization: json["specialization"]??"");
         
         

  }
}