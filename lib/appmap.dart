import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'homepage.dart';

class AppMapScreen extends StatefulWidget {
  final String? orderId;
  final String? deliveryAddress;
  final String? deliveryManName;
  final String? deliveryManContact;

  const AppMapScreen({
    super.key,
    this.orderId,
    this.deliveryAddress,
    this.deliveryManName,
    this.deliveryManContact,
  });

  @override
  State<AppMapScreen> createState() => _AppMapScreenState();
}

class _AppMapScreenState extends State<AppMapScreen> {
  final MapController _mapController = MapController();

  // Restaurant location - CHANGE THIS TO YOUR ACTUAL COORDINATES
  static const LatLng _restaurantLocation = LatLng(36.8065, 34.6414);

  // Delivery location - CHANGE THIS TO YOUR DELIVERY ADDRESS COORDINATES
  late LatLng _deliveryLocation;

  // Driver location (simulated movement)
  late LatLng _driverLocation;

  // Order progress
  double _progress = 0.0;
  String _orderStatus = 'On the way';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _deliveryLocation = const LatLng(36.8165, 34.6514);
    _driverLocation = _restaurantLocation;
    _startDriverSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startDriverSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        setState(() {
          _orderStatus = 'Delivered';
          _progress = 1.0;
        });
        return;
      }

      setState(() {
        _progress += 0.03;

        // Update status
        if (_progress < 0.3) {
          _orderStatus = 'Preparing';
        } else if (_progress < 0.5) {
          _orderStatus = 'On the way';
        } else if (_progress < 0.9) {
          _orderStatus = 'Arriving soon';
        } else {
          _orderStatus = 'Almost there';
        }

        // Move driver from restaurant to delivery
        double lat = _restaurantLocation.latitude +
            (_deliveryLocation.latitude - _restaurantLocation.latitude) *
                _progress;
        double lng = _restaurantLocation.longitude +
            (_deliveryLocation.longitude - _restaurantLocation.longitude) *
                _progress;

        _driverLocation = LatLng(lat, lng);

        // Move camera to follow driver
        _mapController.move(_driverLocation, 14.0);
      });
    });
  }

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  String _getEstimatedTime() {
    int minutesLeft = ((1 - _progress) * 25).round();
    if (minutesLeft <= 0) return 'Arrived';
    return '$minutesLeft min';
  }

  List<LatLng> _getRoutePoints() {
    // Create smooth route points
    List<LatLng> points = [];
    for (double i = 0; i <= 1; i += 0.1) {
      double lat = _restaurantLocation.latitude +
          (_deliveryLocation.latitude - _restaurantLocation.latitude) * i;
      double lng = _restaurantLocation.longitude +
          (_deliveryLocation.longitude - _restaurantLocation.longitude) * i;
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  List<LatLng> _getCompletedRoutePoints() {
    // Route from restaurant to current driver position
    List<LatLng> points = [];
    for (double i = 0; i <= _progress; i += 0.05) {
      double lat = _restaurantLocation.latitude +
          (_deliveryLocation.latitude - _restaurantLocation.latitude) * i;
      double lng = _restaurantLocation.longitude +
          (_deliveryLocation.longitude - _restaurantLocation.longitude) * i;
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // OpenStreetMap (Free!)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _restaurantLocation,
                initialZoom: 13.5,
                minZoom: 10,
                maxZoom: 18,
              ),
              children: [
                // Dark theme map tiles
                TileLayer(
                  urlTemplate:
                      'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png',
                  userAgentPackageName: 'com.example.app',
                  maxZoom: 20,
                ),

                // Route line preview (full route - light/transparent)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _getRoutePoints(),
                      strokeWidth: 3,
                      color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                    ),
                  ],
                ),

                // Solid route line (completed route - bright)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _getCompletedRoutePoints(),
                      strokeWidth: 5,
                      color: const Color(0xFFFF9800),
                      borderColor: Colors.white.withValues(alpha: 0.3),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),

                // Markers
                MarkerLayer(
                  markers: [
                    // Restaurant marker (orange)
                    Marker(
                      point: _restaurantLocation,
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF9800)
                                      .withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.restaurant,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Restaurant',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delivery location marker (blue)
                    Marker(
                      point: _deliveryLocation,
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Driver marker (red - animated)
                    Marker(
                      point: _driverLocation,
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.5),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.delivery_dining,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.deliveryManName ?? 'Driver',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Top bar with status
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => _goHome(context),
                            ),
                            const Expanded(
                              child: Text(
                                'Track order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => _goHome(context),
                            ),
                          ],
                        ),
                      ),

                      // Status banner
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF9800)
                                  .withValues(alpha: 0.5),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$_orderStatus • ETA: ${_getEstimatedTime()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom info card
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress bar
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF9800),
                                    Color(0xFFFF6F00)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Order tracking title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order tracking',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.orderId != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFFF9800)
                                          .withValues(alpha: 0.3),
                                      const Color(0xFFFF6F00)
                                          .withValues(alpha: 0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFF9800),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  '#${widget.orderId}',
                                  style: const TextStyle(
                                    color: Color(0xFFFF9800),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Info rows
                        _buildInfoRow(
                          icon: Icons.person,
                          title: 'Delivery man',
                          subtitle: widget.deliveryManName ?? 'Sima',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.phone,
                          title: 'Contact',
                          subtitle: widget.deliveryManContact ?? '+2203552892',
                          trailing: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF9800),
                                    Color(0xFFFF6F00)
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Calling ${widget.deliveryManContact ?? "+2203552892"}...',
                                  ),
                                  backgroundColor: const Color(0xFFFF9800),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.location_on,
                          title: 'Delivery Location',
                          subtitle: widget.deliveryAddress ??
                              '15 Kaya Sokak, Gönyeli',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF9800).withValues(alpha: 0.3),
                  const Color(0xFFFF6F00).withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFFF9800), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
