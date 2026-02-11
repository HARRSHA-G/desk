import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'construct_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Attempt to launch the backend sidecar first
  await launchGoBackend();
  
  // Launch the main Construct Flow App
  runApp(const ConstructFlowApp());
}

Future<void> launchGoBackend() async {
  print("Attempting to launch Go Backend Sidecar...");
  
  String backendPath;
  
  try {
    // Strategy 1: Production (Release Build)
    // In release mode, assets are bundled in data/flutter_assets/assets/bin/engine.exe relative to the executable
    String exePath = Platform.resolvedExecutable;
    String appDir = p.dirname(exePath);
    backendPath = p.join(appDir, 'data', 'flutter_assets', 'assets', 'bin', 'engine.exe');
    
    // Check if it exists there
    if (!File(backendPath).existsSync()) {
       // Strategy 2: Development (Running from source)
       // When running 'flutter run', generic assets are often not in a predictable absolute path 
       // relative to the Dart script execution context easily without some platform tricks.
       // However, often in debug mode on Windows, we are running from project root context.
       backendPath = p.absolute('assets', 'bin', 'engine.exe');
    }

    if (File(backendPath).existsSync()) {
      print("Found backend executable at: $backendPath");
      // Launch detached process so it doesn't block the UI thread
      await Process.start(
        backendPath, 
        [], 
        runInShell: false, 
        mode: ProcessStartMode.detached
      );
      print("CMS Go Engine successfully launched in background.");
    } else {
      print("WARNING: Backend executable not found at $backendPath. Did you run build.bat?");
    }
  } catch (e) {
    print("CRITICAL ERROR launching backend: $e");
  }
}
