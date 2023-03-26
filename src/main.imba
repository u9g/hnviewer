global css details summary::-webkit-details-marker bg: none
global css details > summary list-style: none

tag NewsComment
	#comments\any[] = []
	#fetched = no
	comment\any

	def fetch_children
		return if #fetched or !comment.kids
		console.log(comment)
		#comments = await Promise.all(comment.kids.map do(id)
			(window.fetch("https://hacker-news.firebaseio.com/v0/item/{id}.json").then(do(r) r.json!)))
		#fetched = yes
		imba.commit!

	def render
		<self>
			if comment..kids > 0
				<details open=false @toggle=fetch_children!>
					<summary innerHTML=comment.text>
					if #fetched
						<ul>
							<NewsComment comment=data> for data in #comments
			else
				<li innerHTML=comment.text>

tag NewsArticle
	story_id\number
	#story\any
	#comments\any[] = []
	#fetched = no

	def awaken
		#story = await window.fetch("https://hacker-news.firebaseio.com/v0/item/{story_id}.json").then do(r) r.json!
		imba.commit!

	def fetch_kids
		return if #fetched or !#story.kids
		#comments = await Promise.all(#story.kids.map do(id)
			(window.fetch("https://hacker-news.firebaseio.com/v0/item/{id}.json").then(do(r) r.json!)))
		#fetched = yes
		imba.commit!

	def render
		<self>
			if #story
				<details open=false @toggle=fetch_kids!>
					<summary> #story.title
					if #comments..length > 0
						<ul>
							if #comments.length > 0
								<NewsComment comment=data> for data in #comments
							else <li> "Hey"
			else
				<li> "Empty"


tag NewsArticles
	#stories\any[]

	def awaken
		let res = await window.fetch("https://hacker-news.firebaseio.com/v0/topstories.json")
		#stories = await res.json!
		imba.commit!

	def render
		<self>
			<ul.tree-view>
				if #stories
					for story_id, idx in #stories
						break if idx > 50
						<NewsArticle story_id=story_id>
				else
					<h1> "Empty"
 
tag app
	def render
		<self>
			<NewsArticles.container.mx-auto[w:60%]>

imba.mount <app>