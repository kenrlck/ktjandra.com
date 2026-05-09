// @ts-check
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';

import cloudflare from '@astrojs/cloudflare';

// Cowork sandbox cannot unlink files inside the mounted workspace, so we send
// build artifacts to /tmp during local previews. Cloudflare Pages will use the
// default `dist/` at deploy time (CI doesn't share this constraint).
const isCowork = process.env.COWORK_BUILD === '1';

// https://astro.build/config
export default defineConfig({
  site: 'https://ktjandra.com',
  integrations: [mdx(), sitemap()],

  ...(isCowork
      ? {
              outDir: '/tmp/ktjandra-dist',
              cacheDir: '/tmp/ktjandra-cache',
          }
      : {}),

  adapter: cloudflare(),
});