import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/profile/data/photo_store.dart';
import 'package:gym_tracker/features/profile/data/profile_repository.dart';
import 'package:gym_tracker/features/profile/domain/photo_crop.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';
import 'package:gym_tracker/features/profile/domain/profile_rules.dart';
import 'package:gym_tracker/features/profile/domain/profile_validator.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(documentStoreProvider)),
);

final photoStoreProvider = Provider<PhotoStore>(
  (ref) => PhotoStore(ref.watch(fileGatewayProvider)),
);

class ProfileController extends Notifier<Profile?> {
  /// A photo can be chosen in the gate before the profile exists.
  bool _hasPhotoFile = false;

  @override
  Profile? build() {
    ref.watch(dataVersionProvider);
    final profile = ref.watch(profileRepositoryProvider).load();
    _hasPhotoFile = profile?.hasPhoto ?? false;
    return profile;
  }

  DateTime _now() => ref.read(clockProvider).now();

  void _commit(Profile? profile) {
    state = profile;
    ref.read(profileRepositoryProvider).save(profile);
  }

  /// Creates or updates the profile from validated values. Entering an age
  /// clears any date of birth (and vice versa) so the two never coexist.
  Profile saveValues(ProfileValues values) {
    final now = _now();
    final current = state;
    final profile = Profile(
      name: values.name,
      gender: values.gender,
      weightKg: values.weightKg,
      heightCm: values.heightCm,
      dateOfBirth: values.dateOfBirth,
      age: values.age,
      ageSetOn: values.age == null ? null : _ageSetOn(current, values, now),
      hasPhoto: _hasPhotoFile,
      createdAt: current?.createdAt ?? now,
      updatedAt: now,
    );
    _commit(profile);
    return profile;
  }

  /// Keeps the original anchor when the user re-saves the same derived age,
  /// so editing other fields doesn't reset the yearly increase.
  CalendarDate _ageSetOn(Profile? current, ProfileValues values, DateTime now) {
    final today = CalendarDate.fromDateTime(now);
    final anchor = current?.ageSetOn;
    if (current != null &&
        anchor != null &&
        ProfileRules.ageOf(current, today) == values.age) {
      return anchor;
    }
    return today;
  }

  Future<Result<void>> setPhoto(
    Uint8List sourceBytes, {
    PhotoCrop? crop,
  }) async {
    final prepared = await PhotoStore.prepare(sourceBytes, crop: crop);
    if (prepared == null) {
      return const Err(PlatformFailure('Unreadable image'));
    }
    try {
      await ref.read(photoStoreProvider).write(prepared);
    } on Exception catch (error) {
      return Err(StorageFailure(StorageFailureKind.writeFailed, '$error'));
    }
    _hasPhotoFile = true;
    ref.invalidate(profilePhotoProvider);
    final current = state;
    if (current != null) {
      _commit(current.copyWith(hasPhoto: true, updatedAt: _now()));
    }
    return const Ok(null);
  }

  Future<void> removePhoto() async {
    await ref.read(photoStoreProvider).delete();
    _hasPhotoFile = false;
    ref.invalidate(profilePhotoProvider);
    final current = state;
    if (current != null) {
      _commit(current.copyWith(hasPhoto: false, updatedAt: _now()));
    }
  }
}

final profileControllerProvider = NotifierProvider<ProfileController, Profile?>(
  ProfileController.new,
);

final profilePhotoProvider = FutureProvider<Uint8List?>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(photoStoreProvider).read();
});

/// Whether the first-launch gate must be shown.
final hasValidProfileProvider = Provider<bool>((ref) {
  final profile = ref.watch(profileControllerProvider);
  final today = CalendarDate.fromDateTime(ref.watch(clockProvider).now());
  return profile != null && ProfileRules.isValid(profile, today);
});
