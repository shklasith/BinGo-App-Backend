import 'dart:io';

import 'domain/scan_result.dart';

class ScanController {
  Future<ScanResult> submit(File imageFile) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return ScanResult(
      classification: Classification(
        category: 'Recyclable',
        confidence: 0.93,
        prepSteps: const [
          'Rinse the item before recycling.',
          'Remove any food residue.',
          'Place it in the dry recyclables bin.',
        ],
      ),
      pointsEarned: 25,
    );
  }
}
