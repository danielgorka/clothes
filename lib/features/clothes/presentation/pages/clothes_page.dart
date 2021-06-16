import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_item.dart';
import 'package:clothes/features/clothes/presentation/widgets/empty_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/shimmer.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClothesPage extends StatelessWidget {
  const ClothesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<ClothesBloc>()..add(LoadClothes()),
        child: const ClothesView(),
      ),
    );
  }
}

@visibleForTesting
class ClothesView extends StatelessWidget {
  const ClothesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClothesBloc, ClothesState>(
      builder: (context, state) {
        if (state is Loading) {
          return const ClothesLoadingView();
        }
        if (state is LoadError) {
          return const ErrorView();
        }
        if (state is Loaded) {
          if (state.clothes.isEmpty) {
            return const EmptyView();
          } else {
            return ClothesGridView(clothes: state.clothes);
          }
        }
        throw StateError('Unknown state');
      },
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
