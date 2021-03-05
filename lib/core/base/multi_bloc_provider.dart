import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

///
/// Merges multiple BlocProvider widgets into one widget tree.
///
class MultiBlocProvider extends StatelessWidget {
  final List<BlocProviderSingleChildWidget> blocProviders;
  final Widget child;

  const MultiBlocProvider({
    Key? key,
    required this.blocProviders,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: blocProviders,
      child: child,
    );
  }
}
