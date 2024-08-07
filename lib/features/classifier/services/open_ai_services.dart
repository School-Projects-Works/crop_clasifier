import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:crop_clasifier/features/classifier/services/connstants.dart';

class GPTServices {
  static Future<bool> isImagePlantOrCrop(Uint8List image) async {
    try {
      String base64Image = base64Encode(image);
      final response = await http.post(
        Uri.parse(OPENAI_API_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAI_API_KEY',
        },
        body: json.encode({
          "model": OPENAI_API_MODEL,
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an expert in determining if an image is a plantt, crop or a part of a plant. Please answer with 'true' or 'false'."
            },
            {
              "role": "user",
               "content": [
                {
                  "type": "text",
                  "text":
                      "Does this image a plant, crop or a part of a plant or contains a plant? Please answer with 'true' or 'false'."
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ] }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content']
            .trim()
            .toString()
            .toLowerCase()
            .contains('true');
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

   static Future<Map<String, dynamic>?> getPlantOrCropInfomationn(
      Uint8List imageToBase64) async {
    try {
      String base64Image = base64Encode(imageToBase64);
      final response = await http.post(
        Uri.parse(OPENAI_API_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAI_API_KEY',
        },
        body: json.encode({
          "model": OPENAI_API_MODEL,
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      'What plant,crop or fruit is in this image? Please provide a comprehensive detailed description.Details should span from the plant\'s name, its uses, and its origin, category, species, common disease etc. Fotmat the content as follows: Seperate content into three ,name, category and description. User "//c!s" to deperate each of them. Example Name=Plant name //c!s category =plant category //c!s description =All the remaining details about the plant in markdown format. Format the description as a markdown text. Add images if possible. the description should me more and very detailed with a lot of innformation and well formatted with markdown text.'},
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        
        final data = json.decode(response.body);
        var content = data['choices'][0]['message']['content'];
        var splitContent = content.split('//c!s');
        //join all the content remaining split data after value at 1 if there is more than one after that value
        var imageUrl = await uploadImageToFirestore(imageToBase64);
        var description = splitContent[2];
        Map<String, dynamic> map ={
          'name': splitContent[0].split('=')[1].trim(),
          'category': splitContent[1].split('=')[1].trim(),
          'description': description.split('=')[1].trim(),
          'imageUrl': imageUrl
        };
        return map;
      } else {
        return null;
      }
    } catch (e) {
    
      return null;
    }
  }

 
  static Future<Map<String,dynamic>?> getPlantDisease(
      Uint8List imageToBase64) async {
    try {
      String base64Image = base64Encode(imageToBase64);
      final response = await http.post(
        Uri.parse(OPENAI_API_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAI_API_KEY',
        },
        body: json.encode({
          "model": OPENAI_API_MODEL,
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      'What disease is this plant suffering from? Please provide a detailed description, State Disease name, Symptoms,Causes and possible treatment.Fotmat the content as follows: Seperate content into two ,name, and description. User " //c!s" to deperate each of them. Example Name=Disease Name //c!s description =All the remaining details about the plant disease in markdown format. Format the description as a markdown text. Add images if possible. the description should me more and very detailed with a lot of innformation and well formatted with markdown text. '
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var content = data['choices'][0]['message']['content'];
         var splitContent = content.split('//c!s');
        //join all the content remaining split data after value at 1 if there is more than one after that value
        var imageUrl = await uploadImageToFirestore(imageToBase64);
        var description = splitContent[1];
        Map<String, dynamic> map = {
          'name': splitContent[0].split('=')[1].trim(),       
          'description': description.split('=')[1].trim(),
          'imageUrl': imageUrl
        };
        return map;
      } else {
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> uploadImageToFirestore(Uint8List imageToBase64) async {
    try {
      final FirebaseStorage _storage = FirebaseStorage.instance;
      final ref = _storage
          .ref('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(
          imageToBase64, SettableMetadata(contentType: 'image/jpg'));
      return await ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
