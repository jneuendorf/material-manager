import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:frontend/common/components/dav_app_bar.dart';
import 'package:frontend/common/components/dav_footer.dart';


class PageWrapper extends StatelessWidget {
  final Widget child;
  final bool loggedIn;

  const PageWrapper({super.key, required this.child, this.loggedIn = true});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: kIsWeb ? DavAppBar(loggedIn: loggedIn) : null,
    body: Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          if (kIsWeb) const DavFooter(),
        ],
      ),
    ),
  );
}