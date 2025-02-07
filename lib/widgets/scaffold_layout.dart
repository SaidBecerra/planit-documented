import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable scaffold layout that provides a consistent structure for screens.
///
//  This widget simplifies building screens with a predefined [AppBar], optional floating action button,
/// customizable background color, and a body widget.
/// 
/// **Features:**
/// - Transparent AppBar with a custom back button.
/// - Optional floating action button and actions.
/// - Customizable background color.
class ScaffoldLayout extends StatelessWidget {
  // Creates a [ScaffoldLayout].
  ///
  // * [body] is the required widget that represents the main content of the screen.
  // * [backgroundColor] is an optional color for the scaffold's background.
  // * [floatingActionButton] is an optional FAB displayed at the bottom right.
  // * [actions] is an optional list of widgets displayed in the AppBar's actions area.
  const ScaffoldLayout({
    this.backgroundColor,
    this.floatingActionButton,
    this.actions,
    required this.body,
    super.key,
  });

  /// The main content of the screen.
  final Widget body;

  /// The optional background color of the scaffold.
  final Color? backgroundColor;

  /// An optional floating action button.
  final FloatingActionButton? floatingActionButton;

  /// Optional widgets displayed in the AppBar's action area.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,  // Displays the floating action button, if provided.
      appBar: AppBar(
        scrolledUnderElevation: 0,  // Removes shadow when the user scrolls.
        surfaceTintColor: Colors.transparent,  // Prevents default material tint.
        forceMaterialTransparency: true,  // Makes the AppBar fully transparent.
        elevation: 0,  // Removes the AppBar elevation.
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(110, 158, 158, 158),  // Light shadow for a subtle effect.
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/left-arrow.png',  // Custom back button icon.
              width: 20,
              height: 20,
            ),
            onPressed: () => Navigator.pop(context),  // Navigates back to the previous screen.
          ),
        ),
        actions: actions,  // Displays additional action buttons in the AppBar, if provided.
        systemOverlayStyle: SystemUiOverlayStyle.dark,  // Sets the system status bar to dark mode.
      ),
      body: body,  // Sets the main content of the screen.
    );
  }
}
