import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const LoadingWidget({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   width: width ?? MediaQuery.of(context).size.width,
    //   height: height ?? MediaQuery.of(context).size.height,
    //   child: LottieBuilder.asset(AppAssets.loadingLottie),
    // );
    return Center(child: CircularProgressIndicator());
  }
}
