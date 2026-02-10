import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../app/app_constants.dart';

class InspirationPage extends StatelessWidget {
  const InspirationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sZ = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Inspiration', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(sZ.width * 0.05, 140, sZ.width * 0.05, 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What category do you\nwant to be inspired in?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 23,
                      height: 1.3,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'I am here for you.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  ...AppConstants.inspirationCategories.map(
                    (label) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => context.push(
                            AppRoutes.inspiredBoard,
                            extra: label,
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.7),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            side: BorderSide(color: Colors.white, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              Icon(_getCategoryIcon(label), size: 22, color: Colors.black87),
                              const SizedBox(width: 12),
                              Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
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
            SizedBox(
              width: sZ.width * 0.35,
              height: sZ.height * 0.6,
              child: const Image(
                image: AssetImage('assets/images/brush_mascot.png'),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Nature':
        return Icons.spa;
      case 'Modern':
        return Icons.architecture;
      case 'Abstract':
        return Icons.palette;
      case 'Portraits':
        return Icons.face;
      case 'Anything':
        return Icons.auto_awesome;
      default:
        return Icons.category;
    }
  }
}
