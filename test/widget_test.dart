// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_sgah/data/mock_data.dart';
import 'package:app_sgah/main.dart';
import 'package:app_sgah/services/google_places_service.dart';

void main() {
  testWidgets('home search filters the local diwaniya list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('ديوانيات'), findsOneWidget);
    expect(find.text('حيث تبدأ اللمة'), findsOneWidget);
    expect(find.text('الديوانيات القريبة'), findsOneWidget);
    expect(find.text('ديوانية أبو محمد'), findsOneWidget);
    expect(find.text('ديوانية الشباب'), findsOneWidget);

    final homeSearch = find.descendant(
      of: find.byKey(const ValueKey('home-search')),
      matching: find.byType(TextField),
    );
    await tester.enterText(homeSearch, 'النخيل');
    await tester.pumpAndSettle();

    expect(find.text('ديوانية النخيل'), findsOneWidget);
    expect(find.text('ديوانية أبو محمد'), findsNothing);
    expect(find.text('ديوانية الشباب'), findsNothing);
  });

  testWidgets('diwaniya card opens the detail screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 3;
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('ديوانية أبو محمد').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.text('تفاصيل الديوانية'), findsOneWidget);
    final detailScrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('نبذة عن الديوانية'),
      250,
      scrollable: detailScrollable,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('نبذة عن الديوانية'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('احجز جلستك'),
      300,
      scrollable: detailScrollable,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('أوقات التجمع'), findsOneWidget);
    expect(find.text('احجز جلستك'), findsOneWidget);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('explore facility filter shows matching results', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('استكشاف').first);
    await tester.pumpAndSettle();

    expect(find.text('اختر المرافق'), findsOneWidget);
    await tester.tap(find.text('غرف خاصة'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('نتائج البحث'), findsOneWidget);
    expect(find.text('ديوانية أبو محمد'), findsOneWidget);
    expect(find.text('ديوانية الشباب'), findsNothing);
  });

  testWidgets('open-now filter and saved favorites work locally', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('مفتوحة الآن'));
    await tester.pumpAndSettle();
    expect(find.text('ديوانية أبو محمد'), findsOneWidget);
    expect(find.text('ديوانية الشباب'), findsOneWidget);
    expect(find.text('ديوانية النخيل'), findsNothing);

    await tester.tap(find.byTooltip('إضافة إلى المحفوظات').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('المحفوظة').first);
    await tester.pumpAndSettle();
    expect(find.text('ديوانية أبو محمد'), findsOneWidget);

    await tester.tap(find.byTooltip('إزالة من المحفوظات'));
    await tester.pumpAndSettle();
    expect(find.text('ما حفظت أي ديوانية للحين'), findsOneWidget);
  });

  test('mock catalog has twelve diwaniyas with bookable sessions', () {
    expect(mockDiwaniyas, hasLength(12));
    for (final diwaniya in mockDiwaniyas) {
      expect(diwaniya.sessions, isNotEmpty);
      expect(
        diwaniya.sessions.every((session) => session.capacity > 0),
        isTrue,
      );
    }
  });

  test('Places service remains optional without an API key', () async {
    final service = GooglePlacesService(apiKey: '');
    expect(service.isConfigured, isFalse);
    expect(await service.getPlaceDetails('mock-place'), isNull);
    expect(service.getPhotoUri('places/mock/photos/photo'), isNull);
    expect(
      service.getGoogleMapsUri(placeId: 'mock-place').queryParameters,
      containsPair('query_place_id', 'mock-place'),
    );
    service.close();
  });

  testWidgets('Add Diwaniya steps advance through review', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('إضافة').first);
    await tester.pumpAndSettle();

    expect(find.text('اسم الديوانية'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('اختر المرافق المتوفرة'), findsOneWidget);
    await tester.tap(find.text('واي فاي'));
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('صور الديوانية'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('مراجعة المعلومات'), findsOneWidget);
    await tester.tap(find.text('حفظ للمعاينة'));
    await tester.pumpAndSettle();
    expect(find.text('تم تجهيز الديوانية'), findsOneWidget);
  });

  testWidgets('complete booking flow reaches local confirmation', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 3;
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('ديوانية أبو محمد').first);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('احجز جلستك'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('احجز جلستك'));
    await tester.pumpAndSettle();

    expect(find.text('وش تبي تحجز؟'), findsOneWidget);
    await tester.tap(find.text('بلايستيشن'));
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('كم شخص؟'), findsOneWidget);
    final increment = find.byKey(const ValueKey('people-increment'));
    for (var person = 0; person < 6; person++) {
      await tester.tap(increment);
    }
    await tester.pumpAndSettle();
    expect(find.text('8'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('كم مدة الحجز؟'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('متى تبي تحجز؟'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('booking-date')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('اختيار').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('booking-time')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('اختيار').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('اختيار الجلسة'));
    await tester.pumpAndSettle();

    expect(find.text('اختر مكان جلستك'), findsOneWidget);
    final matchingSession = find.text('جلسة بلايستيشن');
    await tester.ensureVisible(matchingSession);
    await tester.tap(matchingSession);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('سعة الجلسة أقل من عدد الأشخاص'), findsOneWidget);
    await tester.tap(find.byTooltip('إغلاق'));
    await tester.pumpAndSettle();
    final suitableSession = find.text('غرفة خاصة 01');
    await tester.ensureVisible(suitableSession);
    await tester.tap(suitableSession);
    await tester.pumpAndSettle();
    expect(find.text('اختيار الجلسة'), findsOneWidget);
    await tester.tap(find.text('اختيار الجلسة'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('floor-next')));
    await tester.pumpAndSettle();

    expect(find.text('راجع تفاصيل جلستك'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm-booking')));
    await tester.pumpAndSettle();
    expect(find.text('تم تأكيد حجزك'), findsOneWidget);
    expect(find.text('عرض حجوزاتي'), findsOneWidget);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
