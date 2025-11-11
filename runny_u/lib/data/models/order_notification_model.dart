class OrderNotificationModel {
  final String id;
  final String billNumber;
  final double total;
  final DateTime orderTime;
  final DateTime estimatedReadyTime;
  final bool isRead;
  final bool isReady;

  OrderNotificationModel({
    required this.id,
    required this.billNumber,
    required this.total,
    required this.orderTime,
    required this.estimatedReadyTime,
    this.isRead = false,
    this.isReady = false,
  });

  bool get isPending => DateTime.now().isBefore(estimatedReadyTime);

  Duration get timeRemaining {
    if (isReady) return Duration.zero;
    final remaining = estimatedReadyTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get timeRemainingText {
    if (isReady) return 'Pedido listo';
    final duration = timeRemaining;
    if (duration.inMinutes <= 0) return 'Casi listo';
    return '${duration.inMinutes} min restantes';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billNumber': billNumber,
      'total': total,
      'orderTime': orderTime.toIso8601String(),
      'estimatedReadyTime': estimatedReadyTime.toIso8601String(),
      'isRead': isRead,
      'isReady': isReady,
    };
  }

  factory OrderNotificationModel.fromJson(Map<String, dynamic> json) {
    return OrderNotificationModel(
      id: json['id'] as String,
      billNumber: json['billNumber'] as String,
      total: (json['total'] as num).toDouble(),
      orderTime: DateTime.parse(json['orderTime'] as String),
      estimatedReadyTime: DateTime.parse(json['estimatedReadyTime'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isReady: json['isReady'] as bool? ?? false,
    );
  }

  OrderNotificationModel copyWith({
    String? id,
    String? billNumber,
    double? total,
    DateTime? orderTime,
    DateTime? estimatedReadyTime,
    bool? isRead,
    bool? isReady,
  }) {
    return OrderNotificationModel(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      total: total ?? this.total,
      orderTime: orderTime ?? this.orderTime,
      estimatedReadyTime: estimatedReadyTime ?? this.estimatedReadyTime,
      isRead: isRead ?? this.isRead,
      isReady: isReady ?? this.isReady,
    );
  }
}