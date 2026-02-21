import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/scan_result.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({
    required this.result,
    required this.imagePath,
    super.key,
  });

  final ScanResult result;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(File(imagePath), height: 240, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    result.classification.category,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Confidence: ${(result.classification.confidence * 100).toStringAsFixed(1)}%',
                  ),
                  const SizedBox(height: 8),
                  Text('Points earned: ${result.pointsEarned}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Preparation Steps',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...result.classification.prepSteps.map(
                    (step) => Text('• $step'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
