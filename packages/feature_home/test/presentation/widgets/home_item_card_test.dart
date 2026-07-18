import 'dart:async';
import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:feature_home/src/domain/entities/home_item.dart';
import 'package:feature_home/src/presentation/widgets/home_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// A minimal 1x1 transparent PNG -- `Image.network` needs real, decodable
// bytes to resolve cleanly in a widget test. `flutter_test`'s
// TestWidgetsFlutterBinding intercepts every HttpClient and returns a bare
// 400 with no body by default, which `Image.network` surfaces as an
// uncaught `NetworkImageLoadException` (flagged "unexpected" by the test
// framework) *and*, separately, leaves the failed image with no defined
// size, overflowing HomeItemCard's Row -- neither is something this test
// cares about; both are just artifacts of not mocking the HTTP layer.
const _transparentPng = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

class _FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();
}

class _FakeHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();
}

class _FakeHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  group('HomeItemCard', () {
    testWidgets('clips the thumbnail with AppShapeExtension.radiusSm', (
      tester,
    ) async {
      await HttpOverrides.runZoned(() async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: HomeItemCard(
                item: const HomeItem(
                  id: '1',
                  title: 'Title',
                  subtitle: 'Subtitle',
                  imageUrl: 'https://example.com/thumbnail.png',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(
          clipRRect.borderRadius,
          BorderRadius.circular(AppShapeExtension.standard.radiusSm),
        );
      }, createHttpClient: (_) => _FakeHttpClient());
    });

    testWidgets('omits the thumbnail clip when imageUrl is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: HomeItemCard(
              item: const HomeItem(
                id: '1',
                title: 'Title',
                subtitle: 'Subtitle',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsNothing);
    });
  });
}
