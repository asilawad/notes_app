import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import 'glass_card.dart';

/// Glass search input with a search icon and an animated clear button.
///
/// The [controller] is owned by the caller (`HomeController`), which also
/// applies the 300 ms debounce, so [onChanged] is forwarded on every
/// keystroke. The clear button appears only while the field has text, and
/// clearing also calls [onChanged] with an empty string, so the list resets.
class SearchBarField extends StatelessWidget {
  const SearchBarField({
    super.key,
    required this.controller,
    this.onChanged,
    this.focusNode,
    this.hintText = AppStrings.searchHint,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String hintText;

  void _clear() {
    controller.clear();
    onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GlassCard(
      strong: true,
      borderRadius: AppDimensions.borderRadiusPill,
      padding: const EdgeInsetsDirectional.only(
        start: AppDimensions.spaceMd,
        end: AppDimensions.spaceXxs,
      ),
      child: SizedBox(
        height: AppDimensions.searchBarHeight,
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.search_rounded,
              size: AppDimensions.iconMd,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spaceXs),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                textInputAction: TextInputAction.search,
                maxLines: 1,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: theme.inputDecorationTheme.hintStyle,
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (BuildContext context, TextEditingValue value, _) {
                return AnimatedSwitcher(
                  duration: AppDurations.fadeSwitcher,
                  child: value.text.isEmpty
                      ? const SizedBox.shrink(key: ValueKey<bool>(false))
                      : IconButton(
                          key: const ValueKey<bool>(true),
                          tooltip: AppStrings.tooltipClearSearch,
                          onPressed: _clear,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: AppDimensions.iconSm,
                            color: AppColors.textSecondary,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
