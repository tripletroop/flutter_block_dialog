## [2.0.2] - 2026-07-21

- `BlockButton` can now accept loadingWidget in case the user want to provide his own loading widget
- Merged `Block`'s attributes `resultID` and `blockTag` into single value which is `blockTag`

## [2.0.0] - 2026-07-19

### ⚠️ Breaking Changes

- Added configurable dialog width through `DialogConfig`.
- Individual dialog rows can now override the dialog width.
- Added a global `TextStyle` to `DialogConfig` that is used by all standard text blocks by default.
- Removed `BlockShaker`.
- Dialog shaking is now handled by `BlockDialogController`.
- `BlockCustom` now owns its own controller.
- `BlockButton` removed onValidate and added onPressedWithError

### Added

- Added `isPositive` to `BlockButton` for highlighting primary actions.
- Added `isDialogTitle` to `BlockText` for highlighting dialog titles.
- Added interactive APIs to `BlockDialogController` allowing blocks to communicate with and control other blocks.
- Added `BlockCustomController`, enabling custom blocks to:
  - rebuild themselves,
  - produce block results,
  - interact with other dialog blocks.

### Changed

- Dialog layout is now significantly more customizable.
- Styling can now be controlled globally while still allowing individual blocks to override styles.
- Internal controller architecture has been redesigned for greater flexibility and interaction between blocks.

## [1.2.0]

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

---

## 1.0.0

- Initial release of block-based dialog system.
- Composable rows and blocks with automatic position resolving.
- Built-in blocks: text, input, checkbox, radio group, button, spacer, custom.
- Typed results with `BlocksResult` and per-block `resultId` keys.
- Animated dimmed barrier synchronized with dialog animation.
- Multiple block animations (slide, scale, elastic, depth, cinematic, expand-from-corner).
- Customizable styling via `DialogConfig`.
