import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    String id = Get.parameters['id'] ?? '';
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
