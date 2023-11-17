import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplay/Constants/colors.dart';
import 'package:musicplay/Constants/textstyle.dart';
import 'package:musicplay/controller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 250,
                    width: 250,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Obx(()=>
                      QueryArtworkWidget(
                        id: data[controller.playIndex.value].id,
                        type: ArtworkType.AUDIO,
                        artworkHeight: double.infinity,
                        artworkWidth: double.infinity,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          size: 48,
                          color: whiteColor,
                        ),
                      ),
                    ))),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15))),
              child: Obx(()=>
                Column(
                  children: [
                    Text(
                      data[controller.playIndex.value].displayNameWOExt,
                      style: ourStyle(color: bgDarkColor, size: 20),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      data[controller.playIndex.value].artist.toString(),
                      style: ourStyle(color: bgDarkColor, size: 15),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.position.value,
                            style: ourStyle(color: bgDarkColor),
                          ),
                          Expanded(
                              child: Slider(
                                  thumbColor: sliderColor,
                                  inactiveColor: bgColor,
                                  activeColor: sliderColor,
                                  min: const Duration(seconds: 0)
                                      .inSeconds
                                      .toDouble(),
                                  max: controller.max.value,
                                  value: controller.value.value,
                                  onChanged: (newValue) {
                                    controller.changeDuration(newValue.toInt());
                                    newValue = newValue;
                                  })),
                          Text(
                            controller.duration.value,
                            style: ourStyle(color: bgDarkColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.playSong(
                                data[controller.playIndex.value].uri,
                                controller.playIndex.value-1);
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 30,
                            color: bgDarkColor,
                          ),
                        ),
                        Obx(
                          () => CircleAvatar(
                            radius: 35,
                            backgroundColor: bgDarkColor,
                            child: Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  onPressed: () {
                                    if (controller.isPlaying.value) {
                                      controller.audioplayer.pause();
                                      controller.isPlaying(false);
                                    } else {
                                      controller.audioplayer.play();
                                      controller.isPlaying(true);
                                    }
                                  },
                                  icon: controller.isPlaying.value
                                      ? const Icon(Icons.pause,
                                          size: 35, color: whiteColor)
                                      : const Icon(Icons.play_arrow_rounded,
                                          size: 35, color: whiteColor)),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.playSong(
                                data[controller.playIndex.value].uri,
                                controller.playIndex.value+1);
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            size: 30,
                            color: bgDarkColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
