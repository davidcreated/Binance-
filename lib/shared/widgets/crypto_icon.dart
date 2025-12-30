import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CryptoIcon extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color? backgroundColor;

  const CryptoIcon({
    super.key,
    required this.imageUrl,
    this.size = 32,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFF0B90B),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.currency_bitcoin,
              size: size * 0.6,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
