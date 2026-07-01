import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const ETailorApp());
}

class ETailorApp extends StatelessWidget {
  const ETailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // More providers (HomeProvider, CartProvider...) get
        // added here as we build the screens that need them.
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          // ScreenUtilInit makes .sp / .w / .h / .r sizing work everywhere,
          // calibrated against a 414x896 design (matches the Figma frames).
          return ScreenUtilInit(
            designSize: const Size(414, 896),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'E-Tailor',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                initialRoute: AppRoutes.splash,
                onGenerateRoute: RouteGenerator.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
