import 'package:flutter/material.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF101922),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          shimmerBox(height: 18, width: 220),
          const SizedBox(height: 20),

          shimmerBox(height: 120, width: 120, radius: 100),
          const SizedBox(height: 20),

          shimmerBox(height: 70, width: 150),
          const SizedBox(height: 12),

          shimmerBox(height: 22, width: 180),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              shimmerBox(height: 18, width: 80),
              const SizedBox(width: 20),
              shimmerBox(height: 18, width: 80),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(child: shimmerBox(height: 100)),
              const SizedBox(width: 12),
              Expanded(child: shimmerBox(height: 100)),
              const SizedBox(width: 12),
              Expanded(child: shimmerBox(height: 100)),
            ],
          ),
          const SizedBox(height: 25),

          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) =>
                  shimmerBox(height: 70, width: double.infinity, radius: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmerBox({
    double height = 20,
    double? width,
    double radius = 12,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final gradientPosition = _controller.value * 2 - 1;

        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: Colors.grey[800],
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1 - gradientPosition, -0.3),
                end: Alignment(1 + gradientPosition, 0.3),
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[700]!,
                  Colors.grey[800]!,
                ],
                stops: const [0.1, 0.5, 0.9],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Container(color: Colors.grey[800]),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}