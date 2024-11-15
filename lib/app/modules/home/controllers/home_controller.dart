import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  final ImagePicker _picker = ImagePicker(); //object image picker
  final box = GetStorage(); //get storage variable

  var selectedImagePath = ''.obs; //variable untuk menyimpan path image
  var isImageLoading = false.obs; //variable untuk loading state

  var selectedVideoPath = ''.obs; //variable untuk menyimpan path video
  var isVideoPlaying = false.obs; //variable untuk pause and play state
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }

  // Function untuk memilih gambar
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        box.write('imagePath',
            pickedFile.path); // Menyimpan path gambar ke GetStorage
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  // Fungsi untuk memilih video
  Future<void> pickVideo(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null) {
        selectedVideoPath.value = pickedFile.path;
        box.write('videoPath', pickedFile.path);

        // Initialize VideoPlayerController
        videoPlayerController =
            VideoPlayerController.file(File(pickedFile.path))
              ..initialize().then((_) {
                videoPlayerController!.play();
                isVideoPlaying.value = true; // Update status
                update(); // Notify UI
              });
      } else {
        print('No video selected.');
      }
    } catch (e) {
      print('Error picking video: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  // Fungsi untuk menghapus gambar yang dipilih
  void deleteImage() {
    selectedImagePath.value = ''; // Mengosongkan path gambar
    box.remove(
        'imagePath'); // Menghapus data gambar yang disimpan di GetStorage
  }

  // Fungsi untuk menghapus video yang dipilih
  void deleteVideo() {
    selectedVideoPath.value = ''; // Mengosongkan path video
    videoPlayerController?.dispose(); // Menonaktifkan VideoPlayerController
    videoPlayerController = null; // Menghapus controller
    box.remove('videoPath'); // Menghapus data video yang disimpan di GetStorage
    isVideoPlaying.value = false; // Reset status pemutaran video
  }

  void _loadStoredData() {
    selectedImagePath.value = box.read('imagePath') ?? '';
    selectedVideoPath.value = box.read('videoPath') ?? '';

    if (selectedVideoPath.value.isNotEmpty) {
      videoPlayerController =
          VideoPlayerController.file(File(selectedVideoPath.value))
            ..initialize().then((_) {
              videoPlayerController!.play();
              isVideoPlaying.value = true; // Update status
              update(); // Notify UI
            });
    }
  }

  // Fungsi untuk play video
  void play() {
    videoPlayerController?.play();
    isVideoPlaying.value = true; // Update status
    update(); // Notify UI
  }

  // Fungsi untuk pause video
  void pause() {
    videoPlayerController?.pause();
    isVideoPlaying.value = false; // Update status
    update(); // Notify UI
  }

  // Fungsi untuk toggle play/pause
  void togglePlayPause() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
        isVideoPlaying.value = false; // Update status
      } else {
        videoPlayerController!.play();
        isVideoPlaying.value = true; // Update status
      }
      update(); // Notify UI
    }
  }
}
