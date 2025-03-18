import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/core/env/flavor.dart';
import 'src/core/logger/logger.dart';

Future<void> mainBase(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  logger('launching app with URL: ${flavor.env.supabaseUrl}');

  FlutterError.demangleStackTrace = (stack) {
    if (stack is Trace) return stack.vmTrace;
    if (stack is Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  await Supabase.initialize(
    url: flavor.env.supabaseUrl,
    anonKey: flavor.env.supabaseAnonKey,
  );

  runApp(
    ProviderScope(
      overrides: [
        appFlavorProvider.overrideWithValue(flavor),
      ],
      child: const SmartTextFieldOverlay(
        child: App(),
      ),
    ),
  );
}
