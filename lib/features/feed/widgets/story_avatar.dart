import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';

class StoryAvatar extends StatefulWidget {
  final String name;
  final String imageUrl;
  final bool isLive;
  final VoidCallback onTap;

  const StoryAvatar({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isLive = false,
    required this.onTap,
  });

  @override
  State<StoryAvatar> createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<StoryAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isViewed = false;

  @override
  void initState() {
    super.initState();
    if (widget.isLive) {
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..repeat(reverse: true);

      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      );
    } else {
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      _pulseAnimation = const AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    setState(() {
      _isViewed = true;
    });
    
    // Show story viewer bottom sheet
    _showStoryViewer();
    
    widget.onTap();
  }

  void _showStoryViewer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) => _StoryViewerSheet(
        name: widget.name,
        imageUrl: widget.imageUrl,
        isLive: widget.isLive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isLive ? _pulseAnimation.value : 1.0,
                  child: child,
                );
              },
              child: Container(
                width: widget.isLive ? 56 : 60,
                height: widget.isLive ? 56 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: widget.isLive
                      ? const LinearGradient(
                          colors: [
                            Color(0xFFAA7DFF),
                            Color(0xFFFF6B9D),
                            Color(0xFFFFB86C),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  border: widget.isLive
                      ? null
                      : Border.all(
                          color: _isViewed 
                              ? AppTheme.textTertiary 
                              : AppTheme.primaryYellow,
                          width: 2,
                        ),
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.surfaceGray,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.surfaceGray,
                        child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.isLive) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'LIVE',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 2),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Story Viewer Bottom Sheet
class _StoryViewerSheet extends StatefulWidget {
  final String name;
  final String imageUrl;
  final bool isLive;

  const _StoryViewerSheet({
    required this.name,
    required this.imageUrl,
    required this.isLive,
  });

  @override
  State<_StoryViewerSheet> createState() => _StoryViewerSheetState();
}

class _StoryViewerSheetState extends State<_StoryViewerSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    if (!widget.isLive) {
      _progressController.forward();
      _progressController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextPage();
        }
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          // Story Content
          GestureDetector(
            onTapUp: (details) {
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < width / 3) {
                _previousPage();
              } else if (details.globalPosition.dx > width * 2 / 3) {
                _nextPage();
              }
            },
            child: widget.isLive
                ? _buildLiveContent()
                : _buildStoryContent(),
          ),

          // Progress indicators
          if (!widget.isLive)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(_totalPages, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 2,
                      child: index == _currentPage
                          ? AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return LinearProgressIndicator(
                                  value: _progressController.value,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                                );
                              },
                            )
                          : Container(
                              color: index < _currentPage
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                            ),
                    ),
                  );
                }),
              ),
            ),

          // Header
          Positioned(
            top: widget.isLive ? 16 : 32,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(widget.imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.isLive)
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'LIVE • 4.8K watching',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '2h ago',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),

          // Reply bar at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
                top: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Send message...',
                        style: GoogleFonts.inter(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.favorite_border, color: Colors.white),
                  const SizedBox(width: 12),
                  const Icon(Icons.send_outlined, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.shade900,
            Colors.blue.shade900,
          ],
        ),
      ),
      child: Center(
        child: Text(
          'Story ${_currentPage + 1}',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLiveContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: CachedNetworkImageProvider(widget.imageUrl),
          ),
          const SizedBox(height: 24),
          Text(
            '${widget.name} is live!',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discussing crypto market trends',
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
