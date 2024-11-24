import 'package:flutter/material.dart';
import 'package:registroincidencias/services/firebase_auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  // Instanciamos el servicio de autenticación para usar la función de inicio de sesión.
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Scaffold proporciona una estructura básica para la pantalla con barra superior y cuerpo.
    return Scaffold(
      // Aquí se define la barra de la aplicación en la parte superior de la pantalla.
      appBar: AppBar(
        title: Text("Iniciar Sesión"), // El título de la appBar será "Iniciar Sesión".
        backgroundColor: Colors.black, // El color de fondo de la appBar es negro.
      ),
      // El cuerpo de la pantalla. Usamos un widget Center para centrar el contenido.
      body: Center(
        child: ElevatedButton(
          // Establecemos un estilo personalizado para el botón, en este caso, con fondo rosa.
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          // La acción que se ejecuta cuando el usuario presiona el botón.
          onPressed: () async {
            // Llamamos al método signInWithGoogle del servicio de autenticación.
            final user = await _authService.signInWithGoogle();
            // Si el inicio de sesión fue exitoso (el usuario no es null),
            // redirigimos a la pantalla de incidencias.
            if (user != null) {
              context.go('/incidents'); // Usamos GoRouter para navegar a la pantalla de incidencias.
            }
          },
          // El texto que se muestra en el botón. En este caso, "Iniciar sesión con Google".
          child: const Text("Iniciar sesión con Google"),
        ),
      ),
    );
  }
}