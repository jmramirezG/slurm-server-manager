import 'dart:async';

class Signal {
  final _controller = StreamController.broadcast();

  StreamSubscription listen(void Function(dynamic event) onData) {
    return _controller.stream.listen(onData);
  }

  void emit(dynamic event) {
    _controller.add(event);
  }
}
