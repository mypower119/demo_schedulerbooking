#!/bin/bash
set -e
flutter clean

pod cache clean  --all
rm -rf ios/Flutter/Flutter.framework

rm -rf macos/Pods
rm -rf ios/Pods
rm -f macos/Podfile.lock
rm -f ios/Podfile.lock
rm -f pubspec.lock

echo "Clean done !!!"

flutter pub get
echo "Pub get done !!!"

flutter packages pub run build_runner build --delete-conflicting-outputs
flutter pub global run intl_utils:generate
echo "Build runner done !!!"