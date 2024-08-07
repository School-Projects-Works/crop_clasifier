
import 'package:crop_clasifier/utils/text_styles.dart';
import 'package:flutter/material.dart';





class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.radius = 1,
    this.icon,
  });
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final EdgeInsets? padding;
  final double radius;
  final Widget? icon;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    var styles = CustomTextStyles();
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          onHover = value;
        });
      },
      child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: onHover
                ? Colors.transparent
                : widget.color ?? Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
                color: widget.color ?? Theme.of(context).colorScheme.primary),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) widget.icon!,
                if (widget.icon != null && widget.text.isNotEmpty)
                  const SizedBox(width: 10),
                Text(
                  widget.text,
                  style: styles.bodyStyle(
                      color: onHover
                          ? widget.color ??
                              Theme.of(context).colorScheme.secondary
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )),
    );
  }
}
