import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/routes/router.gr.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart'
    hide PickImage;
import 'package:clothes/features/clothes/presentation/widgets/cloth_item.dart';
import 'package:clothes/features/clothes/presentation/widgets/empty_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/multi_floating_action_button.dart';
import 'package:clothes/features/clothes/presentation/widgets/shimmer.dart';
import 'package:clothes/injection.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClothesPage extends StatelessWidget {
  const ClothesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClothesBloc>()..add(LoadClothes()),
      child: const ClothesView(),
    );
  }
}

@visibleForTesting
class ClothesView extends StatelessWidget {
  const ClothesView({Key? key}) : super(key: key);

  Future<void> _pickImage(
    BuildContext context,
    ImagePickerSource source,
  ) async {
    final image = await AutoRouter.of(context).push(
      EditImageRoute(source: source),
    ) as Uint8List?;

    if (image != null) {
      BlocProvider.of<ClothesBloc>(context).add(ImagePicked(image: image));
    } else {
      BlocProvider.of<ClothesBloc>(context).add(CancelAction());
    }
  }

  Future<void> _showCloth(BuildContext context, int clothId) async {
    await AutoRouter.of(context).push(
      EditClothRoute(clothId: clothId),
    );
    BlocProvider.of<ClothesBloc>(context).add(CancelAction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MultiFloatingActionButton(
        tooltip: context.l10n.newCloth,
        actions: [
          MultiFloatingActionButtonAction(
            key: Keys.createClothWithoutImageAction,
            onTap: () => BlocProvider.of<ClothesBloc>(context).add(
              CreateEmptyCloth(),
            ),
            label: Text(context.l10n.withoutPhoto),
            child: const Icon(Icons.block_outlined),
          ),
          MultiFloatingActionButtonAction(
            key: Keys.createClothTakeImageAction,
            onTap: () => BlocProvider.of<ClothesBloc>(context).add(
              const PickImage(source: ImagePickerSource.camera),
            ),
            label: Text(context.l10n.takePhoto),
            child: const Icon(Icons.camera_alt_outlined),
          ),
          MultiFloatingActionButtonAction(
            key: Keys.createClothPickFromGalleryAction,
            onTap: () => BlocProvider.of<ClothesBloc>(context).add(
              const PickImage(source: ImagePickerSource.gallery),
            ),
            label: Text(context.l10n.pickFromGallery),
            child: const Icon(Icons.photo_outlined),
          ),
        ],
        openedChild: const Icon(Icons.close),
        closedChild: const Icon(Icons.add, size: 36.0),
      ),
      body: BlocConsumer<ClothesBloc, ClothesState>(
        listener: (context, state) async {
          final action = state.action;
          if (action is PickImageAction) {
            await _pickImage(context, action.source);
          } else if (action is EditClothAction) {
            await _showCloth(context, action.clothId);
          }
        },
        listenWhen: (oldState, newState) => oldState.action != newState.action,
        builder: (context, state) {
          switch (state.status) {
            case ClothesStatus.loading:
              return const ClothesLoadingView();
            case ClothesStatus.error:
              return const ErrorView();
            case ClothesStatus.loaded:
              if (state.clothes.isEmpty) {
                return const EmptyView();
              } else {
                return ClothesGridView(clothes: state.clothes);
              }
          }
        },
      ),
    );
  }
}

@visibleForTesting
class ClothesGridView extends StatelessWidget {
  final List<Cloth> clothes;

  const ClothesGridView({
    Key? key,
    required this.clothes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: ClothesUtils.gridViewPadding(context),
      gridDelegate: ClothesUtils.gridDelegate,
      itemCount: clothes.length,
      itemBuilder: (context, index) {
        final cloth = clothes[index];
        return ClothItem(
          cloth: cloth,
          onTap: () {
            //TODO: cloth clicked
          },
        );
      },
    );
  }
}

@visibleForTesting
class ClothesLoadingView extends StatelessWidget {
  const ClothesLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: GridView.builder(
        padding: ClothesUtils.gridViewPadding(context),
        gridDelegate: ClothesUtils.gridDelegate,
        itemBuilder: (context, index) {
          return ClothItem(
            cloth: Cloth.empty(),
          );
        },
      ),
    );
  }
}
