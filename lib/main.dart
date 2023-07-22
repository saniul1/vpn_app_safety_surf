import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:flutter/material.dart';
import 'package:vpn_app/theming/text_styles.dart';
import 'package:vpn_app/utils/sizes.dart';
import 'package:window_manager/window_manager.dart' show WindowOptions, windowManager;

import 'areas/bottom_navbar.dart';
import 'areas/connection_stats.dart';
import 'areas/flag_area.dart';
import 'areas/location_area.dart';
import 'areas/location_condition_info.dart';
import 'states/notifier.dart';
import 'theming/colors.dart';
import 'utils/assets.dart';
import 'utils/platform_details.dart';
import 'widgets/circle_button.dart';
import 'widgets/circles.dart';
import 'widgets/overflow_circle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformDetails.instance.isDesktop && !PlatformDetails.instance.isWeb) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(375, 812),
      alwaysOnTop: true,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      windowManager.setResizable(false);
    });
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.gradientBg,
          ),
          child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraint) {
              const bottomPadding = 160.0; // between 150 - 160
              final size = constraint.maxHeight;
              final littleCircleSizes = [
                size * 0.37,
                size * 0.31,
                size * 0.25,
                size * 0.19,
              ];
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: bottomPadding),
                    child: Stack(
                      children: [
                        Circles(
                          size: size,
                          sizes: littleCircleSizes,
                        ),
                        if (connectionState.reactiveValue(context) == ConnectionState.none)
                          Padding(
                            padding: EdgeInsets.only(bottom: size),
                            child: OverflowCircle(
                              size: size * 0.89,
                              paddonfOffset: bottomPadding * 0.5,
                              littleCirlceSizes: littleCircleSizes,
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: size - (bottomPadding * 0.78)),
                          child: OverflowCircle(
                            size: size * 0.89,
                            littleCirlceSizes:
                                connectionState.reactiveValue(context) != ConnectionState.none
                                    ? littleCircleSizes.sublist(3)
                                    : littleCircleSizes.sublist(2),
                          ),
                        ),
                        const Center(
                          child: CircleButton(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: constraint.maxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size * 0.075),
                          child: connectionState.reactiveValue(context) == ConnectionState.active
                              ? const ConnectionStats()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      connectionState.reactiveValue(context) == ConnectionState.none
                                          ? kSurfIconGradient
                                          : kSurfIconPlain,
                                      width: kSizesSurfLogo,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Builder(builder: (context) {
                                          return Text(
                                            'SAFETY SURF',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.antonioLight26Caps.copyWith(
                                              color: connectionState.reactiveValue(context) ==
                                                      ConnectionState.none
                                                  ? AppColors.tealBlue
                                                  : AppColors.white,
                                              fontSize: 24,
                                              fontFamily: 'Antonio',
                                            ),
                                          );
                                        }),
                                      ],
                                    )
                                  ],
                                ),
                        ),
                        const Column(
                          children: [
                            LocationConditionInfo(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: FlagArea(),
                            ),
                            LocatonArea(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 30.0),
                              child: BottomNavbar(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
