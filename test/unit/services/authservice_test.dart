import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/services/auth_service.dart';

void main() {
  // global variables
  late AuthService authService;
// Common test users and credentials
  const String validEmail = "user1@example.com";
  const String validPassword = 'Password123';
  const String invalidEmail = 'not-an-email';
  const String weakPassword = 'weak';
  const String newValidPassword = 'NewPassword456';

  //Main setUp function that runs before EACH test

  setUp(() {
    authService = AuthService();
  });

// Group 1: Login functionality tests

  group("Login functionality", () {
    test("should successfully login with valid credentials", () {
// no need of arrange, because setup is already there

      final result = authService.login(validEmail, validPassword);

      expect(result, true);
      expect(authService.isLoggedIn, true);
      expect(authService.currentUser, validEmail);
    });

    test("should fail login with invalid password", () {
      //act
      final result = authService.login(validEmail, "WorngPassword");
      //assert

      expect(result, false);
      expect(authService.isLoggedIn, false);
      expect(authService.currentUser, null);
    });

    test("should fail login with non-existent email", () {
      //act
      final result =
          authService.login("nonexistignemail@exmple.com", validPassword);

      //assert
      expect(result, false);
      expect(authService.isLoggedIn, false);
      expect(authService.currentUser, null);
    });
  });

  // Group 2 Logout functionality

  group("Logout Functionality", () {
//Group-specific setUp that runs after the main setUp
    setUp(() {
      authService.login(validEmail, validPassword);
      expect(authService.isLoggedIn, true,
          reason: "Pre Condition:User should be logged in");
    });

    test('Should clear the userr session successfully', () {
      //act
      authService.logout();

      expect(authService.isLoggedIn, false);
      expect(authService.currentUser, null);
    });

    test("should allow login after logout", () {
      //arrange
      authService.logout();
      expect(authService.isLoggedIn, false,
          reason: "User should be loggedout before teh test");

      //act-login again

      final result = authService.login(validEmail, validPassword);

      //assert
      expect(result, true);
      expect(authService.isLoggedIn, true);
      expect(authService.currentUser, validEmail);
    });

    // Group 3: User registration tests

    group("User Registration", () {
      test("should register new user with valid credentials", () {
        //act
        final result = authService.registerUser(
            "newuserexample@gmail.com", "ValidPass123");
        //assert
        expect(result, true);
      });

      test('should reject registration with invalid email format', () {
        // Act
        final result = authService.registerUser(invalidEmail, validPassword);

        // Assert
        expect(result, false);

        // Verify user was not created
        expect(authService.login(invalidEmail, validPassword), false);
      });

      test("should reject registration with weak password'", () {
        final result =
            authService.registerUser("valid@example.com", weakPassword);

        //assert
        expect(result, false);

        // Verify user was not created
        expect(authService.login(invalidEmail, validPassword), false);
      });

      test('should reject registration of existing email', () {
        // Arrange - ensure user exists
        authService.registerUser('existing@example.com', validPassword);

        // Act - try to register again
        final result = authService.registerUser(
            'existing@example.com', 'DifferentPass123');

        // Assert
        expect(result, false);
      });
    });

    // Group 4: Password Management
    group('Password Management', () {
      // Group-specific constants
      const String userEmail = 'user2@example.com';
      const String originalPassword = 'SecurePass456';
      const String newValidPassword = 'NewPassword789';

      setUp(() {
        // Ensure this test user exists before each test
        authService.registerUser(userEmail, originalPassword);
      });

      test('should allow changing password with correct credentials', () {
        // Act
        final result = authService.changePassword(userEmail, originalPassword, newValidPassword);

        // Assert
        expect(result, true);

        // Verify old password no longer works
        expect(authService.login(userEmail, originalPassword), false);

        // Verify new password works
        expect(authService.login(userEmail, newValidPassword), true);
      });

      test('should reject password change with incorrect old password', () {
        // Act
        final result = authService.changePassword(userEmail, "WrongPassword", newValidPassword);

        // Assert
        expect(result, false);

        // Verify original password still works
        expect(authService.login(userEmail, originalPassword), true);
      });

      test('should reject password change with invalid new password', () {
        // Act
        final result = authService.changePassword(userEmail, originalPassword, weakPassword);

        // Assert
        expect(result, false);

        // Verify original password still works
        expect(authService.login(userEmail, originalPassword), true);
      });
    });
  });

  // Group 5: Email validation - TAILORED TO YOUR IMPLEMENTATION
  group("Email Validation", () {
    test("should accept valid email formats", () {
      final validEmails = [
        'user@example.com',
        'user.name@example.co.uk',
        'user+tag@example.org',
        'user-name@sub.domain.com',
      ];

      for (final email in validEmails) {
        expect(authService.registerUser(email, "Password123456"), true,
            reason: "Should accept $email");
      }
    });

    test('should reject email formats missing @', () {
      final invalidEmails = [
        'plaintext',
        'email.example.com',
        'name_at_domain.com',
      ];

      for (final email in invalidEmails) {
        expect(authService.registerUser(email, "Password123456"), false,
            reason: "Should reject $email");
      }
    });

    test('should reject email formats missing .', () {
      final invalidEmails = [
        'user@domainwithoutdot',
        'user@localhost',
      ];

      for (final email in invalidEmails) {
        expect(authService.registerUser(email, "Password123456"), false,
            reason: "Should reject $email");
      }
    });


  });
  // Group 6: Password validation - TAILORED TO YOUR IMPLEMENTATION
  group("Password Validation", () {
    const validEmail = "passwordtest@example.com";

    test("should accept passwords longer than 8 characters with digits", () {
      final validPasswords = [
        'Password123',
        'LongPassword1',
        'C0mpl3xP4ssw0rd',
        '123456789',
      ];

      for (final password in validPasswords) {
        expect(authService.registerUser(validEmail + validPasswords.indexOf(password).toString(),
            password),
            true, reason: "Should accept $password");
      }
    });

    test("should reject passwords 8 characters or shorter", () {
      final invalidPasswords = [
        'Pass123', // 7 chars
        'Abcd123', // 7 chars
        'Short1',  // 6 chars
      ];

      for (final password in invalidPasswords) {
        expect(authService.registerUser(validEmail + invalidPasswords.indexOf(password).toString(),
            password),
            false, reason: "Should reject $password for being too short");
      }
    });

    test("should reject passwords without digits", () {
      final invalidPasswords = [
        'PasswordWithoutNumbers',
        'LongEnoughButNoDigits',
      ];

      for (final password in invalidPasswords) {
        expect(authService.registerUser(validEmail + invalidPasswords.indexOf(password).toString(),
            password),
            false, reason: "Should reject $password for having no digits");
      }
    });
  });
}
