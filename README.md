# Squashed Fluidd

## SYNOPSIS

Tooling squashfs releases of [Fluidd](https://github.com/fluidd-core/fluidd)

## Squashes

The squash bundles are world-readable, owned by root, and all timestamps are set to that of the commit it was built from.

The `-stock` squash is comparable to the `fluidd.zip` provided by upstream.

The `-prefix` squash is built to be served at `/fluidd`.

## Building

On a system with `make`, `git`, `podman`, `mksquashfs`, and at least 1000 subuids/subgids for the current user:

```bash
git clone https://github.com/Laikulo/fluidd-squashed.git
cd fluidd-squashed.git
make
```

## Usage

```bash
mount fluidd-VERSION-prefix.sfs /srv/www/fluidd
```

## Prebuild squashes
Only full releases from upstream will be published here, they will be attached to github releases with the same name as the parent project.

The tags of these releases will point to the tool version that was used to build them, including an upstream-ref.

There is currently no offical timeline, but three business days (excluding vacation/holidays) is an aspirational goal.
