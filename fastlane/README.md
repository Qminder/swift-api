fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Unit tests
### ios release
```
fastlane ios release
```
Depoy new Swift API version
### ios generate_docs
```
fastlane ios generate_docs
```
Generate documentation
### ios bump_patch
```
fastlane ios bump_patch
```
Bump to patch
### ios bump_minor
```
fastlane ios bump_minor
```
Bump to patch

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
