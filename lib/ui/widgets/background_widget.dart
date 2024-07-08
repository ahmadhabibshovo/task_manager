import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utility/assets_path.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          fit: BoxFit.fill,
          AssetsPath.backgroundSvg,
          height: double.maxFinite,
          width: double.maxFinite,
        ),
        child
      ],
    );
  }
}
