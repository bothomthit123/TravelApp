import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:mobiledev/models/favorite.dart';
import 'package:mobiledev/models/search_history.dart'; // ✅ Import model

class FsqPlace {
  final int placeId;
  final String name;
  final String address;
  final String category;
  final double lat;
  final double lng;

  FsqPlace(this.placeId, this.name, this.address, this.category, this.lat, this.lng);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentPosition;
  bool _loading = false;
  List<Marker> _placeMarkers = [];
  List<FsqPlace> _fetchedPlaces = [];

  static const String _foursquareApiKey = 'fsq3QCKaYXsYv/Ta0q9yvtlrIeb247rV7u6EtcMGX/oIEds=';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> saveToFavorite(Favorite favorite) async {
    const String apiUrl = 'https://travelappapi-2.onrender.com/api/Favorite';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(favorite.toJson()),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu địa điểm yêu thích thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu: ${response.statusCode}')),
        );
        print('Phản hồi: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Future<void> _saveToFavorites(int accountId, int placeId) async {
    final place = _fetchedPlaces.firstWhere((p) => p.placeId == placeId);
    final favorite = Favorite(
      favoriteId: 0,
      accountId: accountId,
      name: place.name,
      address: place.address,
      category: place.category,
      latitude: place.lat,
      longitude: place.lng,
      description: '',
      rating: 5.0,
      savedAt: DateTime.now(),
    );
    await saveToFavorite(favorite);
  }

  Future<void> saveSearchHistory(String query) async {
    final search = SearchHistory(
      accountId: 1, // thay bằng ID người dùng đăng nhập thực tế
      searchQuery: query,
      searchedAt: DateTime.now(),
    );

    final url = Uri.parse('https://travelappapi-2.onrender.com/api/SearchHistory');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(search.toJson()),
      );

      print('📤 JSON gửi đi: ${jsonEncode(search.toJson())}');
      print('📥 Phản hồi: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        print('✅ Lưu lịch sử tìm kiếm thành công!');
      } else {
        print('❌ Lỗi khi lưu lịch sử tìm kiếm: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi lưu lịch sử tìm kiếm: $e');
    }
  }


  void _showPlaceDetails(FsqPlace place) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(place.address)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.category_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(place.category),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _saveToFavorites(1, place.placeId);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text("Lưu yêu thích"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _mapController.move(LatLng(place.lat, place.lng), 17.0);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text("Đi đến"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Đóng"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tìm kiếm địa điểm")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? const LatLng(10.762622, 106.660172),
              initialZoom: 13.0,
              onTap: (_, __) => _mapController.move(_mapController.center, _mapController.zoom),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _placeMarkers),
            ],
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Tìm kiếm địa điểm...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: _searchPlaces,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _searchPlaces(_searchController.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getCurrentLocation,
        icon: const Icon(Icons.my_location),
        label: const Text("Vị trí của tôi"),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("GPS chưa bật");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception("Không có quyền vị trí");
      }
      if (permission == LocationPermission.deniedForever) throw Exception("Bị từ chối vĩnh viễn");

      Position position = await Geolocator.getCurrentPosition();
      LatLng latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentPosition = latLng;
        _mapController.move(latLng, 15.0);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ $e")));
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (_currentPosition == null) return;

    // ✅ Gọi không chờ (để tránh cản trở map)
    saveSearchHistory(query);

    setState(() {
      _loading = true;
      _placeMarkers.clear();
    });

    final uri = Uri.parse(
      'https://api.foursquare.com/v3/places/search?query=$query&ll=${_currentPosition!.latitude},${_currentPosition!.longitude}&limit=10',
    );

    try {
      final response = await http.get(uri, headers: {
        'Authorization': _foursquareApiKey,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        final fetchedPlaces = <FsqPlace>[];

        final markers = results.asMap().entries.map((entry) {
          int index = entry.key;
          final place = entry.value;
          final lat = place['geocodes']['main']['latitude'];
          final lng = place['geocodes']['main']['longitude'];
          final name = place['name'];
          final address = place['location']['formatted_address'] ?? 'Không rõ';
          final category = (place['categories']?.isNotEmpty ?? false)
              ? place['categories'][0]['name']
              : 'Không rõ loại';

          final fsqPlace = FsqPlace(index + 1, name, address, category, lat, lng);
          fetchedPlaces.add(fsqPlace);

          return Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showPlaceDetails(fsqPlace),
              child: const Icon(Icons.location_on, color: Colors.green, size: 36),
            ),
          );
        }).toList();

        setState(() {
          _placeMarkers = List<Marker>.from(markers);
          _fetchedPlaces = fetchedPlaces;
          _loading = false;
        });

        if (results.isNotEmpty) {
          final first = results.first;
          final firstLat = first['geocodes']['main']['latitude'];
          final firstLng = first['geocodes']['main']['longitude'];
          _mapController.move(LatLng(firstLat, firstLng), 15.0);
        }
      } else {
        throw Exception('Lỗi Foursquare: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Lỗi tìm kiếm: $e")));
    }
  }

}
