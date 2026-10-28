# Hosting

Personal deployment of PhotoCraft's web build at <https://photocraft.nandan.fyi>
(Cloudflare Workers static assets, custom domain on the `nandan.fyi` zone).

Everything specific to this deployment lives in this directory; the rest of the tree
is untouched upstream code, so syncing never conflicts.

- `update.sh [tag]`: syncs the fork with `upstream`, downloads the latest release's
  `photocraft-web-<ver>.zip`, deploys it with Wrangler, and records the tag in `DEPLOYED`.
- `wrangler.jsonc`: Worker name, static-assets directory, custom domain.
- `site/`: unpacked release (git-ignored).
