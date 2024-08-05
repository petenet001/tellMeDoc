import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorListTile extends StatelessWidget {
  final String name;
  final String specialty;
  final String hospital;
  final String time;

  const DoctorListTile(
      {super.key,
      required this.name,
      required this.specialty,
      required this.hospital,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black.withOpacity(.05),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Container(
          height: 100,
          width: 100,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: const DecorationImage(
                image: AssetImage('assets/doctor_background.png'),fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 17,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
              Text(hospital, style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 14 )),
              Text(specialty),
              Text(time),
            ],
          ),
        )
      ]),
    );
  }
}
