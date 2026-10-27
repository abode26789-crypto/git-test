import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({super.key, required this.step});

  final int step;

  static const _labels = ['اختياراتك', 'الجلسة', 'التأكيد'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length, (index) {
        final active = index == step;
        final complete = index < step;
        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: Container(
                    height: 1,
                    color: complete ? AppColors.green : AppColors.border,
                  ),
                ),
              Column(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: active || complete
                          ? AppColors.green
                          : AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active || complete
                            ? AppColors.green
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: complete
                          ? const Icon(
                              Icons.check,
                              size: 15,
                              color: AppColors.ivory,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: active
                                    ? AppColors.ivory
                                    : AppColors.brown,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      color: active ? AppColors.green : AppColors.brown,
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
