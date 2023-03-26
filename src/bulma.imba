import { getRelativeTime } from './date.imba'

const topStories = await fetch("https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
	.then do(res) res.json()

# Promise<{title: string;url: string;}>[]
const topStoriesData = await Promise.all(topStories.slice(0, 50).map(do(id\number) {
	...await fetch(
		`https://hacker-news.firebaseio.com/v0/item/{id}.json?print=pretty`
	).then(do(res) res.json()),
	commentsUrl: "https://news.ycombinator.com/item?id={id}"
}))

topStoriesData.forEach do(el)
	el.title = el.title.match(/.{1,80}(?:\s|$)/g)[0] + " [...]" if el.title.length > 80
	el.date = getRelativeTime(new Date(el.time * 1000)).toString()

console.log(topStoriesData)

tag app
	def render
		<self.container>
			<div.box>
				<.container.is-size-3>
					"Hacker News at a glance / "
					<a[c:blue4] href="https://val.town" target="blank"> "Powered by val.town"

			for { title, url, score, commentsUrl, date, descendants } in topStoriesData
				<div.box>
					<.container.is-size-3>
						<span.tag.is-success.is-large> score
						" "
						<a[c:blue5] href=url target="blank"> title
						" / "
						<a[c:blue4] href=commentsUrl target="blank"> "{descendants} comments"
						" / posted {date}"


imba.mount <app>
