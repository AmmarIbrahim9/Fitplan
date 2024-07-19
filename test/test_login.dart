// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mockito/mockito.dart';
// import 'package:fitplanv_1/signup.dart';
//
// class MockFirebaseAuth extends Mock implements FirebaseAuth {}
// class MockGoogleSignIn extends Mock implements GoogleSignIn {}
//
// void main() {
//   late MockFirebaseAuth mockFirebaseAuth;
//   late MockGoogleSignIn mockGoogleSignIn;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController confirmPasswordController;
//   late Signup signupWidget;
//
//   setUp(() {
//     mockFirebaseAuth = MockFirebaseAuth();
//     mockGoogleSignIn = MockGoogleSignIn();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     confirmPasswordController = TextEditingController();
//     signupWidget = Signup();
//   });
//
//   testWidgets('Signing up with email and password', (WidgetTester tester) async {
//     when(mockFirebaseAuth.createUserWithEmailAndPassword(
//       email: anyNamed('email'),
//       password: anyNamed('password'),
//     )).thenAnswer((_) async => UserCredential(user: MockUser()));
//
//     await tester.pumpWidget(MaterialApp(home: signupWidget));
//
//     await tester.enterText(find.byKey(ValueKey('email')), 'test@example.com');
//     await tester.enterText(find.byKey(ValueKey('password')), 'Test@123');
//     await tester.enterText(find.byKey(ValueKey('confirmPassword')), 'Test@123');
//
//     await tester.tap(find.text('Confirm'));
//     await tester.pump();
//
//     // Verify that createUserWithEmailAndPassword was called with correct email and password
//     verify(mockFirebaseAuth.createUserWithEmailAndPassword(
//       email: 'test@example.com',
//       password: 'Test@123',
//     )).called(1);
//   });
//
//   testWidgets('Signing up with Google', (WidgetTester tester) async {
//     when(mockGoogleSignIn.signIn()).thenAnswer((_) async => MockGoogleSignInAccount());
//     when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => MockGoogleSignInAuthentication());
//     when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => UserCredential(user: MockUser()));
//
//     await tester.pumpWidget(MaterialApp(home: signupWidget));
//
//     await tester.tap(find.byType(ElevatedButton).first);
//     await tester.pump();
//
//     // Verify that signInWithGoogle was called
//     verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
//   });
//
//   // Add more test cases for error scenarios and terms agreement check
// }
