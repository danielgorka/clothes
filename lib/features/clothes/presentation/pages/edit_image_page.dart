import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:clothes/injection.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        builder: (context, state) {
          if (state.status == EditImageStatus.editing ||
              state.status == EditImageStatus.completed) {
            return EditingView(image: state.image!);
          } else {
            return const PickingView();
          }
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
class PreviewImage extends StatelessWidget {
  final Uint8List image;

  const PreviewImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).dividerColor,
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Image.memory(image),
        ),
      ),
    );
  }
}
