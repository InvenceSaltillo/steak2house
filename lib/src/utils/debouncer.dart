import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

class Debouncer<T> {
  Debouncer({required this.duration, this.onValue});

  late final Duration duration;
  late void Function(T value)? onValue;
  late T _value;
  Timer? _timer;

  T get value => _value;

  set value(T val) {
    _value = val;
    _timer!.cancel();
    _timer = Timer(duration, () => onValue!(_value));
  }
}
