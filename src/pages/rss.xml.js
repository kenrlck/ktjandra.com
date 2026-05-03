import { getCollection } from 'astro:content';
import rss from '@astrojs/rss';
import { SITE_DESCRIPTION, SITE_TITLE } from '../consts';

export async function GET(context) {
	const [work, travel, opinions] = await Promise.all([
		getCollection('work', ({ data }) => !data.draft),
		getCollection('travel', ({ data }) => !data.draft),
		getCollection('opinions', ({ data }) => !data.draft),
	]);

	const items = [
		...work.map((p) => ({ ...p.data, link: `/work/${p.id}/` })),
		...travel.map((p) => ({ ...p.data, link: `/travel/${p.id}/` })),
		...opinions.map((p) => ({ ...p.data, link: `/opinions/${p.id}/` })),
	].sort((a, b) => b.pubDate.valueOf() - a.pubDate.valueOf());

	return rss({
		title: SITE_TITLE,
		description: SITE_DESCRIPTION,
		site: context.site,
		items,
	});
}
