
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/main.dart';

void main() {
  testWidgets('Aplikasi menampilkan halaman login',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SecureHttpApp());

    expect(find.text('Login'), findsOneWidget);
    expect(
      find.text('Keamanan Data & HTTP Dasar'),
      findsOneWidget,
    );
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
