import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log("onChange bloc $bloc : $change");
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log("onChange : $bloc closed");
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log("onChange : $bloc created");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
  }
  
  @override
  void onDone(Bloc bloc, Object? event, [Object? error, StackTrace? stackTrace]) {
    super.onDone(bloc, event, error, stackTrace);
  }
}
