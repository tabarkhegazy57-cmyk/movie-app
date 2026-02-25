import 'package:flutter/material.dart';

class SizedGestureClip extends StatelessWidget {
  const SizedGestureClip({super.key, required this.onTap, required this.path});

  final VoidCallback onTap;
  final String path;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 300,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(path,fit: BoxFit.fill,),
        ),
      ),
    );
  }
}