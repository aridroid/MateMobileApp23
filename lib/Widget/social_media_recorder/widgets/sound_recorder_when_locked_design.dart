

import 'dart:io';
import 'package:flutter/material.dart';


import '../../../Utility/Utility.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../Loaders/Shimmer.dart';
import '../provider/sound_record_notifier.dart';

// ignore: must_be_immutable
class SoundRecorderWhenLockedDesign extends StatelessWidget {
  final SoundRecordNotifier soundRecordNotifier;
  final String cancelText;
  final Function sendRequestFunction;
  final Widget? recordIconWhenLockedRecord;
  final TextStyle? cancelTextStyle;
  final TextStyle? counterTextStyle;
  final Color recordIconWhenLockBackGroundColor;
  final Color? counterBackGroundColor;
  final Color? cancelTextBackGroundColor;
  final Widget? sendButtonIcon;
  // ignore: sort_constructors_first
  const SoundRecorderWhenLockedDesign({
    Key? key,
    required this.sendButtonIcon,
    required this.soundRecordNotifier,
    required this.cancelText,
    required this.sendRequestFunction,
    this.recordIconWhenLockedRecord,
    this.cancelTextStyle,
    this.counterTextStyle,
    required this.recordIconWhenLockBackGroundColor,
    this.counterBackGroundColor,
    this.cancelTextBackGroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            SizedBox(height: 10,),
            //soundRecordNotifier.isPausedRecording?
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 40,
            //   margin: EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.grey,
            //       width: 1,
            //     ),
            //     borderRadius: BorderRadius.circular(25),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       SizedBox(width: 16,),
            //       soundRecordNotifier.currentDuration!=null?
            //       Text(soundRecordNotifier.currentDuration.inMinutes.toString().padLeft(2,'0') +":"+ soundRecordNotifier.currentDuration.inSeconds.toString().padLeft(2,"0"),
            //         style: TextStyle(
            //           color: Colors.black,
            //         ),
            //       ):Offstage(),
            //       soundRecordNotifier.duration!=null?
            //       Text(soundRecordNotifier.duration.inMinutes.toString().padLeft(2,'0') +":"+ soundRecordNotifier.duration.inSeconds.toString().padLeft(2,"0"),
            //         style: TextStyle(
            //           color: Colors.black,
            //         ),
            //       ):Offstage(),
            //       SizedBox(width: 10,),
            //       Row(
            //         children: [
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //           Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.black:Colors.white,),
            //         ],
            //       ),
            //       // SizedBox(width: 10,),
            //       // soundRecordNotifier.playingAudioWhenLocked?
            //       //     InkWell(
            //       //       onTap: (){
            //       //         soundRecordNotifier.playAudioWhenLocked();
            //       //       },
            //       //         child: Icon(Icons.pause)):
            //       // InkWell(
            //       //   onTap: (){
            //       //     soundRecordNotifier.playAudioWhenLocked();
            //       //   },
            //       //     child: Icon(Icons.play_arrow)),
            //       SizedBox(width: 16,),
            //     ],
            //   ),
            // ):
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width*0.15,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                    Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                  ],
                ),
                SizedBox(width: 10,),
                Text("${soundRecordNotifier.second.toString().padLeft(2, '0').toString().padLeft(2,'0')} : ${soundRecordNotifier.minute.toString().padLeft(2,'0')}",
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white:Colors.black,
                  ),
                ),
                SizedBox(width: 10,),
              ],
            ),
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: ()async{
                        soundRecordNotifier.isShow = false;
                        if (soundRecordNotifier.second > 1 ||
                            soundRecordNotifier.minute > 0) {
                          String path = soundRecordNotifier.mPath;
                          await Future.delayed(const Duration(milliseconds: 500));
                          sendRequestFunction(File.fromUri(Uri(path: path)));
                        }
                        soundRecordNotifier.resetEdgePadding();
                        soundRecordNotifier.isPausedRecording = false;
                      },
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeController.isDarkMode?Color(0xFF67AE8C):MateColors.appThemeDark,
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.send,
                          textDirection: TextDirection.ltr,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      if(soundRecordNotifier.isPausedRecording){
                        soundRecordNotifier.resumeRecording();
                      }else{
                        soundRecordNotifier.pauseRecording();
                      }
                    },
                    child: Icon(soundRecordNotifier.isPausedRecording?
                    Icons.play_circle:Icons.pause_circle_outline,
                      size: 30,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      soundRecordNotifier.isShow = false;
                      soundRecordNotifier.resetEdgePadding();
                    },
                    child: Image.asset("lib/asset/iconsNewDesign/delete.png",
                      width: 20,
                      height: 20,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     InkWell(
            //       onTap: () async {
            //         soundRecordNotifier.isShow = false;
            //         if (soundRecordNotifier.second > 1 ||
            //             soundRecordNotifier.minute > 0) {
            //           String path = soundRecordNotifier.mPath;
            //           await Future.delayed(const Duration(milliseconds: 500));
            //           sendRequestFunction(File.fromUri(Uri(path: path)));
            //         }
            //         soundRecordNotifier.resetEdgePadding();
            //       },
            //       child: Transform.scale(
            //         scale: 1.2,
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(600),
            //           child: AnimatedContainer(
            //             duration: const Duration(milliseconds: 500),
            //             curve: Curves.easeIn,
            //             width: 50,
            //             height: 50,
            //             child: Container(
            //               color: recordIconWhenLockBackGroundColor,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(4.0),
            //                 child: recordIconWhenLockedRecord ??
            //                     sendButtonIcon ??
            //                     Icon(
            //                       Icons.send,
            //                       textDirection: TextDirection.ltr,
            //                       size: 28,
            //                       color: (soundRecordNotifier.buttonPressed)
            //                           ? Colors.grey.shade200
            //                           : Colors.black,
            //                     ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: InkWell(
            //           onTap: () {
            //             soundRecordNotifier.isShow = false;
            //             soundRecordNotifier.resetEdgePadding();
            //           },
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text(
            //               cancelText ?? "",
            //               maxLines: 1,
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.clip,
            //               style: cancelTextStyle ??
            //                   const TextStyle(
            //                     color: Colors.black,
            //                   ),
            //             ),
            //           )),
            //     ),
            //     // ShowCounter(
            //     //   soundRecorderState: soundRecordNotifier,
            //     //   counterTextStyle: counterTextStyle,
            //     //   counterBackGroundColor: counterBackGroundColor,
            //     // ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
