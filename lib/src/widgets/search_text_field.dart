import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.controller,
    required this.onSubmitted,
    required this.onChanged,
  }) : super(key: key);

  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onChanged: onChanged,
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.only(
          left: 15,
          bottom: 11,
          top: 11,
          right: 15,
        ),
      ),
    );
  }
}
