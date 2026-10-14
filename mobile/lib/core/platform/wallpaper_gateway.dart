import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

/// Native Year Dots wallpaper (Android) and exported images (both).
abstract interface class WallpaperGateway {
  Future<bool> isLiveWallpaperSupported();

  /// Stores the config where the native wallpaper reads it and redraws.
  Future<void> pushConfig(Map<String, Object?> config);

  /// Opens the system live-wallpaper preview; the user confirms there.
  Future<bool> openLiveWallpaperPicker();

  Future<bool> saveImageToPhotos(Uint8List pngBytes);
}

class NativeWallpaperGateway implements WallpaperGateway {
  const new();

  static const channel = MethodChannel('gymtracker/wallpaper');

  @override
  Future<bool> isLiveWallpaperSupported() async {
    if (!Platform.isAndroid) {
      return false;
    }
    try {
      return await channel.invokeMethod<bool>('isSupported') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<void> pushConfig(Map<String, Object?> config) async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      await channel.invokeMethod<void>('setConfig', config);
    } on PlatformException {
      return;
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<bool> openLiveWallpaperPicker() async {
    try {
      return await channel.invokeMethod<bool>('openPicker') ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> saveImageToPhotos(Uint8List pngBytes) async {
    try {
      if (!await Gal.hasAccess() && !await Gal.requestAccess()) {
        return false;
      }
      await Gal.putImageBytes(pngBytes, name: 'year_dots');
      return true;
    } on GalException {
      return false;
    }
  }
}
