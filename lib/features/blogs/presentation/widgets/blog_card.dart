import 'package:clean_bloc_app/core/theme/app_palette.dart';
import 'package:clean_bloc_app/core/utils/calculate_reading_time.dart';
import 'package:clean_bloc_app/features/blogs/domain/entities/blog.dart';
import 'package:clean_bloc_app/features/blogs/presentation/pages/blog_view_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(16).copyWith(bottom: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: blog.id,
                child: Image.network(
                  blog.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, BlogViewPage.route(blog));
          },
          child: Container(
            height: 200,
            margin: const EdgeInsets.all(16).copyWith(bottom: 4),
            padding: const EdgeInsets.all(16.0),
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                color,
                AppPallete.transparentColor.withOpacity(0.2),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: Chip(
                              label: Text(e),
                              // color:
                              // side: BorderSide(
                              //   color: selectedtopics.contains(e)
                              //       ? AppPallete.transparentColor
                              //       : AppPallete.borderColor,
                              // ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text('${calculateReadingTime(blog.content)} min to read'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
