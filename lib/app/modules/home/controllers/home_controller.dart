import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:knovator_task/constants/api_constants.dart';
import 'package:knovator_task/constants/sizeConstant.dart';
import 'package:knovator_task/data/NetworkClient.dart';
import 'package:knovator_task/database/db_helper.dart';
import 'package:knovator_task/utilities/progress_dialog_utils.dart';

import '../../../../main.dart';
import '../../../../models/postModel.dart';

class HomeController extends GetxController {
  RxList<PostModel> postList = <PostModel>[].obs;
  RxList<PostModel> localList = <PostModel>[].obs;
  RxBool hasData = false.obs;
  Timer? timer;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getIt<DBHelper>().getPostData().then((value) {
        if (!isNullEmptyOrFalse(value)) {
          hasData.value = true;
          localList.clear();
          localList.addAll(value!);
          postList.clear();
          postList.addAll(localList);
          print(postList.length);
        }
        update();
      });
      await getPostListApi(context: Get.context!);
    });
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

  getPostListApi({required BuildContext context}) async {
    await NetworkClient.getInstance.callApi(
      context,
      ApiConstant.baseUrl,
      ApiConstant.getPost,
      MethodType.Get,
      successCallback: (response, message) {
        hasData.value = true;
        if (!isNullEmptyOrFalse(response)) {
          postList.clear();
          postList.addAll(
              (response as List).map((e) => PostModel.fromJson(e)).toList());
          postList.forEach((element) async {
            if (localList.any(
              (e) => e.id == element.id,
            )) {
              PostModel post = localList.firstWhere((e) => e.id == element.id);
              element.isRead!.value = post.isRead!.value;
              element.seconds!.value = post.seconds!.value;
            } else {
              await getIt<DBHelper>().insert(element);
            }
          });
        }
        update();
      },
      failureCallback: (message, statusCode) {
        hasData.value = true;
        if (postList.isEmpty) {
          getIt<CustomDialogs>().getDialog(
            title: "Error",
            desc:
                "Something went wrong. Please check your internet connection.",
          );
        }
      },
    );
  }
}
