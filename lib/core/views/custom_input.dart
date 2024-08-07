import 'package:crop_clasifier/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CustomTextFields extends ConsumerWidget {
  const CustomTextFields({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.keyboardType,
    this.onChanged,
    this.onSaved,
    this.maxLines,
    this.hintText,
    this.radius,
    this.onTap,
    this.helperText,
    this.isCapitalized = false,
    this.isDigitOnly = false,
    this.min = 0,
    this.max = 999999,
    this.color,
    this.isReadOnly = false,
    this.validator,
    this.controller,
    this.isPhoneInput = false,
    this.onSubmitted,
    this.focusNode,
    this.initialValue,
  });

  final String? label;
  final String? helperText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onSubmitted;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final int? maxLines;
  final double? radius;
  final bool? isCapitalized;
  final bool? isDigitOnly;
  final bool? isReadOnly;
  final Color? color;
  final int? max, min;
  final TextEditingController? controller;
  final bool? isPhoneInput;
  final String? initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = CustomTextStyles();
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText ?? false,
      onTap: onTap,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
      initialValue: initialValue,
      inputFormatters: [
        if (isCapitalized!) UpperCaseTextFormatter(),
        if (isDigitOnly ?? false)
          FilteringTextInputFormatter.allow(RegExp(r'^[-+]?\d*\.?\d{0,200}')),
        PreventDeleteFormatter(max!, min!),
      ],
      textCapitalization: isCapitalized!
          ? TextCapitalization.characters
          : TextCapitalization.none,
      style: styles.bodyStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isReadOnly!
              ? Theme.of(context).textTheme.labelLarge!.color!
              : Theme.of(context).textTheme.labelLarge!.color!),
      onChanged: onChanged,
      onSaved: onSaved,
      maxLines: maxLines ?? 1,
      readOnly: isReadOnly ?? false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(
            color: color ?? Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(
            color: color ?? Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
        fillColor: Colors.transparent,
        filled: true,
        errorStyle: styles.bodyStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(
              color: color ?? Theme.of(context).colorScheme.secondary),
        ),
        prefixIconColor: Theme.of(context).colorScheme.secondary,
        suffixIconColor: Theme.of(context).colorScheme.secondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        labelStyle: styles.bodyStyle(
          fontWeight: FontWeight.w300
        ),
        labelText: label,
        hintText: hintText,
        focusColor: Theme.of(context).colorScheme.secondary,
        helperText: helperText,
        helperStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        iconColor: Theme.of(context).colorScheme.secondary,
        hintStyle: styles.bodyStyle(
            fontWeight: FontWeight.w300, fontSize: 13),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 18,
                color: Theme.of(context).colorScheme.secondary,
              )
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (RegExp("[a-zA-Z,]").hasMatch(newValue.text)) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
    } else if (!RegExp(r'^[a-zA-Z0-9_\-=@+,\.;]+$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class PreventDeleteFormatter extends TextInputFormatter {
  final int max, min;

  PreventDeleteFormatter(this.max, this.min);
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > min - 1 && newValue.text.length < max + 1) {
      return newValue;
    }
    return oldValue;
  }
}
