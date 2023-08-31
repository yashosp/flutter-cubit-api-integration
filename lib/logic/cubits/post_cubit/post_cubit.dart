import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterblocapiintegration/data/models/post_model.dart';
import 'package:flutterblocapiintegration/data/repositories/post_repositories.dart';
import 'package:flutterblocapiintegration/logic/cubits/post_cubit/post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostLoadingState()) {
    fetchPosts();
  }

  PostRepository postRepository = PostRepository();

  void fetchPosts() async {
    try {
      List<PostModel> posts = await postRepository.fetchPosts();
      emit(PostLoadedState(posts));
    } on DioError catch (e) {
      // Instead of DioErrorType.connectionTimeout it should DioErrorType.other
      if (e.type == DioErrorType.connectionTimeout) {
        emit(PostErrorState(
            "Can't fetch please check your internet connection"));
      } else {
        emit(PostErrorState(e.type.toString()));
      }
    }
  }
}
