import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/order_notification_model.dart';
import '../../data/services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final List<OrderNotificationModel> _notifications = [];
  Timer? _updateTimer;

  List<OrderNotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  int get pendingOrdersCount => _notifications.where((n) => !n.isReady).length;

  NotificationProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _notificationService.initialize();
    await _notificationService.requestPermissions();
    await _loadNotifications();
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkReadyOrders();
    });
  }

  void _checkReadyOrders() {
    bool hasChanges = false;

    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isReady && 
          DateTime.now().isAfter(_notifications[i].estimatedReadyTime)) {
        _notifications[i] = _notifications[i].copyWith(isReady: true);
        hasChanges = true;
      }
    }

    if (hasChanges) {
      _saveNotifications();
      notifyListeners();
    }
  }

  Future<void> addOrderNotification({
    required String billNumber,
    required double total,
  }) async {
    final delayMinutes = _notificationService.generateRandomWaitTime();
    final now = DateTime.now();
    final readyTime = now.add(Duration(minutes: delayMinutes));

    final notification = OrderNotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      billNumber: billNumber,
      total: total,
      orderTime: now,
      estimatedReadyTime: readyTime,
    );

    _notifications.insert(0, notification);
    await _saveNotifications();
    notifyListeners();

    try {
      await _notificationService.scheduleOrderReadyNotification(
        billNumber: billNumber,
        delayInMinutes: delayMinutes,
      );
    } catch (e) {
      // Silent fail for scheduled notifications
    }

    try {
      await _notificationService.showInstantNotification(
        title: 'Pedido confirmado ',
        body: 'Tu pedido #$billNumber estará listo en $delayMinutes minutos',
      );
    } catch (e) {
      // Silent fail for instant notifications
    }
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _saveNotifications();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    _saveNotifications();
    notifyListeners();
  }

  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _saveNotifications();
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    _saveNotifications();
    _notificationService.cancelAllNotifications();
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _notifications.map((n) => n.toJson()).toList();
    await prefs.setString('order_notifications', json.encode(jsonList));
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('order_notifications');
    
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _notifications.clear();
      _notifications.addAll(
        jsonList.map((json) => OrderNotificationModel.fromJson(json)),
      );
      _checkReadyOrders();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}