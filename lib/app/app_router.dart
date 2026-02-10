import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/local/app_database.dart';

import '../screens/landing/landing_screen.dart';
import '../screens/progress/progress_page.dart';
import '../screens/inspiration/inspiration_page.dart';
import '../screens/inspiration/inspiration_board_page.dart';
import '../screens/inspiration/inspiration_detail_page.dart';
import '../screens/upload/upload_details_page.dart';
import '../screens/drawing_details/drawing_details_page.dart';
import '../screens/feedback/feedback_page.dart';

class AppRoutes {
  static const landing = '/';
  static const progress = '/progress';
  static const inspired = '/inspiration';
  static const inspiredBoard = '/inspiration/board';
  static const inspiredDetail = '/inspiration/detail';

  static const uploadDetails = '/upload/details';
  static const drawingDetails = '/drawing/details';
  static const feedback = '/feedback';
}

class AppRouter {
  static Page<void> _page(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    opaque: true,
    barrierColor: Colors.transparent,
    child: Material(
      type: MaterialType.transparency,
      child: child,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Incoming page: slight fade + slide
      final inFade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final inSlide = Tween<Offset>(
        begin: const Offset(0.06, 0.0), // subtle from right
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      // Outgoing page: fade out
      final outFade = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOut,
      );

      return FadeTransition(
        // secondaryAnimation goes 0->1 for the route BELOW; we invert to fade it OUT
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(outFade),
        child: SlideTransition(
          position: animation.drive(inSlide),
          child: FadeTransition(
            opacity: inFade,
            child: child,
          ),
        ),
      );
    },
  );
}




  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.landing,
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        pageBuilder: (context, state) =>
            _page(state, const LandingScreen(userName: 'Sarah')),
      ),
      GoRoute(
        path: AppRoutes.progress,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final banner = extra?['banner'] as String?;
          return _page(state, ProgressPage(initialBanner: banner));
        },
      ),
      GoRoute(
        path: AppRoutes.inspired,
        pageBuilder: (context, state) => _page(state, const InspirationPage()),
        routes: [
          GoRoute(
            path: 'board',
            pageBuilder: (context, state) {
              final category = state.extra as String? ?? 'Anything';
              return _page(state, InspirationBoardPage(category: category));
            },
          ),
          GoRoute(
            path: 'detail',
            pageBuilder: (context, state) {
              final m = state.extra as Map<String, dynamic>? ?? {};
              final category = m['category'] as String? ?? 'Anything';
              final index = m['index'] as int? ?? 0;
              return _page(
                state,
                InspirationDetailPage(category: category, index: index),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.uploadDetails,
        pageBuilder: (context, state) {
          final imagePath = state.extra as String;
          return _page(state, UploadDetailsPage(imagePath: imagePath));
        },
      ),
      GoRoute(
        path: AppRoutes.drawingDetails,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return _page(
            state,
            DrawingDetailsPage(
              imagePath: args['imagePath'] as String,
              name: args['name'] as String,
              date: args['date'] as DateTime,
              description: args['description'] as String?,
              category: args['category'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.feedback,
        pageBuilder: (context, state) {
          final drawings = state.extra as List<Drawing>;
          return _page(state, FeedbackPage(drawings: drawings));
        },
      ),
    ],
  );
}
