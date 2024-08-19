# BarcodeInputListener

`BarcodeInputListener` is a Flutter widget that captures keyboard events to process barcodes. It listens for key events and buffers characters within a specified `bufferDuration`. Once a complete barcode is detected, it triggers the provided `onBarcodeScanned` callback.

## Getting Started

This widget allows you to listen for barcode input from hardware barcode scanners across various platforms, including web, desktop (Windows, Linux, macOS), and mobile (iOS, Android). It’s a non-intrusive way to capture barcode data without requiring a focused text input field.

## Features

- **Cross-Platform Support**: Works across web, desktop (Windows, Linux, macOS), and mobile (iOS, Android).
- **Customizable**: Configure buffer duration and event type (key down or key up) for barcode detection.
- **Non-Intrusive**: Listens for barcode input without requiring a focused text field.