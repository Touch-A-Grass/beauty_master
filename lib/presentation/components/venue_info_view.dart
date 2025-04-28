import 'package:beauty_master/domain/models/venue.dart';
import 'package:flutter/material.dart';

class VenueInfoView extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const VenueInfoView({super.key, required this.venue, this.onTap, this.backgroundColor, this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(venue.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: foregroundColor)),
                const SizedBox(height: 8),
                Text(venue.address, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: foregroundColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
