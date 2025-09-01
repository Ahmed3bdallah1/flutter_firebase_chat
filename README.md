# flutter_firebase_chat

**A Flutter package to integrate with firebase firestore.**

## Features

<<<<<<< HEAD
- Easy integration with Firestore system.
- Support for Real-time messaging.
- Customizable chat view with flexible style options.
- User data collection for enabling chat service.

---
=======
# flutter_firebase_chat

A Flutter package that simplifies the integration of Firestore and Real-Time chatting.
>>>>>>> f590b71af9211ba066d7a7ebe79821eab643a677

## Getting Started

### Prerequisites

1. Flutter SDK installed on your machine.
2. A local stored user account is required to acquire the chat without any conflicts.

### Installation

Add the following line to your `pubspec.yaml` file:

```yaml  
dependencies:
  flutter_firebase_chat : ^1.0.0
```  

Run `flutter pub get` to install the package.

<<<<<<< HEAD
---
=======
```yaml
dependencies:
  flutter_firebase_chat : ^1.0.0
```
>>>>>>> f590b71af9211ba066d7a7ebe79821eab643a677

## Usage

Before proceeding with chat, initialize your chat service (in the `initState` of your widget) and initialize your service locator in main :


### Initialize in the main

```dart  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await flutterFirebaseChatLocator();
}
```

### Initializing Chat Data

```dart  
ChatServiceInit.initialize(
  // required User Model
  userData: UserModel(
    id: 1, // Required
    uuid: "UUId",
    name: "User Name",
    email: "User Email",
    phone: "User Phone",
    role: "User",
  ), // UserModel.fromJson({})
  
  // Optional Style Customizations
  style: Style(
    primaryColor: Colors.blue, // Default: const Color(0xff113D64)
    scaffoldColor: Colors.white, // Default: Colors.white
    appBarBackgroundColor: Colors.blue, // Default: Colors.blue
    appBarForegroundColor: Colors.white, // Default: const Color(0xff13828E)
    textStyle: TextStyle(), // Default: TextStyle()
    userChatBubbleColor: Colors.blue, // Default: Colors.grey
    grey1: Colors.grey, // Default: const Color(0xffd0d9e5)
    grey2: Colors.grey, // Default: const Color(0xff929898)
    circleProgressColor: Colors.blue, // Default: Colors.blue
  ),
);
```

### Navigating to the Chat View

Once initialized, navigate to the Chat page view using:

```dart  
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChatPage(
                receiverId: "Receiver ID",
                receiverName: "Receiver Name",
                receiver: UserModel(...) // UserModel.fromJson() there is two ways to store the receiving user data
              ),
  ),
);
```  

---

## Additional Information
