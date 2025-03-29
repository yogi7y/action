import 'package:flutter/widgets.dart';

class SliverSizedBox extends StatelessWidget {
  const SliverSizedBox({
    this.height,
    this.width,
    super.key,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: SizedBox(
          height: height,
          width: width,
        ),
      );
}
