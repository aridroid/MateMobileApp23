import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {

  @override
  void onInit() {
    getStoredValue();
    super.onInit();
  }

  bool isDarkMode = true;

  getStoredValue()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool("isDarkMode")??true;
    update();
  }

  void toggleDarkMode()async{
    isDarkMode = !isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", isDarkMode);
    update();
  }

}