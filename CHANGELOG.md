- 1.3.2
  - Added model deletion matcher.

- 1.3.1
  - Fixed issue where model creation matcher would unconditionally pass on subsequent matches.

- 1.3.0
  - Matchers are now only included into relevant spec types.
  - Matchers can now be individually required.
  - Added model creation matcher.

- 1.2.3
  - Now compatible with Rails 4.2.

- 1.2.2
  - Fixed issue with model validation matchers failing when validation has configuration present.

- 1.2.1
  - Altered model matchers to be more robust against non-ActiveRecord objects.

- 1.2.0
  - Updated model descriptions and failure messages.

- 1.1.0
  - Added model association matchers.
  - Added model attribute matchers.

- 1.0.1
  - Fixed issue where matchers would error unless explicitly passed the controller object.

- 1.0.0
  - Initial release
