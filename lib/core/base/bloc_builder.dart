import 'package:flutter/material.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

///
/// Handles building a widget when BloC's state changes.
///
class BlocBuilderWidget<S extends BlocState> extends StatefulWidget
    implements IBlocBuilder {
  final bool Function(S previous, S next)? buildWhen;
  final BlocBuilder<S> builder;
  final Bloc<S> bloc;

  @override
  final WidgetBuilder? loadingBuilder;
  @override
  final bool waitForData;

  const BlocBuilderWidget({
    Key? key,
    required this.builder,
    required this.bloc,
    this.waitForData = false,
    this.loadingBuilder,
    this.buildWhen,
  }) : super(key: key);

  @override
  _BlocBuilderWidgetState<S> createState() {
    return _BlocBuilderWidgetState<S>();
  }
}

class _BlocBuilderWidgetState<S extends BlocState>
    extends State<BlocBuilderWidget<S>> with BlocBuilderMixin {
  late Stream<S> _stream;

  @override
  void initState() {
    super.initState();
    _buildStream();
  }

  @override
  void didUpdateWidget(BlocBuilderWidget<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bloc != widget.bloc ||
        oldWidget.buildWhen != widget.buildWhen) {
      _buildStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: widget.bloc.currentState,
      stream: _stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<S> snapshot,
      ) {
        final loading = buildLoadingWidgetIfNeeded(context, snapshot, widget);

        if (loading != null) {
          return loading;
        }

        return widget.builder(context, snapshot.data!);
      },
    );
  }

  void _buildStream() {
    S? previousState;
    S? nextState;

    _stream = widget.buildWhen == null
        ? widget.bloc.onData
        : widget.bloc.onData.distinct((S previous, S next) {
            // FIXME: Need investigation
            // Woraround for not getting the previous state.
            if (previousState == null) {
              previousState = previous;
              nextState = next;
            } else {
              previousState = nextState;
              nextState = next;
            }

            return !widget.buildWhen!(previousState!, nextState!);
          });
  }
}
