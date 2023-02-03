import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

// const Icon reactionIcon0= Icon(
//   Icons.thumb_up_alt_outlined,
//   size: 20,
//   color: Colors.white,
// );
//
// const Icon reactionIcon1= Icon(
//   Icons.sentiment_very_satisfied_outlined ,
//   size: 20,
//   color: Colors.white,
// );
//
// const Icon reactionIcon1= Icon(
//   Icons.sentiment_very_dissatisfied,
//   size: 20,
//   color: Colors.white,
// );
//
// const Icon reactionIcon1= Icon(
//   Icons.sentiment_satisfied_alt_rounded,
//   size: 20,
//   color: Colors.white,
// );
//
// const Icon reactionIcon2= Icon(
//   Icons.celebration_outlined,
//   size: 20,
//   color: Colors.white,
// );
//
// const Icon reactionIcon3= Icon(
//   Icons.lightbulb_outline_rounded,
//   size: 20,
//   color: Colors.white,
// );
//
// const Icon reactionIcon4= Icon(
//   Icons.favorite,
//   size: 20,
//   color: Colors.white,
// );

/*const List<Icon> reactionIcons=[
  Icon(
    Icons.thumb_up_alt_outlined,
    size: 20,
    color: Colors.white,
  ),
  Icon(
    Icons.sentiment_satisfied_alt_rounded,
    size: 20,
    color: Colors.white,
  ),
  Icon(
    Icons.celebration_outlined,
    size: 20,
    color: Colors.white,
  ),
  Icon(
    Icons.lightbulb_outline_rounded,
    size: 20,
    color: Colors.white,
  ),
  Icon(
    Icons.favorite,
    size: 20,
    color: Colors.white,
  )
];*/

// const List<IconData> reactionIcons=[
//   Icons.thumb_up_alt_rounded,
//   Icons.sentiment_very_satisfied,
//   Icons.celebration_rounded,
//   Icons.lightbulb_rounded,
//   Icons.favorite,
// ];

const List<String> reactionImages = [
  "lib/asset/Reactions/clapping1.png",
  "lib/asset/ChatReactionImage/heart.png",
  //"lib/asset/Reactions/interested.png",
  //"lib/asset/icons/heart.png",
  "lib/asset/Reactions/going.png",
  "lib/asset/Reactions/vibes1.png",
  //"lib/asset/Reactions/clapping1.png",
  "lib/asset/Reactions/bear.png",
];

const List<String> reactionTexts = [
  "Love",
  "Interested",
  "Going",
  "Vibes",
  "Let's gooo!",
  // "Go bears",
];


