// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:stcerwallet/service/address_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   final stores = await createStore();
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MainApp(stores));

  //   // // Verify that our counter starts at 0.
  //   // expect(find.text('0'), findsOneWidget);
  //   // expect(find.text('1'), findsNothing);

  //   // // Tap the '+' icon and trigger a frame.
  //   // await tester.tap(find.byIcon(Icons.add));
  //   // await tester.pump();

  //   // // Verify that our counter has incremented.
  //   // expect(find.text('0'), findsNothing);
  //   // expect(find.text('1'), findsOneWidget);
  // });

  test('should return private key from mnemonic', () {
    final addressService = AddressService(null);
    final privateKey = addressService.getPrivateKey(
        "loan absorb orange crouch mixed position sweet law ghost habit upgrade toss");
    expect(privateKey,
        "02e41a913e0d109672c9122c96f0715ef62746aabe186a8160bca314acaa3178");
  });
}
