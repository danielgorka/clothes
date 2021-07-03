import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:clothes/features/clothes/presentation/widgets/app_shimmer.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_shadow.dart';
import 'package:clothes/features/clothes/presentation/widgets/rounded_container.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    Widget content = ListView(
      key: Keys.editClothListView,
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ImagesView(
              images: cloth?.images,
            ),
            const ImageShadow(side: ShadowSide.top),
            if (cloth == null || cloth!.name.isNotEmpty)
              const ImageShadow(side: ShadowSide.bottom),
            NameView(
              name: cloth?.name,
            ),
          ],
        ),

        DescriptionView(
          description: cloth?.description,
        ),
        // TypeTagsView(),
        // ColorTagsView(),
        // OtherTagsView(),
        // CreationDateView(),
      ],
    );
    if (cloth == null) {
      content = AppShimmer(
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
            color: Colors.white,
            onPressed: () {
              BlocProvider.of<EditClothBloc>(context).add(CloseCloth());
            },
          ),
          if (editable)
            IconButton(
              color: Colors.white,
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

@visibleForTesting
class NameView extends StatelessWidget {
  final String? name;

  const NameView({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headline4!.copyWith(
          color: Colors.white,
        );

    final Widget content;
    if (name == null) {
      content = RoundedContainer(
        width: style.fontSize! * 4,
        height: style.fontSize! / 2,
      );
    } else {
      content = Text(
        name!,
        textAlign: TextAlign.center,
        style: style,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: content,
      ),
    );
  }
}

@visibleForTesting
class DescriptionView extends StatelessWidget {
  final String? description;

  const DescriptionView({
    Key? key,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (description != null && description!.isEmpty) {
      return Container();
    }

    final style = Theme.of(context).textTheme.bodyText2!;
    final Widget content;
    if (description == null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundedContainer(
            width: style.fontSize! * 15,
            height: style.fontSize! / 2,
          ),
          const SizedBox(height: 6.0),
          RoundedContainer(
            width: style.fontSize! * 10,
            height: style.fontSize! / 2,
          ),
        ],
      );
    } else {
      content = Text(
        description!,
        style: style,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.notes),
          const SizedBox(width: 16.0),
          Expanded(
            child: content,
          ),
        ],
      ),
    );
  }
}
