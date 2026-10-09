import 'package:doctor_appointmentapp/providers/doctorprovider.dart';
import 'package:doctor_appointmentapp/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class Videocallpage extends StatefulWidget {
  final String usersId;
  const Videocallpage({super.key,required this.usersId});

  @override
  State<Videocallpage> createState() => _VideocallpageState();
}

class _VideocallpageState extends State<Videocallpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     if(!mounted) return;
     context.read<Doctorprovider>().initializevideocall();
   },);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<Doctorprovider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text("Video Call"),
        ),

        body:Stack(
          children: [


            Positioned.fill(child: provider.remoteRenderer.srcObject!=null?RTCVideoView(
              provider.remoteRenderer,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ):Center(
              child: Text("Waiting for patient",style: TextStyle(
                color: Colors.white,fontSize: 18
              ),),
            )),


            Positioned(
              top: 20,
              right: 20,

              width: 120,
              height: 170,

              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(15),
                child: Container(
                  color: Colors.grey.shade900,
                  child: provider.localRenderer.srcObject!=null&& !provider.isCameraOff?
                  RTCVideoView(provider.localRenderer,mirror: provider.isFrontCamera,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,)
                  :Center(
                    child: Icon(
                      Icons.videocam_off,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              )),


              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8
                  ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(provider.connectionstatus,
                    style: TextStyle(color: Colors.white),),
                )),

                if(provider.isVideoLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white,),
                  ),
                ),

                 

                 ///controls
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///mic
                      _controlButton(icon: provider.isMuted?Icons.mic_off:Icons.mic, 
                      onPressed: () {
                        provider.toggleMute();
                      },),
                      ///camera
                      _controlButton(icon: provider.isCameraOff?
                      Icons.videocam_off:Icons.videocam, 
                      onPressed: () {
                        provider.toggleCamera();
                      },),
                      //switch camera
                      _controlButton(icon: Icons.flip_camera_ios, 
                      onPressed: () {
                        provider.switchCamera();
                      },),
                      //end call
                      _controlButton(icon: Icons.call_end,
                      backgroundColor: Colors.red,
                       onPressed:() {
                         provider.endCall();

                         if(context.mounted){
                          Navigator.pop(context);
                         }
                       },)
                    ],
                  ))
          ],
        ) ,
      );
      
    },);
  }
}





////controll button

  Widget _controlButton({

    required IconData icon,

    required VoidCallback onPressed,

    Color backgroundColor =
        Colors.white24,

  }) {

    return Container(

      width: 58,
      height: 58,

      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),

      child: IconButton(

        onPressed: onPressed,

        icon: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
