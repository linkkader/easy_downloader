// Created by linkkader on 14/11/2022

///Tuple like python]
///[first] first value
///[second] second value
///[third] third value
///[Tuple] tuple
///[Tuple] tuple
///[Tuple] tuple
///[Tuple] tuple
class Tuple<T1, T2, T3> {
  final T1 first;
  final T2 second;
  final T3 third;
  const Tuple(this.first, this.second, this.third);

  ///equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tuple<T1, T2, T3> &&
        other.first == first &&
        other.second == second &&
        other.third == third;
  }

  @override

  ///hash code
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;

  @override

  ///convert to string
  String toString() {
    return '($first, $second, $third)';
  }
}
