// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:crop_clasifier/core/views/custom_dialog.dart';
import 'package:crop_clasifier/features/classifier/views/view_details.dart';
import 'package:crop_clasifier/features/plants/data/plant_model.dart';
import 'package:crop_clasifier/features/plants/services/plant_services.dart';
import 'package:crop_clasifier/generated/assets.dart';
import 'package:crop_clasifier/utils/app_colors.dart';
import 'package:crop_clasifier/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../services/open_ai_services.dart';

class ClassifierPage extends ConsumerStatefulWidget {
  const ClassifierPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassifierPageState();
}

class _ClassifierPageState extends ConsumerState<ClassifierPage> {
  List<Map<String, dynamic>> listOfSlides = [
    {
      'title': 'Crop Classifier',
      'description': 'Withe the help of YOLOv5 model and Tesnorflow',
      'image': Assets.slides1
    },
    {
      'title': 'Disease Detector',
      'description': 'Find plant disease with the help of AI',
      'image': Assets.slides2
    },
    {
      'title': 'K-Means Clustering',
      'description': 'Find the best crop for your land',
      'image': Assets.slides3
    },
    {
      'title': 'Crop Classifier',
      'description': 'Withe the help of YOLOv5 model and Tesnorflow',
      'image': Assets.slides4
    },
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var style = CustomTextStyles();
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('back'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    aspectRatio: 1,
                    viewportFraction: 1,
                    autoPlay: true,
                  ),
                  items: listOfSlides.map((slide) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                slide['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      slide['title'],
                                      textAlign: TextAlign.center,
                                      style: style.bodyStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      slide['description'],
                                      textAlign: TextAlign.center,
                                      style:
                                          style.bodyStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  Assets.imagesLogoLight,
                  width: size.width * 0.3,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                      'We save the farmer from the stress of crop disease',
                      textAlign: TextAlign.center,
                      style: style.bodyStyle(
                          color: Colors.black, fontWeight: FontWeight.w400)),
                ),
                InkWell(
                  onTap: () {
                    _pickImage(source: ImageSource.camera);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Take Picture',
                                  style: style.bodyStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text('Take a picture of the crop',
                                  style: style.captionStyle(
                                      color: secondaryColor)),
                            ],
                          ),
                        ),
                        const Icon(Icons.camera_enhance_outlined,
                            size: 30, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pickImage(source: ImageSource.gallery);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Choose from Gallery',
                                  style: style.bodyStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text('Choose a picture from gallery',
                                  style: style.captionStyle(
                                      color: secondaryColor)),
                            ],
                          ),
                        ),
                        const Icon(Icons.photo_library_outlined,
                            size: 30, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoaded)
            Container(
              width: double.infinity,
              height: size.height,
              color: Colors.black.withOpacity(0.98),
              child: const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()),
              ),
            )
        ],
      ),
    ));
  }

  bool _isLoaded = false;
  void _pickImage({required ImageSource source}) async {
    var style = CustomTextStyles();
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _isLoaded = true;
      });

      var croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      if (croppedFile == null) {
        setState(() {
          _isLoaded = false;
        });
        CustomDialogs.toast(message: 'Image not cropped');
        return;
      }
      var imageToByte = await croppedFile.readAsBytes();
      var results = await GPTServices.isImagePlantOrCrop(imageToByte);
      if (results) {
        //Navigator.pushNamed(context, '/crop');
        var content = await GPTServices.getPlantOrCropInfomationn(imageToByte);
        print('Content ===================================');
        print(content);
        print('===========================================');
        PlantModel plant = PlantModel(
            name: content!['name'],
            description: content['description'],
            imageUrl: content['imageUrl'],
            id: PlantServices.plantId,
            category: content['category'],
            createdAt: DateTime.now().millisecondsSinceEpoch);
        setState(() {
          _isLoaded = false;
        });
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
          expand: false,
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) => ViewDetails(
            plantModel: plant,
          ),
        );
      } else {
        setState(() {
          _isLoaded = false;
        });
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
          expand: false,
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
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
                Image.memory(imageToByte, height: 200),
                const SizedBox(height: 10),
                const Text('This is not a plant or crop image',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              ],
            ),
          ),
        );
      }
    }
  }
}
