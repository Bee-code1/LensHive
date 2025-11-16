import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';

/// Navigation helper for Home Service flows
/// Centralized navigation to avoid duplication and ensure consistency
void goToNewHomeService(BuildContext context) {
  context.push(Routes.homeServiceNew);
}

