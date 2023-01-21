import * as axios  from "axios";
import * as cheerio from "cheerio";
import * as moment from "moment";

interface Genre {
    id: string;
    name: string;
}

type RankingTags = Array<Genre & { tags: string[] }>;

(async () => {
    const genres = await fetchRankingGenreList();
    const tags: RankingTags = [];

    for (const genre of genres) {
        tags.push({
            id: genre.id,
            name: genre.name,
            tags: await fetchRankingTagList(genre.id),
        });
    }

    const category_list = {
        version: moment.default().format("YYYYMMDD"),
        category_list: tags,
    };

    console.log(JSON.stringify(category_list, null, "  "));
})();

async function fetchRankingGenreList(): Promise<Genre[]> {
    const client = axios.default;
    const result = (await client.get("https://www.nicovideo.jp/ranking")).data;
    const dom = cheerio.load(result);

    const genre: Genre[] = [];
    dom(".RankingGenreListContainer").find("li").find("a").each((_, element) => {
        if (!("attribs" in element)) {
            return;
        }

        if (!("href" in element.attribs)) {
            return;
        }

        const path = element.attribs["href"];
        const matches = path.match(/^\/ranking\/genre\/([^?\/]+)/);
        if (matches === null) {
            return;
        }

        genre.push({
            id: matches[1],
            name: dom(element).text().trim(),
        });
    });

    return genre;
}

async function fetchRankingTagList(genre: string) {
    const url = "https://www.nicovideo.jp/ranking/genre/" + genre;
    const client = axios.default;
    const result = (await client.get(url)).data;
    const dom = cheerio.load(result);

    const tags: string[] = [];
    dom(".RepresentedTagsContainer").find(".RankingFilterTag").each((_, element) => {
        const tag = dom(element).text().trim();
        if (tag !== "すべて") {
            tags.push(tag);
        }
    });

    return tags;
}
