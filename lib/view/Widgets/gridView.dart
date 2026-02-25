import 'package:flutter/material.dart';

class CustomGridviewBuilder extends StatelessWidget {

  const CustomGridviewBuilder({super.key,required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget Function(BuildContext,int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 10,
            childAspectRatio: .7),
        itemBuilder: itemBuilder
        ,itemCount: itemCount);
  }
}