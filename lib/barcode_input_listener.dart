library barcode_input_listener;

import 'dart:async';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef BarcodeScannedVoidCallBack = void Function(String barcode);

/// `BarcodeInputListener` is a widget that captures keyboard events to process barcodes.
/// It listens for key events and buffers characters within the specified `bufferDuration`.
/// Once a complete barcode is detected, it triggers the provided `onBarcodeScanned` callback.
///
/// The widget works across various platforms including web, desktop (Windows, Linux, macOS), and mobile (iOS, Android).
/// For web and desktop, it uses `HardwareKeyboard` for event handling. For mobile platforms, it uses
/// `KeyboardListener` with a focus node to capture input.
///
/// The behavior of listening to key down or key up events can be controlled with the `useKeyDownEvent` flag.
/// The widget will continue to listen for input even if it is not visible.

class BarcodeInputListener extends StatefulWidget {
  final Widget child;
  final BarcodeScannedVoidCallBack onBarcodeScanned;
  final Duration bufferDuration;
  final bool useKeyDownEvent;

  const BarcodeInputListener({
    super.key,
    required this.child,
    required this.onBarcodeScanned,
    this.bufferDuration = const Duration(milliseconds: 100),
    this.useKeyDownEvent = false,
  });

  @override
  State<BarcodeInputListener> createState() => _BarcodeInputListenerState();
}

class _BarcodeInputListenerState extends State<BarcodeInputListener> {
  final List<String> _bufferedChars = [];
  DateTime? _lastEventTime;
  late StreamSubscription<String?> _keyStreamSubscription;
  final StreamController<String?> _keyStreamController =
      StreamController<String?>();

  @override
  void initState() {
    super.initState();
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      HardwareKeyboard.instance.addHandler(_onKeyEvent);
    }
    _keyStreamSubscription = _keyStreamController.stream
        .where((char) => char != null)
        .listen(_handleKeyEvent);
  }

  @override
  void dispose() {
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    }
    _keyStreamSubscription.cancel();
    _keyStreamController.close();
    super.dispose();
  }

  bool _onKeyEvent(KeyEvent event) {
    if ((!widget.useKeyDownEvent && event is KeyUpEvent) ||
        (widget.useKeyDownEvent && event is KeyDownEvent)) {
      String? char = _getCharacterFromEvent(event);
      if (char != null) {
        _keyStreamController.add(char);
      }
    }
    return true;
  }

  String? _getCharacterFromEvent(KeyEvent event) {
    final String? char = event.character;
    if (char != null && char.isNotEmpty) {
      return char;
    }
    return null;
  }

  void _handleKeyEvent(String? char) {
    _clearOldBufferedChars();
    _lastEventTime = DateTime.now();
    _bufferedChars.add(char!);
    final barcode = _bufferedChars.join();
    widget.onBarcodeScanned(barcode);
  }

  void _clearOldBufferedChars() {
    if (_lastEventTime != null &&
        _lastEventTime!
            .isBefore(DateTime.now().subtract(widget.bufferDuration))) {
      _bufferedChars.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return widget.child;
    } else {
      final focusNode = FocusNode();
      focusNode.requestFocus();
      return KeyboardListener(
        autofocus: true,
        includeSemantics: true,
        focusNode: focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            String? char = event.character;
            if (char != null) {
              _keyStreamController.add(char);
            }
          }
        },
        child: widget.child,
      );
    }
  }
}
