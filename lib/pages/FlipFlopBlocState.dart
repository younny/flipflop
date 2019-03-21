import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flutter/material.dart';

class FlipFlopBlocState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  FlipFlopBloc bloc(BuildContext context) {
    return Provider.of<FlipFlopBloc>(context);
  }
}
