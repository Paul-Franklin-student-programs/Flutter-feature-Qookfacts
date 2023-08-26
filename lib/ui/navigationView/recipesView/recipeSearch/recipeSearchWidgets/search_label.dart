import 'package:flutter/material.dart';

class SearchLabel extends StatelessWidget {
  final String label;

  const SearchLabel({Key? key,required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'opensans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
