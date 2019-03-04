import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/models/flipflop_api.dart';
import 'package:flutter/widgets.dart';

class FlipFlopProvider extends InheritedWidget {
  final FlipFlopBloc flipFlopBloc;

  FlipFlopProvider({
    Key key,
    FlipFlopBloc flipFlopBloc,
    Widget child
}) : this.flipFlopBloc = flipFlopBloc ??
      FlipFlopBloc(
        FlipFlopApi()
      ),
  super(key: key, child: child);

  static FlipFlopBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(FlipFlopProvider)
            as FlipFlopProvider).flipFlopBloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}