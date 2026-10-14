import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/backup/backup_contributor.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/storage/data_section.dart';

typedef LocalizedText = String Function(AppLocalizations l10n);

/// `ref.read` from either a provider or a widget.
typedef ProviderReader = T Function<T>(ProviderListenable<T> provider);

/// A bottom-navigation / rail destination contributed by a feature.
class TabDestination {
  const new({
    required this.order,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });

  final int order;
  final LocalizedText label;
  final IconData icon;
  final IconData selectedIcon;
  final GoRoute route;
}

List<BackupContributor> _noContributors(Ref ref) => const [];

Future<void> _nothingToClear(ProviderReader read) async {}

/// Everything a feature plugs into the app; adding a feature means adding one
/// of these to the app's module list.
class FeatureModule {
  const new({
    required this.name,
    this.sections = const [],
    this.tab,
    this.routes = const [],
    this.backupContributors = _noContributors,
    this.clearLocalData = _nothingToClear,
  });

  final String name;
  final List<DataSection> sections;
  final TabDestination? tab;

  /// Full-screen routes outside the tab shell.
  final List<RouteBase> routes;

  /// Contributors for data outside the document (e.g. the profile photo).
  final List<BackupContributor> Function(Ref ref) backupContributors;

  /// Deletes files the feature keeps outside the document (reset all data).
  final Future<void> Function(ProviderReader read) clearLocalData;
}
