import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PermissionHelper {
  static Future<bool> requestNotificationPermissions(BuildContext context) async {
    final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
    
    final androidPlugin = notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      
      if (granted == null || !granted) {
        if (context.mounted) {
          _showPermissionDialog(context);
        }
        return false;
      }
      return true;
    }
    
    final iosPlugin = notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    
    return true; 
  }

  static void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos de notificaciones'),
        content: const Text(
          'Para recibir notificaciones cuando tu pedido esté listo, necesitas habilitar los permisos de notificaciones en la configuración de la aplicación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}