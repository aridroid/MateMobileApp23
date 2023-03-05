import 'dart:async';
import 'dart:io';
//import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../audio_encoder_type.dart';

class SoundRecordNotifier extends ChangeNotifier {
  GlobalKey key = GlobalKey();

  /// This Timer Just For wait about 1 second until starting record
  Timer _timer;

  /// This time for counter wait about 1 send to increase counter
  Timer _timerCounter;

  /// Use last to check where the last draggable in X
  double last = 0;

  /// Used when user enter the needed path
  String initialStorePathRecord = "";

  /// recording mp3 sound Object
  Record recordMp3 = Record();

  /// recording mp3 sound to check if all permisiion passed
  bool _isAcceptedPermission = false;

  /// used to update state when user draggable to the top state
  double currentButtonHeihtPlace = 0;

  /// used to know if isLocked recording make the object true
  /// else make the object isLocked false
  bool isLocked = false;

  /// when pressed in the recording mic button convert change state to true
  /// else still false
  bool isShow = false;

  /// to show second of recording
  int second;

  /// to show minute of recording
  int minute;

  /// to know if pressed the button
  bool buttonPressed;

  /// used to update space when dragg the button to left
  double edge;
  bool loopActive;

  /// store final path where user need store mp3 record
  bool startRecord;

  /// store the value we draggble to the top
  double heightPosition;

  /// store status of record if lock change to true else
  /// false
  bool lockScreenRecord;
  String mPath;
  AudioEncoderType encode;

  bool isLeftToRight = false;
  // ignore: sort_constructors_first
  SoundRecordNotifier({
    this.edge = 0.0,
    this.minute = 0,
    this.second = 0,
    this.buttonPressed = false,
    this.loopActive = false,
    this.mPath = '',
    this.startRecord = false,
    this.heightPosition = 0,
    this.lockScreenRecord = false,
    this.encode = AudioEncoderType.AAC,
  });

  /// To increase counter after 1 sencond
  void _mapCounterGenerater() {
    _timerCounter = Timer(const Duration(seconds: 1), () {
      _increaseCounterWhilePressed();
      _mapCounterGenerater();
    });
  }

  /// used to reset all value to initial value when end the record
  resetEdgePadding() async {
    isLocked = false;
    edge = 0;
    buttonPressed = false;
    second = 0;
    minute = 0;
    isShow = false;
    key = GlobalKey();
    heightPosition = 0;
    lockScreenRecord = false;
    if (_timer != null) _timer.cancel();
    if (_timerCounter != null) _timerCounter.cancel();
    recordMp3.stop();
    notifyListeners();
  }

  changeIsLeftToRightToTrue(){
    print('changed to true');
    isLeftToRight = true;
    notifyListeners();
  }

  changeIsLeftToRightToFalse(){
    print('changed to false');
    isLeftToRight = false;
    notifyListeners();
  }

  String _getSoundExtention() {
    if (encode == AudioEncoderType.AAC ||
        encode == AudioEncoderType.AAC_LD ||
        encode == AudioEncoderType.AAC_HE ||
        encode == AudioEncoderType.OPUS) {
      return ".m4a";
    } else {
      return ".3gp";
    }
  }

  User _user;
  /// used to get the current store path
  Future<String> getFilePath() async {
    _user = FirebaseAuth.instance.currentUser;
    String _sdPath = "";
    //if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path + "/" + _user.uid + ".m4a";
      if(File(appDocPath).existsSync()){
        print("Deleted");
        await File(appDocPath).delete();
      }



      //_sdPath = initialStorePathRecord.isEmpty ? appDocDir.path : initialStorePathRecord;
    //}
    // else {
    //   Directory appDocDir = await getApplicationDocumentsDirectory();
    //   _sdPath = initialStorePathRecord.isEmpty ? appDocDir.path : initialStorePathRecord;
    // }
    // var d = Directory(_sdPath);
    // if (!d.existsSync()) {
    //   d.createSync(recursive: true);
    // }
    // var uuid = const Uuid();
    // String uid = uuid.v1();
    // String storagePath = _sdPath + "/" + uid + _getSoundExtention();
    mPath = appDocPath;
    return appDocPath;
  }


