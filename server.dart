import 'dart:async';
import 'dart:io';

class WebSocketServer {
  static int counter = 0;
  static final List<WebSocket> connectedClients = [];

  static Future<void> main() async {
    final server = await HttpServer.bind('0.0.0.0', 3000); // Allow connections from any IP
    print('WebSocket server listening on port ${server.port}');

    await for (var request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        handleWebSocket(request);
      } else {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.writeln('WebSocket connections only.');
        request.response.close();
      }
    }
  }

  static void handleWebSocket(HttpRequest request) {
    WebSocketTransformer.upgrade(request).then((WebSocket webSocket) {
      connectedClients.add(webSocket);
      print('Client connected. Total clients: ${connectedClients.length}');

      webSocket.listen(
        (data) {
          print('Received: $data');
          if (data == 'click') {
            counter++;
            updateClientsCounter();
          }
        },
        onDone: () {
          connectedClients.remove(webSocket);
          print('Client disconnected. Total clients: ${connectedClients.length}');
        },
        onError: (error) {
          print('Error: $error');
        },
      );
    });
  }

  static void updateClientsCounter() {
    final String counterMessage = 'Counter: $counter';
    connectedClients.forEach((client) {
      client.add(counterMessage);
    });
  }
}

void main() {
  WebSocketServer.main();
}
