import 'package:doctor_appointmentapp/models/appointment.dart';
import 'package:doctor_appointmentapp/models/doctormodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class Doctorprovider extends ChangeNotifier{

    ///local camera
    final RTCVideoRenderer localRenderer=RTCVideoRenderer();
 
 ///customer camera
  final RTCVideoRenderer remoteRenderer=RTCVideoRenderer();

   bool isMuted = false;
  bool isCameraOff = false;
  bool isFrontCamera = true;

  bool isVideoLoading = true;

    MediaStream? localStream;

  RTCPeerConnection?peerConnection;
  
  String connectionstatus="connecting..";


Future<List<Doctormodel>>showDoctors()async{
  final snapshot= await FirebaseFirestore.instance.collection("Doctors").get();
  List<Doctormodel> Doctor=[];

  for(var doc in snapshot.docs){
    var data=doc.data();

    print("Data $data");
    print("name ${data["name"]}");
    print("name ${data["phonenumber"]}");
    print("name ${data["email"]}");

    Doctor.add(Doctormodel(
      doctorid: doc.id,
      name: data["name"],
      PhoneNumber: data["phonenumber"],
       email: data["email"],
        specialization: data["specialization"],
         qualification:data["qualification"]));
    

  }

return Doctor;
}


Future<bool>createAppointment(String patientid,String doctorid,)async{
  try{
    await FirebaseFirestore.instance.collection("appointments").add({
      "patientId":patientid,
      "doctorId":doctorid,
      "date":null,
      "time":null,
      "status":"pending",
    });
    return true;
  }
  catch(e){
    print(e);
    return false;
  }


}

Future<List<appointmentmodel>>showappointment(String doctorId)async{
  final snapshot=await FirebaseFirestore.instance.collection("appointments").
  where("doctorId",isEqualTo: doctorId).get();

  List<appointmentmodel> appointments=[];

  for(var doc in snapshot.docs){
  final data=doc.data();

  ///get patient id from appountment
  String patienId=data["patientId"];

  //find patient  using patientid
  final patientdoc=await FirebaseFirestore.instance.collection("Patients").doc(patienId).get();

  String patientName="";
  String phoneNumber="";

  if(patientdoc.exists){
    patientName=patientdoc.data()?["name"]??"";
    phoneNumber=patientdoc.data()?["phonenumber"]??"";
  }

  // add name into appointment
  data["patientName"]=patientName;
  data["phoneNumber"]=phoneNumber;

  appointments.add(appointmentmodel.fromJson(doc.id, data));

  }
return appointments;
}



Future<bool>updateAppointment(String patientId,String doctorId,DateTime date,String time,String status)async{
  try{
      print("patientId = $patientId");
    print("doctorId = $doctorId");
    print("status = $status");


    final snapshot=await FirebaseFirestore.instance.collection("appointments").
    where("patientId",isEqualTo: patientId).
    where("doctorId",isEqualTo: doctorId).get();

      print("Found documents = ${snapshot.docs.length}");

    if(snapshot.docs.isEmpty){
      print("No appointment found");
      return false;
    }

    await snapshot.docs.first.reference.update({
      "date":date,
      "time":time,
      "status":status,
      "notificationRead":false,
    });
        print("Firestore updated");
    return true;
  }
  catch(e){
    print(e);
     print("ERROR = $e");
    return false;
  }


}

////patient view their appointment status

Future<List<appointmentmodel>> showpatientAppointment(
    String patientId) async {

  print("Patient ID = $patientId");

  final snapshot = await FirebaseFirestore.instance
      .collection("appointments")
      .where("patientId", isEqualTo: patientId)
      .get();

  print("Found = ${snapshot.docs.length}");

  List<appointmentmodel> appointments = [];

  for (var doc in snapshot.docs) {
    print("DATA = ${doc.data()}");

    final data=doc.data();
      
      ///finding doctor id
      final doctorId=data["doctorId"];

      ///get doctor document
      
      final doctorDoc=await FirebaseFirestore.instance.collection("Doctors").doc(doctorId).get();

      final doctorData=doctorDoc.data();

      data["doctorName"] = doctorData?["name"] ?? "Unknown Doctor";
      data["specialization"] = doctorData?["specialization"] ?? "";
     

    appointments.add(
      appointmentmodel.fromJson(
        doc.id,
        data,
      ),
    );
  }

  return appointments;
}


List<appointmentmodel> appointments = [];
Future<void>loadappointments(String doctorId)async{
 final data=await showappointment(doctorId);

 appointments=data;
 notifyListeners();

}


////get notifications

Future<int>getNotifications(String patientId)async{

  final snapshot= await FirebaseFirestore.instance.collection("appointments").
  where("patientId",isEqualTo: patientId).
  where("status",whereIn:  ["confirmed","cancelled"])
  .where("notificationRead",isEqualTo: false)
  .get();

  print("Patient ID: $patientId");
  print("Notification count: ${snapshot.docs.length}");

  return snapshot.docs.length;

}


////profile
///
Future<Map<String,dynamic>?>patientprofile(String patientId)async{

 final docs=await FirebaseFirestore.instance.collection("Patients").doc(patientId).get();

 if(!docs.exists){
  return null;
 }

 return docs.data();

}




