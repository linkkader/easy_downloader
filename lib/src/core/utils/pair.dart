// Created by linkkader on 14/11/2022


///Pair like python]
///[first] first value
///[second] second value
///[Pair] pair
class Pair<T1, T2> {
  final T1 first;
  final T2 second;
  const Pair(this.first, this.second);

  ///equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pair<T1, T2> &&
        other.first == first &&
        other.second == second;
  }

  ///hash code
  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  ///convert to string
  @override
  String toString() {
    return '($first, $second)';
  }
}
