import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:clothes/injection.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class EditImagePage extends StatelessWidget {
  final ImagePickerSource source;

  const EditImagePage({
    Key? key,
    required this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditImageBloc>(
      create: (_) => getIt<EditImageBloc>()
        ..add(PickImage(
          imagePickerSource: source,
        )),
      child: EditImageView(source: source),
    );
  }
}

@visibleForTesting
class EditImageView extends StatelessWidget {
  final ImagePickerSource source;

  const EditImageView({
    Key? key,
    required this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EditImageBloc, EditImageState>(
        listener: (context, state) {
          if (state.status == EditImageStatus.completed) {
            AutoRouter.of(context).pop(state.image);
          } else if (state.status == EditImageStatus.canceled) {
            AutoRouter.of(context).pop();
          }
        },
        listenWhen: (oldState, newState) => oldState.status != newState.status,
        builder: (context, state) {
          return Stack(
            children: [
              if (state.image != null) EditingView(image: state.image!),
              if (state.image == null) const PickingView(),
              IgnorePointer(
                ignoring: !state.isComputing,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: state.isComputing ? 1.0 : 0.0,
                  child: const LoadingView(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

@visibleForTesting
class EditingView extends StatelessWidget {
  final Uint8List image;

  const EditingView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SaveBar(),
          Expanded(
            child: PreviewImage(image: image),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class PickingView extends StatelessWidget {
  const PickingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: (_) {
        BlocProvider.of<EditImageBloc>(context).add(CancelEditingImage());
        //AutoRouter.of(context).pop();
      },
      child: Center(
        child: Text(context.l10n.selectingImage),
      ),
    );
  }
}

@visibleForTesting
class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Theme.of(context).canvasColor,
      child: Center(
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: isDark ? Colors.white : Colors.grey[800]!,
              highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
              child: Text(
                context.l10n.saving,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class SaveBar extends StatelessWidget {
  const SaveBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            key: Keys.editImageCancelButton,
            onPressed: () {
              BlocProvider.of<EditImageBloc>(context).add(CancelEditingImage());
            },
            child: Text(
              context.l10n.cancel,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          TextButton(
            key: Keys.editImageSaveButton,
            onPressed: () {
              BlocProvider.of<EditImageBloc>(context)
                  .add(CompleteEditingImage());
            },
            child: Text(
              context.l10n.save,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class PreviewImage extends StatefulWidget {
  final Uint8List image;
  final CropController? controller;

  const PreviewImage({
    Key? key,
    required this.image,
    this.controller,
  }) : super(key: key);

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  late CropController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CropController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditImageBloc, EditImageState>(
      listener: (context, state) {
        if (state.status == EditImageStatus.cropping) {
          _controller.crop();
        }
      },
      listenWhen: (oldState, newState) => oldState.status != newState.status,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Crop(
            controller: _controller,
            maskColor: Colors.black.withOpacity(0.5),
            baseColor: Colors.transparent,
            image: widget.image,
            aspectRatio: ClothesUtils.aspectRatio,
            cornerDotBuilder: (size, cornerIndex) {
              return DotControl(color: Colors.grey[400]!);
            },
            onCropped: (image) {
              BlocProvider.of<EditImageBloc>(context)
                  .add(CompleteCroppingImage(croppedImage: image));
            },
          ),
        ),
      ),
    );
  }
}
