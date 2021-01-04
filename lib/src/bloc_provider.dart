import 'package:flutter/material.dart';
import 'bloc.dart';

typedef UpdateShouldNotify<T> = bool Function(T bloc, _BlocProvider oldWidget);

class BlocProvider<T extends Bloc> extends StatefulWidget {
  final T bloc;
  final Widget child;
  final UpdateShouldNotify<T>? updateShouldNotifyOverride;

  BlocProvider({
    Key? key,
    required this.child,
    required this.bloc,
    this.updateShouldNotifyOverride,
  }) : super(key: key);

  static T of<T extends Bloc>(BuildContext context,
          [bool attachContext = true]) =>
      _BlocProvider.of(context, attachContext);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      bloc: widget.bloc,
      child: widget.child,
      updateShouldNotifyOverride: widget.updateShouldNotifyOverride,
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class _BlocProvider<T extends Bloc> extends InheritedWidget {
  final T bloc;
  final Widget child;
  final UpdateShouldNotify<T>? updateShouldNotifyOverride;

  _BlocProvider({
    required this.bloc,
    required this.child,
    this.updateShouldNotifyOverride,
  }) : super(child: child);

  static T of<T extends Bloc>(BuildContext context, bool attachContext) {
    final type = _typeOf<_BlocProvider<T>>();

    _BlocProvider<T>? blocProvider;

    if (attachContext) {
      blocProvider =
          context.dependOnInheritedWidgetOfExactType<_BlocProvider<T>>();
    } else {
      var element =
          context.getElementForInheritedWidgetOfExactType<_BlocProvider<T>>();
      if (element != null) {
        blocProvider = element.widget as _BlocProvider<T>;
      }
    }

    if (blocProvider == null) {
      throw FlutterError('Unable to find BLoC of type $type.\n'
          'Context provided: $context');
    }
    return blocProvider.bloc;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(_BlocProvider oldWidget) =>
      updateShouldNotifyOverride != null
          ? updateShouldNotifyOverride!(bloc, oldWidget)
          : oldWidget.bloc != bloc;
}
