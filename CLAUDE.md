# ktjandra.com — project context for Claude

Drop this file into context at the start of a new session and you'll have everything you need to keep working on the site.

## Project at a glance

- **Site:** [ktjandra.com](https://ktjandra.com)
- **Owner:** Kenrick Tjandra (kenrick@raiserobotics.ai)
- **Stack:** Astro 6 (static) → GitHub → Cloudflare Pages → Cloudflare DNS → registrar at Porkbun
- **Aesthetic:** editorial, serif-forward (Source Serif 4 / Inter)
- **Theme:** auto light/dark via `prefers-color-scheme`
- **Cost:** ~$11/yr (Porkbun renewal). Hosting and DNS are free.
- **Voice:** Priya Krishna — warm, direct, opinionated, has rhythm. Avoid em-dash overuse, "genuinely", "honestly", "straightforward". Prose over bullet soup.

## Repo & deploy

- **GitHub:** `github.com/kenrick098/ktjandra.com` (public, personal account `kenrick098`)
- **Branch that deploys:** `main`
- **Build trigger:** every push to `main` triggers a Cloudflare Pages build automatically
- **Pages project name:** `ktjandra-com`
- **Pages preview URL:** `ktjandra-com.pages.dev`
- **Workers preview URL:** `ktjandra-com.kenrick098.workers.dev` (artifact of the unified Workers/Pages platform; same content as Pages)
- **Build command:** `npm run build`
- **Build output:** `dist/`

DNS lives on Cloudflare nameservers (`bob.ns.cloudflare.com`, `mia.ns.cloudflare.com`). The custom-domain attachment in the Pages project is what routes traffic; no manual DNS records were needed once DNS was on Cloudflare.

## Local paths

- **Workspace folder (source of truth):** `/Users/kenrick/Documents/Claude/Projects/website`
- **Inside Cowork bash sandbox, that maps to:** `/sessions/<session>/mnt/website`
- **Screenshot previews (gitignored):** `/Users/kenrick/Documents/Claude/Projects/website/_previews/`

## File structure

```
website/
├── astro.config.mjs              # site URL, integrations, /tmp redirect for Cowork builds
├── src/
│   ├── consts.ts                 # SITE_TITLE, SITE_DESCRIPTION, AUTHOR_*
│   ├── content.config.ts         # zod schemas for work/travel/opinions collections
│   ├── styles/global.css         # editorial CSS — fonts, color tokens, post-list, hero
│   ├── components/
│   │   ├── BaseHead.astro        # <head> meta, OG, canonical
│   │   ├── Header.astro          # site nav (Work / Travel / Opinions / About)
│   │   ├── Footer.astro          # © + RSS + email
│   │   ├── FormattedDate.astro
│   │   ├── Photo.astro           # single image w/ caption — default travel-post photo
│   │   ├── Photos.astro          # 2–3 portrait images side by side (portrait only)
│   │   └── FullBleed.astro       # full-viewport-width "money shot" — one per post max
│   ├── layouts/
│   │   ├── PostLayout.astro      # shared post wrapper for all 3 collections
│   │   └── BlogPost.astro        # ORPHANED — leftover from Astro starter, ignore
│   ├── pages/
│   │   ├── index.astro           # homepage (hero + intro paragraphs + recent writing)
│   │   ├── about.astro
│   │   ├── rss.xml.js            # aggregates all 3 collections into one feed
│   │   ├── work/
│   │   │   ├── index.astro       # section listing
│   │   │   └── [...slug].astro   # dynamic post route
│   │   ├── travel/{index,[...slug]}.astro
│   │   ├── opinions/{index,[...slug]}.astro
│   │   └── blog/                 # STUBS — original starter route, redirects to /
│   └── content/
│       ├── work/                 # .md or .mdx files; .gitkeep keeps the dir
│       ├── travel/
│       ├── opinions/
│       └── blog/                 # ORPHANED example posts from the starter; not loaded
├── deploy-init.sh                # one-shot first deploy (already used)
├── move-to-personal.sh           # ran once to move repo to personal GH
└── CLAUDE.md                     # this file
```

## Content schema

Frontmatter for any post in `src/content/{work,travel,opinions}/`:

```yaml
---
title: "Required string"
description: "Required string — used in OG previews, section listings, and the lede on the post page"
pubDate: 2026-05-03                # required, ISO date
updatedDate: 2026-06-01            # optional
heroImage: ./relative-image.jpg    # optional, ImageMetadata path relative to the .md file
heroImageUrl: "/biak/01.jpeg"      # optional, string URL under public/ — used by split-hero layout
heroLayout: "split"                # optional, "standard" (default) or "split"
draft: false                       # default false; true hides from build
tags: ["foo", "bar"]               # optional

# Travel collection only:
location: "Lisbon, Portugal"

# Work collection only:
role: "Lead engineer"
collaborators: ["Alice", "Bob"]
---
```

Posts can be `.md` or `.mdx`. MDX supports inline components.

## Travel post layout (settled)

These conventions came out of the Biak Pt. 2 build. Don't re-litigate; iterate inside them.

**Body column is 640px**, not 720px. Same width for site nav, footer, and full-bleed captions. Defined in `global.css` via `main`, `.site-header`, `.site-footer`, and `figure.full-bleed figcaption` max-widths.

### Reusable MDX components

Three components live in `src/components/` for use inside travel `.mdx` posts. Import at the top of every travel post:

```mdx
import Photo from '../../components/Photo.astro';
import Photos from '../../components/Photos.astro';
import FullBleed from '../../components/FullBleed.astro';
```

`<Photo src alt caption? wide? />` is the default. Single image at column width with a small breath-out (~30px past the column on each side). Most travel photos are this.

`<Photos images caption? />` or `<Photos>...</Photos>` puts 2–3 photos in a row. **Only use this for portrait-orientation source photos.** Side-by-side landscape was tried and looked bad (it forces a 4:5 crop). Landscape photos go single, period.

`<FullBleed src alt caption? />` breaks past the column to the viewport edges, capped at 85vh tall. **One per post, max.** Save it for the most impactful image — often near the close.

### Asymmetric split-hero opener (opt in)

For travel posts that earn it, open with a magazine-style two-column hero: title block on the left, photo on the right, ~85vh on desktop. Mobile collapses to single column with photo first.

Opt in via frontmatter:

```yaml
heroImageUrl: "/biak/01-frame.jpeg"
heroLayout: "split"
```

`heroImageUrl` is a string URL into `public/`. Without `heroLayout: split`, posts get the standard centered title block.

### Section headers (h2)

Travel posts use 2–4 h2 section breaks as natural pivots in the prose — bold serif at column width, large top margin. Encouraged, not required. They give the post a browseable shape.

### Captions

Sans-serif gray underneath the photo. **Short, often fragment-y.** "Cinnamon buns at Bread 41." energy. Avoid conversational over-explanation. If a caption is more than ~15 words, it's probably trying too hard.

### Photo workflow

1. Drop source photos in `public/<post-slug>/` (e.g., `public/biak/01-frame.jpeg`).
2. Reference as string URLs in MDX (`/biak/01-frame.jpeg`). This bypasses Astro's image optimization but keeps the workflow simple for a personal blog.
3. **Compress before commit.** Per-photo budget: 500KB–1MB. Whole-page budget: 3–5MB.

ImageMagick batch compression:

```bash
for f in public/<slug>/*.{jpg,jpeg,JPG,JPEG}; do
  [ -f "$f" ] || continue
  convert "$f" -auto-orient -resize "2400x2400>" -quality 80 -strip "$f.tmp" && mv "$f.tmp" "$f"
done
```

Caps longest dimension at 2400px, JPEG quality 80, strips EXIF, applies rotation metadata. Typical reduction: 70–80%.

## Local development

In a normal terminal on the user's machine:

```bash
cd ~/Documents/Claude/Projects/website
npm install              # first time only
npm run dev              # dev server at http://localhost:4321
npm run build            # production build into dist/
```

## Cowork sandbox build quirks

The Cowork mount at `/sessions/<session>/mnt/website` doesn't allow `unlink()`, which breaks `astro build` (it tries to clean its own `.vite` cache). Workaround used by previous sessions:

```bash
# 1. Mirror source into /tmp, install deps fresh there
mkdir -p /tmp/website-build
rsync -a --exclude='.astro' --exclude='dist' --exclude='node_modules' \
  /sessions/<session>/mnt/website/ /tmp/website-build/
cd /tmp/website-build && npm install --silent --no-audit --no-fund
npx astro build

# 2. For preview screenshots, playwright-chromium (ARM64) is installed at
#    /tmp/playwright-browsers/chromium-1217/chrome-linux/chrome
#    See /tmp/website-build/screenshot.mjs for the script that uses it.
```

This is only for in-session builds and screenshots. Cloudflare Pages CI builds natively from `dist/` and doesn't have this constraint.

## Workflow conventions

- **Kenrick provides:** drafts (text), revisions, photos, decisions.
- **Claude provides:** scaffolding, code, formatting, frontmatter, image optimization, deploy plumbing, screenshots.
- **Don't fill gaps with filler. Don't over-explain. Deliver the work** (per Kenrick's global CLAUDE.md).
- **When unclear, use AskUserQuestion** rather than guessing.
- **Iteration style:** show a draft, ask for picks/remixes, ship.
- **Tone audit:** Kenrick has anti-anti-AI-writing standards. Match Priya Krishna voice; avoid hedging, banned words, and over-formatting.
- **Layout review preview:** when iterating on layout, generate a self-contained `_preview/<slug>.html` (gitignored) that Kenrick can double-click. Inline the CSS, strip the site nav and footer (their absolute links break under `file://`), rewrite absolute `/biak/` paths to relative `biak/`, and copy the photo folder alongside. Fastest way to get a real-look review without a dev server.
- **Tall screenshots:** full-page playwright captures of long posts are often 10000+ px tall. Chat previews compress them and miscount of photos. Slice into 4 vertical chunks with `convert SRC -crop WxH+0+Y biak-section-N.png` for in-chat review.
- **Photo placement:** prefer one photo every 1–2 paragraphs. Rhythm beats density.
- **Captions in Claude's voice are placeholders.** When Claude writes a caption based on what it sees in a photo, flag it for Kenrick to verify — Claude will guess at people, places, and context. Kenrick corrects.

## Common commands

```bash
# Verify the live site
curl -sI https://ktjandra.com | head -10

# Push a content update
cd ~/Documents/Claude/Projects/website
git add -A && git commit -m "Update <thing>" && git push
# Cloudflare auto-deploys within ~90 seconds.

# Roll back a bad deploy
# Cloudflare dashboard → Pages → ktjandra-com → Deployments → "..." on a previous deploy → Rollback to this deployment
```

## Loose ends as of last session (2026-05-07)

- `SITE_DESCRIPTION` in `src/consts.ts` still uses the original "Robotics engineer at Raise Robotics..." copy. New homepage framing isn't reflected in OG/social previews yet.
- `src/content/opinions/welcome.md` is a Claude-written placeholder. Either ship as-is, rewrite, or delete.
- No OG image generation — link previews show text only.
- No www → apex redirect rule on Cloudflare. Both URLs serve the same content; canonical meta tag handles SEO but a 301 would be tidier.
- The Astro starter's example blog posts at `src/content/blog/` are orphaned (no collection loads them). Delete via Cowork's file-delete tool or in a regular terminal when convenient.

## Resolved 2026-05-07

- First travel post shipped: `/travel/biak-pt-2/` — split hero, three h2 section breaks, seven photos, ~5MB total page weight.
- Built `Photo` / `Photos` / `FullBleed` MDX components and codified rules above.
- Tightened body column 720 → 640px after NYT travel-piece layout study.
- Added split-hero opener (`heroLayout: split` + `heroImageUrl`) to schema and PostLayout.
- Bulk-compressed Biak photos 17MB → 5MB (max 2400px, q80, strip EXIF).
- `/about` bio updated by Kenrick during this session.
- Lisbon mock placeholder removed.

## Quick re-onboarding for Claude

1. Read this file.
2. Read the user's global CLAUDE.md and the ABOUT ME folder if available.
3. Read `MEMORY.md` in Claude's auto-memory dir if present.
4. Don't re-decide stack, design, or aesthetics — those are settled. Push back only if Kenrick asks for a change.
5. When making content edits: edit, build, screenshot, show, iterate.
6. When making structural edits (routes, collections, layouts): edit, build, verify pages still render at all paths, then push.
