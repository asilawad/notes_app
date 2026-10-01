import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';

/// One option in a [FilterChipGroup].
@immutable
class FilterChipItem<T> {
  const FilterChipItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
  });

  /// The value returned when this chip is tapped. Can be a nullable type,
  /// for example `NoteCategory?` where `null` means "All".
  final T value;

  /// Display text. Must come from `AppStrings` (or `NoteCategory.label`).
  final String label;

  final IconData? icon;

  /// Icon color while the chip is not selected. Falls back to the secondary
  /// text color. A selected chip always shows a white icon.
  final Color? iconColor;
}

/// Single-select group of glass filter chips.
///
/// Used for the category filter and the date-range filter on the home
/// screen, and (with [scrollable] set to false) as the category selector in
/// the note form. The group is stateless: the caller owns [selected] and
/// updates it in [onSelected].
class FilterChipGroup<T> extends StatelessWidget {
  const FilterChipGroup({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    this.scrollable = true,
    this.padding = EdgeInsets.zero,
  });

  final List<FilterChipItem<T>> items;

  /// The value of the currently selected chip.
  final T selected;

  final ValueChanged<T> onSelected;

  /// True: a single horizontally scrolling row. False: chips wrap onto
  /// several lines.
  final bool scrollable;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = items
        .map(
          (FilterChipItem<T> item) => _FilterChipTile(
            label: item.label,
            icon: item.icon,
            iconColor: item.iconColor,
            isSelected: item.value == selected,
            onTap: () => onSelected(item.value),
          ),
        )
        .toList(growable: false);

    if (!scrollable) {
      return Padding(
        padding: padding,
        child: Wrap(
          spacing: AppDimensions.spaceXs,
          runSpacing: AppDimensions.spaceXs,
          children: chips,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: <Widget>[
          for (int index = 0; index < chips.length; index++) ...<Widget>[
            if (index > 0) const SizedBox(width: AppDimensions.spaceXs),
            chips[index],
          ],
        ],
      ),
    );
  }
}

/// A single animated chip. Private: use [FilterChipGroup].
class _FilterChipTile extends StatelessWidget {
  const _FilterChipTile({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle =
        Theme.of(context).textTheme.labelMedium ?? const TextStyle();
    final Color foreground = isSelected
        ? AppColors.textOnPrimary
        : AppColors.textPrimary;
    final Color effectiveIconColor = isSelected
        ? AppColors.textOnPrimary
        : (iconColor ?? AppColors.textSecondary);

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: AppDurations.chipSelection,
        curve: AppCurves.standard,
        constraints: const BoxConstraints(minHeight: AppDimensions.chipHeight),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.glassFill,
          borderRadius: AppDimensions.borderRadiusPill,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.glassBorderStrong,
            width: AppDimensions.glassBorderWidth,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppDimensions.borderRadiusPill,
            child: Padding(
              padding: AppDimensions.chipPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (icon != null) ...<Widget>[
                    TweenAnimationBuilder<Color?>(
                      tween: ColorTween(end: effectiveIconColor),
                      duration: AppDurations.chipSelection,
                      builder: (BuildContext context, Color? color, _) {
                        return Icon(
                          icon,
                          size: AppDimensions.iconSm,
                          color: color,
                        );
                      },
                    ),
                    const SizedBox(width: AppDimensions.spaceXxs),
                  ],
                  AnimatedDefaultTextStyle(
                    duration: AppDurations.chipSelection,
                    curve: AppCurves.standard,
                    style: baseStyle.copyWith(color: foreground),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
