import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool isButtonDisabled = false.obs;
  Rx<PageController> pageController = PageController(initialPage: 0).obs;

  void submitClick() {
    currentPage.value = 0;
    pageController.value = 1 as PageController;
  }
}
