class ScanResult {
  ScanResult({required this.classification, required this.pointsEarned});

  final Classification classification;
  final int pointsEarned;
}

class Classification {
  Classification({
    required this.category,
    required this.confidence,
    required this.prepSteps,
  });

  final String category;
  final double confidence;
  final List<String> prepSteps;
}

class ScanResultRouteData {
  const ScanResultRouteData({required this.result, required this.imagePath});

  final ScanResult result;
  final String imagePath;
}
