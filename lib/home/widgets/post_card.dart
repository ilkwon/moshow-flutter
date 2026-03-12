import 'package:flutter/material.dart';

//------------------------------------------------------------------------------
class PostCard extends StatelessWidget {
  
  final String imageUrl;
  final String title;
  final String location;
  final String badge;

  const PostCard({
    super.key,
    
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit:StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover
        ),
        
        // 하단 그라데이션 오버레이
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
            ),
          ),
        ),

        // 하단 정보
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + kToolbarHeight + 12,
            16,
            MediaQuery.of(context).padding.bottom + 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 뱃지
              if (badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const Spacer(),
              // 제목
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // 위치
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}