import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


/// A dialog that shows a loading indicator.
/// Used whenever a dialog must await a Future.
class BaseFutureDialog extends StatefulWidget {
  final Widget child;
  final RxBool loading;

  const BaseFutureDialog({
    Key? key,
    required this.child,
    required this.loading,
  }) : super(key: key);


  static const Duration animationDuration = Duration(milliseconds: 300);

  @override
  State<BaseFutureDialog> createState() => _BaseFutureDialogState();
}

class _BaseFutureDialogState extends State<BaseFutureDialog> {
  final RxBool animating = false.obs;

  @override
  void initState() {
    super.initState();

    widget.loading.listen((bool value) {
      if (value) {
        animating.value = true;
      } else {
        Future.delayed(BaseFutureDialog.animationDuration, () {
          animating.value = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Obx(() => AnimatedContainer(
      duration: BaseFutureDialog.animationDuration,
      height: widget.loading.value ? 200 : null,
      width: widget.loading.value ? 200 : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.loading.value
            ? Center(
              child: Lottie.asset('assets/lotties/loading-circle.json',
              frameRate: FrameRate.max),
            )
            : AnimatedOpacity(
              duration: BaseFutureDialog.animationDuration * 0.5,
              opacity: !widget.loading.value && !animating.value ? 1.0 : 0.0,
              child: widget.child,
            ),
      ),
    )),
  );
}
