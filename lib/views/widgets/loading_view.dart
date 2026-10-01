import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/responsive.dart';
import 'glass_card.dart';
import 'note_tile.dart';

/// Loading placeholder that mimics the notes list or grid with pulsing
/// skeleton cards, so the layout does not jump when the real notes arrive.
///
/// Pass the same [layout] the home screen is using, so the skeleton matches
/// the real tiles. The whole skeleton pulses through a single animation
/// (cheaper than a per-card shimmer), and the skeleton cards skip the
/// backdrop blur to stay light.
class LoadingView extends StatefulWidget {
  const LoadingView({super.key, this.layout = NoteTileLayout.list});

  final NoteTileLayout layout;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.skeletonPulse,
  );

  late final Animation<double> _opacity = Tween<double>(
    begin: AppDimensions.skeletonMinOpacity,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: AppCurves.standard));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Respect the system "reduce motion" setting: show a static skeleton.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.loadingNotes,
      excludeSemantics: true,
      child: FadeTransition(
        opacity: _opacity,
        child: widget.layout == NoteTileLayout.grid
            ? _buildGrid(context)
            : _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppDimensions.screenPadding,
      itemCount: AppDimensions.skeletonItemCount,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: AppDimensions.noteListSpacing),
      itemBuilder: (BuildContext context, int index) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: AppDimensions.skeletonTileHeight,
          ),
          child: _SkeletonTile(fillHeight: false),
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppDimensions.screenPadding,
      itemCount: AppDimensions.skeletonItemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns,
        mainAxisSpacing: AppDimensions.noteGridSpacing,
        crossAxisSpacing: AppDimensions.noteGridSpacing,
        childAspectRatio: AppDimensions.noteGridAspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        return const _SkeletonTile(fillHeight: true);
      },
    );
  }
}

/// One placeholder card: title bar, two text bars and a badge pill.
class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile({required this.fillHeight});

  /// True in a grid cell (fills the cell height); false in the list, where
  /// the card takes the height of its content.
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _SkeletonBar(widthFactor: AppDimensions.skeletonTitleWidthFactor),
              SizedBox(height: AppDimensions.spaceXs),
              _SkeletonBar(widthFactor: AppDimensions.skeletonLineWidthFactor),
              SizedBox(height: AppDimensions.spaceXs),
              _SkeletonBar(
                widthFactor: AppDimensions.skeletonShortLineWidthFactor,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceSm),
          _SkeletonPill(),
        ],
      ),
    );
  }
}

/// A text-line placeholder whose width is a fraction of the available width.
class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: const SizedBox(
        height: AppDimensions.skeletonLineHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.skeleton,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radiusSm),
            ),
          ),
        ),
      ),
    );
  }
}

/// A category-badge placeholder.
class _SkeletonPill extends StatelessWidget {
  const _SkeletonPill();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: AlignmentDirectional.centerStart,
      child: SizedBox(
        width: AppDimensions.skeletonBadgeWidth,
        height: AppDimensions.categoryBadgeHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.skeleton,
            borderRadius: AppDimensions.borderRadiusPill,
          ),
        ),
      ),
    );
  }
}
