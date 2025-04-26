import 'package:flutter/material.dart';

class Valoracion extends StatelessWidget {
  final String rating; 

  const Valoracion({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int numericRating = int.tryParse(rating) ?? 0;
    int starCount = (numericRating / 10).round(); 
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < starCount ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }
}