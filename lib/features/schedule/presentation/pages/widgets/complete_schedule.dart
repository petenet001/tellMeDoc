import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';
import 'package:tell_me_doctor/features/schedule/data/models/schedule_model.dart';


class CompleteSchedule extends ConsumerWidget {
  final ScheduleModel scheduleModel;
  const CompleteSchedule(this.scheduleModel, {super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.maxFinite,
        height: 215,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.secondaryBgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(scheduleModel.profile),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheduleModel.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        scheduleModel.position,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 35,
                width: 290,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Iconsax.calendar_1,
                      color: Colors.black54,
                    ),
                    Text(
                      scheduleModel.date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Iconsax.clock,
                      color: Colors.black54,
                    ),
                    Text(
                      scheduleModel.time,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kPrimaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: Text(
                        "View details",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
