import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatefulWidget {
  final String message;
  final Future<void> Function() onRetry;

  const ErrorWidgetCustom({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  State<ErrorWidgetCustom> createState() => _ErrorWidgetCustomState();
}

class _ErrorWidgetCustomState extends State<ErrorWidgetCustom> {
  bool _isLoading = false;

  Future<void> _handleRetry() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onRetry();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 80, color: Colors.redAccent),

            const SizedBox(height: 16),

            const Text(
              "Đã xảy ra lỗi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: 140,
              height: 45,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Thử lại",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}