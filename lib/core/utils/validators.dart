import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

/// Form field validators for the Notes App.
///
/// Every validator matches the `FormField` contract: it returns `null` when
/// the value is valid, or the error message to display when it is not.
abstract final class Validators {
  /// Validates the note title: required and within the maximum length.
  static String? title(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.titleRequired;
    if (text.length > AppDimensions.noteTitleMaxLength) {
      return AppStrings.titleTooLong(AppDimensions.noteTitleMaxLength);
    }
    return null;
  }

  /// Validates the note content: required and within the maximum length.
  static String? content(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.contentRequired;
    if (text.length > AppDimensions.noteContentMaxLength) {
      return AppStrings.contentTooLong(AppDimensions.noteContentMaxLength);
    }
    return null;
  }
}
