import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';

class PatientDetail extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/specialist.jpg",
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rimal Hamal",
                    style: TextStyle(
                        color: AppColor.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const Text(
                    "Female",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.cake,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "01/01/2024",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "180 Aplles St. NY 10236",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Height",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    "5 ft",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Weight",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    "72Kg",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("BIM",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    "20.33",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Blood Type",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    "B+",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: Colors.red,
                size: 15,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "573-8378241",
                style: TextStyle(color: AppColor.appThemeColor, fontSize: 13),
              ),
              Spacer(),
              Icon(
                Icons.other_houses_outlined,
                color: AppColor.appThemeColor,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  "Spent ${2.56} used your service ",
                  style: TextStyle(color: AppColor.appThemeColor, fontSize: 13),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
