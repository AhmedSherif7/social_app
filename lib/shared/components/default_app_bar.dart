import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

PreferredSizeWidget defaultAppBar({
  required context,
  title,
  actions,
}) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(IconBroken.Arrow___Left_2),
    ),
    title: Text(title ?? ''),
    titleSpacing: 5.0,
    actions: actions,
  );
}
