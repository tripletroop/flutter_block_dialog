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
