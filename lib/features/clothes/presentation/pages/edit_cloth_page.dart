import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/app/utils/keys.dart';
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

  String _getErrorMessage(BuildContext context, EditClothError error) {
    switch (error) {
      case EditClothError.clothNotFound:
        return context.l10n.clothNotFound;
      case EditClothError.savingError:
        return context.l10n.errorSavingChanges;
      default:
        return context.l10n.somethingWentWrong;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EditClothBloc, EditClothState>(
        listener: (context, state) async {
          if (state.action is CloseClothAction) {
            await AutoRouter.of(context).pop();
            BlocProvider.of<EditClothBloc>(context).add(ClearAction());
          }

          if (state.cloth != null && state.hasError) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getErrorMessage(context, state.error)),
              ),
            );

            BlocProvider.of<EditClothBloc>(context).add(ClearError());
          }
        },
        listenWhen: (oldState, newState) =>
            oldState.action != newState.action ||
            oldState.error != newState.error,
        builder: (context, state) {
          if (state.cloth == null && state.hasError) {
            return ErrorView(
              message: _getErrorMessage(context, state.error),
            );
          }

          return MainClothView(
            cloth: state.cloth,
            editing: state.editing,
          );
        },
      ),
    );
  }
}

@visibleForTesting
class MainClothView extends StatefulWidget {
  final Cloth? cloth;
  final bool editing;

  const MainClothView({
    Key? key,
    this.cloth,
    this.editing = false,
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
    final Widget leftButton;
    final Widget rightButton;
    if (widget.editing) {
      leftButton = Container();
      rightButton = const AppBarSaveButton();
    } else {
      leftButton = const AppBarBackButton();
      if (widget.cloth != null) {
        rightButton = const AppBarEditButton();
      } else {
        rightButton = Container();
      }
    }

    Widget content = ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ImagesView(
              editing: widget.editing,
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
        if (!widget.editing)
          const ImageShadow(
            key: Keys.editClothTopShadow,
            side: ShadowSide.top,
            overrideSystemUiOverlayStyle: true,
          ),
        AnimatedSwitcher(
          duration: ClothesUtils.switchViewDuration,
          child: leftButton,
        ),
        AnimatedSwitcher(
          duration: ClothesUtils.switchViewDuration,
          child: rightButton,
        ),
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
class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: MediaQuery.of(context).padding.top + 8.0,
            bottom: 12.0,
          ),
          child: BackButton(
            color: Colors.white,
            onPressed: () {
              BlocProvider.of<EditClothBloc>(context).add(CloseCloth());
            },
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class AppBarEditButton extends StatelessWidget {
  const AppBarEditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: MediaQuery.of(context).padding.top + 8.0,
            bottom: 12.0,
          ),
          child: IconButton(
            key: Keys.editClothButton,
            color: Colors.white,
            onPressed: () {
              BlocProvider.of<EditClothBloc>(context).add(EditCloth());
            },
            icon: const Icon(Icons.edit_rounded),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class AppBarSaveButton extends StatelessWidget {
  const AppBarSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: MediaQuery.of(context).padding.top + 8.0,
            bottom: 12.0,
          ),
          child: IconButton(
            key: Keys.saveClothButton,
            onPressed: () {
              BlocProvider.of<EditClothBloc>(context).add(SaveCloth());
            },
            icon: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class ImagesView extends StatelessWidget {
  final bool editing;
  final List<ClothImage>? images;

  const ImagesView({
    Key? key,
    this.editing = false,
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

    return AnimatedCrossFade(
      duration: ClothesUtils.switchViewDuration,
      crossFadeState:
          editing ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: IgnorePointer(
        ignoring: editing,
        child: ImagesMainView(images: images!),
      ),
      secondChild: IgnorePointer(
        ignoring: !editing,
        child: ImagesEditableView(images: images!),
      ),
    );
  }
}

@visibleForTesting
class ImagesMainView extends StatelessWidget {
  final List<ClothImage> images;

  const ImagesMainView({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: ClothesUtils.aspectRatio,
        enableInfiniteScroll: false,
        viewportFraction: 1.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index, realIndex) {
        return ClothImageView(image: images[index]);
      },
    );
  }
}

@visibleForTesting
class ImagesEditableView extends StatelessWidget {
  final List<ClothImage> images;

  const ImagesEditableView({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: MediaQuery.of(context).padding.top + 64.0,
        bottom: 8.0,
      ),
      shrinkWrap: true,
      gridDelegate: ClothesUtils.gridDelegate,
      itemCount: images.length + 1,
      itemBuilder: (context, index) {
        if (index == images.length) {
          return const AddImageView();
        }
        return EditableImageView(image: images[index]);
      },
    );
  }
}

@visibleForTesting
class EditableImageView extends StatelessWidget {
  final ClothImage image;

  const EditableImageView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: ClothesUtils.smallBorderRadius,
          child: ClothImageView(
            image: image,
          ),
        ),
        Positioned(
          top: -8.0,
          right: -8.0,
          child: RawMaterialButton(
            fillColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            constraints: const BoxConstraints(),
            shape: const CircleBorder(),
            onPressed: () {
              //TODO: delete image
            },
            child: const Icon(
              Icons.remove,
              size: 24.0,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
class AddImageView extends StatelessWidget {
  const AddImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      borderRadius: ClothesUtils.smallBorderRadius,
      child: InkWell(
        borderRadius: ClothesUtils.smallBorderRadius,
        onTap: () {
          //TODO: add new image
        },
        child: Center(
          child: Icon(
            Icons.add_rounded,
            size: 48.0,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
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
