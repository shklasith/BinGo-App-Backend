class RecyclingCenter {
  const RecyclingCenter({
    required this.name,
    required this.address,
    required this.operatingHours,
  });

  factory RecyclingCenter.fromJson(Map<String, dynamic> json) {
    return RecyclingCenter(
      name: json['name']?.toString() ?? 'Unknown center',
      address: json['address']?.toString() ?? 'Address unavailable',
      operatingHours: json['operatingHours']?.toString() ?? 'Hours unavailable',
    );
  }

  final String name;
  final String address;
  final String operatingHours;
}
