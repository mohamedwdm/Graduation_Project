import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/env_config.dart';
import 'core/di/injection_container.dart';
import 'core/utils/bloc_observer.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Environment
  EnvConfig.initialize(Environment.dev);
  
  // 2. Initialize Dependency Injection
  await initDependencies();
  
  // 3. Set Bloc Observer
  Bloc.observer = AppBlocObserver();
  
  runApp(const Go2CarApp());
}