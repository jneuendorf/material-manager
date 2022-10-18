import 'package:flutter/material.dart';


class NestedNavigator extends StatelessWidget {
    final GlobalObjectKey<NavigatorState>? navigationKey;
    final String initialRoute;
    final Map<String, WidgetBuilder> routes;
    final String tag;

    const NestedNavigator({
      super.key, 
      required this.initialRoute,
      required this.routes,
      required this.tag,
      this.navigationKey,
    });

    @override
    Widget build(BuildContext context) {
      return Navigator(
        key: navigationKey,
        //initialRoute: initialRoute,
        onPopPage: (Route route, dynamic result) {
          print('Route: $route');
          print('Result: $result');
          return true;
        },
        onGenerateRoute: (RouteSettings routeSettings) {
          
          print('modal: ${ModalRoute.of(context)!.settings.name.toString()} at $tag');
          final uri = Uri.parse(ModalRoute.of(context)!.settings.name.toString());
          String route = '/${uri.pathSegments.sublist(1).join('/')}';
          print('New route: $route');
          return MaterialPageRoute(
            settings: RouteSettings(name: route),//routeSettings,
            builder: (context) {
              return routes[route]!(context);
            },
          );
          // WidgetBuilder? builder = routes[ModalRoute.of(context)?.settings.name?? routeSettings.name];
          // if (routeSettings.name.toString() == '/') {
          //   return PageRouteBuilder(
          //     pageBuilder: (context, __, ___) => builder!(context),
          //     settings: routeSettings,
          //   );
          // } else {
          //   return MaterialPageRoute(
          //     builder: builder!,
          //     settings: routeSettings,
          //   );
          // }
        },
      );
    }
  }