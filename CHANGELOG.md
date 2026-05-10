## 1.2.0

### Added
- Added `getBlockByTag` to `BlockDialogController` to allow accessing blocks from anywhere using the controller.
- `BlockButton.onValidate` and `BlockButton.onPressed` now return the dialog controller instance for easier access to other blocks during interactions.

### Fixed
- Fixed `RenderFlex` overflow issues when the software keyboard pushes the dialog layout.
- Fixed `DialogConfig` children padding affecting `DialogButton` background coloring on press states.


## [1.1.1]

### Fixed
- Added missing `padding` parameter to `BlockOverride` constructor

### Changed
- Updated `BlockButton.onPressed` to use `FutureOr<void>` instead of `Function`
- Updated `BlockValidation` to use `FutureOr<String?>`
- Improved documentation to clarify async behavior and loading handling


## [1.1.0]

### Added
- Support for `initialValue` in `BlockInputField`
- New configuration options in `DialogConfig`:
  - `maxWidth`
  - `maxHeight`
  - `childrenPadding`
  - `textDirection`
- Ability for individual blocks to override default padding
- Ability to trigger shake animation on specific blocks from `onValidate` callback (useful for validation feedback)

### Improved
- Enhanced layout flexibility and responsiveness through new sizing and padding controls

## 1.0.1
- Fixed BlockCustom decoration logic when `matchDialogTheme` is enabled/disabled.

--------

## 1.0.0

- Initial release of block-based dialog system.
- Composable rows and blocks with automatic position resolving.
- Built-in blocks: text, input, checkbox, radio group, button, spacer, custom.
- Typed results with `BlocksResult` and per-block `resultId` keys.
- Animated dimmed barrier synchronized with dialog animation.
- Multiple block animations (slide, scale, elastic, depth, cinematic, expand-from-corner).
- Customizable styling via `DialogConfig`.
