import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const baseSchema = (image: () => any) =>
	z.object({
		title: z.string(),
		description: z.string(),
		pubDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		heroImage: z.optional(image()),
		draft: z.boolean().default(false),
		tags: z.array(z.string()).optional(),
	});

const work = defineCollection({
	loader: glob({ base: './src/content/work', pattern: '**/*.{md,mdx}' }),
	schema: ({ image }) =>
		baseSchema(image).extend({
			role: z.string().optional(),
			collaborators: z.array(z.string()).optional(),
		}),
});

const travel = defineCollection({
	loader: glob({ base: './src/content/travel', pattern: '**/*.{md,mdx}' }),
	schema: ({ image }) =>
		baseSchema(image).extend({
			location: z.string().optional(),
		}),
});

const opinions = defineCollection({
	loader: glob({ base: './src/content/opinions', pattern: '**/*.{md,mdx}' }),
	schema: ({ image }) => baseSchema(image),
});

export const collections = { work, travel, opinions };
