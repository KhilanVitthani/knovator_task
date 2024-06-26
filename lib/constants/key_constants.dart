import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const googleApiKey = "AIzaSyCpIeFLQ0WiscoWAPgm8InBjrcqZxLgD30";

double maxHeight = 773;
double maxWidth = 390;

var constrainsForWeb = !isWeb
    ? null
    : BoxConstraints(
        // minHeight: maxHeight,
        // maxHeight: maxHeight,
        minWidth: maxWidth,
        maxWidth: maxWidth,
      );

bool isWeb = (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)
    ? false
    : true;
GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
