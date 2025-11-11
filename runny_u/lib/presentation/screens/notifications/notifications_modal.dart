import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../config/theme/app_theme.dart';
import '../../providers/notification_provider.dart';
import '../../../data/models/order_notification_model.dart';

class NotificationsModal extends StatelessWidget {
  const NotificationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (context, provider, _) {
                if (provider.notifications.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = provider.notifications[index];
                    return _NotificationCard(
                      notification: notification,
                      onTap: () {
                        provider.markAsRead(notification.id);
                      },
                      onDismiss: () {
                        provider.removeNotification(notification.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Notificaciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount == 0) {
                return const SizedBox(width: 48);
              }
              return TextButton(
                onPressed: () => provider.markAllAsRead(),
                child: const Text(
                  'Marcar todas',
                  style: TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppTheme.mediumGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes notificaciones',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Aquí aparecerán tus pedidos',
            style: TextStyle(color: AppTheme.mediumGray),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final OrderNotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    final timeFormatter = DateFormat('HH:mm');

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: notification.isRead ? Colors.white : AppTheme.lightPink,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: notification.isReady
                        ? Colors.green.withOpacity(0.1)
                        : AppTheme.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification.isReady
                        ? Icons.check_circle
                        : Icons.schedule,
                    color: notification.isReady
                        ? Colors.green
                        : AppTheme.primaryOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Pedido #${notification.billNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatter.format(notification.total),
                        style: const TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: notification.isReady
                                ? Colors.green
                                : AppTheme.mediumGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.isReady
                                ? '¡Listo para recoger!'
                                : notification.timeRemainingText,
                            style: TextStyle(
                              color: notification.isReady
                                  ? Colors.green
                                  : AppTheme.mediumGray,
                              fontSize: 12,
                              fontWeight: notification.isReady
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Pedido: ${timeFormatter.format(notification.orderTime)}',
                            style: const TextStyle(
                              color: AppTheme.mediumGray,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}