


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../provider/sound_record_notifier.dart';

/// used to show mic and show dragg text when
/// press into record icon
class ShowMicWithText extends StatelessWidget {
  final bool shouldShowText;
  final String slideToCancelText;
  final SoundRecordNotifier soundRecorderState;
  final TextStyle slideToCancelTextStyle;
  final Color backGroundColor;
  final Widget recordIcon;
  final Color counterBackGroundColor;
  // ignore: sort_constructors_first
  ShowMicWithText({
    this.backGroundColor,
    Key key,
    this.shouldShowText,
    this.soundRecorderState,
    this.slideToCancelTextStyle,
    this.slideToCancelText,
    this.recordIcon,
    this.counterBackGroundColor,
  }) : super(key: key);
  final colorizeColors = [
    Colors.black,
    Colors.grey.shade200,
    Colors.black,
  ];
  final colorizeTextStyle = const TextStyle(
    fontSize: 14.0,
    fontFamily: 'Horizon',
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: !soundRecorderState.buttonPressed
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Transform.scale(
              key: soundRecorderState.key,
              scale: soundRecorderState.buttonPressed ? 1.2 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(600),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  width: soundRecorderState.buttonPressed ? 50 : 35,
                  height: soundRecorderState.buttonPressed ? 50 : 35,
                  child: Container(
                    color: (soundRecorderState.buttonPressed)
                        ? backGroundColor ??
                            Theme.of(context).colorScheme.secondary
                        : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: recordIcon ??
                          Icon(
                            Icons.mic,
                            size: 20,
                            color: Colors.black,
                            // (soundRecorderState.buttonPressed)
                            //     ? Colors.grey.shade200
                            //     : Colors.black,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (shouldShowText)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: DefaultTextStyle(
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      slideToCancelText ?? "",
                      textStyle: slideToCancelTextStyle ?? colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
      ],
    );
  }
}
