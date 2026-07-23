# Markdown::Render 2.0.4 Release Notes

**Release Date:** 2026-04-11

## Overview

Patch release replacing `LWP::UserAgent` with `HTTP::Tiny` in the GitHub
API rendering path. Consistent with the same dependency reduction effort
applied across the Amazon::API and Amazon::Credentials distributions.

---

## Changes

### `Markdown::Render` (`Render.pm`)

`_render_with_github` now uses `HTTP::Tiny` directly instead of constructing
an `LWP::UserAgent` + `HTTP::Request` pair. The POST to the GitHub Markdown
API is made via `HTTP::Tiny->post` with an explicit `Content-Type:
application/json` header. Response handling updated from LWP's object
interface (`$rsp->is_success`, `$rsp->content`, `$rsp->status_line`) to
HTTP::Tiny's hashref interface (`$rsp->{success}`, `$rsp->{content}`,
`$rsp->{status}`, `$rsp->{reason}`).

### Build

`release-notes.mk` added, providing a `make release-notes` target consistent
with the other distributions in this family.

---

## Dependency Changes

Removed: `LWP::UserAgent`, `HTTP::Request`

Added: `HTTP::Tiny` (core since Perl 5.14)

---

## Upgrade Notes

`HTTP::Tiny` requires `IO::Socket::SSL` and `Net::SSLeay` for HTTPS. The
GitHub API endpoint is HTTPS so these must be installed. They were previously
pulled in transitively via LWP and are now explicit dependencies.
