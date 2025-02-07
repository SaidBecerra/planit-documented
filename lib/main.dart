import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planit/widgets/registration/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:planit/widgets/homepage/custom_navigation_bar.dart';

/// Main function of the application
/// 
/// This function is the entry point of the Flutter application. It ensures that
/// Firebase services are initialized before the app starts and displays the 
/// appropriate screen based on the authentication state.

void main() async {
   // Ensures that widget binding is initialized before any asynchronous calls.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with platform-specific options (e.g., Android, iOS).
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Start the Flutter application and provide the initial screen based on
  // the user's authentication state using a StreamBuilder.
  runApp(MaterialApp(
      home: StreamBuilder(
        // Listen for authentication state changes using FirebaseAuth.
        stream: FirebaseAuth.instance.authStateChanges(),
        // Build the appropriate widget based on the authentication state.
        builder: (ctx, snapshot) {
            // If the snapshot has data, it means the user is authenticated.
            if (snapshot.hasData) {
              return const CustomNavigatonBar();  // Show the main navigation bar.
            }
            // If the user is not authenticated, show the welcome screen.
            return const WelcomeScreen();
          },
        )
      )
    );
  }
