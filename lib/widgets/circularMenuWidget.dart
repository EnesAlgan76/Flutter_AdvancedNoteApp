import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';

class CircularMenuWidget extends StatelessWidget {
  final Function() onGalleryImage;
  final Function() onCaptureImage;
  final Function() onAddReminder;
  final Function() onAddTask;

  CircularMenuWidget({
    required this.onGalleryImage,
    required this.onCaptureImage,
    required this.onAddReminder,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      toggleButtonAnimatedIconData: AnimatedIcons.menu_close,
      alignment: Alignment.bottomLeft,
      toggleButtonColor: Color(0xff006c8d),
      toggleButtonSize: 25,
      toggleButtonMargin: 20,
      toggleButtonPadding: 13,
      startingAngleInRadian: pi * 1.50,
      endingAngleInRadian: pi * 1.99,
      radius: 100,
      toggleButtonBoxShadow: [],
      items: [
        CircularMenuItem(
          color: Color(0xff595959),
          iconSize: 20,
          boxShadow: [],
          icon: Icons.photo,
          onTap: () => onGalleryImage(),
        ),
        CircularMenuItem(
          color: Color(0xff207178),
          icon: Icons.camera_alt_rounded,
          iconSize: 20,
          boxShadow: [],
          onTap: onCaptureImage,
        ),
        CircularMenuItem(
          color: Color(0xfffdc701),
          icon: Icons.alarm_add_rounded,
          iconSize: 20,
          boxShadow: [],
          onTap: onAddReminder,
        ),
        CircularMenuItem(
          color: Color(0xff9c0757),
          icon: Icons.check_circle_outline_rounded,
          iconSize: 20,
          boxShadow: [],
          onTap: onAddTask,
        ),
      ],
    );
  }
}
