import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/clock/iso_date_time.dart';
import 'package:gym_tracker/core/storage/document_store.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/core/storage/parsed_section.dart';
import 'package:gym_tracker/features/profile/data/photo_store.dart';
import 'package:gym_tracker/features/profile/data/profile_dto.dart';
import 'package:gym_tracker/features/profile/domain/profile.dart';

class ProfileRepository {
  const new(this.store);

  static const sectionKey = 'profile';

  static const section = ParsedSection(
    key: sectionKey,
    emptyValue: null,
    parse: parse,
  );

  final DocumentStore store;

  static Profile? parse(Object? raw) {
    final json = JsonCast.optionalObject(raw, sectionKey);
    return json == null ? null : _fromDto(ProfileDto.fromJson(json));
  }

  Profile? load() => parse(store.read(sectionKey));

  void save(Profile? profile) => store.write(
    sectionKey,
    profile == null ? null : _toDto(profile).toJson(),
  );

  static Profile _fromDto(ProfileDto dto) => Profile(
    name: dto.name,
    gender:
        Gender.tryParse(dto.gender) ??
        (throw FormatException('Unknown gender ${dto.gender}')),
    dateOfBirth: _date(dto.dob),
    age: dto.age,
    ageSetOn: _date(dto.ageSetOn),
    weightKg: dto.weightKg,
    heightCm: dto.heightCm,
    hasPhoto: dto.photoFile != null,
    createdAt: IsoDateTime.parse(dto.createdAt),
    updatedAt: IsoDateTime.parse(dto.updatedAt),
  );

  static ProfileDto _toDto(Profile profile) => ProfileDto(
    name: profile.name,
    gender: profile.gender.storageName,
    dob: profile.dateOfBirth?.toIso(),
    age: profile.age,
    ageSetOn: profile.ageSetOn?.toIso(),
    weightKg: profile.weightKg,
    heightCm: profile.heightCm,
    photoFile: profile.hasPhoto ? PhotoStore.fileName : null,
    createdAt: IsoDateTime.format(profile.createdAt),
    updatedAt: IsoDateTime.format(profile.updatedAt),
  );

  static CalendarDate? _date(String? iso) =>
      iso == null ? null : CalendarDate.parse(iso);
}
