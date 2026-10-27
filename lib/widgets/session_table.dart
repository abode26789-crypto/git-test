import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/session.dart';

class SessionTable extends StatelessWidget {
  const SessionTable({
    super.key,
    required this.session,
    required this.floorSize,
    required this.statusColor,
    required this.suitable,
    required this.selected,
    required this.onTap,
  });

  final Session session;
  final Size floorSize;
  final Color statusColor;
  final bool suitable;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: floorSize.width * session.x,
      top: floorSize.height * session.y,
      width: floorSize.width * session.width,
      height: floorSize.height * session.height,
      child: Opacity(
        opacity: suitable ? 1 : 0.48,
        child: Material(
          color: session.type == 'private' ? AppColors.ivory : AppColors.white,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: selected ? AppColors.green : statusColor,
                  width: selected ? 2.5 : 1.4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    session.type == 'private'
                        ? Icons.door_front_door_outlined
                        : session.type == 'playstation'
                        ? Icons.sports_esports_outlined
                        : Icons.weekend_outlined,
                    size: 17,
                    color: statusColor,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    session.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${session.capacity} أشخاص',
                    style: const TextStyle(color: AppColors.brown, fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
