import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:action/src/design_system/icons/app_icons.dart';
import 'package:action/src/shared/pickers/common_picker.dart';
import 'package:action/src/shared/pickers/picker_item.dart';

class MockOverlayPortalController extends Mock implements OverlayPortalController {}

void main() {
  group('CommonPicker', () {
    late OverlayPortalController controller;

    setUp(() {
      controller = MockOverlayPortalController();
      when(() => controller.hide()).thenReturn(null);
    });

    testWidgets('renders correctly with items', (tester) async {
      final items = List.generate(3, (index) => 'Item $index');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CommonPicker(
                controller: controller,
                title: 'Search items...',
                items: items,
                syncTextController: (_, __) {},
                emptyStateWidget: const PickerEmptyState(
                  message: 'No items found',
                ),
                itemBuilder: (context, index) => Text(items[index]),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Search items...'), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('shows empty state when no items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CommonPicker(
                controller: controller,
                title: 'Search items...',
                items: [],
                syncTextController: (_, __) {},
                emptyStateWidget: const PickerEmptyState(
                  message: 'No items found',
                ),
                itemBuilder: (context, index) => const SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No items found'), findsOneWidget);
    });

    testWidgets('hides overlay on tap outside', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CommonPicker(
                controller: controller,
                title: 'Search items...',
                items: ['Item'],
                syncTextController: (_, __) {},
                emptyStateWidget: const PickerEmptyState(
                  message: 'No items found',
                ),
                itemBuilder: (context, index) => const Text('Item'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the transparent overlay
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      verify(() => controller.hide()).called(1);
    });
  });

  group('PickerItem', () {
    testWidgets('renders correctly', (tester) async {
      bool wasTapped = false;
      bool wasRemoved = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: PickerItem(
                title: 'Test Item',
                icon: AppIcons.hammerOutlined,
                isSelected: true,
                onTap: () => wasTapped = true,
                onRemove: () => wasRemoved = true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Item'), findsOneWidget);

      // The remove icon should be visible since isSelected is true
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.text('Test Item'));
      expect(wasTapped, isTrue);

      await tester.tap(find.byIcon(Icons.clear));
      expect(wasRemoved, isTrue);
    });

    testWidgets('does not show remove button when not selected', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: PickerItem(
                title: 'Test Item',
                icon: AppIcons.hammerOutlined,
                isSelected: false,
                onTap: () {},
                onRemove: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsNothing);
    });
  });

  group('PickerEmptyState', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const PickerEmptyState(
                message: 'Custom empty message',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom empty message'), findsOneWidget);
    });
  });
}
