# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Pagy 43+ compatibility support
- Comprehensive test suite covering Pagy versions 6, 7, 8, 9, and 43
- GitHub Actions CI workflow for automated testing
- Development script to test against all supported Pagy versions

### Fixed
- Fixed module inclusion for Pagy 43+ (uses `Pagy::Method` instead of `Pagy::Backend`)
- Fixed pagy method signature for Pagy 43+ (`pagy(:offset, collection, limit: N)`)
- Fixed `.prev` attribute compatibility (renamed to `.previous` in Pagy 43+)
- Fixed `.series` method compatibility (became protected in Pagy 43+)

## [0.2.0] - 2025-08-29

### Added
- Initial release with cache monitoring features
- Web UI for viewing cache entries
- Cache event tracking (hits, misses, writes, deletes)
- Statistics and visualization charts
- Dark mode support

## [0.1.0] - 2025-02-26

### Added
- Initial proof of concept
