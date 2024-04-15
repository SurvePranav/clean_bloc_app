import 'dart:io';

import 'package:clean_bloc_app/core/usecase/usecase.dart';
import 'package:clean_bloc_app/features/blogs/domain/entities/blog.dart';
import 'package:clean_bloc_app/features/blogs/domain/usecases/get_all_blogs.dart';
import 'package:clean_bloc_app/features/blogs/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBlogUploadEvent);
    on<BlogGetAllBlogsEvent>(_onBlogGetAllBlogsEvent);
  }

  void _onBlogUploadEvent(
      BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(error: l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onBlogGetAllBlogsEvent(
      BlogGetAllBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold((l) => emit(BlogFailure(error: l.message)),
        (r) => emit(BlogFetchSuccess(blogs: r)));
  }
}
