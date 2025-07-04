' Of course. A "client" needs a "server" to connect to. Therefore, I will provide you with the code for both a simple TCP client and a corresponding TCP server written in FreeBASIC.

' This example will demonstrate a basic chat-like application:
' *   **The Server:** Waits for a client to connect. Once connected, it receives messages from the client and sends back a reply.
' *   **The Client:** Connects to the server, allows the user to type messages, sends them, and prints the server's response.

' ### Prerequisites

' 1.  You need the **FreeBASIC compiler (`fbc`)** installed.
' 2.  The networking functions used here are part of the `fbgfx` library, which is included by default with standard FreeBASIC installations.

' ---

' ### 1. The Server Code

' Save this code in a file named `server.bas`. This program must be running *before* you run the client.

' ```freebasic
' server.bas
' A simple TCP server in FreeBASIC

#include "fbgfx.bi" ' The networking library is part of fbgfx

' Use the fbgfx namespace for networking functions
Using FB.Net

' --- Configuration ---
CONST PORT = 12345 ' The port to listen on

' --- Main Program ---
Dim As TCPsocket server_socket, client_socket
Dim As String buffer = String(1024, 0) ' A 1KB buffer to receive data
Dim As Integer bytes_received

' 1. Initialize the networking library
If Net_Init() <> 0 Then
    Print "Error: Could not initialize networking."
    Print "Details: "; Net_GetError()
    Sleep
    End 1
End If

' 2. Open a listening socket on our chosen port
server_socket = Net_TCP_Listen(PORT)
If server_socket = 0 Then
    Print "Error: Could not open listening socket on port "; PORT
    Print "Details: "; Net_GetError()
    Net_Quit()
    Sleep
    End 1
End If

Print "Server is running and listening on port "; PORT
Print "Waiting for a client to connect..."

' 3. Wait for a client to connect (this call blocks until a connection arrives)
client_socket = Net_TCP_Accept(server_socket)
If client_socket = 0 Then
    Print "Error: Failed to accept a client connection."
    Print "Details: "; Net_GetError()
    Net_TCP_Close(server_socket)
    Net_Quit()
    Sleep
    End 1
End If

Print "Client connected! You can now exchange messages."
Print "-----------------------------------------------"

' 4. Communication loop
Do
    ' Wait and receive a message from the client
    bytes_received = Net_TCP_Recv(client_socket, @buffer[0], 1024)

    If bytes_received <= 0 Then
        ' If 0 or less, the client has disconnected or an error occurred
        Print "Client disconnected."
        Exit Do
    End If

    ' Print the message received from the client
    ' Use Left() to only show the actual bytes received, not the whole buffer
    Dim As String client_message = Left(buffer, bytes_received)
    Print "Client says: "; client_message

    ' Prepare and send a response back to the client
    Dim As String server_response = "Message received: '" + client_message + "'"
    If Net_TCP_Send(client_socket, server_response, Len(server_response)) < Len(server_response) Then
        Print "Error sending response to client."
        Print "Details: "; Net_GetError()
        Exit Do
    End If
Loop

' 5. Clean up and shut down
Print "Closing connections and shutting down server."
Net_TCP_Close(client_socket)
Net_TCP_Close(server_socket)
Net_Quit()

Print "Server stopped. Press any key to exit."
Sleep
End 0
```

' ---

' ### 2. The Client Code

' Save this code in a separate file named `client.bas`.

' ```freebasic
' client.bas
' A simple TCP client in FreeBASIC

#include "fbgfx.bi" ' The networking library is part of fbgfx

' Use the fbgfx namespace for networking functions
Using FB.Net

' --- Configuration ---
CONST HOST = "127.0.0.1" ' The server's IP address (127.0.0.1 is localhost)
CONST PORT = 12345       ' The port to connect to (must match the server)

' --- Main Program ---
Dim As TCPsocket socket
Dim As String message_to_send
Dim As String receive_buffer = String(1024, 0) ' 1KB buffer for replies
Dim As Integer bytes_received

' 1. Initialize the networking library
If Net_Init() <> 0 Then
    Print "Error: Could not initialize networking."
    Print "Details: "; Net_GetError()
    Sleep
    End 1
End If

' 2. Try to connect to the server
Print "Attempting to connect to server at "; HOST; ":"; PORT; "..."
socket = Net_TCP_Open(HOST, PORT)

If socket = 0 Then
    Print "Error: Could not connect to the server."
    Print "Please make sure the server program is running."
    Print "Details: "; Net_GetError()
    Net_Quit()
    Sleep
    End 1
End If

Print "Connected successfully!"
Print "Enter a message to send, or type 'quit' to exit."
Print "---------------------------------------------------"

' 3. Communication loop
Do
    ' Get input from the user
    Input "> ", message_to_send

    ' Check if the user wants to quit
    If LCase(message_to_send) = "quit" Then Exit Do

    ' Send the message to the server
    If Net_TCP_Send(socket, message_to_send, Len(message_to_send)) < Len(message_to_send) Then
        Print "Error: Failed to send message."
        Print "Details: "; Net_GetError()
        Exit Do
    End If

    ' Wait for the server's response
    bytes_received = Net_TCP_Recv(socket, @receive_buffer[0], 1024)

    If bytes_received <= 0 Then
        Print "Server disconnected or an error occurred."
        Exit Do
    End If

    ' Print the server's response
    Dim As String server_response = Left(receive_buffer, bytes_received)
    Print "Server replied: "; server_response

Loop

' 4. Clean up and shut down
Print "Disconnecting from server..."
Net_TCP_Close(socket)
Net_Quit()

Print "Client stopped. Press any key to exit."
Sleep
End 0
' ```

---

' ### How to Compile and Run

' 1.  **Open two separate command prompts** or terminals. You need one for the server and one for the client.

' 2.  **In the first terminal**, compile the server:
'     ```bash
'     fbc -s console server.bas
'     ```

' 3.  **In the second terminal**, compile the client:
'     ```bash
'     fbc -s console client.bas
'     ```
'     *(The `-s console` switch tells the compiler to create a console application, not a graphics window.)*

' 4.  **In the first terminal**, run the server:
'     ```bash
'     server.exe   # On Windows
'     ./server     # On Linux/macOS
'     ```
'     You will see: `Server is running and listening on port 12345`

' 5.  **In the second terminal**, run the client:
'     ```bash
'     client.exe   # On Windows
'     ./client     # On Linux/macOS
'     ```

' 6.  Now you can type messages in the client's window, press Enter, and you will see the message and the server's reply appear in both windows. Type `quit` in the client window to close the connection.