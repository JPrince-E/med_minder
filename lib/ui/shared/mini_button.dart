import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

var log = getLogger('BlackPlayBackButton');

class BlackPlayBackButton extends StatelessWidget {
  final void Function()? onPressed;
  const BlackPlayBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          onPressed ??
              () {
                context.pop();
                log.w('Back button pressed!');
              };
        },
        child: Container(
          height: 48,
          width: 56,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: AppColors.fullBlack,
          ),
          child: RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppColors.plainWhite,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
