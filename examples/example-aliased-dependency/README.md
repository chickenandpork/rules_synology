# Aliased-Dependency Example

This is intended to confirm that dependency with a `repo_name` does not fail.  This is tested with the `images()` rule because that was a macro and really the crux of the aliased import.  It seems that macros are evaluated in the scope where called, not where defined, so default toolchains cannot refer to rules_synology by name (when aliased, the name differs), nor can it refer in the calling/dependent repo.

This example confirms that the repair in PR#200 persists.

## Currently

The current build command is:

(cd examples/example-aliased-dependency && bazel build :icons)
