import 'dart:io';
import 'package:clean_bloc_app/core/error/exceptions.dart';
import 'package:clean_bloc_app/core/error/failures.dart';
import 'package:clean_bloc_app/features/blogs/data/models/blog_model.dart';
import 'package:clean_bloc_app/features/blogs/data/data_sources/blog_remote_data_source.dart';
import 'package:clean_bloc_app/features/blogs/domain/entities/blog.dart';
import 'package:clean_bloc_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepoImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepoImpl({required this.blogRemoteDataSource});
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterid: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog =
          await blogRemoteDataSource.uploadBlog(blog: blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
