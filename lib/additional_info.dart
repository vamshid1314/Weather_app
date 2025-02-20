import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget{
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Icon(icon,
            size: 28),

        const SizedBox(height: 15),

        Text(
          label,
          style: TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          value,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}