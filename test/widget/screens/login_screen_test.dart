import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/screens/login_screen.dart';

void main() {
  group("Login Screen Widgets test", () {
    /*
     * TEST 1: Rendering Test
     *
     * This test verifies that all expected UI elements are rendered correctly.
     * It's a basic test that ensures the widget builds without errors and
     * all key components are present.

     */

    testWidgets("Should render all ui elements correctly",
        (WidgetTester tester) async {
      // ARRANGE: Build the LoginScreen widget within a MaterialApp
      // The MaterialApp is needed to provide the theme and navigation context

      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(onLogin: (email, password) {}),
      ));

      //Assert
      // Checks AppBar title
      expect(find.text("Login"), findsOneWidget);
      // Checks for both text fields

      expect(find.byType(TextFormField), findsNWidgets(2));
      // Checks for field labels
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Checks for the login button
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('LOGIN'), findsOneWidget);

      // Checks for icons
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
    /*
     * TEST 2: Empty Form Validation
     *
     * This test verifies that validation errors appear when trying to
     * submit an empty form. It simulates tapping the login button without
     * entering any data.
     */

    testWidgets("Should show validation errors for empty fields",
        (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(onLogin: (email, password) {}),
      ));
// ACT: Tap the login button without entering any data
      await tester.tap(find.byType(ElevatedButton));
      // IMPORTANT: We need to rebuild the widget to see the validation messages
      await tester.pump();

      // ASSERT: Check that appropriate error messages are displayed
      expect(find.text("Please enter your email"), findsOneWidget);
      expect(find.text("Please enter your password"), findsOneWidget);
    });

    /*
     * TEST 3: Email Validation
     *
     * This test verifies that the email field correctly validates email format.
     * It enters an invalid email address and submits the form.
     */

    testWidgets("Should validate Email format", (WidgetTester tester) async {
      // ARRANGE: Build the LoginScreen
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          onLogin: (email, password) {},
        ),
      ));

      // ACT: Enter invalid email and valid password
      // The first TextFormField (index 0) is the email field

      await tester.enterText(find.byKey(Key("email_field")), 'invalid-email');
      // The second TextFormField (index 1) is the password field
      await tester.enterText(find.byKey(Key('password_field')), 'password123');

      // Tap login
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      //assert
      expect(find.text("Please enter a valid email"), findsOneWidget);
    });
/*
     * TEST 4: Password Length Validation
     *
     * This test verifies that the password field validates minimum length.
     * It enters a valid email but a password that's too short.
     */

    testWidgets("should validate password length", (WidgetTester tester) async {
      // ARRANGE: Build the LoginScreen
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          onLogin: (email, password) {},
        ),
      ));

      await tester.enterText(
          find.byKey(Key("email_field")), 'example@gmail.com');
      // The second TextFormField (index 1) is the password field
      await tester.enterText(find.byKey(Key('password_field')), '1234');
      // Tap login
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      //Assert
      // ASSERT: Check for password length error
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    /*
     * TEST 5: Loading State
     *
     * This test verifies that the loading indicator appears after submitting
     * the form with valid inputs.
     */

    testWidgets("should show loading indicator after submission",
        (WidgetTester tester) async {
      // ARRANGE: Build the LoginScreen
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          onLogin: (email, password) {},
        ),
      ));

      // ACT: Enter valid credentials
      await tester.enterText(
          find.byKey(Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');

      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap login
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);

      await tester.pump(Duration(seconds: 1));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    /*
     * TEST 6: Callback Invocation
     *
     * This test verifies that the onLogin callback is properly called with
     * the correct email and password when submitting valid credentials.
     */

    testWidgets('should call onLogin with correct credentials',
        (WidgetTester tester) async {
      // ARRANGE: Create variables to capture callback values
      String? capturedEmail;
      String? capturedPassword;

      // Build the LoginScreen with a callback that captures the values
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          onLogin: (email, password) {
            capturedEmail = email;
            capturedPassword = password;
          },
        ),
      ));

      // ACT: Enter valid credentials and submit
      await tester.enterText(
          find.byKey(Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      await tester.tap(find.byKey(Key('login_button')));

      // Wait for the loading state (1 second) to complete
      await tester.pump(); // Show loading state
      await tester.pump(Duration(seconds: 1)); // Wait for delay
      await tester.pump(); // Process the callback

      // ASSERT: Verify the callback was called with correct values
      expect(capturedEmail, 'test@example.com');
      expect(capturedPassword, 'password123');
    });

    /*
     * TEST 7: Email Trimming
     *
     * This test verifies that the email is trimmed before being passed
     * to the onLogin callback, removing any leading/trailing whitespace.
     */
    testWidgets('should trim email before submitting',
        (WidgetTester tester) async {
      // ARRANGE: Variable to capture the email
      String? capturedEmail;

      // Build the LoginScreen
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(
          onLogin: (email, password) {
            capturedEmail = email;
          },
        ),
      ));

      // ACT: Enter email with whitespace and submit
      await tester.enterText(find.byKey(Key('email_field')),
          ' test@example.com '); // Note the spaces
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      await tester.tap(find.byKey(Key('login_button')));

      // Wait for the loading state to complete
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      await tester.pump();

      // ASSERT: Email should be trimmed
      expect(capturedEmail, 'test@example.com'); // No spaces
    });
  });
}
