import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';
import 'package:tell_me_doctor/features/home/data/models/schedule_model.dart';



class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  String selectedOption = "Upcoming";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //const SizedBox(height: 20,),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildOption("Upcoming"),
                    buildOption("Complete"),
                    buildOption("Result"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // dynamic content
              Expanded(
                child: buildContent(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOption(String option) {
    return Container(
      padding: const EdgeInsets.only(top: 13, bottom: 13, right: 25, left: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: selectedOption == option ? AppColors.kPrimaryColor : Colors.transparent,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = option;
          });
        },
        child: Text(
          option,
          style: TextStyle(
            color: selectedOption == option ? Colors.white : Colors.black38,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (selectedOption == "Upcoming") {
      return buildUpcoming();
    } else if (selectedOption == "Complete") {
      return buildComplete();
    } else if (selectedOption == "Result") {
      return buildResult();
    }
    return const SizedBox.shrink();
  }

  // content for upcoming
  Widget buildUpcoming() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scheduleDoctors.length,
      itemBuilder: (context, index) {
        final doctor = scheduleDoctors[index];
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
                            image: NetworkImage(doctor.profile),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            doctor.position,
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
                          doctor.date,
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
                          doctor.time,
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
                            "Cancel",
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
                            "Reschedule",
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
      },
    );
  }

  // content for complete
  Widget buildComplete() {
    return const Center(
      child: Text(
        "No appointments Complete ",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  } // content for result

  Widget buildResult() {
    return const Center(
      child: Text(
        "No appointments Result ",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}