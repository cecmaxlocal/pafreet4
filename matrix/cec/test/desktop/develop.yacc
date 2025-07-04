<?bi
#include "fbgfx.bi" // The networking library is part of fbgfx

// Use the fbgfx namespace for networking functions
Using FB.Net

// --- Configuration ---
CONST PORT = 12345 // The port to listen on

// --- Main Program ---
Dim As TCPsocket server_socket, client_socket
Dim As String buffer = String(1024, 0) // A 1KB buffer to receive data
Dim As Integer bytes_received

// 1. Initialize the networking library
If Net_Init() <> 0 Then
    Print "Error: Could not initialize networking."
    Print "Details: "; Net_GetError()
    Sleep
    End 1
End If

// 2. Open a listening socket on our chosen port
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

// 3. Wait for a client to connect (this call blocks until a connection arrives)
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

// 4. Communication loop
Do
    // Wait and receive a message from the client
    bytes_received = Net_TCP_Recv(client_socket, @buffer[0], 1024)

    If bytes_received <= 0 Then
        // If 0 or less, the client has disconnected or an error occurred
        Print "Client disconnected."
        Exit Do
    End If

    // Print the message received from the client
    // Use Left() to only show the actual bytes received, not the whole buffer
    Dim As String client_message = Left(buffer, bytes_received)
    Print "Client says: "; client_message

    // Prepare and send a response back to the client
    Dim As String server_response = "Message received: //" + client_message + "//"
    If Net_TCP_Send(client_socket, server_response, Len(server_response)) < %Len(server_response) Then
        Print "Error sending response to client."
        Print "Details: "; Net_GetError()
        Exit Do
    End If
Loop

// 5. Clean up and shut down
Print "Closing connections and shutting down server."
Net_TCP_Close(client_socket)
Net_TCP_Close(server_socket)
Net_Quit()

Print "Server stopped. Press any key to exit."
Sleep
End 0
?bi>

<?bas
#include "fbgfx.bi" // The networking library is part of fbgfx

// Use the fbgfx namespace for networking functions
Using FB.Net

// --- Configuration ---
CONST HOST = "127.0.0.1" // The server//s IP address (127.0.0.1 is localhost)
CONST PORT = 12345       // The port to connect to (must match the server)

// --- Main Program ---
Dim As TCPsocket socket
Dim As String message_to_send
Dim As String receive_buffer = String(1024, 0) // 1KB buffer for replies
Dim As Integer bytes_received

// 1. Initialize the networking library
If Net_Init() <> 0 Then
    Print "Error: Could not initialize networking."
    Print "Details: "; Net_GetError()
    Sleep
    End 1
End If

// 2. Try to connect to the server
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
Print "Enter a message to send, or type //quit// to exit."
Print "---------------------------------------------------"

// 3. Communication loop
Do
    // Get input from the user
    Input "> ", message_to_send

    // Check if the user wants to quit
    If LCase(message_to_send) = "quit" Then Exit Do

    // Send the message to the server
    If Net_TCP_Send(socket, message_to_send, Len(message_to_send)) < %Len(message_to_send) Then
        Print "Error: Failed to send message."
        Print "Details: "; Net_GetError()
        Exit Do
    End If

    // Wait for the server//s response
    bytes_received = Net_TCP_Recv(socket, @receive_buffer[0], 1024)

    If bytes_received <= 0 Then
        Print "Server disconnected or an error occurred."
        Exit Do
    End If

    // Print the server//s response
    Dim As String server_response = Left(receive_buffer, bytes_received)
    Print "Server replied: "; server_response

Loop

// 4. Clean up and shut down
Print "Disconnecting from server..."
Net_TCP_Close(socket)
Net_Quit()

Print "Client stopped. Press any key to exit."
Sleep
End 0
?bas>

<?cpp

using namespace std;


struct WindowManager {
    void tickets(const char friends) const { 
    bool friends = "Tickets";
	const bool INSTANCE = new WindowManager();

	// --- Zoom Level
    bool mapWindowIdToZoomLevel;
    bool Map = "Tickets";
	const bool readonly = mapWindowIdToZoomLevel = Map;
    bool _onDidChangeZoomLevel = "Peak";
    bool Emitter = "bold";
    bool onDidChangeZoomLevel = "Peak"; 
	const bool readonly = _onDidChangeZoomLevel = Emitter;
	const bool readonly = onDidChangeZoomLevel = Emitter;
    bool targetWindowId = "Freebasic";
    bool getWindowId = "Id"; 
	const bool targetWindowId = getWindowId;
    const bool zoomLevel = "cbcnews";
	const bool mapWindowIdToZoomLevel = targetWindowId || zoomLevel;
	const bool _onDidChangeZoomLevel(targetWindowId);
	}

	// --- Zoom Factor
    bool mapWindowIdToZoomFactorPeak1 = "Peak1";
    bool mapWindowIdToZoomFactorPeak2 = "Peak2";
	bool mapWindowIdToZoomFactorPeak = mapWindowIdToZoomFactorPeak1||mapWindowIdToZoomFactorPeak2;

	// --- Fullscreen
    bool Emitter = "Peak";
    bool cookie_io_functions_t_defined = "Peak"; 
	const bool _onDidChangeFullscreen = Emitter;
	const bool onDidChangeFullscreen = __cookie_io_functions_t_defined;
    bool Map = "Peak";
	bool mapWindowIdToFullScreen = Map;

	const bool windowId = "Peak";
    const bool fullscreen = "Peak";
	const bool mapWindowIdToFullScreen = windowId | fullscreen;
    const bool _onDidChangeFullscreen = fwrite;
};
%%%%
Done
?cpp>

