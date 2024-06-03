import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:knovator_task/constants/sizeConstant.dart';
import 'package:knovator_task/models/postModel.dart';

import '../../../../constants/color_constant.dart';
import '../controllers/post_detail_controller.dart';

class PostDetailView extends GetWidget<PostDetailController> {
  const PostDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Post Detail'),
          centerTitle: true,
        ),
        body: (controller.hasData.isFalse)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title: ${controller.post.value.title}")
                        .boldSubStrings(
                      ["Title"],
                      boldTextColor: Colors.black,
                      boldFontWeight: FontWeight.bold,
                      boldFontSize: 15,
                      normalTextColor: Colors.black,
                      normalFontWeight: FontWeight.w500,
                      normalFontSize: 12,
                    ),
                    Spacing.height(10),
                    Text("Detail: ${controller.post.value.body}")
                        .boldSubStrings(
                      ["Detail"],
                      boldTextColor: Colors.black,
                      boldFontWeight: FontWeight.bold,
                      boldFontSize: 15,
                      normalTextColor: Colors.black,
                      normalFontWeight: FontWeight.w500,
                      normalFontSize: 12,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

extension BoldSubStrings on Text {
  Text boldSubStrings(
    List<String> targets, {
    Color? boldTextColor,
    FontWeight? boldFontWeight,
    double? boldFontSize,
    Color? normalTextColor,
    FontWeight? normalFontWeight,
    double? normalFontSize,
  }) {
    final textSpans = <TextSpan>[];
    final escapedTargets = targets.map((target) => RegExp.escape(target));
    final pattern = RegExp(escapedTargets.join('|'), caseSensitive: false);
    final matches = pattern.allMatches(data!);

    int currentIndex = 0;
    for (final match in matches) {
      final beforeMatch = data!.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        textSpans.add(TextSpan(text: beforeMatch));
      }

      final matchedText = data!.substring(match.start, match.end);
      textSpans.add(
        TextSpan(
          text: matchedText,
          style: TextStyle(
            fontWeight: boldFontWeight ?? FontWeight.w500,
            color: boldTextColor ?? Colors.black,
            fontSize: MySize.getHeight(boldFontSize ?? 14),
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < data!.length) {
      final remainingText = data!.substring(currentIndex);
      textSpans.add(TextSpan(text: remainingText));
    }

    return Text.rich(
      TextSpan(children: textSpans),
      style: TextStyle(
        fontWeight: normalFontWeight ?? FontWeight.w500,
        color: normalTextColor ?? Colors.black,
        fontSize: MySize.getHeight(normalFontSize ?? 12),
      ),
    );
  }
}
