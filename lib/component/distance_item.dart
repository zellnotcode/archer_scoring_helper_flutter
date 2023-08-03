import 'package:archer_score_helper/component/container_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/color.dart';

class DistanceItem extends StatelessWidget {
  final String name;
  final String distance;
  final String target;
  const DistanceItem(
      {super.key,
      required this.name,
      required this.distance,
      required this.target});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ContainerItem(
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              heightFactor: 0,
              child: Text(
                'Distance',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CustomColor.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style:
                  GoogleFonts.poppins(fontSize: 16, color: CustomColor.white),
            ),
            Text(
              distance,
              style:
                  GoogleFonts.poppins(fontSize: 16, color: CustomColor.white),
            ),
            Text(
              target,
              style:
                  GoogleFonts.poppins(fontSize: 16, color: CustomColor.white),
            )
          ],
        ),
      ),
    );
  }
}
