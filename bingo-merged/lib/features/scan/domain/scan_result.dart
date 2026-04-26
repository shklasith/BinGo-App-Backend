class ScanResult {
  ScanResult({required this.classification, required this.pointsEarned});

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      classification: Classification.fromJson(
        json['classification'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      pointsEarned: _toInt(json['pointsEarned']),
    );
  }

  final Classification classification;
  final int pointsEarned;
}

class Classification {
  Classification({
    required this.category,
    required this.confidence,
    required this.prepSteps,
  });

  factory Classification.fromJson(Map<String, dynamic> json) {
    final steps = json['prepSteps'];

    return Classification(
      category: json['category']?.toString() ?? 'Unknown',
      confidence: _toDouble(json['confidence']),
      prepSteps: steps is List
          ? steps.map((step) => step.toString()).toList()
          : const <String>[],
    );
  }

  final String category;
  final double confidence;
  final List<String> prepSteps;
}

class ScanResultRouteData {
  const ScanResultRouteData({required this.result, required this.imagePath});

  final ScanResult result;
  final String imagePath;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
