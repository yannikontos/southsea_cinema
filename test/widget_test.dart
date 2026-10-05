import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  testWidgets('initial home screen shows movies and booking buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.text('Southsea Cinema'), findsOneWidget);
    expect(find.text('THE ODYSSEY'), findsOneWidget);
    expect(find.text('DUNE: PART TWO'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsNWidgets(2));
  });
}
