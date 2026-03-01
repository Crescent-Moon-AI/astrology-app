import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/friend_profile.dart';
import 'relationship_label_badge.dart';

class FriendCard extends StatelessWidget {
  final FriendProfile friend;
  final VoidCallback? onTap;

  const FriendCard({
    super.key,
    required this.friend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: CosmicColors.surfaceElevated,
            border: Border.all(color: CosmicColors.borderGlow),
          ),
          child: Row(
            children: [
              // Avatar circle with initials
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: CosmicColors.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    friend.name.isNotEmpty
                        ? friend.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Name and birth date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      friend.birthDate,
                      style: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Relationship badge
              if (friend.relationshipLabel.isNotEmpty)
                RelationshipLabelBadge(label: friend.relationshipLabel),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: CosmicColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
