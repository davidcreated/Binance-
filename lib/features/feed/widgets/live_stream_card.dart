import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';

class LiveStreamCard extends StatefulWidget {
  const LiveStreamCard({super.key});

  @override
  State<LiveStreamCard> createState() => _LiveStreamCardState();
}

class _LiveStreamCardState extends State<LiveStreamCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _liveIndicatorController;
  late Animation<double> _liveIndicatorAnimation;

  @override
  void initState() {
    super.initState();
    _liveIndicatorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _liveIndicatorAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _liveIndicatorController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _liveIndicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFAA7DFF), Color(0xFFFF6B9D)],
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.pravatar.cc/150?img=1',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Zain_Global',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E0FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.rocket_launch,
                                  size: 10,
                                  color: Color(0xFF8B5CF6),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '5',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF8B5CF6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '3h',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: AppTheme.textSecondary),
              ],
            ),
          ),
          
          // Post text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'well come '),
                  TextSpan(
                    text: '👉',
                    style: GoogleFonts.notoColorEmoji(),
                  ),
                  const TextSpan(text: ' and enjoy '),
                  TextSpan(
                    text: '😜😀',
                    style: GoogleFonts.notoColorEmoji(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Live Stream Preview
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E0FF).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Background
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: const Color(0xFFE8E0FF).withOpacity(0.3),
                  ),
                ),
                
                // Live badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _liveIndicatorAnimation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withOpacity(
                                _liveIndicatorAnimation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'LIVE',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4845',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Gift icon
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                
                // Center avatar
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://i.pravatar.cc/150?img=8',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                
                // Chat bubbles
                Positioned(
                  bottom: 50,
                  left: 12,
                  child: _buildChatBubble('MD MASUM M...', 'following 💫'),
                ),
                Positioned(
                  bottom: 26,
                  left: 12,
                  child: _buildChatBubble('abuhanif-U...', 'Zain bhai make me Co host', isPink: true),
                ),
                Positioned(
                  bottom: 4,
                  left: 12,
                  child: _buildChatBubble('Ossie Debe...', 'hi Host', isGreen: true),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Trade info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF44336),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'S',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'HOLO/USDT',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'at 0',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Filled',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildAction(Icons.thumb_up_outlined, '39'),
                const SizedBox(width: 32),
                _buildAction(Icons.mode_comment_outlined, '0'),
                const SizedBox(width: 32),
                _buildAction(Icons.share_outlined, '2'),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String user, String message, {bool isPink = false, bool isGreen = false}) {
    Color bgColor = Colors.black.withOpacity(0.6);
    if (isPink) bgColor = const Color(0xFFE91E63).withOpacity(0.8);
    if (isGreen) bgColor = AppTheme.success.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎉 ',
            style: GoogleFonts.inter(fontSize: 10),
          ),
          Text(
            '$user: $message',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          count,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