////web configuration 
 final Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun.l.google.com:19302',
        ],
      },
    ],
  };

///initialize video call
///
Future<void>initializevideocall()async{
  try{
    isVideoLoading=true;
    notifyListeners();

    print("1.Initializing local render...");
    await localRenderer.initialize();
    
    print("2.Initializing remote render...");
    await remoteRenderer.initialize();
    
    print("3.starting Camera...");
    await openCamera();
     
    print("4.camera opend") ;

    await doctorPatientConnect();
    print("5.Patient connection initialized");

    isVideoLoading=false;
    connectionstatus ="Waiting for patient...";

    notifyListeners();

  }catch(e,stackTrace){
    
    print("___video call Error__");
    print("Video call error: $e");
    print("STACK TRACE :$stackTrace");

    isVideoLoading=false;
    connectionstatus="Camera initialization failed";

    notifyListeners();
    
  }
}



///opencamera
///
Future<void> openCamera() async {
  try {
    print("========== CAMERA START ==========");

    // Request Android permissions
    final cameraPermission = await Permission.camera.request();
    final microphonePermission =
        await Permission.microphone.request();

    print("Camera permission: $cameraPermission");
    print("Microphone permission: $microphonePermission");

    if (!cameraPermission.isGranted) {
      throw Exception("Camera permission denied");
    }

    if (!microphonePermission.isGranted) {
      throw Exception("Microphone permission denied");
    }

    final constraints = {
      'audio': true,
      'video': {
        'facingMode': isFrontCamera ? 'user' : 'environment',
        'width': {
          'ideal': 1280,
        },
        'height': {
          'ideal': 720,
        },
      },
    };

    print("Calling getUserMedia...");

    localStream = await navigator.mediaDevices.getUserMedia(
      constraints,
    );

    print("Camera Stream: $localStream");

    localRenderer.srcObject = localStream;

    print("Renderer source: ${localRenderer.srcObject}");

    isCameraOff = false;

    notifyListeners();

    print("========== CAMERA WORKING ==========");
  } catch (e, stackTrace) {
    print("========== CAMERA ERROR ==========");
    print("TYPE: ${e.runtimeType}");
    print("ERROR: $e");
    print("STACK: $stackTrace");
    print("==================================");

    rethrow;
  }
}
  

Future<void> doctorPatientConnect() async {
  // Create WebRTC connection between doctor and patient

  peerConnection=await createPeerConnection(configuration,);

//add docror's track
  if(localStream!=null){

    for(final track in localStream!.getTracks()){

      await peerConnection!.addTrack(track,localStream!,);
    }
  }

  //recieve patient video

  peerConnection!.onTrack=(RTCTrackEvent event){

    if(event.streams.isNotEmpty){

      remoteRenderer.srcObject=event.streams[0];

      connectionstatus="connected";

      notifyListeners();
    }
  };

  ///ice candidate
  ///
  peerConnection!.onIceCandidate=(RTCIceCandidate candidate){
    print("ICE candidate:${candidate.candidate}");
  };

  ///connection status
  
  peerConnection!.onConnectionState=
  (RTCPeerConnectionState state){
    print("Connection state:$state");

    connectionstatus=state.toString();
  

  // switch(state){

  //   case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
  //   connectionstatus="connected";
  //   break;

  //   case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
  //   connectionstatus="Connecting";
  //   break;


  //   case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
  //   connectionstatus="Disconnected";
  //   break;

  //   case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
  //   connectionstatus="Connectionfailed";
  //   break;

  //   case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
  //   connectionstatus="Call ended";
  //   break;

  //   default:
  //      connectionstatus="connecting....";
  // }

  notifyListeners();

  };

}

//mute

void  toggleMute(){

if(localStream==null){
  return;
}

final tracks=localStream!.getAudioTracks();

if(tracks.isEmpty){
  return;
}

final track=tracks.first;

track.enabled=!track.enabled;

isMuted=!track.enabled;

notifyListeners();
}

///camera on/pff
void toggleCamera(){

  if (localStream==null){
    return;
  }

  final tracks=localStream!.getVideoTracks();

  if(tracks.isEmpty){
    return;
  }
  final track=tracks.first;

  track.enabled=!track.enabled;

  isCameraOff=!track.enabled;

  notifyListeners();
}



////switch camera 
Future<void> switchCamera() async {

    if (localStream == null) {
      return;
    }

    final tracks =
        localStream!.getVideoTracks();

    if (tracks.isEmpty) {
      return;
    }

    await Helper.switchCamera(
      tracks.first,
    );

    isFrontCamera =
        !isFrontCamera;

    notifyListeners();
  }


// end call

  Future<void> endCall() async {

    if (localStream != null) {

      for (final track
          in localStream!.getTracks()) {

        track.stop();
      }
    }

    localRenderer.srcObject = null;

    remoteRenderer.srcObject = null;

    await peerConnection?.close();

    peerConnection = null;

    localStream = null;

    isMuted = false;

    isCameraOff = false;

    connectionstatus="Call ended";

    notifyListeners();
  }



// dispose

  @override
  void dispose() {

    localStream?.getTracks().forEach(
      (track) {
        track.stop();
      },
    );

    localRenderer.dispose();

    remoteRenderer.dispose();

    peerConnection?.close();

    super.dispose();
  }

}