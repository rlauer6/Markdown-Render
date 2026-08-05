# Markdown::Render 2.1.1 Release Notes

**Released:** 2026-08-05
**Author:** Rob Lauer

---

## Overview

This is a patch release that delivers bug fixes, CLI improvements,
build system updates, and new build infrastructure via
`CPAN::Maker::Bootstrapper`. The most notable user-facing change is a
correction to the `markdown-render` wrapper script, which now
correctly targets `Markdown::Render::CLI` as its module entry point.

---

## What's New

### Bug Fixes

- **`bin/markdown-render`** — Fixed an incorrect module reference: the
  modulino wrapper now correctly invokes `Markdown::Render::CLI`
  instead of the bare `Markdown::Render` module. Also corrected a typo
  in the wrapper name (`markdown-rendor` → `markdown-render`).

### CLI Improvements (`Markdown::Render::CLI`)

- Added `-h` as a short alias for `--help` (i.e., `help|h`).
- Set `render` as the default command, so invoking `markdown-render`
  without an explicit subcommand now falls through to the render
  operation automatically.
- Updated usage documentation in POD to reflect the `markdown-render`
  binary name, replacing outdated references to `md-utils.pl`.
- Added a missing `1;` before `__END__` to ensure the module returns true on load.

---

## Dependencies

### New Optional Dependency

- **`Text::Markdown::Discount` ≥ 0.18** added to `cpanfile` as a
  `suggests` dependency (optional, improves Markdown rendering
  performance if installed).

---

## Build System Changes

The following changes were applied by `CPAN::Maker::Bootstrapper` as part of a managed build system update:

### `help.mk`
- Help output is now written to a temp file and piped through `$PAGER`
  (falling back to `less`, `more`, or `cat`) for improved usability in
  terminals.
- Added documentation for new build variables: `SYNTAX_CHECKING=OFF` and `SKIP_TESTS=1`.
- Removed the `MODULINO_NAME` variable entry (superseded by `modulino.mk`).

### `perl.mk`
- `perlcritic` invocations in the `critic` target now consistently
  pass `--theme` and `--severity` flags, controlled by
  `PERLCRITIC_THEME` and `PERLCRITIC_SEVERITY` variables (defaulting
  to `pbp` and `5` respectively).

### `release-notes.mk`
- The `release-notes` target now supports a `DRYRUN` environment
  variable, passing `--dryrun` to `cmb release-notes` when set.
- Added the missing `##` help comment to make the target visible in `make help`.

### `update.mk`
- Two new managed include files are now tracked: `bash-completion.mk`
  and `modulino.mk`.
- Fixed update ordering: `post-update` now runs before `Makefile` is
  replaced, preventing a race condition where the new `Makefile` could
  overwrite include files mid-update.

### `Makefile`
- **`cpanfile` generation** refactored into separate intermediate
  targets (`cpanfile.requires`, `cpanfile.suggests`,
  `cpanfile.recommends`), enabling proper per-tier dependency type
  tagging via `cpan-maker create-cpanfile --dependency-type`.
- `all` target is now an explicit `.PHONY` that builds the tarball
  directly, removing the implicit `update-available` dependency from
  the default goal.
- `update-available` is now an order-only prerequisite of the tarball
  target (`| update-available`), so it runs as a check without
  affecting rebuild decisions.
- `modulino` target inlined into `Makefile` is replaced by `-include
  .includes/modulino.mk`.
- Bash completion support added via `-include
  .includes/bash-completion.mk`.
- `deps.mk` now depends on built source files (`$(SOURCE_FILES)`)
  rather than `.pm.in` inputs, resolving a previous chicken-and-egg
  issue with dependency regeneration.
- `test-requires` filter logic simplified: `cmb filter` is now always
  called (with empty or absent skip/history files handled gracefully),
  removing a conditional branch.
- `build-ci` target now mounts the current working directory into the
  Docker container and passes `REPO` as an environment variable.
- `README.md` generation from POD is now non-fatal (`|| true`) if
  `md-utils` processing fails.
- `MIN_PERL_VERSION_FLAG` derivation now guards against a missing
  `buildspec.yml` before calling `dnk`.

---

## New Files

| File | Description |
|------|-------------|
| `.includes/bash-completion.mk` | New managed include for shell tab-completion support |
| `.includes/modulino.mk` | New managed include replacing the inline `modulino` target in `Makefile` |
| `t/00-markdown-render-cli.t` | New unit test for `Markdown::Render::CLI` |

---

## Upgrade Notes

- If you are using the `markdown-render` wrapper script, reinstall or
  regenerate it — the previous version pointed to the wrong module
  (`Markdown::Render` instead of `Markdown::Render::CLI`) and
  contained a typo in the wrapper name.
- Run `make update` to pull in the latest managed build include files
  from your installed `CPAN::Maker::Bootstrapper`.
- `Text::Markdown::Discount` is now listed as a suggested
  dependency. Installing it (`cpanm Text::Markdown::Discount`) will
  improve rendering performance but is not required.
