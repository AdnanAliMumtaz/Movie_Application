import 'package:flutter/material.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField; // Indicates whether it's a password field
  final String? hintText; // Hint text for the field
  final String? labelText; // Label text for the field
  final FormFieldSetter<String>? onSaved; // Function to be called when form is saved
  final FormFieldValidator<String>? validator; // Validator for form field
  final ValueChanged<String>? onFieldSubmitted; // Function to be called when field is submitted
  final TextInputType? inputType; // Keyboard type for the field

  const FormContainerWidget({
    Key? key,
    this.controller,
    this.fieldKey,
    this.isPasswordField,
    this.hintText,
    this.labelText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
  }) : super(key: key); // Use const constructor and pass the key parameter

  @override
  _FormContainerWidgetState createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true; // Toggle for password visibility

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.35),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 58,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: widget.controller,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField ?? false, // Using null-aware operator
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          labelText: widget.labelText,
          // Show suffix icon only for password fields
          suffixIcon: widget.isPasswordField == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                )
              : null, // Set to null if it's not a password field
        ),
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        keyboardType: widget.inputType,
      ),
    );
  }
}
