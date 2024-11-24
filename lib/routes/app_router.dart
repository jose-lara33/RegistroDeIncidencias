import 'package:go_router/go_router.dart';
import 'package:registroincidencias/screens/incidents_screen.dart';
import '../screens/login_screen.dart';


class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/incidents',
        builder: (context, state) => IncidentFormScreen(),
      ),
    ],
  );
}
