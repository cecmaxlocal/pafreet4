// Absolutely. Here is a simple, modern TCP server written in the **Dart** language.

// This Dart server is designed to be **fully compatible** with the FreeBASIC client provided earlier. It will listen on the same port, accept a connection, receive messages, and send back a reply, just like the FreeBASIC server did.

// One of the key advantages of Dart for this kind of task is its excellent built-in support for asynchronous operations, which makes handling network connections efficient and clean.

// ### The Server Code (Dart)

// Save this code in a file named `server.dart`.

// ```dart
// server.dart
// A simple, asynchronous TCP server in Dart.

import 'dart:io';      // Core library for I/O, including networking.
import 'dart:convert'; // For encoding/decoding strings (like UTF-8).

// --- Configuration ---
const HOST = '127.0.0.1'; // Can also use InternetAddress.anyIPv4 to listen on all interfaces.
const PORT = 12345;      // The port to listen on (must match the client).

// The main function must be 'async' to use 'await'.
Future<void> main() async {
  ServerSocket serverSocket;

  try {
    // 1. Bind the server to a host and port.
    // This returns a Future, so we 'await' it.
    serverSocket = await ServerSocket.bind(HOST, PORT);
    print('Server is running and listening on ${serverSocket.address.host}:${serverSocket.port}');
    print('Waiting for a client to connect...');
  } catch (e) {
    print('Error: Could not start the server: $e');
    exit(1);
  }

  // 2. Listen for incoming client connections.
  // The 'serverSocket' is a Stream. We can use 'await for' to handle
  // each incoming connection as it arrives.
  // This loop will run forever, handling new clients.
  await for (Socket clientSocket in serverSocket) {
    // When a client connects, pass it to a handler function.
    // This allows the main loop to immediately wait for the next client.
    handleConnection(clientSocket);
  }
}

/// Handles the communication with a single connected client.
void handleConnection(Socket client) {
  print('Client connected from: ${client.remoteAddress.address}:${client.remotePort}');

  // 3. Listen for data from the client.
  client.listen(
    // onData callback: This is called whenever data is received.
    (List<int> data) {
      // The data arrives as a list of bytes. We need to decode it.
      // The FreeBASIC client sends a simple string, which is typically UTF-8 compatible.
      final message = utf8.decode(data).trim();
      print('Client says: $message');

      // Prepare and send a response back to the client.
      final response = "Message received: '$message'";
      client.write(response); // .write() automatically encodes the string to UTF-8.
    },

    // onError callback: This is called if an error occurs on the socket.
    onError: (error) {
      print('An error occurred: $error');
      client.close();
    },

    // onDone callback: This is called when the client closes the connection.
    onDone: () {
      print('Client disconnected.');
      client.close();
    },
  );
}
// ```

// ---

// ### How to Run the Dart Server

// 1.  **Install the Dart SDK:** If you don't have it, download and install it from the official Dart website: [https://dart.dev/get-dart](https://dart.dev/get-dart)

// 2.  **Open a command prompt** or terminal.

// 3.  **Navigate** to the directory where you saved `server.dart`.

// 4.  **Run the server** using the `dart` command:
//     ```bash
//     dart server.dart
//     ```

// 5.  You will see the output:
//     ```
//     Server is running and listening on 127.0.0.1:12345
//     Waiting for a client to connect...
//     ```

// ### How to Test with the FreeBASIC Client

// 1.  Keep the Dart server running in its terminal.
// 2.  Open a **new terminal** and run the compiled **FreeBASIC client** from the previous example (`client.exe` or `./client`).
// 3.  The client will connect to your Dart server.
// 4.  Type messages in the client window and press Enter. You will see the interaction happen in both terminals, proving they can communicate perfectly.

// ### Key Differences from the FreeBASIC Server

// *   **Asynchronous vs. Blocking:** The FreeBASIC server used *blocking* calls (`Net_TCP_Accept`, `Net_TCP_Recv`). The program would halt and wait at those lines. The Dart server is **asynchronous** and event-driven. It registers callbacks (`onData`, `onError`, `onDone`) and doesn't block, making it highly efficient.
// *   **Concurrency:** The simple FreeBASIC server could only handle **one client at a time**. The Dart server, because of its asynchronous nature, can handle **multiple clients concurrently** without any extra code. If a second client connects while the first is active, the `await for` loop will simply call `handleConnection` again for the new client.