import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';
import 'package:tell_me_doctor/features/schedule/presentation/pages/widgets/complete_schedule.dart';
import 'package:tell_me_doctor/features/schedule/presentation/pages/widgets/upcoming_schedule.dart';
import 'package:tell_me_doctor/features/schedule/data/models/schedule_model.dart';


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
              const SizedBox(height:0),
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
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 13, bottom: 13, right: 27, left: 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: selectedOption == option
              ? AppColors.kPrimaryColor
              : Colors.transparent,
        ),
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
        return  UpcomingSchedule(doctor);
      },
    );
  }

  // content for complete
  Widget buildComplete() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scheduleDoctors.length,
      itemBuilder: (context, index) {
        final doctor = scheduleDoctors[index];
        return  CompleteSchedule(doctor);
      },
    );
   /* return const Center(
      child: Text(
        "No appointments Complete ",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );*/
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
