import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/app.dart';
import 'package:mobile/src/di/injection.dart';
import 'package:shared/shared.dart' show getIt;

void main() {
  tearDown(() => getIt.reset());

  testWidgets('boots straight into the login page for an unauthenticated user', (
    tester,
  ) async {
    await configureDependencies(env: Env.current);

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
