import 'dart:math';

import 'package:get/get.dart';

class PostModel {
  int? userId;
  int? id;
  String? title;
  String? body;
  RxInt? isRead;
  RxInt? seconds;

  PostModel(
      {this.userId, this.id, this.title, this.body, this.isRead, this.seconds});

  PostModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
    isRead = RxInt(json['isRead'] ?? 0);
    seconds = RxInt(json['seconds'] ?? Random().nextInt(60));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['isRead'] = this.isRead?.value;
    data['seconds'] = this.seconds?.value;
    return data;
  }
}