  bool playingAudioWhenLocked = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  Duration duration;
  Duration currentDuration;
  String hasPreviousPath = "";

  // void playAudioWhenLocked()async{
  //   String path;
  //   path = await recordMp3.stop();
  //   if(hasPreviousPath!=""){
  //     File file = await FFmpeg.concatenate([hasPreviousPath,path]);
  //     hasPreviousPath = file.path;
  //     duration = await _audioPlayer.setFilePath(file.path);
  //   }else{
  //     print('elese');
  //     hasPreviousPath = path;
  //     duration = await _audioPlayer.setFilePath(path);
  //   }
  //   print(path);
  //
  //   _audioPlayer.play();
  //   playingAudioWhenLocked = true;
  //   notifyListeners();
  //   _audioPlayer.playerStateStream.listen((state) {
  //     if (state.processingState == ProcessingState.completed) {
  //       playingAudioWhenLocked = false;
  //       notifyListeners();
  //     }
  //   });
  //
  //   _audioPlayer.positionStream.listen((event) {
  //     currentDuration = event;
  //     notifyListeners();
  //   });
  // }
  //
  // void pauseVideoWhenLocked()async{
  //   _audioPlayer.pause();
  //   playingAudioWhenLocked = true;
  //   notifyListeners();
  // }

  /// used to change the draggable to top value
  setNewInitialDraggableHeight(double newValue) {
    currentButtonHeihtPlace = newValue;
  }

  /// used to change the draggable to top value
  /// or To The X vertical
  /// and update this value in screen
  updateScrollValue(Offset currentValue, BuildContext context) async {
    if (buttonPressed == true) {
      final x = currentValue;

      /// take the diffrent between the origin and the current
      /// draggable to the top place
      double hightValue = currentButtonHeihtPlace - x.dy;

      /// if reached to the max draggable value in the top
      if (hightValue >= 50) {
        isLocked = true;
        lockScreenRecord = true;
        hightValue = 50;
        notifyListeners();
      }
      if (hightValue < 0) hightValue = 0;
      heightPosition = hightValue;
      lockScreenRecord = isLocked;
      notifyListeners();

      /// this operation for update X oriantation
      /// draggable to the left or right place
      try {
        RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (position.dx <= MediaQuery.of(context).size.width * 0.6) {
          resetEdgePadding();
        } else if (x.dx >= MediaQuery.of(context).size.width) {
          edge = 0;
          edge = 0;
        } else {
          if (x.dx <= MediaQuery.of(context).size.width * 0.5) {}
          if (last < x.dx) {
            edge = edge -= x.dx / 200;
            if (edge < 0) {
              edge = 0;
            }
          } else if (last > x.dx) {
            edge = edge += x.dx / 200;
          }
          last = x.dx;
        }
        // ignore: empty_catches
      } catch (e) {}
      notifyListeners();
    }
  }

  /// this function to manage counter value
  /// when reached to 60 sec
  /// reset the sec and increase the min by 1
  _increaseCounterWhilePressed() {
    if (loopActive) {
      return;
    }

    loopActive = true;

    second = second + 1;
    buttonPressed = buttonPressed;
    if (second == 60) {
      second = 0;
      minute = minute + 1;
    }

    notifyListeners();
    loopActive = false;
    notifyListeners();
  }

  /// this function to start record voice
  record() async {
    if (!_isAcceptedPermission) {
      await Permission.microphone.request();
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
      _isAcceptedPermission = true;
    } else {
      buttonPressed = true;
      String recordFilePath = await getFilePath();
      _timer = Timer(const Duration(milliseconds: 900), () {
        recordMp3.start(path: recordFilePath);
      });
      _mapCounterGenerater();
      notifyListeners();
    }
    notifyListeners();
  }

