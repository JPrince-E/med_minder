// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/entities.dart';
// import 'package:heher_app/app/helpers/globals.dart';
// import 'package:heher_app/app/models/calls/call_model.dart';
// import 'package:heher_app/app/resources/app.logger.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:heher_app/app/services/navigation_service.dart';
// import 'package:heher_app/ui/features/calls/presentation/views/calls_receiver_screen.dart';

// var log = getLogger('showInComingCall');

// // Show Incoming Call function
// Future<void> showInComingCall(
//   String calltype,
//   String callerImageUrl,
//   String callerName,
// ) async {
//   await Future.delayed(
//     const Duration(seconds: 0),
//     () async {
//       CallKitParams callKitParams = CallKitParams(
//         id: "1",
//         nameCaller: callerName,
//         appName: 'HeHer',
//         avatar:
//             'https://images.pexels.com/photos/338713/pexels-photo-338713.jpeg',
//         handle: '${calltype} call'.toUpperCase(),
//         type: 0,
//         duration: 55000,
//         android: AndroidParams(
//           isCustomNotification: true,
//           isShowLogo: true,
//           ringtonePath: 'ringtone_default',
//           backgroundColor: "#0f1d3c",
//           backgroundUrl:
//               'https://images.pexels.com/photos/3894157/pexels-photo-3894157.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
//           actionColor: '#4CAF50',
//         ),
//         ios: IOSParams(
//           iconName: 'AppIcon40x40',
//           handleType: '',
//           supportsVideo: true,
//           maximumCallGroups: 2,
//           maximumCallsPerCallGroup: 1,
//           audioSessionMode: 'default',
//           audioSessionActive: true,
//           audioSessionPreferredSampleRate: 44100.0,
//           audioSessionPreferredIOBufferDuration: 0.005,
//           supportsDTMF: true,
//           supportsHolding: true,
//           supportsGrouping: false,
//           supportsUngrouping: false,
//           ringtonePath: 'Ringtone.caf',
//         ),
//       );

//       await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
//       FlutterCallkitIncoming.onEvent.listen(
//         (event) async {
//           switch (event!.event) {
//             case Event.actionCallIncoming:
//               log.wtf('Call Incoming');
//               break;
//             case Event.actionCallAccept:
//               log.wtf('Call accepted');
//               // Accept and Join Call
//               CallModel? retrievedCallData;

//               final DatabaseReference _databaseReference =
//                   FirebaseDatabase.instance.ref();

//               String myUserId = "${Globals.email.split(".")[0]}";
//               var myCallPath = "calls/$myUserId";

//               final snapshot = await _databaseReference.child(myCallPath).get();
//               if (snapshot.exists) {
//                 log.wtf("Retrieved data: ${snapshot.value}");
//                 retrievedCallData = callModelFromJson(
//                   jsonEncode(snapshot.value),
//                 );
//                 if (retrievedCallData.onCall == true) {
//                   log.w(
//                       "Active incoming call from ${retrievedCallData.personInCallName}");
//                 } else {
//                   log.w("No active incoming calls");
//                   // FlutterCallkitIncoming.showMissCallNotification(
//                   //     callKitParams);
//                   // return;
//                 }
//               } else {
//                 log.w('No data available.');
//                 return;
//               }

//               await Future.delayed(Duration(milliseconds: 500)).then(
//                 (value) {
//                   Navigator.push(
//                     NavigationService.navigatorKey.currentContext!,
//                     MaterialPageRoute(
//                       builder: (context) => CallReceiverScreen(
//                         callDetails: retrievedCallData!,
//                         callerImageUrl: callerImageUrl,
//                       ),
//                     ),
//                   );
//                 },
//               );
//               break;
//             case Event.actionCallDecline:
//               await FlutterCallkitIncoming.endCall('1');
//               log.w('Call declined');
//               break;
//             case Event.actionCallEnded:
//               log.w('Call Ended');
//               break;
//             case Event.actionDidUpdateDevicePushTokenVoip:
//               // Handle this case.
//               break;
//             case Event.actionCallStart:
//               // Handle this case.
//               break;
//             case Event.actionCallTimeout:
//               // Handle this case.
//               break;
//             case Event.actionCallCallback:
//               // Handle this case.
//               break;
//             case Event.actionCallToggleHold:
//               // Handle this case.
//               break;
//             case Event.actionCallToggleMute:
//               // Handle this case.
//               break;
//             case Event.actionCallToggleDmtf:
//               // Handle this case.
//               break;
//             case Event.actionCallToggleGroup:
//               // Handle this case.
//               break;
//             case Event.actionCallToggleAudioSession:
//               // Handle this case.
//               break;
//             case Event.actionCallCustom:
//               // Handle this case.
//               break;
//           }
//         },
//       );
//     },
//   );
// }
