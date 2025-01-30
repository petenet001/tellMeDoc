/*
import 'package:get/get.dart';
import 'package:lis_mobile/composable/cache.dart';

class Middleware {
  static void observer(Routing? routing) async {
    String token = await Storage.get("token");
    if (Get.currentRoute == '/splash') {
      Future.delayed(const Duration(seconds: 2), () async {
        if (token.isEmpty) {
        //  Get.toNamed('/auth');
          Get.offAllNamed('/auth');
        } else {
          //Get.toNamed('/mainpage');
          Get.offAllNamed('/mainpage');
        }
      });
    }
  }
}
*/
