import 'package:get/get.dart';

import '../controllers/reserved_controller.dart';

class ReservedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReservedController>(
      () => ReservedController(),
    );
  }
}
