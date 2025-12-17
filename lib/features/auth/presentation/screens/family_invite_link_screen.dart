import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/features/auth/data/providers/auth_bootstrap_providers.dart';

class FamilyInviteLinkScreen extends ConsumerStatefulWidget {
  const FamilyInviteLinkScreen({super.key, required this.inviteId});

  final String inviteId;

  @override
  ConsumerState<FamilyInviteLinkScreen> createState() => _FamilyInviteLinkScreenState();
}

class _FamilyInviteLinkScreenState extends ConsumerState<FamilyInviteLinkScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.inviteId.trim().isNotEmpty) {
        ref.read(pendingFamilyInviteIdProvider.notifier).setInviteId(widget.inviteId.trim());
      }
      if (mounted) {
        context.go(AppRoutes.splash);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      ),
    );
  }
}
