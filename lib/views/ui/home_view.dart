import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/responsive.dart';
import '../../data/models/note_category.dart';
import '../../data/models/note_model.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/app_button.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/error_state_view.dart';
import '../widgets/filter_chip_group.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_view.dart';
import '../widgets/note_tile.dart';
import '../widgets/search_bar_field.dart';

/// Which content the home screen is showing. Used as the switcher key.
enum _HomeContent { loading, error, noNotes, noResults, notes }

/// Category filter chips: "All" (null) followed by the fixed categories.
final List<FilterChipItem<NoteCategory?>> _categoryFilterItems =
    <FilterChipItem<NoteCategory?>>[
      const FilterChipItem<NoteCategory?>(
        value: null,
        label: AppStrings.categoryAll,
        icon: Icons.apps_rounded,
      ),
      for (final NoteCategory category in NoteCategory.values)
        FilterChipItem<NoteCategory?>(
          value: category,
          label: category.label,
          icon: category.icon,
          iconColor: category.color,
        ),
    ];

/// Date-range filter chips.
final List<FilterChipItem<DateRangeFilter>> _dateFilterItems = DateRangeFilter
    .values
    .map(
      (DateRangeFilter filter) =>
          FilterChipItem<DateRangeFilter>(value: filter, label: filter.label),
    )
    .toList(growable: false);

/// Home screen: header, search, filters and the notes list or grid.
///
/// All state and actions live in [HomeController]; this view only renders
/// them and picks which of the loading, error, empty or notes content shows.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.openNewNote,
        tooltip: AppStrings.tooltipAddNote,
        child: const Icon(Icons.add_rounded),
      ),
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(context),
              Padding(
                padding: AppDimensions.horizontalPadding,
                child: SearchBarField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              _buildFilters(),
              const SizedBox(height: AppDimensions.spaceMd),
              Expanded(child: _buildContent(context)),
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppDimensions.screenPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(AppStrings.homeTitle, style: textTheme.headlineMedium),
                Obx(
                  () => Visibility(
                    visible:
                        !controller.isLoading.value &&
                        !controller.hasError.value,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Text(
                      AppStrings.notesCount(controller.filteredNotes.length),
                      style: textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final bool isGrid = controller.isGridView.value;
            return IconButton(
              onPressed: controller.toggleLayout,
              tooltip: isGrid
                  ? AppStrings.tooltipListView
                  : AppStrings.tooltipGridView,
              icon: Icon(
                isGrid ? Icons.view_agenda_rounded : Icons.grid_view_rounded,
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filters
  // ---------------------------------------------------------------------------
  Widget _buildFilters() {
    return Column(
      children: <Widget>[
        Obx(
          () => FilterChipGroup<NoteCategory?>(
            items: _categoryFilterItems,
            selected: controller.selectedCategory.value,
            onSelected: controller.selectCategory,
            padding: AppDimensions.horizontalPadding,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        Obx(
          () => FilterChipGroup<DateRangeFilter>(
            items: _dateFilterItems,
            selected: controller.selectedDateFilter.value,
            onSelected: controller.selectDateFilter,
            padding: AppDimensions.horizontalPadding,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Content
  // ---------------------------------------------------------------------------
  Widget _buildContent(BuildContext context) {
    return Obx(() {
      final NoteTileLayout layout = controller.isGridView.value
          ? NoteTileLayout.grid
          : NoteTileLayout.list;

      final _HomeContent state;
      final Widget child;

      if (controller.isLoading.value) {
        state = _HomeContent.loading;
        child = LoadingView(layout: layout);
      } else if (controller.hasError.value) {
        state = _HomeContent.error;
        child = ErrorStateView(
          message: AppStrings.loadError,
          onRetry: controller.retry,
          isRetrying: controller.isRetrying.value,
        );
      } else if (!controller.hasNotes) {
        state = _HomeContent.noNotes;
        child = const EmptyStateView.noNotes();
      } else if (controller.filteredNotes.isEmpty) {
        state = _HomeContent.noResults;
        child = EmptyStateView.noResults(
          onClearFilters: controller.clearFilters,
        );
      } else {
        state = _HomeContent.notes;
        child = _buildNotes(context, layout);
      }

      return AnimatedSwitcher(
        duration: AppDurations.fadeSwitcher,
        child: KeyedSubtree(key: ValueKey<_HomeContent>(state), child: child),
      );
    });
  }

  Widget _buildNotes(BuildContext context, NoteTileLayout layout) {
    final List<NoteModel> notes = controller.filteredNotes.toList(
      growable: false,
    );

    Widget buildTile(int index) {
      final NoteModel note = notes[index];
      return AnimatedListItem(
        key: ValueKey<String>(note.id),
        index: index,
        // Only the first items animate, so scrolling through a long list
        // never replays the entry animation.
        animate: index < AppDurations.maxStaggerItems,
        child: NoteTile(
          note: note,
          layout: layout,
          onTap: () => controller.openNote(note),
          onLongPress: () => _confirmDelete(context, note),
        ),
      );
    }

    // Lets Flutter keep each tile's state when notes are reordered.
    int? findIndex(Key key) {
      if (key is! ValueKey<String>) return null;
      final int index = notes.indexWhere(
        (NoteModel note) => note.id == key.value,
      );
      return index < 0 ? null : index;
    }

    if (layout == NoteTileLayout.grid) {
      return GridView.builder(
        padding: AppDimensions.listBottomPadding,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns,
          mainAxisSpacing: AppDimensions.noteGridSpacing,
          crossAxisSpacing: AppDimensions.noteGridSpacing,
          childAspectRatio: AppDimensions.noteGridAspectRatio,
        ),
        itemCount: notes.length,
        findChildIndexCallback: findIndex,
        itemBuilder: (BuildContext context, int index) => buildTile(index),
      );
    }

    return ListView.separated(
      padding: AppDimensions.listBottomPadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: notes.length,
      findItemIndexCallback: findIndex,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: AppDimensions.noteListSpacing),
      itemBuilder: (BuildContext context, int index) => buildTile(index),
    );
  }

  // ---------------------------------------------------------------------------
  // Delete confirmation
  // ---------------------------------------------------------------------------
  Future<void> _confirmDelete(BuildContext context, NoteModel note) async {
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

    if (confirmed ?? false) unawaited(controller.deleteNote(note));
  }
}
