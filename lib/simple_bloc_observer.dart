import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver implements BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    log("onChange bloc $bloc : $change");
  }

  @override
  void onClose(BlocBase bloc) {
    // TODO: implement onClose
        log("onChange : $bloc closed");

  }

  @override
  void onCreate(BlocBase bloc) {
    // TODO: implement onCreate
        log("onChange : $bloc created");

  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // TODO: implement onError
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    // TODO: implement onEvent
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
        log("onTransition $bloc bloc : $transition");

  }
  
  @override
  void onDone(Bloc bloc, Object? event, [Object? error, StackTrace? stackTrace]) {
    // TODO: implement onDone
  }
}
