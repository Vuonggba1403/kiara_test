import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final Duration duration;
  final double verticalOffset;
  final ScrollPhysics? physics;

  const AnimatedListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.duration = const Duration(milliseconds: 375),
    this.verticalOffset = 50.0,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: duration,
          delay: const Duration(milliseconds: 100),
          child: SlideAnimation(
            verticalOffset: verticalOffset,
            child: FadeInAnimation(child: children[index]),
          ),
        );
      },
    );
  }
}

class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final double verticalOffset;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const AnimatedColumn({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 375),
    this.verticalOffset = 50.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: AnimationConfiguration.toStaggeredList(
        duration: duration,
        childAnimationBuilder: (widget) => SlideAnimation(
          verticalOffset: verticalOffset,
          child: FadeInAnimation(child: widget),
        ),
        children: children,
      ),
    );
  }
}

class AnimatedListBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final Duration duration;
  final double verticalOffset;
  final ScrollPhysics? physics;

  const AnimatedListBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.duration = const Duration(milliseconds: 375),
    this.verticalOffset = 50.0,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        controller: controller,
        padding: padding,
        physics: physics,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: duration,
            child: SlideAnimation(
              verticalOffset: verticalOffset,
              child: FadeInAnimation(child: itemBuilder(context, index)),
            ),
          );
        },
      ),
    );
  }
}
