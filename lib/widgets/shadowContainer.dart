import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  const ShadowContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://st2.depositphotos.com/4196725/i/600/depositphotos_62170067-stock-photo-black-fabric-texture.jpg"),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(4, 4),
            )
          ]),
      child: child,
    );
  }
}
