import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateOurApp extends StatefulWidget
{
  const RateOurApp({super.key});



  @override
  State<RateOurApp> createState() => _RateOurAppState();
}

class _RateOurAppState extends State<RateOurApp> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 220,
        child: Column(
          children: [
            Text('Rating: $rating',
            style: TextStyle(fontSize: 30),
            ),
              RatingBar.builder(
                itemSize: 40,
                minRating: 1,
                  itemBuilder: (context, _) => Icon(Icons.star),
                  onRatingUpdate: (rating) => setState(() {
                    this.rating = rating;
                  }),
              )
          ],
        ),
      ),
      actions: [

      ],
    );
  }
}

