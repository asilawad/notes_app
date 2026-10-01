import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/note_form_controller.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../data/models/note_category.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/filter_chip_group.dart';
import '../widgets/gradient_background.dart';

/// Category selector options, built once from the fixed category set.
final List<FilterChipItem<NoteCategory>> _categoryItems = NoteCategory.values
    .map(
      (NoteCategory category) => FilterChipItem<NoteCategory>(
        value: category,
        label: category.label,
        icon: category.icon,
        iconColor: category.color,
      ),
    )
    .toList(growable: false);

/// Create/edit screen. One view serves both modes: [NoteFormController]
/// decides from `Get.arguments` whether it opens empty or pre-filled.
///
/// While a save is running, the fields and buttons are disabled and the
/// system back gesture is blocked, so the screen cannot be left or
/// submitted twice mid-save.
class NoteFormView extends GetView<NoteFormController> {
  const NoteFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget scaffold = Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _buildHeader(context),
              Expanded(child: _buildForm(context)),
              _buildActions(),
            ],
          ),
        ),
      ),
    );

    // Only the PopScope rebuilds when `isSaving` changes; the scaffold is
    // built once above and passed in as a prebuilt child.
    return Obx(
      () => PopScope(canPop: !controller.isSaving.value, child: scaffold),
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
          Obx(
            () => IconButton(
              onPressed: controller.isSaving.value ? null : controller.cancel,
              tooltip: AppStrings.tooltipBack,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Expanded(
            child: Text(
              controller.isEditing
                  ? AppStrings.editNoteTitle
                  : AppStrings.createNoteTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Form fields
  // ---------------------------------------------------------------------------
  Widget _buildForm(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: AppDimensions.screenPadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: _ContentWidth(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Obx(
                () => CustomTextField(
                  controller: controller.titleController,
                  hintText: AppStrings.titleHint,
                  validator: Validators.title,
                  textStyle: textTheme.titleLarge,
                  maxLength: AppDimensions.noteTitleMaxLength,
                  autofocus: !controller.isEditing,
                  enabled: !controller.isSaving.value,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(AppStrings.categoryLabel, style: textTheme.labelLarge),
              const SizedBox(height: AppDimensions.spaceXs),
              Obx(
                () => AbsorbPointer(
                  absorbing: controller.isSaving.value,
                  child: FilterChipGroup<NoteCategory>(
                    items: _categoryItems,
                    selected: controller.selectedCategory.value,
                    onSelected: controller.selectCategory,
                    scrollable: false,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Obx(
                () => CustomTextField(
                  controller: controller.contentController,
                  hintText: AppStrings.contentHint,
                  validator: Validators.content,
                  textStyle: textTheme.bodyLarge,
                  maxLength: AppDimensions.noteContentMaxLength,
                  showCounter: true,
                  minLines: AppDimensions.noteContentMinLines,
                  maxLines: null,
                  enabled: !controller.isSaving.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  Widget _buildActions() {
    return Padding(
      padding: AppDimensions.screenPadding,
      child: _ContentWidth(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => AppButton(
                  label: AppStrings.cancel,
                  variant: AppButtonVariant.secondary,
                  fullWidth: true,
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.cancel,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceXs),
            Expanded(
              flex: 2,
              child: Obx(
                () => AppButton(
                  label: controller.isEditing
                      ? AppStrings.updateNote
                      : AppStrings.saveNote,
                  icon: Icons.check_rounded,
                  fullWidth: true,
                  isLoading: controller.isSaving.value,
                  onPressed: controller.save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Keeps the form column readable on tablets and wide screens by limiting
/// its width and centering it. On phones the limit has no effect.
class _ContentWidth extends StatelessWidget {
  const _ContentWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.contentMaxWidth,
        ),
        child: child,
      ),
    );
  }
}
