import 'dart:async';
import 'package:flutter_triple/flutter_triple.dart';

class TimerStore extends Store<int> {
  Timer? _timer;

  TimerStore() : super(0);

  void startOrResetTimer() {
    _timer?.cancel();
    update(0);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      update(state + 1);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    update(0);
  }
}
