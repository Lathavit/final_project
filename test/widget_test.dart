import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget); // ตรวจสอบว่ามีตัวอักษร '0' บนหน้าจอหรือไม่
    expect(find.text('1'), findsNothing); // ตรวจสอบว่าไม่มีตัวอักษร '1' บนหน้าจอ

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add)); // สั่งแตะที่ไอคอน '+' เพื่อเพิ่มค่า
    await tester.pump(); // สั่งให้ทำการรีเรนเฟรมเพื่อทำการปรับปรุง widget

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing); // ตรวจสอบว่าไม่มีตัวอักษร '0' บนหน้าจอ
    expect(find.text('1'), findsOneWidget); // ตรวจสอบว่ามีตัวอักษร '1' บนหน้าจอ
  });
}
