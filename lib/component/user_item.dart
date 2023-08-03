import 'package:archer_score_helper/component/container_item.dart';
import 'package:archer_score_helper/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserItem extends StatelessWidget {
  final String name;
  final String age;

  const UserItem({super.key, required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ContainerItem(
        height: 115,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              heightFactor: 0,
              child: Text(
                'User',
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
              age,
              style:
                  GoogleFonts.poppins(fontSize: 16, color: CustomColor.white),
            )
          ],
        ),
      ),
    );
  }
}
