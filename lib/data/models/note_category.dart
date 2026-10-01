import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Fixed set of note categories, each with a fixed label, icon and colors.
///
/// Firestore stores the stable [key] (the enum name), never the display
/// [label], so renaming a label in [AppStrings] never breaks saved notes.
enum NoteCategory {
  personal(
    label: AppStrings.categoryPersonal,
    icon: Icons.person_outline_rounded,
    color: AppColors.categoryPersonal,
    tintColor: AppColors.categoryPersonalTint,
  ),
  work(
    label: AppStrings.categoryWork,
    icon: Icons.work_outline_rounded,
    color: AppColors.categoryWork,
    tintColor: AppColors.categoryWorkTint,
  ),
  ideas(
    label: AppStrings.categoryIdeas,
    icon: Icons.lightbulb_outline_rounded,
    color: AppColors.categoryIdeas,
    tintColor: AppColors.categoryIdeasTint,
  ),
  important(
    label: AppStrings.categoryImportant,
    icon: Icons.star_outline_rounded,
    color: AppColors.categoryImportant,
    tintColor: AppColors.categoryImportantTint,
  );

  const NoteCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.tintColor,
  });

  /// Display name shown in the UI.
  final String label;

  /// Icon shown on badges, chips and the category selector.
  final IconData icon;

  /// Solid category color (icons, accents).
  final Color color;

  /// Soft translucent tint (badge and chip backgrounds).
  final Color tintColor;

  /// Category assigned to new notes.
  static const NoteCategory defaultCategory = NoteCategory.personal;

  /// Stable identifier saved in Firestore.
  String get key => name;

  /// Converts a stored [key] back to a category.
  ///
  /// Falls back to [defaultCategory] for null or unknown values, so a bad or
  /// missing field in an old document can never crash the app.
  static NoteCategory fromKey(String? key) {
    for (final NoteCategory category in NoteCategory.values) {
      if (category.name == key) return category;
    }
    return defaultCategory;
  }
}
