import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/core/env/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.demangleStackTrace = (stack) {
    if (stack is Trace) return stack.vmTrace;
    if (stack is Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: App()));
}
