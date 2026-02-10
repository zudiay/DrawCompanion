import 'package:flutter/material.dart';
import 'app/app_router.dart';
import 'app/app_theme.dart';

void main() {
  runApp(const MyApp());
}

const _phonePreviewWidth = 420;
const _phoneFrameWidth = 375.0;
const _phoneFrameHeight = 812.0;

const _appBackgroundImage = 'assets/images/backgrounds/app_background.png';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Preload the background image so it won't flash/appear late on transitions
    precacheImage(const AssetImage(_appBackgroundImage), context);
  }

  Widget _withBackground(Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          _appBackgroundImage,
          fit: BoxFit.cover,
        ),

        // Optional overlay to keep the background subtle
        Container(color: Colors.white.withOpacity(0.12)),

        // ✅ Force transparent material for transitions
        Material(
          type: MaterialType.transparency,
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MODY AI',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,

      // ✅ Option B: set app root background color (prevents white during transitions)
      color: Colors.transparent,

      builder: (context, child) {
        final size = MediaQuery.sizeOf(context);

        // Safety: child should never be null, but just in case
        final routedChild = child ?? const SizedBox.shrink();

        // Desktop preview "phone frame"
        if (size.width > _phonePreviewWidth) {
          return Container(
            color: Colors.grey.shade300,
            child: Center(
              child: Container(
                width: _phoneFrameWidth,
                height: _phoneFrameHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: const Size(_phoneFrameWidth, _phoneFrameHeight),
                    padding: EdgeInsets.zero,
                  ),
                  child: _withBackground(routedChild),
                ),
              ),
            ),
          );
        }

        // ✅ Background on normal devices
        return _withBackground(routedChild);
      },
    );
  }
}
