void printDebug(Object? object) {
  assert(() {
    //ignore: avoid_print
    print(object);
    return true;
  }());
}
