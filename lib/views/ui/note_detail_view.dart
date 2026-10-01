import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/note_detail_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/glass_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/note_model.dart';
import '../widgets/app_button.dart';
import '../widgets/category_badge.dart';
import '../widgets/error_state_view.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';

/// Note details screen: a clean reading layout with the category, the
/// created and updated times, and edit and delete actions.
///
/// The note comes from [NoteDetailController], which watches it live by id,
/// so edits made in the form appear here as soon as the user comes back.
/// The reading card shares its Hero tag with the matching `NoteTile`, so the
/// tile animates into this screen.
class NoteDetailView extends GetView<NoteDetailController> {
  const NoteDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _buildHeader(context),
              Expanded(child: _buildBody(context)),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: AppDimensions.screenPadding,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: Get.back<void>,
            tooltip: AppStrings.tooltipBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Expanded(
            child: Text(
              AppStrings.detailsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: controller.editNote,
            tooltip: AppStrings.tooltipEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _confirmDelete(context),
            tooltip: AppStrings.tooltipDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------
  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (controller.hasError.value) {
        return ErrorStateView(
          message: AppStrings.loadError,
          onRetry: controller.retry,
          isRetrying: controller.isRetrying.value,
        );
      }

      final NoteModel? note = controller.note.value;
      // Null only while the controller closes an invalid or deleted note.
      if (note == null) return const SizedBox.shrink();

      return _buildReader(context, note);
    });
  }

  Widget _buildReader(BuildContext context, NoteModel note) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String title = note.title.trim().isEmpty
        ? AppStrings.untitledNote
        : note.title;

    return SingleChildScrollView(
      padding: AppDimensions.screenPadding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.contentMaxWidth,
          ),
          child: Hero(
            tag: note.heroTag,
            flightShuttleBuilder: _buildFlightShuttle,
            child: GlassCard(
              strong: true,
              blurSigma: context.glass.blurStrong,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(title, style: textTheme.headlineSmall),
                  const SizedBox(height: AppDimensions.spaceSm),
                  CategoryBadge(category: note.category),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Text(
                    AppStrings.createdOn(
                      DateFormatter.dateTime(note.createdAt),
                    ),
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppDimensions.spaceXxs),
                  Text(
                    AppStrings.updatedOn(
                      DateFormatter.dateTime(note.updatedAt),
                    ),
                    style: textTheme.bodySmall,
                  ),
                  const Divider(),
                  SelectableText(note.content, style: textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The reading card is much taller than the tile it flies from. Inside a
  /// non-scrolling scroll view the content is clipped instead of overflowing
  /// while the card resizes during the transition.
  Widget _buildFlightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero detailHero =
        (direction == HeroFlightDirection.push
                ? toHeroContext.widget
                : fromHeroContext.widget)
            as Hero;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: detailHero.child,
    );
  }

  // ---------------------------------------------------------------------------
  // Delete confirmation
  // ---------------------------------------------------------------------------
  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.deleteDialogTitle),
          content: const Text(AppStrings.deleteDialogMessage),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: AppButton(
                    label: AppStrings.cancel,
                    variant: AppButtonVariant.secondary,
                    fullWidth: true,
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceXs),
                Expanded(
                  child: AppButton(
                    label: AppStrings.deleteConfirm,
                    variant: AppButtonVariant.danger,
                    fullWidth: true,
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) unawaited(controller.deleteNote());
  }
}
