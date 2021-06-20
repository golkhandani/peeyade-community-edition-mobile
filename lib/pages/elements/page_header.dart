import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pyd/constants.dart';
import 'package:pyd/pages/explore_page.dart';
import 'package:pyd/pages/global_theme_provider.dart';
import 'package:pyd/pages/page_viewer.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
    this.header,
    this.onPressed,
    this.back = false,
  }) : super(key: key);

  final Widget? header;
  final void Function()? onPressed;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (back == true) PageHeaderBackButton(),
          if (header != null && onPressed != null)
            Expanded(
              child: Container(
                height: 48,
                child: ClickableBox(
                  child: header!,
                  onPressed: onPressed!,
                ),
              ),
            ),
          if (header != null && onPressed == null)
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: theme.boxColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: theme.boxColor),
                ),
                child: header!,
              ),
            ),
        ],
      ),
    );
  }
}

class ClickableBox extends StatelessWidget {
  ClickableBox({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  final Widget child;
  final void Function() onPressed;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    var splash = theme.accentColor.withOpacity(0.3);
    return Material(
      elevation: kElevation,
      color: backgroundColor ?? theme.boxColor,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        enableFeedback: true,
        highlightColor: theme.accentColor,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        splashColor: splash,
        onTap: onPressed,
        child: Container(
          constraints: BoxConstraints(minHeight: 48, minWidth: 80),
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: theme.boxShadowColor.withOpacity(0.3),
            //   width: 1,
            // ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PageHeaderTitle extends StatelessWidget {
  const PageHeaderTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            fontSize: 20,
            color: theme.boxTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PageHeaderBackButton extends StatelessWidget {
  const PageHeaderBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      margin: EdgeInsets.only(right: 8.0),
      child: ClickableBox(
        child: Center(
          child: Icon(
            FlutterIcons.arrow_back_mdi,
            color: theme.boxTextColor,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
