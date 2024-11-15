import 'dart:io';

import 'package:camera/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image and Video Picker'),
        backgroundColor: Colors.teal,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Section for Image selection
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Pick an Image',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.6)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: Get.height / 2.5,
                        width: Get.width * 0.8,
                        child: Obx(() {
                          return controller.isImageLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : controller.selectedImagePath.value.isEmpty
                                  ? const Center(
                                      child: Text('No image selected',
                                          style:
                                              TextStyle(color: Colors.white)))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        File(
                                            controller.selectedImagePath.value),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                        }),
                      ),
                      const SizedBox(height: 20),
                      // Tombol hapus foto
                      Obx(() {
                        if (controller.selectedImagePath.value.isNotEmpty) {
                          return ElevatedButton.icon(
                            onPressed: controller.deleteImage,
                            icon: Icon(Icons.delete, color: Colors.white),
                            label: Text('Delete Image',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        } else {
                          return const SizedBox(); // Tidak tampilkan tombol hapus jika tidak ada gambar
                        }
                      }),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                controller.pickImage(ImageSource.camera),
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            label: Text('Camera',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                controller.pickImage(ImageSource.gallery),
                            icon:
                                Icon(Icons.photo_library, color: Colors.white),
                            label: Text('Gallery',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                    color: Colors.white,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20),
                // Section for Video selection
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Pick a Video',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.6)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: Get.height / 3,
                        width: Get.width * 0.8,
                        child: Obx(() {
                          return controller.selectedVideoPath.value.isEmpty
                              ? const Center(
                                  child: Text('No video selected',
                                      style: TextStyle(color: Colors.white)),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: AspectRatio(
                                    aspectRatio: controller
                                            .videoPlayerController!
                                            .value
                                            .aspectRatio ??
                                        1,
                                    child: VideoPlayer(
                                        controller.videoPlayerController!),
                                  ),
                                );
                        }),
                      ),
                      const SizedBox(height: 20),
                      // Tombol hapus video
                      Obx(() {
                        if (controller.selectedVideoPath.value.isNotEmpty) {
                          return ElevatedButton.icon(
                            onPressed: controller.deleteVideo,
                            icon: Icon(Icons.delete, color: Colors.white),
                            label: Text('Delete Video',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        } else {
                          return const SizedBox(); // Tidak tampilkan tombol hapus jika tidak ada video
                        }
                      }),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                controller.pickVideo(ImageSource.camera),
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            label: Text('Camera',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                controller.pickVideo(ImageSource.gallery),
                            icon:
                                Icon(Icons.photo_library, color: Colors.white),
                            label: Text('Gallery',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
