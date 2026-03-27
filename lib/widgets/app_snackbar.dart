import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static OverlayEntry? _currentEntry;

  /// 🔴 ERROR SNACKBAR
  static void showError(String message) {
    _show(
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
    );
  }

  /// 🟢 SUCCESS SNACKBAR
  static void showSuccess(String message) {
    _show(
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  /// 🟡 WARNING SNACKBAR (optional)
  static void showWarning(String message) {
    _show(
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  /// 🔵 INFO SNACKBAR (optional)
  static void showInfo(String message) {
    _show(
      message: message,
      backgroundColor: Colors.blue,
      icon: Icons.info_outline,
    );
  }

  /// 🔥 CORE METHOD (DO NOT CALL DIRECTLY)
  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final overlay =
        Navigator.of(Get.key.currentContext!, rootNavigator: true).overlay;

    if (overlay == null) {
      print("❌ Overlay not available");
      return;
    }

    // Remove previous snackbar (avoid stacking)
    _currentEntry?.remove();

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: _AnimatedSnackbar(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
        ),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 3), () {
      _currentEntry?.remove();
      _currentEntry = null;
    });
  }
}

/// 🎬 ANIMATED UI WIDGET
class _AnimatedSnackbar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;

  const _AnimatedSnackbar({
    required this.message,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<_AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8),
            ],
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}