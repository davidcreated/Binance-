import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../home/widgets/bottom_nav_bar.dart';
import 'widgets/story_avatar.dart';
import 'widgets/feed_post.dart';
import 'widgets/live_stream_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedNavIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<String> _tabs = ['Discover', 'Following', 'Campaign', 'News', 'Ann...'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // Refresh completed - could add haptic feedback or update data here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Tab Bar with animation
            _buildTabBar(),
            
            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppTheme.primaryYellow,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    // Stories Row
                    SliverToBoxAdapter(
                      child: _buildStoriesRow(),
                    ),
                    
                    // Divider
                    const SliverToBoxAdapter(
                      child: Divider(height: 1, color: AppTheme.borderLight),
                    ),
                    
                    // Recommended Header
                    SliverToBoxAdapter(
                      child: _buildRecommendedHeader(),
                    ),
                    
                    // Feed Posts
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return AnimatedFeedItem(
                            index: index,
                            child: index == 0 
                                ? const LiveStreamCard()
                                : FeedPost(index: index),
                          );
                        },
                        childCount: 5,
                      ),
                    ),
                    
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppTheme.textPrimary,
              unselectedLabelColor: AppTheme.textSecondary,
              labelStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              indicatorColor: AppTheme.primaryYellow,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesRow() {
    final stories = [
      {'name': 'Zain_Global', 'isLive': true, 'image': 'https://i.pravatar.cc/150?img=1'},
      {'name': 'Hua BNB', 'isLive': false, 'image': 'https://i.pravatar.cc/150?img=2'},
      {'name': 'Shakir Fay...', 'isLive': false, 'image': 'https://i.pravatar.cc/150?img=3'},
      {'name': 'Faruk Abu...', 'isLive': false, 'image': 'https://i.pravatar.cc/150?img=4'},
      {'name': 'CeM BNB', 'isLive': false, 'image': 'https://i.pravatar.cc/150?img=5'},
    ];

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StoryAvatar(
              name: story['name'] as String,
              imageUrl: story['image'] as String,
              isLive: story['isLive'] as bool,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Recommended',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_drop_down,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryYellow,
        child: Stack(
          children: [
            const Icon(Icons.add, color: AppTheme.textPrimary, size: 28),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Feed Item wrapper
class AnimatedFeedItem extends StatefulWidget {
  final int index;
  final Widget child;

  const AnimatedFeedItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<AnimatedFeedItem> createState() => _AnimatedFeedItemState();
}

class _AnimatedFeedItemState extends State<AnimatedFeedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
