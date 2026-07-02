import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/user_provider.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ETailorApp());
}

class ETailorApp extends StatelessWidget {
  const ETailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'E-Tailor',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
