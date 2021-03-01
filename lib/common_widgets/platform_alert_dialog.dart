import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tracker_app/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {this.cancelActionText,
      @required this.title,
      @required this.content,
      @required this.defaultActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final title;
  final content;
  final cancelActionText;
  final defaultActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelActionText),
        ),
      );
    }
    actions.add(PlatformAlertDialogAction(
      onPressed: () => Navigator.of(context).pop(true),
      child: Text(defaultActionText),
    ));
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({this.child, this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
