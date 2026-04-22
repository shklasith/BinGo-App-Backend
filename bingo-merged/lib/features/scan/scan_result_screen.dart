import 'dart:io';

import 'package:flutter/material.dart';

import 'domain/scan_result.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({
    super.key,
    required this.result,
    required this.imagePath,
  });

  final ScanResult result;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final isRecyclable = result.classification.category == 'Recyclable';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Scan Result'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (imagePath.isNotEmpty)
              Image.file(
                File(imagePath),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            Text(
              result.classification.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${(result.classification.confidence * 100).toStringAsFixed(0)}% confidence',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isRecyclable ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isRecyclable ? 'Recyclable' : 'Not Recyclable',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preparation Steps:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...result.classification.prepSteps.map(
                    (step) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '- $step',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Points Earned: ${result.pointsEarned}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
