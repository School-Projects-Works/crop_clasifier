import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_clasifier/core/views/custom_dialog.dart';
import 'package:crop_clasifier/features/auth/provider/user_provider.dart';
import 'package:crop_clasifier/features/plants/data/plant_model.dart';
import 'package:crop_clasifier/features/plants/services/plant_services.dart';
import 'package:crop_clasifier/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../utils/text_styles.dart';

class ViewDetails extends ConsumerStatefulWidget {
  const ViewDetails({super.key, required this.plantModel});
  final PlantModel plantModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends ConsumerState<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var style = CustomTextStyles();
    return Container(
      height: size.height * .95,
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
              const Spacer(),
              TextButton(
                  onPressed: () async {
                    var user = ref.watch(userProvider);
                    if (user.id.isEmpty) {
                      CustomDialogs.toast(message: 'Login to save data');
                      return;
                    }
                    CustomDialogs.loading(message: 'Saving Plant...');
                    var plantExist =
                        await PlantServices.getPlantById(widget.plantModel.id);

                    if (plantExist == null) {
                      var res = await PlantServices.addPlant(widget.plantModel);
                      CustomDialogs.dismiss();
                      if (res) {
                        CustomDialogs.showDialog(
                            message: 'Plant saved successfully');
                      } else {
                        CustomDialogs.showDialog(
                            message: 'Error saving plant',
                            type: DialogType.error);
                      }
                    } else {
                      CustomDialogs.dismiss();
                      CustomDialogs.showDialog(message: 'Plant already saved');
                    }
                  },
                  child: Text('Save Plant',
                      style: style.bodyStyle(color: primaryColor)))
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
                CachedNetworkImage(
                  imageUrl: widget.plantModel.imageUrl,
                  width: double.infinity,
                  height: 200,
                  placeholder: (context, url) => const Column(
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()),
                    ],
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10),
                Text(widget.plantModel.name,
                    style: style.titleStyle(color: primaryColor)),
                const SizedBox(height: 10),
                MarkdownBody(
                  data: widget.plantModel.description,
                  softLineBreak: true,
                  imageBuilder: (uri, title, alt) {
                    return CachedNetworkImage(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        imageUrl: uri.toString());
                  },
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
