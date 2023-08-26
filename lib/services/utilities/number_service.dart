extension Range on num {
  List<num> until(num endPoint) {
    var exclusive = to(endPoint);
    exclusive.removeLast();
    return exclusive;
  }

  List<num> to(num endPoint) {
    var numbers = <num>[];
    if (endPoint > this) {
      for (num i = this; i <= endPoint; i++) {
        numbers.add(i);
      }
    } else {
      for (num i = this; i >= endPoint; i--) {
        numbers.add(i);
      }
    }
    return numbers;
  }
}