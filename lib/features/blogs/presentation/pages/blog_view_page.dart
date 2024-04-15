import 'package:clean_bloc_app/core/theme/app_palette.dart';
import 'package:clean_bloc_app/core/utils/calculate_reading_time.dart';
import 'package:clean_bloc_app/core/utils/format_date.dart';
import 'package:clean_bloc_app/features/blogs/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewPage extends StatelessWidget {
  final Blog blog;
  const BlogViewPage({super.key, required this.blog});
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewPage(
          blog: blog,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'By ${blog.posterName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${formatDateBydMMMYYYY(blog.updatedAt)}. ${calculateReadingTime(blog.content)} min',
                  style: const TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: blog.id,
                      child: Image.network(blog.imageUrl, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image);
                      }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
