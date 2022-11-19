import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget
{
  final String? message;
  const ErrorDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: SizedBox(
        height: 220,
        child: Column(
          children: [
            Image.asset("assets/video/wrongs.gif",
            height: 100,
            width: 100,),
            const SizedBox(height: 10,),
            const Text("Ooops,",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),),
            const SizedBox(height: 30,),
            Text(message!),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: ()
          {
            Navigator.pop(context);
          },
          child: const Center(
            child: Text("OK"),
          ),
        ),
      ],
    );
  }
}
