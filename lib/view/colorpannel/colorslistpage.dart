import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:com.example.wheel_of_life/utils/mycolors.dart';

import 'createpalette.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key});
  //final userId =

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  int index = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  Color pickedColor = Colors.blue;
  Color currentColor = Colors.blue;
  List colorList = [];
  Map<String, int> colorMap = {
    "color0": Colors.grey.value,
    "color1": Colors.grey.value,
    "color2": Colors.grey.value,
    "color3": Colors.grey.value,
    "color4": Colors.grey.value,
    "color5": Colors.grey.value,
    "color6": Colors.grey.value,
    "color7": Colors.grey.value,
  };
  void changeColor(Color color) {
    setState(() {
      pickedColor = color;
    });
  }

  void onColorChanged(Color color) {
    if (index <= 7) {
      setState(() {
        currentColor = color;
        colorMap.update("color$index", (value) => color.value);
        print(color);
        // colorMap.length < 8;
        index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appbg,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Create your pallet',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: appbg,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
              size: 30,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  Get.to(() => Settings());
                },
                child: const Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                      controller: controller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Pallet Name",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: appbg,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: appbg,
                            width: 1,
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color0"] as int)),
                              ),
                            ),
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color1"] as int)),
                              ),
                            ),
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color2"] as int)),
                              ),
                            ),
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color3"] as int)),
                              ),
                            ),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color4"] as int)),
                              ),
                            ),
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color5"] as int)),
                              ),
                            ),
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color6"] as int)),
                              ),
                            ),
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(colorMap["color7"] as int)),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ColorPicker(
                    pickerColor: pickedColor,
                    onColorChanged: changeColor,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    onColorChanged(pickedColor);
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // List<int> colorList = colorMap.values.toList();
                        // MyColorPallet colorPallet = MyColorPallet(controller.text, colorList);
                        await FirebaseFirestore.instance
                            .collection("Pallets")
                            .doc("$userId Pallet")
                            .collection("User Pallets")
                            .add({
                          "Pallet Name": controller.text.trim(),
                          "Pallet Colors": colorMap
                        });
                        Navigator.of(context).pop();

                        print("all okayyy");
                      }
                    },
                    child: const Text("Save Pallet")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(PalletScreen.routeName);
                    },
                    child: const Text("Pallet Screen"))
              ],
            ),
          ),
        ));
  }
}
