

import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln; 
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  final String username = 'jose.lara34'; // Cambiar por un correo real
  final String password = 'Jose!2004'; // Cambiar por la contraseña

  Future<void> sendIncidentCopy(String recipient, String title, String description) async {
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Registro de Incidencias')
      ..recipients.add(recipient)
      ..subject = 'Copia de tu Incidencia'
      ..text = 'Título: $title\nDescripción: $description';

    try {
      await send(message, smtpServer);
    } catch (e) {
      print('Error al enviar correo: $e');
    }
  }
}
