import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/modules/home/bloc/add_post_cubit.dart';
import 'package:miss_independent/modules/home/bloc/add_post_state.dart';
import 'package:miss_independent/modules/home/widgets/upload_image.dart';
import 'package:miss_independent/modules/home/widgets/upload_medias.dart';
import 'package:video_player/video_player.dart';

import '../../../common/enums/status.dart';
import '../../../di/injection.dart';
import '../../../widgets/button.dart';
import '../../../widgets/text_field.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postDescriptionController =
      TextEditingController();
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _linkVideoController = TextEditingController();
  List<XFile> _medias = [];
  bool _showChoosesVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditorial = context.getRouteArguments<bool>() ?? false;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: kPrimaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            isEditorial
                ? S.of(context).createEditorial
                : S.of(context).createPost,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: kPrimaryColor),
          ),
        ),
        body: BlocProvider(
          create: (BuildContext context) => getIt<AddPostCubit>(),
          child: BlocConsumer<AddPostCubit, AddPostState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == RequestStatus.failed &&
                  state.message?.isNotEmpty == true) {
                showErrorMessage(context, state.message!);
              }
              if (state.status == RequestStatus.success) {
                showErrorMessage(
                    context,
                    isEditorial
                        ? S.of(context).createEditorialSuccessfully
                        : S.of(context).createPostSuccessfully);
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    if (isEditorial)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: BasicTextField(
                          controller: _postTitleController,
                          hintText: S.of(context).enterYourTitleHere,
                          multiline: false,
                        ),
                      ),
                    BasicTextField(
                      controller: _postDescriptionController,
                      hintText: S.of(context).enterYourDescriptionHere,
                      multiline: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isEditorial
                        ? UploadImage(
                            onChanged: (XFile? file) {
                              setState(() {
                                _medias = [file!];
                              });
                            },
                          )
                        : UploadMedias(
                            isShowChoosesVideo: _showChoosesVideo,
                            linkVideoController: _linkVideoController,
                            onSelectMediaType: _onSelectMediaType,
                            onChanged: (List<XFile>? files) {
                              setState(() {
                                _medias = files ?? [];
                              });
                              if ((files?.isNotEmpty ?? false) &&
                                  _showChoosesVideo) {
                                _playVideo(files?.first);
                              }
                            },
                          ),
                    if (_medias.isNotEmpty)
                      !_showChoosesVideo
                          ? _buildImagesMedia()
                          : _controller!.value.isInitialized
                              ? _buildVideoMedia()
                              : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    BasicButton(
                      width: double.infinity,
                      disabled: _medias.isEmpty,
                      onPressed: () {
                        _submitCreatePost(
                            context,
                            _postTitleController.text,
                            _postDescriptionController.text,
                            isEditorial
                                ? 1
                                : _showChoosesVideo
                                    ? 3
                                    : 2,
                            1,
                            _medias);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      label: S.of(context).post,
                      isLoading: state.status == RequestStatus.requesting,
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Widget _buildVideoMedia() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12),
      constraints: const BoxConstraints(maxHeight: 200),
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  Widget _buildImagesMedia() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Wrap(
        children: _medias.mapIndexed((int index, e) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20, top: 20),
                child: Image.file(
                  File(e.path),
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              ),
              Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: () {
                      _medias.removeAt(index);
                      setState(() {});
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.remove_circle,
                        color: kErrorRedColor,
                      ),
                    ),
                  ))
            ],
          );
        }).toList(),
      ),
    );
  }

  void _submitCreatePost(BuildContext context, String? title, String? text,
      int postType, int category, List<XFile>? files) {
    context
        .read<AddPostCubit>()
        .createPost(title, text, postType, category, files);
  }

  void _onSelectMediaType(bool isVideo) {
    if (_showChoosesVideo != isVideo) {
      _medias.clear();
      setState(() {
        _showChoosesVideo = isVideo;
      });
    }
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;

      controller = VideoPlayerController.file(File(file.path));
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      const double volume = 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      setState(() {});
    }
  }
}
