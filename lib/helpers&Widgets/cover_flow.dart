import 'dart:math' as math;
import 'package:flutter/material.dart';

class CoverFlow extends StatefulWidget {
  final List<Widget> items;
  final double height;

  const CoverFlow({
    super.key,
    required this.items,
    this.height = 340,
  });

  @override
  State<CoverFlow> createState() => _CoverFlowState();
}

class _CoverFlowState extends State<CoverFlow> {
  final PageController controller = PageController(
    viewportFraction: 0.45,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: controller,
        itemCount: widget.items.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double page = 0;

              if (controller.hasClients &&
                  controller.position.hasContentDimensions) {
                page = controller.page ?? controller.initialPage.toDouble();
              }

              final diff = index - page;

              final scale =
                  (1 - diff.abs() * 0.22).clamp(0.72, 1.0);

              final angle = diff * 0.55;

              final translate = diff * -70;

              return Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(translate)
                    ..rotateY(angle)
                    ..scale(scale),
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black26,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: widget.items[index],
              ),
            ),
          );
        },
      ),
    );
  }
}