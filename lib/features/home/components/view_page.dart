import 'package:crop_clasifier/features/plants/data/plant_model.dart';
import 'package:crop_clasifier/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ViewPage extends ConsumerWidget {
  const ViewPage({super.key, required this.plant});
  final PlantModel plant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    var style = CustomTextStyles();
    return Container(
      height: size.height * .8,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //back button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(width: 10),
              Text('Back', style: style.bodyStyle()),
            ],
          ),
          const SizedBox(height: 10),
          //title

          Expanded(
              child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant.name, style: style.titleStyle()),
                const SizedBox(height: 10),
                MarkdownBody(
                  data: plant.description,
                  softLineBreak: true,
                  styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.spaceAround,
                    p: style.bodyStyle(
                      fontSize: 17,
                      height: 1.7,
                    ),
                    h1: style.titleStyle(
                      fontSize: 18,
                    ),
                    h2: style.titleStyle(
                      fontSize: 18,
                    ),
                    h3: style.titleStyle(),
                    h4: style.titleStyle(),
                    h5: style.titleStyle(),
                    h6: style.titleStyle(),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
