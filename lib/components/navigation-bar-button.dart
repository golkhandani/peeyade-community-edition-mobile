import 'package:flutter/material.dart';

class NavigationBarButton extends StatelessWidget {
  NavigationBarButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.enable,
  }) : super(key: key);
  final void Function()? onPressed;
  final IconData icon;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      animationDuration: Duration(milliseconds: 300),
      constraints: BoxConstraints(
          maxHeight: 64, maxWidth: 64, minHeight: 64, minWidth: 64),
      elevation: 6,
      splashColor: Colors.transparent,
      enableFeedback: true,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: enable ? Colors.black87 : Colors.black38),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.elliptical(120, 100)),
          shape: BoxShape.rectangle,
        ),
        child: Icon(
          icon,
          color: enable ? Colors.black87 : Colors.black38,
          size: 25,
        ),
      ),
    );
  }
}
