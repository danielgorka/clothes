import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/app/utils/theme.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:clothes/features/clothes/presentation/widgets/app_bar_floating_action_button.dart';
import 'package:clothes/features/clothes/presentation/widgets/app_shimmer.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_shadow.dart';
import 'package:clothes/features/clothes/presentation/widgets/rounded_container.dart';
import 'package:clothes/features/clothes/presentation/widgets/tag_view.dart';
import 'package:clothes/injection.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      key: Keys.editClothAnnotatedRegion,
      value: AppTheme.overlayDark,
      child: Scaffold(
        body: BlocConsumer<EditClothBloc, EditClothState>(
          listener: (context, state) async {
            if (state.action is CloseClothAction) {
              await AutoRouter.of(context).pop();
              BlocProvider.of<EditClothBloc>(context).add(ClearAction());
            }
          },
          listenWhen: (oldState, newState) =>
              oldState.action != newState.action,
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
      ),
    );
  }
}

@visibleForTesting
class MainClothView extends StatefulWidget {
  final Cloth? cloth;
  final bool loading;

  const MainClothView({
    Key? key,
    this.cloth,
    this.loading = false,
  }) : super(key: key);

  @override
  _MainClothViewState createState() => _MainClothViewState();
}

class _MainClothViewState extends State<MainClothView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView(
      key: Keys.editClothListView,
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ImagesView(
              images: widget.cloth?.images,
            ),
            if (widget.cloth == null || widget.cloth!.name.isNotEmpty)
              const ImageShadow(
                key: Keys.editClothBottomShadow,
                side: ShadowSide.bottom,
              ),
            NameView(
              name: widget.cloth?.name,
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        DescriptionView(
          description: widget.cloth?.description,
        ),
        TagsView(
          title: context.l10n.kindOfCloth,
          tagType: ClothTagType.clothKind,
          tags: widget.cloth?.tags,
        ),
        TagsView(
          title: context.l10n.colors,
          tagType: ClothTagType.color,
          tags: widget.cloth?.tags,
        ),
        TagsView(
          title: context.l10n.otherTags,
          tagType: ClothTagType.other,
          tags: widget.cloth?.tags,
        ),
        CreationDateView(
          creationDate: widget.cloth?.creationDate,
        ),
      ],
    );
    if (widget.cloth == null) {
      content = AppShimmer(
        child: content,
      );
    }
    return Stack(
      children: [
        content,
        if (widget.cloth != null)
          AppBarFloatingActionButton(
            scrollController: _scrollController,
            appBarHeight:
                MediaQuery.of(context).size.width / ClothesUtils.aspectRatio,
            onPressed: () {
              BlocProvider.of<EditClothBloc>(context).add(
                ChangeFavourite(favourite: !widget.cloth!.favourite),
              );
            },
            child: Icon(
              widget.cloth!.favourite
                  ? Icons.favorite_outlined
                  : Icons.favorite_border_outlined,
            ),
          ),
        const ImageShadow(
          key: Keys.editClothTopShadow,
          side: ShadowSide.top,
        ),
        AppBarView(editable: widget.cloth != null),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Icon(
              Icons.image,
              size: constraints.biggest.width,
            );
          },
        ),
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

    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: content,
        ),
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

@visibleForTesting
class TagsView extends StatelessWidget {
  final String title;
  final ClothTagType tagType;
  final List<ClothTag>? tags;

  const TagsView({
    Key? key,
    required this.title,
    required this.tagType,
    required this.tags,
  }) : super(key: key);

  Widget _blankChip(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 2.0,
      ),
      child: RoundedContainer(
        width: width,
        height: 26.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tags != null && tags!.isEmpty) {
      return Container();
    }

    final List<Widget> tagWidgets;
    if (tags == null) {
      tagWidgets = [
        _blankChip(60.0),
        _blankChip(80.0),
      ];
    } else {
      tagWidgets = tags!
          .where((tag) => tag.type == tagType)
          .map((tag) => TagView(tag: tag))
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        runSpacing: -8.0,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ...tagWidgets
        ],
      ),
    );
  }
}

@visibleForTesting
class CreationDateView extends StatefulWidget {
  final DateTime? creationDate;

  const CreationDateView({
    Key? key,
    this.creationDate,
  }) : super(key: key);

  @override
  _CreationDateViewState createState() => _CreationDateViewState();
}

class _CreationDateViewState extends State<CreationDateView> {
  late final DateFormat dateFormat;
  late final DateFormat timeFormat;

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat.yMd().add_Hms();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.creationDate == null) {
      return Container();
    }

    final date = dateFormat.format(widget.creationDate!);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          context.l10n.creationDate(date),
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
