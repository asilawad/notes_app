import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../data/models/note_category.dart';

/// Small pill showing a note's category: icon in the category color and the
/// label in the primary text color, on a soft translucent tint.
///
/// The label uses the normal text color instead of the category color, since
/// light colors such as amber and sky blue have weak contrast as text on a
/// light background. The icon and tint keep the category recognizable.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final NoteCategory category;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppDimensions.categoryBadgeHeight,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: category.tintColor,
          borderRadius: AppDimensions.borderRadiusPill,
        ),
        child: Padding(
          padding: AppDimensions.badgePadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                category.icon,
                size: AppDimensions.iconXs,
                color: category.color,
              ),
              const SizedBox(width: AppDimensions.spaceXxs),
              Flexible(
                child: Text(
                  category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
