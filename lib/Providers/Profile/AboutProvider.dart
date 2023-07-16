import 'package:mate_app/Model/bookmarkByUserModel.dart';
import 'package:mate_app/Model/feedItemsBookmarkModel.dart';
import 'package:mate_app/Model/feedItemsLikeModel.dart';
import 'package:mate_app/Model/feedsCommentFetchModel.dart';

import '../../Exceptions/Custom_Exception.dart';

import '../../Model/FeedItem.dart';
import '../../Model/FeedType.dart' as feedType;
import '../../Services/Profile/AboutService.dart';
import 'package:flutter/material.dart';

class AboutProvider with ChangeNotifier {
  /// initialization
  AboutService _aboutService = AboutService();

  ///constructor
  // AboutProvider() {
  //   _aboutService = AboutService();
  // }

  Future<void> fetchAboutSection() async {
    notifyListeners();
  }


}
