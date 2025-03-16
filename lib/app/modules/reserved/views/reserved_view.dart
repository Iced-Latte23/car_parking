import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reserved_controller.dart';

class ReservedView extends GetView<ReservedController> {
  const ReservedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReservedView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReservedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
