import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:knovator_task/app/routes/app_pages.dart';
import 'package:knovator_task/constants/sizeConstant.dart';
import 'package:knovator_task/models/postModel.dart';

import '../../../../constants/api_constants.dart';
import '../../../../database/db_helper.dart';
import '../../../../main.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: (controller.hasData.isFalse)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (controller.postList.isEmpty)
                ? Center(
                    child: Text("No Data found"),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        if (!isNullEmptyOrFalse(box.read(PrefConstant.post))) {
                          PostModel post =
                              PostModel.fromJson(box.read(PrefConstant.post));
                          controller.stopTimer(post: post);
                        }
                      }
                      return true;
                    },
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (context, index) {
                          PostModel post = controller.postList[index];
                          return Obx(() {
                            return InkWell(
                              onTap: () async {
                                controller.stopTimer(post: post);
                                await Get.toNamed(Routes.POST_DETAIL,
                                    arguments: {
                                      ArgumentConstant.post: post,
                                    });
                                if (post.isRead?.value == 0) {
                                  post.isRead!.value = 1;
                                  getIt<DBHelper>()
                                      .updateRead(id: post.id!, status: 1.obs);
                                  controller.update();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (post.isRead?.value == 1)
                                      ? Colors.white
                                      : Colors.yellow.shade500,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        post.title ?? "",
                                        style: TextStyle(
                                          fontSize: MySize.getHeight(15),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Spacing.width(10),
                                    InkWell(
                                      onTap: () {
                                        controller.stopTimer(post: post);
                                        controller.startTimer(post: post);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              size: MySize.getWidth(15),
                                            ),
                                            Text(
                                              "${post.seconds?.value} sec",
                                              style: TextStyle(
                                                fontSize: MySize.getHeight(12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        separatorBuilder: (context, index) {
                          return Spacing.height(10);
                        },
                        itemCount: controller.postList.length),
                  ),
      );
    });
  }
}
