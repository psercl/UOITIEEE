# UOITIEEE

# Editing Locally

1. Install Ruby (if needed)
2. Install Jekyll, `gem install jekyll`
3. Clone this repository, `git@github.com:MooseV2/UOITIEEE.git`
4. `cd UOITIEEE`
5. Make changes
6. Run with `jekyll serve` to make sure it worked
7. Add the files you changed, `git add -A`
8. Write a commit message, `git commit -m "Updated <...>"`
9. Push your changes, `git push`
10. ???
11. Profit

# Creating a post

1. Create a file in `_posts` with a filename in this format: `2017-01-01-post-name.md`
2. Add the following front matter to the file:
```YAML
---
title: Post title
layout: post
image: post-image.jpg
---
```
3. Place the corresponding image in `assets/images/`
4. Fill the rest of the file with [markdown formatted text](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).

# Adding events

Edit `_data/events.yml`. Follow the examples below.

```YAML
# Simplest event format
- name: Halloween
  start: 2017-10-31

# Event with start/end times (NOTE: Must use quotes with time)
- name: Workshop A
  start: '2017-11-10T15:00:00'
  end: '2017-11-10T17:00:00'

# Event with url, yellow background, and red text
- name: IEEE Day
  start: 2017-10-03
  url: /IEEE-day/
  colour: 'yellow'
  textColour: 'red'

# Event with external URL
- name: Online Infosession
  start: 2017-11-10
  url: 'http://google.com'
```

# Adding McNaughton Centre Access

Follow the same format as above for `_data/access.yml`

# Adding/changing executive information

Edit `_data/execs.yml` and follow the example below.

```YAML
- name: Joe Blow
  position: Treasurer
  desc: >-
    Hello, I'm the guy that takes care of keeping the jazz in your life. 
    Stay classy, Atlanta!

- name: Jimmy Johnson
  position: Marketing
  desc: >-
    I've got Photoshop, I know HTML, and I can get you to BUY a PRODUCT.
``` 

# Changing featured items on the home page

Edit `_data/featured.yml` and follow the example below.

```YAML
# Simple post with a title and external url
- name: hello-word
  title: Hello World
  url: https://google.ca

# Post with custom excerpt text
- name: ieeextreme11
  title: IEEEXtreme 11.0
  excerpt: The IEEEXtreme Programming Competition

# Post with custom image
- name: sign-up
  url: /hello/
  title: Sign up to the IEEE Student Branch at UOIT
  image: signup.jpg
```
Place images in `/assets/images`. If `title`, `url`, `excerpt`, or `image` are missing, they will be pulled from the post with the matching `name`.
