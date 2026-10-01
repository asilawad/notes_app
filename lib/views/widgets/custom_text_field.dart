import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable text field for the Notes App.
///
/// Fill color, borders, radius, padding, hint and error styles all come from
/// `InputDecorationTheme` in `AppTheme`, so this widget defines no visual
/// values of its own. It only adds the behavior shared by the note form
/// fields (title and content) and the search field.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.showCounter = false,
    this.autofocus = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;

  /// Placeholder text. Must come from `AppStrings`.
  final String? hintText;

  /// Matches the `FormField` contract, so `Validators.title` and
  /// `Validators.content` can be passed directly.
  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  /// Overrides the text style (for example a larger style for note titles).
  /// Falls back to the theme's default input style.
  final TextStyle? textStyle;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Hard character limit. Typing and pasting beyond it is blocked.
  final int? maxLength;

  /// Minimum visible lines. Use with `maxLines: null` for a field that
  /// starts tall and keeps growing as the user writes.
  final int? minLines;

  /// Use null for unlimited growth. Any value other than 1 makes the field
  /// multiline.
  final int? maxLines;

  /// Shows the "12/100" character counter when [maxLength] is set.
  final bool showCounter;

  final bool autofocus;

  /// Set to false while saving, so the text cannot change mid-request.
  final bool enabled;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  /// Validates as soon as the user interacts with the field, so errors
  /// appear while typing, not only on submit.
  final AutovalidateMode autovalidateMode;

  bool get _isMultiline => maxLines != 1;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: textStyle,
      enabled: enabled,
      autofocus: autofocus,
      autovalidateMode: autovalidateMode,
      textCapitalization: textCapitalization,
      keyboardType:
          keyboardType ??
          (_isMultiline ? TextInputType.multiline : TextInputType.text),
      textInputAction:
          textInputAction ??
          (_isMultiline ? TextInputAction.newline : TextInputAction.next),
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: showCounter ? null : '',
        alignLabelWithHint: _isMultiline,
      ),
    );
  }
}
