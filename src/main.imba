global css details summary::-webkit-details-marker bg: none
global css details > summary list-style: none
# global css a@important c:cooler4

def fixInnerHtml
	$1..replace(/<pre>/, '<div style="background-color: tan;">')..replace /<\/pre>/, '</div>'

# def fetchson url\string
# 	const resp = await fetch($1)
# 	if !response.ok {
# 		throw new TypeError "Bad response status"
# 	}

# 	const cloned = response.clone()
# 	cache.put(url, cloned)

# 	return resp


# 	fetch(url).then(do(response)
# 		return 


tag NewsComment
	#show_kids = no
	#comment\({ kids?: number[]; by:string; text: string } | undefined)
	comment_id\number

	def awaken
		#comment = await window.fetch("https://hacker-news.firebaseio.com/v0/item/{comment_id}.json").then do(r) r.json!
		imba.commit!

	def fetch_children
		return if #show_kids or !#comment.kids
		#show_kids = yes
		imba.commit!

	def render
		<self>
			if #comment
				<a[c:cooler4] href="https://news.ycombinator.com/user?id={#comment.by}"> #comment.by
				if #comment..kids..length > 0
					<details open=false @toggle=fetch_children!>
						<summary innerHTML=fixInnerHtml(#comment.text)>
						if #show_kids
							<ul>
								<NewsComment comment_id=kid> for kid in #comment.kids
				else
					<li innerHTML=fixInnerHtml(#comment.text)>
			else
				<li> "Empty"

			<br>

tag NewsArticle
	story_id\number
	#story\any
	#show_comments = no

	def awaken
		#story = await window.fetch("https://hacker-news.firebaseio.com/v0/item/{story_id}.json").then do(r) r.json!
		imba.commit!

	def fetch_kids
		return if #show_comments or !#story.kids
		#show_comments = yes
		imba.commit!

	def render
		<self>
			if #story
				<details open=false @toggle=fetch_kids!>
					<summary> #story.title + " / "
						<a[c:cooler4] href=#story.url> "link"
					if #story..kids..length > 0
						<ul>
							<NewsComment comment_id=kid> for kid in #story.kids
			else
				<li> "Empty"

tag NewsArticles
	#stories\any[]

	def awaken
		#stories = await window.fetch("https://hacker-news.firebaseio.com/v0/topstories.json").then do(r) r.json!
		imba.commit!

	def render
		<self>
			<ul.tree-view[ofy:scroll pos:relative h:90ch]>
				if #stories
					for story_id, idx in #stories
						break if idx > 50
						<NewsArticle story_id=story_id>
				else
					<h1> "Empty"
 
tag app
	def render
		<self>
			<.window[h:100vh]>
				<.title-bar>
					<.title-bar-text> "Hacker News"
					<div.title-bar-controls>
						<button aria-label="Minimize">
						<button aria-label="Maximize">
						<button aria-label="Close">
				<.window-body>
					<NewsArticles.container.mx-auto[w:60%]>
					# <menu role="tablist">
# 			<div class="title-bar">
#     <div class="title-bar-text">A Window With Tabs and Groups</div>
#     <div class="title-bar-controls">
#       <button aria-label="Minimize"></button>
#       <button aria-label="Maximize"></button>
#       <button aria-label="Close"></button>
#     </div>
#   </div>

imba.mount <app>