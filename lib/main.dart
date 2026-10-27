import 'package:flutter/material.dart';

import 'core/constants/app_theme.dart';
import 'models/booking_draft.dart';
import 'models/diwaniya.dart';
import 'screens/add_diwaniya_screen.dart';
import 'screens/booking_summary_screen.dart';
import 'screens/details_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/saved_screen.dart';
import 'widgets/app_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ديوانيات',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final Set<String> _favorites = {};
  final List<BookingDraft> _bookings = [];

  void _toggleFavorite(String id) {
    setState(() {
      if (!_favorites.add(id)) _favorites.remove(id);
    });
  }

  void _openDiwaniya(Diwaniya diwaniya) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DetailsScreen(
          diwaniya: diwaniya,
          isFavorite: _favorites.contains(diwaniya.id),
          onFavorite: () => _toggleFavorite(diwaniya.id),
          onReturnHome: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            setState(() => _selectedIndex = 0);
          },
          onViewBookings: _openBookings,
          onBookingConfirmed: _recordBooking,
        ),
      ),
    );
  }

  void _openBookings(BookingDraft draft) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BookingReceiptScreen(draft: draft),
      ),
    );
  }

  void _recordBooking(BookingDraft draft) {
    setState(() => _bookings.add(draft));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        favorites: _favorites,
        onFavorite: _toggleFavorite,
        onExplore: () => setState(() => _selectedIndex = 1),
        onOpenDiwaniya: _openDiwaniya,
      ),
      ExploreScreen(
        favorites: _favorites,
        onFavorite: _toggleFavorite,
        onOpenDiwaniya: _openDiwaniya,
      ),
      const AddDiwaniyaScreen(),
      SavedScreen(
        favorites: _favorites,
        onFavorite: _toggleFavorite,
        onOpenDiwaniya: _openDiwaniya,
      ),
      ProfileScreen(
        bookingDrafts: _bookings,
        onOpenBookings: () {
          if (_bookings.isNotEmpty) {
            _openBookings(_bookings.last);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('لا توجد حجوزات بعد')));
          }
        },
        onOpenSaved: () => setState(() => _selectedIndex = 3),
        onOpenAddDiwaniya: () => setState(() => _selectedIndex = 2),
        onOpenSettings: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الإعدادات ستتوفر لاحقاً')),
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SizedBox.expand(
              child: IndexedStack(index: _selectedIndex, children: pages),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: AppBottomNavigation(
            selectedIndex: _selectedIndex,
            onSelected: (index) => setState(() => _selectedIndex = index),
          ),
        ),
      ),
    );
  }
}
