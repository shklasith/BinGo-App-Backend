import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../domain/entities/recycling_center.dart';
import '../../shared/app_scaffold.dart';
import '../../shared/app_theme.dart';

class CentersScreen extends StatefulWidget {
  const CentersScreen({super.key});

  @override
  State<CentersScreen> createState() => _CentersScreenState();
}

class _CentersScreenState extends State<CentersScreen> {
  List<RecyclingCenter> _centers = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _loadNearby() async {
    final permission = await Permission.locationWhenInUse.request();

    if (!permission.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final position = await Geolocator.getCurrentPosition();

      final centers = await _fetchNearbyCenters(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _centers = centers;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<List<RecyclingCenter>> _fetchNearbyCenters(
    double lat,
    double lng,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      RecyclingCenter(
        name: 'Green Drop Center',
        address: '123 Eco Street',
        operatingHours: 'Mon–Sat: 8am – 5pm',
      ),
      RecyclingCenter(
        name: 'City Recycling Hub',
        address: '45 Clean Ave',
        operatingHours: 'Daily: 7am – 7pm',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return AppScaffold(
      currentIndex: 3,
      body: Stack(
        children: [
          // 🌈 Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 500,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE0F2FE), Color(0xFFECFEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),

          // 🔍 Search + Location
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            left: 14,
            right: 14,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search centers...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _isLoading ? null : _loadNearby,
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_outlined),
                  ),
                ),
              ],
            ),
          ),

          // 📍 Markers
          const Positioned(top: 200, left: 100, child: _PinMarker(primary: true)),
          const Positioned(top: 300, right: 80, child: _PinMarker(primary: false)),

          // 📦 Bottom Card (FIXED)
          Positioned(
            left: 14,
            right: 14,
            bottom: safeBottom + 110, // 🔥 IMPORTANT FIX
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 247, 239, 239).withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: _buildBottomCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Text('Error: $_error');
    }

    if (_centers.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Find centers near you',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            'Tap location button to load nearby recycling points',
            style: TextStyle(color: AppTheme.muted),
          ),
        ],
      );
    }

    final center = _centers.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_centers.length} Centers Near You',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text('${center.name} • ${center.address}'),
        const SizedBox(height: 4),
        Text(
          center.operatingHours,
          style: const TextStyle(color: Colors.green),
        ),
      ],
    );
  }
}

// 📍 Marker
class _PinMarker extends StatelessWidget {
  const _PinMarker({required this.primary});
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_on,
      size: 40,
      color: primary ? Colors.blue : Colors.green,
    );
  }
}

// 🔲 Grid Background
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x330EA5E9)
      ..strokeWidth = 1;

    const gap = 36.0;

    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}