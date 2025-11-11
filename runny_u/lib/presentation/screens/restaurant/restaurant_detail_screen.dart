import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/theme/app_theme.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../home/widgets/menu_drawer.dart';
import 'widgets/menu_item_card.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurantDetails(widget.restaurantId);
    });
  }

  void _addToCart(BuildContext context, menuItem) {
    final cartProvider = context.read<CartProvider>();
    cartProvider.addItem(menuItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menuItem.name} añadido al carrito'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart');
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const MenuDrawer(),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          final restaurant = provider.selectedRestaurant;

          return LoadingOverlay(
            isLoading: provider.isLoading,
            child: restaurant == null
                ? Center(
                    child: provider.error != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: AppTheme.mediumGray,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error al cargar restaurante',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: restaurant.image,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppTheme.lightGray,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primaryOrange,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppTheme.lightGray,
                                height: 200,
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 80,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (user != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.lightPink,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Abierto a 00 - 19:00',
                                        style: const TextStyle(
                                          color: AppTheme.darkRed,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Text(
                                    restaurant.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: AppTheme.mediumGray,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Horario: ${restaurant.schedule}',
                                        style: const TextStyle(
                                          color: AppTheme.mediumGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: AppTheme.mediumGray,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Ubicación: ${restaurant.location}',
                                          style: const TextStyle(
                                            color: AppTheme.mediumGray,
                                          ),
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
                      for (final category in restaurant.menu) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              category.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = category.items[index];
                                return MenuItemCard(
                                  item: item,
                                  onAdd: () => _addToCart(context, item),
                                );
                              },
                              childCount: category.items.length,
                            ),
                          ),
                        ),
                      ],
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 16),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}