  bool isPausedRecording = false;
  pauseRecording()async{
    if(second > 0 || minute > 0){
      _timerCounter?.cancel();
      await recordMp3.pause();
      isPausedRecording = true;
      notifyListeners();
    }
  }

  resumeRecording()async{
   _mapCounterGenerater();
   if(hasPreviousPath!=""){
     String recordFilePath = await getFilePath();
     await recordMp3.start(path: recordFilePath);
   }else{
     await recordMp3.resume();
   }
   isPausedRecording = false;
   notifyListeners();
  }

  /// to check permission
  voidInitialSound() async {
    if (Platform.isIOS) _isAcceptedPermission = true;

    startRecord = false;
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        _isAcceptedPermission = true;
      }
    }
  }
}

// class FFmpeg {
//
//   static Future<File> concatenate(List<String> assetPaths)async{
//     User _user = FirebaseAuth.instance.currentUser;
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String appDocPath = appDocDir.path + "/" + _user.uid + "/outputs" + DateTime.now().microsecondsSinceEpoch.toString() + ".m4a";
//     final file = File(appDocPath);
//
//     // if(File(appDocPath).existsSync()){
//     //   print("Deleted when concatenate");
//     //   await File(appDocPath).delete();
//     // }
//
//     print(assetPaths[0]);
//     print(assetPaths[1]);
//     var cmd = "ffmpeg -i 'concat:${assetPaths[0]}|${assetPaths[1]}' -acodec copy ${file.path}";
//     //var cmd ="-i ${assetPaths[0]} -i ${assetPaths[1]} -filter_complex 'concat=n=2:v=0:a=1[a]' -map '[a]' -codec:a libmp3lame -qscale:a 2 ${file.path}";
//
//     // final cmd = ["-y"];
//     // for(var path in assetPaths){
//     //   //final tmp = await copyToTemp(path);
//     //   cmd.add("-i");
//     //   print(path);
//     //   cmd.add(path);
//     // }
//
//     // cmd.addAll([
//     //   "-filter_complex",
//     //   "[0:a] [1:a] concat=n=${assetPaths.length}:v=0:a=1 [a]",
//     //   "-map", "[a]", "-c:a", "m4a", file.path
//     // ]);
//
//     // await FFmpegKit.executeWithArguments(cmd).then((value){
//     //   print('---------');
//     //   print(value.getOutput().then((value) => print(value)));
//     // });
//
//     FFmpegKit.executeAsync(cmd, (session) async {
//       final returnCode = await session.getReturnCode();
//       print("returnCode $returnCode");
//     });
//     print("---Path---");
//     print(file.path);
//     return file;
//   }
//
//   static Future<File>copyToTemp(String path)async{
//     User _user = FirebaseAuth.instance.currentUser;
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String appDocPath = appDocDir.path + "/" + _user.uid  + "tempPath"  + ".m4a";
//
//     File tempFile;
//     tempFile = File(appDocPath);
//
//     if(File(appDocPath).existsSync()){
//       print("Deleted");
//       await File(appDocPath).delete();
//     }
//
//     // Directory tempDir = await getApplicationDocumentsDirectory();
//     // File tempFile;
//     // tempFile = File('${tempDir.path}/${_user.uid}/tempSave.m4a');
//     //
//     // if(tempFile.existsSync()){
//     //   print("Deleted");
//     //   await tempFile.delete();
//     //   tempFile = File('${tempDir.path}/${_user.uid}/tempSave.m4a');
//     // }
//
//     // if(await tempFile.exists()){
//     //   return tempFile;
//     // }
//     //final bd = await rootBundle.load(path);
//     await tempFile.writeAsBytes(path.codeUnits,);
//     return tempFile;
//   }
//
// }
