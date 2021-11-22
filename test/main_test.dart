import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agricola/pages/pageUpload.dart';

void main() {
  testWidgets("View Status", (WidgetTester tester) async {
    var widget = pageUpload();
    await tester.pumpWidget(Scaffold(
      body: Container(
        child: Center(
          child: widget,
        ),
      ),
    ));
    expect(find.text("SELECT IMAGE"), findsNothing);
  });
}
