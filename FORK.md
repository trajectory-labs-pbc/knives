# This fork

`trajectory-labs-pbc/knives` is the Trajectory Labs fork of
[sjawhar/knives](https://github.com/sjawhar/knives).

## Layout

- `main` is upstream's `main`, with no changes.
- `trajectory` is the default branch: an upstream release tag and a few commits on it. Each
  commit message ends with an `Upstream-Status:` line that says why it stays here.
- Each `v<upstream version>-trajectory.<n>` tag is a release, built by
  `.github/workflows/trajectory-release.yml`. The archive carries knives, the jj build that
  knives needs (`JJ_TAG` and `JJ_SHA256` in that workflow), and `packaging/knives.sh` as
  `bin/knives`. A rebase can replace the commit that a release tag points at; the tag stays.

Two settings are in GitHub, not in git:

- Upstream's `release.yml` is disabled, so a push to `main` makes no release.
- The ruleset "Release tags never move or vanish" stops a `v*` tag from moving or being deleted.
  It has no bypass, so after a failed release build, push the next `<n>`, not the same tag.

## Repositories this fork needs

- [trajectory-labs-pbc/toon-rust](https://github.com/trajectory-labs-pbc/toon-rust): its branch
  `knives-pin` holds the commit that `Cargo.toml` names.
- [trajectory-labs-pbc/jj](https://github.com/trajectory-labs-pbc/jj/releases): the jj build that
  matches the `jj-lib` version in `Cargo.toml`. CI uses the first release tagged
  `v<jj-lib version>-sami.*`, with no sha256 check. The release workflow uses `JJ_TAG`.

## Move to a newer upstream tag

1. Compare the `jj-lib` version in `Cargo.toml` at the new tag with the current one. If it
   changed, stop: a jj build of the new version must first be released on
   trajectory-labs-pbc/jj, and this repository has no procedure that makes one.
2. Rebase `trajectory` onto the new tag. Review it with
   `git range-diff <old tag>..<old head> <new tag>..trajectory`.
3. Run `git diff <old tag> <new tag> -- .github/workflows/release.yml` and copy what applies
   into `trajectory-release.yml`.
4. Push `trajectory` with `--force-with-lease`. When its CI passes, push the tag
   `v<new version>-trajectory.1`.
