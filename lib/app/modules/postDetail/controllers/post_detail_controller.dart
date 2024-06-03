import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:knovator_task/constants/api_constants.dart';
import 'package:knovator_task/constants/sizeConstant.dart';
import 'package:knovator_task/data/NetworkClient.dart';
import 'package:knovator_task/utilities/progress_dialog_utils.dart';

import '../../../../database/db_helper.dart';
import '../../../../main.dart';
import '../../../../models/postModel.dart';

class PostDetailController extends GetxController {
  Rx<PostModel> post = PostModel().obs;
  RxBool hasData = false.obs;
  Timer? timer;
  @override
  void onInit() {
    if (Get.arguments != null) {
      post.value = Get.arguments[ArgumentConstant.post] ?? PostModel();
      if (post.value.isRead!.value == 1) {
        startTimer(post: post.value);
      }
    }
    getPostByIdApi(context: Get.context!);
    super.onInit();
  }

  startTimer({required PostModel post}) {
    box.write(PrefConstant.post, post.toJson());
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) async {
        if (post.seconds!.value > 0) {
          post.seconds!.value = post.seconds!.value - 1;
        } else {
          post.seconds!.value = 0;
          stopTimer(post: post);
        }
      },
    );
  }

  stopTimer({required PostModel post}) {
    timer?.cancel();
    getIt<DBHelper>().updateSeconds(id: post.id!, seconds: post.seconds!);
  }

  getPostByIdApi({required BuildContext context}) async {
    hasData.value = false;
    await NetworkClient.getInstance.callApi(
      context,
      ApiConstant.baseUrl,
      ApiConstant.getPostById + "/${post.value.id}" ?? "",
      MethodType.Get,
      successCallback: (response, message) {
        hasData.value = true;
        if (!isNullEmptyOrFalse(response)) {
          response["seconds"] = post.value.seconds!.value;
          post.value = PostModel.fromJson(response);
        }
        update();
      },
      failureCallback: (message, statusCode) {
        hasData.value = true;
        if (isNullEmptyOrFalse(post.value)) {
          getIt<CustomDialogs>().getDialog(
            title: "Error",
            desc: "${message}",
          );
        }
      },
    );
  }

  @override
  void onClose() {
    stopTimer(post: post.value);
    super.onClose();
  }
}
