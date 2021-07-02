import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class EditClothPage extends StatelessWidget {
  final int clothId;

  const EditClothPage({
    Key? key,
    @PathParam('clothId') required this.clothId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditClothBloc>(
      create: (context) => getIt<EditClothBloc>()
        ..add(SetCloth(
          clothId: clothId,
        )),
      child: const EditClothView(),
    );
  }
}

@visibleForTesting
class EditClothView extends StatelessWidget {
  const EditClothView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EditClothBloc, EditClothState>(
        listener: (context, state) async {
          if (state.action is CloseClothAction) {
            await AutoRouter.of(context).pop();
            BlocProvider.of<EditClothBloc>(context).add(ClearAction());
          }
        },
        listenWhen: (oldState, newState) => oldState.action != newState.action,
        builder: (context, state) {
          if (state.cloth == null && state.hasError) {
            //TODO: create more user friendly view with specific error message
            return const ErrorView();
          }

          return MainClothView(
            cloth: state.cloth,
            loading: state.loading,
          );
        },
      ),
    );
  }
}

@visibleForTesting
class MainClothView extends StatelessWidget {
  final Cloth? cloth;
  final bool loading;

  const MainClothView({
    Key? key,
    this.cloth,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget content = ListView(
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
        ImagesView(
          images: cloth?.images,
        ),
        // NameView(),
        // DescriptionView(),
        // TypeTagsView(),
        // ColorTagsView(),
        // OtherTagsView(),
        // CreationDateView(),
      ],
    );
    if (cloth == null) {
      content = Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[600]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
        child: content,
      );
    }
    return Stack(
      children: [
        content,
        AppBarView(editable: cloth != null),
      ],
    );
  }
}

@visibleForTesting
class AppBarView extends StatelessWidget {
  final bool editable;

  const AppBarView({
    Key? key,
    required this.editable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: MediaQuery.of(context).padding.top + 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(
            onPressed: () {
              BlocProvider.of<EditClothBloc>(context).add(CloseCloth());
            },
          ),
          if (editable)
            IconButton(
              key: Keys.editClothButton,
              onPressed: () {
                //TODO: start editing
              },
              icon: const Icon(Icons.edit_rounded),
            ),
        ],
      ),
    );
  }
}

@visibleForTesting
class ImagesView extends StatelessWidget {
  final List<ClothImage>? images;

  const ImagesView({
    Key? key,
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images == null) {
      return AspectRatio(
        aspectRatio: ClothesUtils.aspectRatio,
        child: LayoutBuilder(builder: (context, constraints) {
          return Icon(
            Icons.image,
            size: constraints.biggest.width,
          );
        }),
      );
    }
    return CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: ClothesUtils.aspectRatio,
        enableInfiniteScroll: false,
        viewportFraction: 1.0,
      ),
      itemCount: images!.length,
      itemBuilder: (context, index, realIndex) {
        return ClothImageView(image: images![index]);
      },
    );
  }
}
