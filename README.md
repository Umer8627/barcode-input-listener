# BarcodeInputListener

**BarcodeInputListener** is a Flutter package designed to seamlessly capture barcode input from hardware barcode scanners. It works across multiple platforms, including web, desktop (Windows, Linux, macOS), and mobile (iOS, Android). This package allows you to detect barcode scans even when a text input field isn't focused, providing a flexible and cross-platform solution.

## Challenges with Barcode Scanning

When dealing with hardware barcode scanners, developers typically have a few approaches to capture scanned barcodes:

1. **Using a Text Input Field:** One common method is to implement a text input field (e.g., `TextField`), focus on it, and capture the scanned barcode. While simple, this method only works when the text field has focus, which might not always be ideal.

2. **Listening for System Events:** Another method involves listening for system events (e.g., Android service intents). However, this approach is often specific to certain manufacturers or devices, requiring the use of their SDKs, and it is not cross-platform friendly.

3. **Listening for Hardware Keyboard Events:** The third option is to listen for hardware keyboard events and identify barcode input. This method is more flexible, as it supports all devices, including external barcode scanners connected via Bluetooth or Wi-Fi. The challenge lies in distinguishing between regular user input and barcode scans.

## How BarcodeInputListener Works

Most hardware barcode scanners share some common characteristics:
- They emulate a keyboard when scanning a barcode.
- The keystrokes occur in a very short time frame (usually less than 100 milliseconds between each character).
- The barcode input is typically completed with a special character, such as the Enter key.

To identify barcode scans, **BarcodeInputListener** uses the following approach:

- **Event Handling:** The widget listens for key events, either key down or key up, depending on the `useKeyDownEvent` flag.
  
- **Character Buffering:** Pressed keys are stored in a buffer for a brief period, defined by the `bufferDuration`.

- **Barcode Detection:** When a sequence of characters ending with the Enter key is detected within the buffer duration, it is recognized as a barcode.

- **Callback Trigger:** The `onBarcodeScanned` callback is then invoked with the detected barcode.

## Usage

```dart
import 'package:barcode_input_listener/barcode_input_listener.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarcodeInputListener(
      onBarcodeScanned: (barcode) {
        print('Barcode scanned: $barcode');
      },
      child: MyHomePage(),
    );
  }
}
