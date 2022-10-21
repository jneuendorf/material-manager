import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:frontend/common/components/dav_app_bar.dart';
import 'package:frontend/common/components/dav_footer.dart';


class PageWrapper extends StatelessWidget {
  final Widget child;
  final bool loggedIn;
  final bool showFooter;
  final bool showPadding;

  const PageWrapper({
    super.key, 
    required this.child, 
    this.loggedIn = true,
    this.showFooter = true,
    this.showPadding = true,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? DavAppBar(loggedIn: loggedIn) : null,
    body: Padding(
      padding: showPadding 
        ? const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0) 
        : EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          if (kIsWeb && showFooter) showPadding 
            ? const DavFooter() 
            : const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DavFooter(),
            ),
        ],
      ),
    ),
  );
}