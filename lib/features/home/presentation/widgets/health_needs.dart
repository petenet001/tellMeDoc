import 'package:flutter/material.dart';
import 'package:tell_me_doctor/config/theme/colors.dart';
import 'package:tell_me_doctor/features/home/data/models/needed_category.dart';


class HealthNeeds extends StatelessWidget {
  const HealthNeeds({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(customIcons.length, (index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
               // debugPrint("cliqué  $index et voici la taille : ${customIcons.length}");

                if(index == customIcons.length -1){
                  debugPrint("cliqué  $index ceci est le dernier element ");
                  showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      backgroundColor: Colors.white,
                      builder: (context) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          height: 410,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Health Needs",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  healthNeeds.length,
                                      (index) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          padding: const EdgeInsets.all(20),
                                          decoration: const BoxDecoration(
                                            color: AppColors.secondaryBgColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                              healthNeeds[index].icon),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(healthNeeds[index].name),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                "Health Needs",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  specialisedCared.length,
                                      (index) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          padding: const EdgeInsets.all(18),
                                          decoration: const BoxDecoration(
                                            color: AppColors.secondaryBgColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                              specialisedCared[index].icon),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(specialisedCared[index].name),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }else{
                  debugPrint("cliqué  $index ceci n'est pas le dernier element ");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthNeeds(),
                    ));
                }
              },
              borderRadius: BorderRadius.circular(190),
              child: Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryBgColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(customIcons[index].icon),
              ),
            ),
            const SizedBox(height: 12),
            Text(customIcons[index].name),
          ],
        );
      }),
    );
  }
}