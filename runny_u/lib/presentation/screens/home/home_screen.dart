import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../config/theme/app_theme.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import 'widgets/menu_drawer.dart';
import 'widgets/restaurant_card.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../notifications/notifications_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Runny U',
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
      floatingActionButton: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          final unreadCount = notificationProvider.unreadCount;
          
          return FloatingActionButton(
            onPressed: _showNotifications,
            backgroundColor: AppTheme.primaryOrange,
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryYellow,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
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
            ),
          );
        },
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          return LoadingOverlay(
            isLoading: provider.isLoading && provider.restaurants.isEmpty,
            child: RefreshIndicator(
              onRefresh: () => provider.loadRestaurants(),
              color: AppTheme.primaryOrange,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar restaurante...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: AppTheme.lightGray,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Restaurantes disponibles',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ),
                  ),
                  if (provider.error != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppTheme.mediumGray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar restaurantes',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => provider.loadRestaurants(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (provider.restaurants.isEmpty && !provider.isLoading)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: AppTheme.mediumGray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay restaurantes disponibles',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final restaurant = provider.restaurants[index];
                            return RestaurantCard(
                              restaurant: restaurant,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RestaurantDetailScreen(
                                      restaurantId: restaurant.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: provider.restaurants.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}