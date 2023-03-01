// Created by linkkader on 14/11/2022

class Pair<T1, T2> {
  final T1 first;
  final T2 second;
  const Pair(this.first, this.second);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pair<T1, T2> && other.first == first && other.second == second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  String toString() {
    return '($first, $second)';
  }

}