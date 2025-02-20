import 'package:flutter/material.dart';

class HourlyForcast extends StatelessWidget{
  final String time;
  final String value;
  final IconData icon;
  const HourlyForcast({
    super.key,
    required this.time,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            Icon(icon,size: 28),

            const SizedBox(height: 8),

            Text(
                value
            )
          ],
        ),
      ),
    );
  }
}