import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:vpn_app/data/models/location_model.dart';
import 'package:vpn_app/theming/colors.dart';
import 'package:vpn_app/utils/app_icons.dart';

import '../states/notifier.dart';
import '../widgets/connection_stats_item.dart';

class ConnectionStats extends StatefulWidget {
  const ConnectionStats({super.key});

  @override
  State<ConnectionStats> createState() => _ConnectionStatsState();
}

class _ConnectionStatsState extends State<ConnectionStats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Connected',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ConnectionStatsItem(
              icon: AppIcons.caretdoubledown,
              title: "158.2",
              subtitle: "Mb/s",
            ),
            Builder(builder: (context) {
              final selectedIP = selectedIPs.reactiveValue(context).first;
              final serverName =
                  LocationModel.locationByIp(selectedIP)?.serverByIp(selectedIP)?.name ?? "";
              return ConnectionStatsItem(
                icon: AppIcons.harddrives,
                title: serverName.toUpperCase(),
                subtitle: "Server",
              );
            }),
            ConnectionStatsItem(
              icon: AppIcons.caretdoubleup,
              title: "158.2",
              subtitle: "Mb/s",
            ),
          ],
        ),
      ],
    );
  }
}
