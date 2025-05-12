// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:fluttertest/services/counter.dart';
//
// void main() {
//   // given when then
//   test('Counter initial value should be 0', () {
//     //arrange
//     final counter = Counter();
//
//     // Act
//
//     //Assert
//
//     expect(counter.value, 0);
//   });
//
//   test("Counter should increemnt correctly", () {
//     final counter = Counter();
//
//     //act
//
//     counter.increment();
//     //assert
//
//     expect(counter.value, 1);
//
//     //act
//     counter.increment();
//
//     //asset again
//     expect(counter.value, 2);
//   });
//
//   test("Counter should decrement correctly", () {
//     //arrange
//     final counter = Counter();
//
//     counter.setValue(5);
//
//     //act
//
//     counter.decrement();
//     //assert
//
//     expect(counter.value, 4);
//
//     //act
//     counter.increment();
//
//     //asset again
//     expect(counter.value, 5);
//   });
//
//   test("counter should not decrement below 0", () {
//     final counter = Counter();
//
//     expect(counter.value, 0);
//
//     //act
//
//     counter.decrement();
//
//     //assert
//
//     expect(counter.value, 0);
//   });
//
//   test("Counter should reset to 0", () {
//     //ararnge
//
//     final counter = Counter();
//
//     counter.setValue(10);
//
//     //act
//     counter.rest();
//
//     //assetion
//     expect(counter.value, 0);
//   });
//
//   test("Counter should set value correctly", () {
//     //arrange
//     final counter = Counter();
//     //act
//     counter.setValue(10);
//
//     //assert
//     expect(counter.value, 10);
//   });
//
//   test("Counter should  not accept negative values", () {
//     //arrange
//     final counter = Counter();
//     counter.setValue(15);
//
//     //act
//     counter.setValue(-25);
//
//     expect(counter.value, 15);
//   });
// }
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:fluttertest/services/counter.dart';
//
// import 'package:flutter_test/flutter_test.dart';
//
//
// void main() {
//   late Counter counter;
//
//   setUp(() {
//     // This runs before each test
//     counter = Counter();
//   });
//
//   test('Counter initial value should be 0', () {
//     expect(counter.value, 0);
//   });
//
//   test('Counter should increment correctly', () {
//     counter.increment();
//     expect(counter.value, 1);
//
//     counter.increment();
//     expect(counter.value, 2);
//   });
//
//   test('Counter should decrement correctly', () {
//     counter.setValue(5);
//     counter.decrement();
//     expect(counter.value, 4);
//   });
//
//   test('Counter should not decrement below 0', () {
//     counter.decrement();
//     expect(counter.value, 0);
//   });
//
//   test('Counter should reset to 0', () {
//     counter.setValue(10);
//     counter.rest();
//     expect(counter.value, 0);
//   });
//
//   test('Counter should set value correctly', () {
//     counter.setValue(15);
//     expect(counter.value, 15);
//   });
//
//   test('Counter should not accept negative values', () {
//     counter.setValue(5);
//     counter.setValue(-3);
//     expect(counter.value, 5);
//   });
// }
//

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/services/counter.dart';

void main() {
  late Counter counter;
  setUp(() {
    counter = Counter();
  });

  group("Counter Initialization", () {
    test('Counter initial value should be 0', () {
      expect(counter.value, 0);
    });
  });


  group("Counter Increment", (){

    test("Should increase value by 1", (){

      counter.increment();

      expect(counter.value, 1);
    });

    test("Should handle multiple increment",(){

      counter.increment();
      counter.increment();
      counter.increment();

      expect(counter.value, 3);
    });



  });
}
