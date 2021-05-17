import 'package:flutter/material.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

class BlocBuilderMixin {
  bool shouldWaitForData<S>(bool canWait, AsyncSnapshot<S> snapshot) {
    final state = snapshot.connectionState;

    return canWait &&
        (state == ConnectionState.waiting || state == ConnectionState.none);
  }

  Widget? buildLoadingWidgetIfNeeded<S>(
    BuildContext context,
    AsyncSnapshot<S> snapshot,
    IBlocBuilder widget,
  ) {
    if (shouldWaitForData(widget.waitForData, snapshot)) {
      if (widget.loadingBuilder != null) {
        return widget.loadingBuilder!(context);
      }

      return Container();
    }
  }
}
