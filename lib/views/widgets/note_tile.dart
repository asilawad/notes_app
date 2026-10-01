import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/glass_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/note_model.dart';
import 'category_badge.dart';
import 'glass_card.dart';

/// How a [NoteTile] is laid out.
enum NoteTileLayout {
  /// Full-width row-style card for the list view.
  list,

  /// Compact card that fills its grid cell (fixed height from the grid).
  grid,
}

/// Note card for the home screen, in a list or a grid layout.
///
/// The card is wrapped in a [Hero] using `note.heroTag`, and the details
/// screen must use the same tag, so the card animates into the details view.
///
/// Performance: every tile uses the light blur (`GlassTheme.blurLight`), and
/// [GlassCard] isolates it in a `RepaintBoundary`.
///
/// Note: in [NoteTileLayout.grid] the preview expands to fill the cell, so
/// that layout must be placed in a bounded-height parent such as a
/// `SliverGrid` cell.
class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    this.onLongPress,
    this.layout = NoteTileLayout.list,
  });

  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final NoteTileLayout layout;

  bool get _isGrid => layout == NoteTileLayout.grid;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String title = note.title.trim().isEmpty
        ? AppStrings.untitledNote
        : note.title;

    final Widget preview = Text(
      note.content,
      maxLines: _isGrid
          ? AppDimensions.noteGridPreviewMaxLines
          : AppDimensions.noteListPreviewMaxLines,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium,
    );

    return Hero(
      tag: note.heroTag,
      child: GlassCard(
        blurSigma: context.glass.blurLight,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          mainAxisSize: _isGrid ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              maxLines: _isGrid
                  ? AppDimensions.noteGridTitleMaxLines
                  : AppDimensions.noteListTitleMaxLines,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spaceXs),
            if (_isGrid) Expanded(child: preview) else preview,
            const SizedBox(height: AppDimensions.spaceSm),
            _buildFooter(textTheme),
          ],
        ),
      ),
    );
  }

  /// Category badge and relative "last updated" time.
  Widget _buildFooter(TextTheme textTheme) {
    final Widget date = Text(
      DateFormatter.relative(note.updatedAt),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodySmall,
    );

    // The grid cell is narrow, so the badge and date may wrap onto two lines.
    if (_isGrid) {
      return Wrap(
        spacing: AppDimensions.spaceXs,
        runSpacing: AppDimensions.spaceXxs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          CategoryBadge(category: note.category),
          date,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child: CategoryBadge(category: note.category)),
        const SizedBox(width: AppDimensions.spaceXs),
        Flexible(child: date),
      ],
    );
  }
}
