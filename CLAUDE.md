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
│   │   └── FormattedDate.astro
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
description: "Required string — used in OG previews and section listings"
pubDate: 2026-05-03                # required, ISO date
updatedDate: 2026-06-01            # optional
heroImage: ./relative-image.jpg    # optional, path relative to the .md file
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

## Loose ends as of last session (2026-05-03)

- `SITE_DESCRIPTION` in `src/consts.ts` still uses the original "Robotics engineer at Raise Robotics..." copy. New homepage framing isn't reflected in OG/social previews yet.
- `/about` page bio is still robotics-only; doesn't mention tennis or photography.
- `src/content/opinions/welcome.md` is a Claude-written placeholder. Either ship as-is, rewrite, or delete.
- No OG image generation — link previews show text only.
- No www → apex redirect rule on Cloudflare. Both URLs serve the same content; canonical meta tag handles SEO but a 301 would be tidier.
- The Astro starter's example blog posts at `src/content/blog/` are orphaned (no collection loads them). They can be deleted via Cowork's file-delete tool when convenient.

## Quick re-onboarding for Claude

1. Read this file.
2. Read the user's global CLAUDE.md and the ABOUT ME folder if available.
3. Read `MEMORY.md` in Claude's auto-memory dir if present.
4. Don't re-decide stack, design, or aesthetics — those are settled. Push back only if Kenrick asks for a change.
5. When making content edits: edit, build, screenshot, show, iterate.
6. When making structural edits (routes, collections, layouts): edit, build, verify pages still render at all paths, then push.
