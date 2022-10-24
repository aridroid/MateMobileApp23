import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/bookmarkByUserModel.dart';
import 'package:mate_app/Model/feedItemsBookmarkModel.dart';
import 'package:mate_app/Model/feedItemsLikeModel.dart';
import 'package:mate_app/Model/feedsCommentFetchModel.dart';

import '../../Services/APIService.dart';
import '../../Services/BackEndAPIRoutes.dart';

class AboutService {

  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

}
