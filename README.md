# Convex Flutter

A Flutter package that provides a seamless way to connect your Flutter applications to a Convex backend database using Rust-based Foreign Function Interface (FFI). This package enables developers to perform queries, mutations, actions, and real-time subscriptions with a Convex backend service.

## Features

- **Singleton Client**: Ensures a single instance of the Convex client for efficient resource management.
- **Query Execution**: Retrieve data from your Convex backend with ease.
- **Mutations**: Perform updates or changes to your Convex database.
- **Actions**: Execute custom server-side logic on your Convex backend.
- **Real-Time Subscriptions**: Subscribe to live updates from your Convex database.
- **Authentication**: Set authentication tokens for secure communication.
- **Rust-Powered**: Leverages Rust for high-performance communication with the Convex backend.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  convex_flutter: ^0.1.0 # Replace with the actual version
```

## Usage

### Initialize the Client

First, initialize the ConvexClient with your Convex deployment URL and a unique client ID:

```dart
final client = await ConvexClient.init(
  deploymentUrl: 'https://your-convex-deployment.com',
  clientId: 'your-unique-client-id',
);
```

### Query the Backend

Use the `query` method to retrieve data from your Convex backend:

```dart
final client = ConvexClient.instance;
final result = await client.query(
  "messages:list",
  {"limit": "10"},
);
print("Query Result: $result");
```

### Mutate the Backend

Perform updates or changes to your Convex database using the `mutation` method:

```dart
await client.mutation(
  "messages:send",
  {"body": "Hello, Convex!", "author": "Flutter Developer"},
);
```

### Execute Actions

Execute custom server-side logic using the `action` method:

```dart
await client.action(
  "messages:send",
  {"body": "Hello, Convex!", "author": "Flutter Developer"},
);
```

### Real-Time Subscriptions

Subscribe to live updates from your Convex database using the `subscribe` method:

```dart
final subscription = await client.subscribe(
  "messages:list",
  {"limit": "10"},
  onUpdate: (data) {
    print("Subscription Update: $data");
  },
  onError: (error) {
    print("Subscription Error: $error");
  },
);
```

### Authentication

Set an authentication token for secure communication:

```dart
await client.setAuth(token: 'your-auth-token');
```

### Cancelling Subscriptions

Cancel an active subscription using the provided subscription handle:

```dart
client.cancelSubscription(subscription);
```

Example: Chat Application
Below is a complete example of a simple chat application using convex_flutter:

```dart
import 'dart:convert';
import 'package:convex_flutter/convex_flutter.dart';
import 'package:flutter/material.dart';

late ConvexClient convexClient;

Future<void> main() async {
  convexClient = await ConvexClient.init(
    deploymentUrl: "https://your-app.convex.cloud",
    clientId: "flutter-app-1.0",
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController messageController = TextEditingController();
  ArcSubscriptionHandle? subscriptionHandle;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _subscribeToMessages();
  }

  Future<void> _subscribeToMessages() async {
    subscriptionHandle = await convexClient.subscribe(
      name: "messages:list",
      args: {},
      onUpdate: (value) {
        final List<dynamic> jsonList = jsonDecode(value);
        setState(() {
          messages = jsonList.map((e) => e as Map<String, dynamic>).toList();
        });
      },
      onError: (message, value) {
        print("Subscription Error: $message");
      },
    );
  }

  Future<void> _sendMessage(String text) async {
    await convexClient.mutation(
      name: "messages:send",
      args: {"body": text, "author": "FlutterUser"},
    );
    messageController.clear();
  }

  @override
  void dispose() {
    if (subscriptionHandle != null) convexClient.cancelSubscription(subscriptionHandle!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Convex Chat")),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return ListTile(
                    title: Text(msg["body"]),
                    subtitle: Text("By: ${msg["author"]}"),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(hintText: "Type a message..."),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendMessage(messageController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Prerequisites

- **Flutter**: Ensure you have Flutter installed and configured.
- **Convex Backend**: Set up a Convex deployment and define your query, mutation, and action functions.
- **Rust**: Required only for development or modification of the Rust FFI layer.

## Contributing

Contributions are welcome! Please fork the repository, make your changes, and submit a pull request. Ensure your code follows Dart and Rust conventions.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m "Add your feature"`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a pull request

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

For issues or questions, please [open an issue](../../issues) on the GitHub repository or contact the maintainers.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

```

```
