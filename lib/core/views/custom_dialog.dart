
import 'package:crop_clasifier/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';



enum DialogType { error, success, warning, info }

class CustomDialogs {
  static void dismiss() {
    SmartDialog.dismiss();
  }

  // show loading dialog
  static loading({required String message}) {
    return SmartDialog.showLoading(
      msg: message,
      alignment: Alignment.center,
      animationType: SmartAnimationType.centerFade_otherSlide,
    );
  }

  static toast({required String message, DialogType type = DialogType.info}) {
    return SmartDialog.showToast(
      message,
      animationType: SmartAnimationType.centerFade_otherSlide,
      alignment: Alignment.center,
      builder: (context) {
        var styles = CustomTextStyles();
        return Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: type == DialogType.error
                      ? Colors.red
                      : type == DialogType.success
                          ? Colors.green
                          : type == DialogType.warning
                              ? Colors.orange
                              : Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type == DialogType.error
                          ? Icons.error
                          : type == DialogType.success
                              ? Icons.check_circle
                              : type == DialogType.warning
                                  ? Icons.warning
                                  : Icons.info,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      message,
                      style: styles.bodyStyle(
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // show success dialog
  static showDialog(
      {required String message,
      DialogType type = DialogType.info,
      String? secondBtnText,
      VoidCallback? onConfirm}) {
    return SmartDialog.show(
      alignment: Alignment.center,
      animationType: SmartAnimationType.scale,
      animationTime: const Duration(milliseconds: 300),
      clickMaskDismiss: true,
      maskColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        var styles = CustomTextStyles();
        return Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: type == DialogType.error
                      ? Colors.red
                      : type == DialogType.success
                          ? Colors.green
                          : Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        type == DialogType.error
                            ? Icons.error
                            : type == DialogType.success
                                ? Icons.check_circle
                                : type == DialogType.warning
                                    ? Icons.warning
                                    : Icons.info,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        message,
                        style: styles.bodyStyle(
                            color: Colors.white,
                           fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                            top: BorderSide(color: Colors.white, width: 1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (onConfirm != null &&
                              secondBtnText != null &&
                              secondBtnText.isNotEmpty)
                            Expanded(
                              child: InkWell(
                                onTap: onConfirm,
                                child: Text(secondBtnText,
                                    textAlign: TextAlign.center,
                                    style: styles.bodyStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        )),
                              ),
                            ),
                          if (onConfirm != null &&
                              secondBtnText != null &&
                              secondBtnText.isNotEmpty)
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                SmartDialog.dismiss();
                              },
                              child: Text(
                                  onConfirm != null &&
                                          secondBtnText != null &&
                                          secondBtnText.isNotEmpty
                                      ? 'Cancel'
                                      : 'Okay',
                                  textAlign: TextAlign.center,
                                  style: styles.bodyStyle(
                                      color: Colors.white,
                                     fontSize: 13)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
