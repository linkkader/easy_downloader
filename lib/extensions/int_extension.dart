// Created by linkkader on 7/10/2022

extension IntExtension on int {
  ///convert bytes to human readable string
  String toHumanReadableSize() {
    if (this < 1024) {
      return "$this B";
    } else if (this < 1024 * 1024) {
      return "${(this / 1024).toStringAsFixed(2)} KB";
    } else if (this < 1024 * 1024 * 1024) {
      return "${(this / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      return "${(this / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }

  ///generate list of int from 0
  List<int> toList() {
    return List.generate(this, (index) => index);
  }

  ///sleep delay in seconds
  Future sleep() async {
    await Future.delayed(Duration(seconds: this));
  }
}
