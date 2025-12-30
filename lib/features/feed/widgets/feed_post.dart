import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';

class FeedPost extends StatefulWidget {
  final int index;

  const FeedPost({super.key, required this.index});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _likeCount = 39;
  bool _showHeart = false;
  
  late AnimationController _heartAnimController;
  late Animation<double> _heartAnimation;
  late AnimationController _likeButtonController;

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _heartAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_heartAnimController);

    _likeButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    _likeButtonController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    HapticFeedback.mediumImpact();
    
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
        _likeCount++;
        _showHeart = true;
      });
    } else {
      setState(() {
        _showHeart = true;
      });
    }
    
    _heartAnimController.forward(from: 0);
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
    });
  }

  void _handleLikeTap() {
    HapticFeedback.lightImpact();
    
    _likeButtonController.forward().then((_) {
      _likeButtonController.reverse();
    });
    
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _handleBookmarkTap() {
    HapticFeedback.lightImpact();
    
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Post saved to bookmarks' : 'Removed from bookmarks',
          style: GoogleFonts.inter(),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.darkSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showShareSheet() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ShareSheet(),
    );
  }

  void _showCommentSheet() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CommentSheet(),
    );
  }

  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PostOptionsSheet(
        onReport: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post reported', style: GoogleFonts.inter()),
              backgroundColor: AppTheme.error,
            ),
          );
        },
        onNotInterested: () {
          Navigator.pop(context);
        },
        onCopyLink: () {
          Navigator.pop(context);
          Clipboard.setData(const ClipboardData(text: 'https://binance.com/post/123'));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Link copied', style: GoogleFonts.inter()),
              backgroundColor: AppTheme.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          border: Border(
            bottom: BorderSide(color: AppTheme.borderLight.withOpacity(0.5)),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Row
                Row(
                  children: [
                    // Avatar
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile
                        _showProfileSheet();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: 'https://i.pravatar.cc/150?img=${widget.index + 10}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppTheme.surfaceGray,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppTheme.surfaceGray,
                              child: const Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Name and Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Richard Teng',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryYellow,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  size: 12,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '20h',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Follow Button
                    _FollowButton(),
                    
                    const SizedBox(width: 8),
                    
                    // More Options
                    GestureDetector(
                      onTap: _showOptionsSheet,
                      child: const Icon(
                        Icons.more_horiz,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Post Content
                Text(
                  'Partnering with Ignyte AE and DIFC to open Web3 opportunities across the UAE. We\'re providing startups with what they need most: education, mentorship from industry leaders, and practical tools to build. ...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    height: 1.5,
                  ),
                ),
                
                // Read More
                GestureDetector(
                  onTap: () {
                    // Expand post
                  },
                  child: Text(
                    'Read more',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Images Row
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/400/200?random=${widget.index}',
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 100,
                            color: AppTheme.surfaceGray,
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 100,
                            color: AppTheme.surfaceGray,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/400/200?random=${widget.index + 100}',
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 100,
                            color: AppTheme.surfaceGray,
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 100,
                            color: AppTheme.surfaceGray,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Actions Row
                Row(
                  children: [
                    // Like Button with animation
                    _buildActionButton(
                      icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      label: _likeCount.toString(),
                      isActive: _isLiked,
                      onTap: _handleLikeTap,
                      controller: _likeButtonController,
                    ),
                    const SizedBox(width: 32),
                    
                    // Comment Button
                    _buildActionButton(
                      icon: Icons.mode_comment_outlined,
                      label: '0',
                      onTap: _showCommentSheet,
                    ),
                    const SizedBox(width: 32),
                    
                    // Share Button
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      label: '2',
                      onTap: _showShareSheet,
                    ),
                    
                    const Spacer(),
                    
                    // Bookmark
                    GestureDetector(
                      onTap: _handleBookmarkTap,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          key: ValueKey(_isBookmarked),
                          color: _isBookmarked 
                              ? AppTheme.primaryYellow 
                              : AppTheme.textSecondary,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // Double tap heart animation
            if (_showHeart)
              Positioned.fill(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _heartAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartAnimation.value,
                        child: Opacity(
                          opacity: _heartAnimation.value > 0 
                              ? 1 - (_heartAnimation.value / 1.5).abs()
                              : 0,
                          child: child,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: AppTheme.error,
                      size: 80,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: CachedNetworkImageProvider(
                'https://i.pravatar.cc/150?img=${widget.index + 10}',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Richard Teng',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '@richardteng • CEO of Binance',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Posts', '1.2K'),
                _buildStatColumn('Followers', '2.5M'),
                _buildStatColumn('Following', '142'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.textPrimary,
                ),
                child: Text('Follow', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
    AnimationController? controller,
  }) {
    Widget iconWidget = Icon(
      icon,
      size: 20,
      color: isActive ? AppTheme.primaryYellow : AppTheme.textSecondary,
    );

    if (controller != null) {
      iconWidget = AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + (controller.value * 0.3),
            child: child,
          );
        },
        child: iconWidget,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Follow Button with state
class _FollowButton extends StatefulWidget {
  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _isFollowing = !_isFollowing;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: _isFollowing ? AppTheme.surfaceGray : AppTheme.primaryYellow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          _isFollowing ? 'Following' : 'Follow',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

// Share Sheet
class _ShareSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shareOptions = [
      {'icon': Icons.link, 'label': 'Copy Link'},
      {'icon': Icons.message, 'label': 'Messages'},
      {'icon': Icons.email, 'label': 'Email'},
      {'icon': Icons.share, 'label': 'More'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: shareOptions.map((option) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceGray,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        option['icon'] as IconData,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// Comment Sheet
class _CommentSheet extends StatefulWidget {
  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Comments',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Comments list
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 48,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No comments yet',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    'Be the first to comment!',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Comment input
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: GoogleFonts.inter(color: AppTheme.textTertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppTheme.borderLight),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      HapticFeedback.lightImpact();
                      _commentController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Comment posted!', style: GoogleFonts.inter()),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send, color: AppTheme.primaryYellow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Post Options Sheet
class _PostOptionsSheet extends StatelessWidget {
  final VoidCallback onReport;
  final VoidCallback onNotInterested;
  final VoidCallback onCopyLink;

  const _PostOptionsSheet({
    required this.onReport,
    required this.onNotInterested,
    required this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.link),
            title: Text('Copy link', style: GoogleFonts.inter()),
            onTap: onCopyLink,
          ),
          ListTile(
            leading: const Icon(Icons.not_interested),
            title: Text('Not interested', style: GoogleFonts.inter()),
            onTap: onNotInterested,
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined, color: AppTheme.error),
            title: Text('Report', style: GoogleFonts.inter(color: AppTheme.error)),
            onTap: onReport,
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
