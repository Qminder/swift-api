#!/bin/bash

set -o pipefail && xcodebuild -project QminderAPI.xcodeproj -scheme QminderAPI-iOS CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator13.0 clean build | xcpretty --color
set -o pipefail && xcodebuild -project QminderAPI.xcodeproj -scheme QminderAPI-macOS CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO clean build | xcpretty --color
set -o pipefail && xcodebuild -project QminderAPI.xcodeproj -scheme QminderAPI-watchOS CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO clean build | xcpretty --color
set -o pipefail && xcodebuild -project QminderAPI.xcodeproj -scheme QminderAPI-tvOS CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO clean build | xcpretty --color