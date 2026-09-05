FLUIDD_VERSION:=$(file < upstream-ref)
OUTPUT_BASE:=fluidd-$(FLUIDD_VERSION)

TYPES := stock prefix

SQUASHES = $(foreach s,$(TYPES),$(OUTPUT_BASE)-$s.sfs)

PODMAN=podman
MKSQUASHFS=mksquashfs
GIT=git

all: $(SQUASHES)

$(OUTPUT_BASE)-%.sfs: dist.%/index.html src.timestamp
	$(MKSQUASHFS) dist.$* $@ \
		-reproducible \
		-all-time $(file < src.timestamp) \
		-mkfs-time $(file < src.timestamp) \
		-all-root \
		-action 'chmod(ugo=rwX)@true' \
		-noappend


dist.stock/index.html: FLUIDD_BASE=/
dist.prefix/index.html: FLUIDD_BASE=/fluidd
dist.%/index.html: workspace.container src/.git/HEAD src.timestamp
	[ -d dist.$* ] || mkdir dist.$*
	$(PODMAN) run --rm \
		-v $(CURDIR)/src:/mnt/src:O \
		-v $(CURDIR)/dist.$*:/mnt/dist:rw -w /mnt/src \
		-u node --userns keep-id:uid=1000 \
		-e SOURCE_DATE_EPOCH=$(file < src.timestamp) \
		$(file < workspace.container) sh -c \
		'ln -sTf /mnt/dist /mnt/src/dist && pnpm ci && npm run build -- --base $(FLUIDD_BASE)'

src.timestamp: src/.git/HEAD
	$(GIT) --git-dir src/.git --work-tree src show --no-patch --format=%ct HEAD > $@

workspace.container: workspace/Dockerfile
	$(PODMAN) build workspace --iidfile-raw=$@


src/.git/HEAD: upstream-ref
	$(GIT) clone --filter=blob:none https://github.com/fluidd-core/fluidd.git -b $(FLUIDD_VERSION) src
