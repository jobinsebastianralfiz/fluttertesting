import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/services/calculator.dart';

void main() {
  late Calculator calculator;

  setUp(() {
    calculator = Calculator();
  });

  group("Calculator", () {
    test("Should add two number", () {
      //arrange is done in setup
      // act
      final result = calculator.add(5, 5);
      //assert
      expect(result, 10);
    });

    test("Should subtract two number", () {
      //arrange is done in setup
      // act
      final result = calculator.subtract(6, 5);
      //assert
      expect(result, 1);
    });
    test("Should multiply two number", () {
      //arrange is done in setup
      // act
      final result = calculator.multiply(6, 5);
      //assert
      expect(result, 30);
    });

    test("Should dive two number", () {
      //arrange is done in setup
      // act
      final result = calculator.divide(6, 2);
      //assert
      expect(result, 3);
    });

    test("Should throw an error when dividign by zero", () {
      expect(() => calculator.divide(10, 0), throwsArgumentError);
    });
  });
}
