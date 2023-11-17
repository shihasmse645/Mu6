import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplay/Constants/colors.dart';
import 'package:musicplay/Constants/textstyle.dart';
import 'package:musicplay/controller/player_controller.dart';
import 'package:musicplay/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: whiteColor,
                ))
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text("Mu6", style: ourStyle()),
        ),
        body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL),
            builder: ((context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No Songs Found"),
                );
              } else {
                //print(snapshot.data);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Obx(
                          () => ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.black),
                            ),
                            tileColor: bgColor,
                            title: Text(
                              "${snapshot.data![index].album}",
                              style: ourStyle(size: 15),
                            ),
                            subtitle: Text(
                              "${snapshot.data![index].artist}",
                              style: ourStyle(size: 12),
                            ),
                            leading: QueryArtworkWidget(
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                color: whiteColor,
                                size: 32,
                              ),
                            ),
                            trailing: controller.playIndex.value == index &&
                                    controller.isPlaying.value
                                ? const Icon(Icons.play_arrow,
                                    color: whiteColor, size: 26)
                                : null,
                            onTap: () {
                              Get.to(() => Player(data: snapshot.data!,),transition: Transition.downToUp);
                              controller.playSong(snapshot.data![index].uri,index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            })));
  }
}
