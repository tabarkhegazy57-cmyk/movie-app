import 'package:flutter/material.dart';
import 'package:movie_app/core/appcolor.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.sufIcon,required this.angle, required this.toolTipMessage});

  final String title;
  final Widget? sufIcon;
  final double angle;
  final String toolTipMessage;
  @override

  Widget build(BuildContext context) {


    return AppBar(
      backgroundColor: AppColors.backGround,
      centerTitle: true,
      titleSpacing: 0,
      leadingWidth: 90,
      leading: IconButton(
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        },
        icon: Icon(Icons.arrow_back_ios, color: AppColors.appBarColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.appBarColor,
        ),
      ),
      actions: [
        SizedBox(
          width: 90,
          child: Tooltip(
            message: toolTipMessage,
            child: Transform.rotate(
                angle: angle,
                child:sufIcon
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}