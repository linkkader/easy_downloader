// Created by linkkader on 14/11/2022

///Pair like python]
///[first] first value
///[second] second value
///[Pair] pair
class Pair<T1, T2> {
  final T1 first;
  final T2 second;
  const Pair(this.first, this.second);

  @override

  ///equal operator
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pair<T1, T2> &&
        other.first == first &&
        other.second == second;
  }

  @override

  ///hash code
  int get hashCode => first.hashCode ^ second.hashCode;

  @override

  ///convert to string
  String toString() {
    return '($first, $second)';
  }
}
