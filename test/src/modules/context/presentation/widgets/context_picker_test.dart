import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:action/src/modules/context/domain/entity/context.dart';
import 'package:action/src/modules/context/presentation/state/context_picker_provider.dart';
import 'package:action/src/modules/context/presentation/view_models/context_view_model.dart';
import 'package:action/src/modules/context/presentation/widgets/context_picker.dart';

class MockOverlayPortalController extends Mock implements OverlayPortalController {}

class MockContextPickerData extends Mock implements ContextPickerData {}

void main() {
  group('ContextPicker', () {
    late OverlayPortalController controller;
    late ContextPickerData data;
    late ContextViewModel contextViewModel;
    late Function(ContextViewModel) onContextSelectedMock;

    setUp(() {
      controller = MockOverlayPortalController();
      onContextSelectedMock = (_) {};

      contextViewModel = ContextViewModel(
        context: const ContextEntity(
          id: '1',
          name: 'Home',
        ),
      );

      data = ContextPickerData(
        onContextSelected: onContextSelectedMock,
        selectedContext: contextViewModel,
      );

      when(() => controller.hide()).thenReturn(null);
    });

    testWidgets('renders correctly with items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            contextPickerResultsProvider.overrideWith((ref, _) => [contextViewModel])
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ContextPicker(
                controller: controller,
                data: data,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Search contexts...'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('shows empty state when no items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [contextPickerResultsProvider.overrideWith((ref, _) => [])],
          child: MaterialApp(
            home: Scaffold(
              body: ContextPicker(
                controller: controller,
                data: data,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No contexts found'), findsOneWidget);
    });

    testWidgets('calls onContextSelected and hides overlay when item is tapped', (tester) async {
      bool wasSelected = false;

      final overriddenData = ContextPickerData(
        onContextSelected: (context) {
          wasSelected = true;
          expect(context, equals(contextViewModel));
        },
        selectedContext: null,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            contextPickerResultsProvider.overrideWith((ref, _) => [contextViewModel]),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ContextPicker(
                controller: controller,
                data: overriddenData,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(wasSelected, isTrue);
      verify(() => controller.hide()).called(1);
    });
  });
}