const List<String> chatReactionImages = [
  "lib/asset/ChatReactionImage/heart.png",
  "lib/asset/ChatReactionImage/laugh.png",
  "lib/asset/ChatReactionImage/wow.png",
  "lib/asset/ChatReactionImage/cry.png",
  "lib/asset/ChatReactionImage/angry.png",
  "lib/asset/ChatReactionImage/like.png",
  "lib/asset/ChatReactionImage/dislike.png",
  "lib/asset/ChatReactionImage/love-hearts-eyes-emoji.png",
  "lib/asset/ChatReactionImage/smiling-face-with-sunglasses-cool-emoji.png",
  "lib/asset/ChatReactionImage/smiley-hd-free-transparent-image.png",
  "lib/asset/ChatReactionImage/angel-blushing-smile-emoji.png",
  "lib/asset/ChatReactionImage/emoticon-signal-smiley-thumb-emoji-free-frame.png",
  "lib/asset/ChatReactionImage/emoticon-heart-smiley-upscale-whatsapp-emoji.png",
  "lib/asset/ChatReactionImage/tongue-out-emoji.png",
  "lib/asset/ChatReactionImage/loudly-crying-emoji.png",
  "lib/asset/ChatReactionImage/fearful-emoji.png",
  "lib/asset/ChatReactionImage/unamused-face-emoji-png.png",
  "lib/asset/ChatReactionImage/smiley-image-free-png-hq.png",
  "lib/asset/ChatReactionImage/sad-crying-emoji-png.png",
  "lib/asset/ChatReactionImage/emoticon-thinking-thought-world-whatsapp-day-emoji.png",
  "lib/asset/ChatReactionImage/smiley-png-download-free.png",
  "lib/asset/ChatReactionImage/emoticon-angry-anger-emojis-sticker-emoji.png",
  "lib/asset/ChatReactionImage/smiley-free-clipart-hd.png",
  "lib/asset/ChatReactionImage/smiley-images-free-transparent-image-hq.png",
  "lib/asset/ChatReactionImage/emoticon-sticker-smiley-sleep-kaomoji-emoji.png",
  "lib/asset/ChatReactionImage/emoticon-of-smiley-face-tears-joy-whatsapp.png",
  "lib/asset/ChatReactionImage/smiley-download-free-photo-png.png",
  "lib/asset/ChatReactionImage/heart-domain-sticker-emoji-free-download-png-hd.png",
  "lib/asset/ChatReactionImage/heart-broken-love-emoticon-emoji-free-clipart-hq.png",
  "lib/asset/ChatReactionImage/emoticon-whatsapp-emoji-free-photo-png.png",
  "lib/asset/ChatReactionImage/thank-discord-media-thought-social-think-emoji.png",
  "lib/asset/ChatReactionImage/emoticon-emotion-smiley-iphone-emoji-free-transparent-image-hd.png",
  "lib/asset/ChatReactionImage/emoticon-smirk-sticker-world-day-emoji_800x800.png",
  "lib/asset/ChatReactionImage/emoticon-on-money-keep-bag-carving-emoji.png",
  "lib/asset/ChatReactionImage/photos-dislike-emoji-hq-image-free.png",
];


List<Reaction<String>> reactionClassList = [
  // Reaction<String>(
  //     icon: Image.asset(
  //       "lib/asset/Reactions/interested.png",
  //       width: 01,
  //     ),
  //     // previewIcon: _buildReactionsPreviewIcon("lib/asset/Reactions/interested.png"),
  //     value: "-1",
  //     title: _buildTitle("")),


  Reaction<String>(
      icon: Image.asset(
        "lib/asset/Reactions/love1.png",
        width: 20,
      ),
      previewIcon: _buildReactionsPreviewIcon("lib/asset/Reactions/love.png"),
      value: "0",
      title: _buildTitle("  Love  ")),

  Reaction<String>(
      icon: Image.asset(
        "lib/asset/Reactions/interested.png",
        width: 20,
      ),
      previewIcon: _buildReactionsPreviewIcon("lib/asset/Reactions/interested.png"),
      value: "1",
      title: _buildTitle("Interested")),


  Reaction<String>(
    icon: Image.asset(
      "lib/asset/Reactions/going.png",
      width: 20,
    ),
      previewIcon: _buildReactionsPreviewIcon("lib/asset/Reactions/going.png"),
      value: "2",
    title: _buildTitle("Going")),


  Reaction<String>(
      icon: Image.asset(
        "lib/asset/Reactions/vibes1.png",
        width: 20,
      ),
      previewIcon: _buildReactionsPreviewIcon("lib/asset/Reactions/vibes1.png"),
      value: "3",
      title: _buildTitle("Vibes")),

  Reaction<String>(
      icon: Image.asset(
        "lib/asset/Reactions/clapping1.png",
        width: 20,
      ),
      previewIcon: _buildReactionsPreviewIcon("lib/asset/Reactions/clapping.png"),
      value: "4",
      title: _buildTitle("Let's gooo!")),

  // Reaction<String>(
  //     icon: Image.asset(
  //       "lib/asset/Reactions/bear.png",
  //       width: 20,
  //     ),
  //     previewIcon: _buildReactionsPreviewIcon("lib/asset/Reactions/bear.png"),
  //     value: "5",
  //     title: _buildTitle("Go bears!")),


];

Container _buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 45),
  );
}

Container _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}

// List<Color> reactionIconColors=[
//   Colors.orange,
//   Colors.red,
//   Colors.white,
//   Colors.amber,
//   Colors.blue,
// ];

List<Color> reactionIconBGColors = [
  Colors.orange[50],
  Colors.red[50],
  Colors.white,
  Colors.yellow[50],
  Colors.blue[50],
];
