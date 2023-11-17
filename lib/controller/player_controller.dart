import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioplayer = AudioPlayer();

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkPermisson();
  }

  updatePosition() {
    audioplayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioplayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDuration(seconds) {
    var duration = Duration(seconds: seconds);
    audioplayer.seek(duration);
  }

  playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioplayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioplayer.play();
      isPlaying(true);
      updatePosition();
    } on Exception catch (e) {
      print(e);
    }
  }

  checkPermisson() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
      // return audioQuery.querySongs(
      //     ignoreCase: true,
      //     orderType: OrderType.ASC_OR_SMALLER,
      //     sortType: null,
      //     uriType: UriType.EXTERNAL);
    } else {
      checkPermisson();
    }
  }
}
