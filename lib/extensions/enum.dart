// Created by linkkader on 8/10/2022

extension EnumExtension<T> on Enum {
  String get name => toString().split('.').last;

  ///check if two enum value are same
  bool operator <=(Enum other) {
    return (runtimeType.toString() == other.runtimeType.toString() &&
        index == other.index);
  }
}
