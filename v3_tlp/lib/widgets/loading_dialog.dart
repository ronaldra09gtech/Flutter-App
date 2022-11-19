import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingDialog extends StatelessWidget
{
  final String? message;

  const LoadingDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.withOpacity(0.2),
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 12),
          child: const SpinKitFadingCircle(
            color: Colors.white,
            size: 70,
          )
      ),
          const SizedBox(height: 10,),
          const Text("Please Wait...",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16
          ),)

        ],
      ),
    );
  }
}