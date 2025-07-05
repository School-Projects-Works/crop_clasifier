import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_clasifier/core/views/custom_input.dart';
import 'package:crop_clasifier/features/auth/provider/user_provider.dart';
import 'package:crop_clasifier/features/auth/views/login_page.dart';
import 'package:crop_clasifier/features/classifier/views/classifier_page.dart';
import 'package:crop_clasifier/features/classifier/views/disease_detection.dart';
import 'package:crop_clasifier/generated/assets.dart';
import 'package:crop_clasifier/utils/app_colors.dart';
import 'package:crop_clasifier/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../plants/provider/plant_provider.dart';
import '../components/view_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    var style = CustomTextStyles();
    var dummyData = ref.watch(dummyDataProvider);
    var plantsStream = ref.watch(plantSreamProvider);
    var size = MediaQuery.of(context).size;
    dummyData.when(data: (value) {
      print('Data loaded');
    }, loading: () {
      print('Loading data');
    }, error: (error, stackTrace) {
      print('Error loading data');
    });
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        //padding: const EdgeInsets.all(8),
        height: size.height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Assets.imagesLogoDark,
                        width: 70,
                        height: 70,
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 10,
                      ),
                      if (ref.watch(userProvider).email.isEmpty)
                        TextButton(
                            onPressed: () {
                              //open new page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: style.bodyStyle(color: Colors.white),
                            ))
                      else
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: secondaryColor,
                          child: Icon(Icons.person),
                        )
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          //open new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ClassifierPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primaryColor.withOpacity(0.6)),
                          child: Column(
                            children: [
                              const Icon(Icons.image_search,
                                  size: 30, color: Colors.white),
                              Text(
                                'Farmers Pal',
                                style: style.bodyStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // disease detector
                      InkWell(
                        onTap: () {
                          //open new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DiseaseDetection()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primaryColor.withOpacity(0.6)),
                          child: Column(
                            children: [
                              const Icon(Icons.bug_report,
                                  size: 30, color: Colors.white),
                              Text(
                                'Disease Detector',
                                style: style.bodyStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  plantsStream.when(
                      data: (data) {
                        var plants = ref.read(plantsProvider).filter;
                        //shuffle the list
                        plants.shuffle();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: size.height * 0.6,
                            child: Column(
                              children: [
                                CustomTextFields(
                                  hintText: 'Search for a crop',
                                  suffixIcon: const IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: null,
                                  ),
                                  onChanged: (value) {
                                    ref
                                        .read(plantsProvider.notifier)
                                        .filterPlants(value);
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            childAspectRatio: 0.8,
                                            mainAxisSpacing: 10),
                                    itemCount: plants.length,
                                    itemBuilder: (context, index) {
                                      var plant = plants[index];
                                      return InkWell(
                                        onTap: () {
                                          //open a bottom sheet
                                          showMaterialModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            expand: false,
                                            isDismissible: false,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) =>
                                                ViewPage(plant: plant),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // to align the text to the left
                                          children: [
                                            Container(
                                              //width: size.width * .45,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        blurRadius: 10,
                                                        spreadRadius: 1)
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl: plant.imageUrl,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: size.height * 0.2,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child:
                                                                CircularProgressIndicator()),
                                                      ],
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              plant.name,
                                              style: style.bodyStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor),
                                            ),
                                            Text(
                                              plant.category,
                                              style: style.bodyStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color: secondaryColor),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      error: (error, stackTrace) {
                        return const Center(
                          child: Text('Error loading data'),
                        );
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
