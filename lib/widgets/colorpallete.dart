import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:com.example.wheel_of_life/models/colorpalletemodel.dart';

import '../view/colorpannel/createpalette.dart';

class ColorPalette extends HookWidget {
  final ValueNotifier<Color> selectColor;
  final Color initialColor = Colors.red;
  final double initialOpacity = 0.1;

  List colorList;
  static MyColorPallet initialColorPallet = MyColorPallet("", []);
  // = [];

  ColorPalette({
    Key? key,
    this.colorList = const [
      Colors.black,
      Colors.orange,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.limeAccent,
      Colors.pink,
      Colors.yellow,
      Colors.indigo
    ],
    required this.selectColor,
  }) : super(key: key);
  MyColorPallet colorPallet = useState(initialColorPallet).value;

  String text = "test";
  List colorsX = [Colors.green];

  @override
  Widget build(BuildContext context) {
    final List<Color> colorscoming;
    final selectedColor = useState<Color>(initialColor);
    final selectedOpacity = useState<double>(initialOpacity);
    navFunc() async {
      //      MyColorPallet result =  await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PalletScreen(sketch: ,)),
      // );
      // colorsX = result.mycolors;
      // print(result.pallete_nme);
      // print(result.mycolors);
    }
    useEffect(() {
      final newColorList = colorPallet.mycolors;
      newColorList.add(colorsX[0]);
      text = "hehhe";
      colorPallet.mycolors = newColorList;
      return null;
    }, [colorPallet.pallete_nme]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 25,
                width: MediaQuery.of(context).size.width - 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      selectColor.value.withOpacity(0),
                      selectColor.value.withOpacity(selectedOpacity.value),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: selectColor.value,
                  border: Border.all(color: Colors.blue, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: selectedOpacity.value,
          min: 0,
          max: 1,
          onChanged: (value) {
            selectedOpacity.value = value;
          },
          onChangeEnd: (value) {
            selectColor.value = selectColor.value.withOpacity(value);
          },
          activeColor: selectColor.value,
        ),
        Container(
          height: 50,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      navFunc();
                      //showColorWheel(context, selectColor);
                    },
                    child: Image.asset(
                      'assets/art/colorpicker.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 2,
                    children: [
                      for (Color color in colorPallet.mycolors)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => selectColor.value = color,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Container(
                //   height: 30,
                //   width: 30,
                //   decoration: BoxDecoration(
                //     color: selectColor.value,
                //     border: Border.all(color: Colors.blue, width: 1.5),
                //     borderRadius: const BorderRadius.all(Radius.circular(20)),
                //   ),
                // ),
              ],
            ),
          ]),
        ),
        Text(text),
        const SizedBox(height: 10),
      ],
    );
  }

  showColorWheel(BuildContext context, ValueNotifier<Color> color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: color.value,
                  onColorChanged: (value) {
                    color.value = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
