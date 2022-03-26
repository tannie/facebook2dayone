# Facebook -> day one

## Steps

### Get zip-file from Facebook

Download your data  at [download information](https://www.facebook.com/dyi/?referrer=yfi_settings) in JSON format, and unzip it.  

Normally it will download into your 'Downloads' folder and you can double-click it to unzip it. Depending on your settings, it might automatically unzip itself. You'll then have a folder with your name (or the name you use on Facebook).   

It will look something like this:
* Downloads
	* \<yourname\>
		* activity_messages
		* comments_and_reactions
		* communities
		* groups
		* messages
		* other_activity
		* pages
		* polls
		* posts
		* saved_items_and_collections
		* stories  

### Install command-line tool for DayOne

Make sure the dayone2 executable is on your PATH (select DayOne > Install Command Line Tools...). You only have to do this once.

### Download the script and edit (or delete) 'config'

Download 'fb2do.rb' from this page. If you are familiar with using git on the command-line you can do:  
`git checkout git@github.com:tannie/facebook2dayone.git`

You can also click on the green 'CODE' button at the top and click 'download zip'. This will download a zipfile with the script, a config file and this file. Again, double-click to unzip if it hasn't done it automatically.

Your 'Downloads' folder now looks like this:
* Downloads
  - \<yourname\>
	* activity_messages
	* comments_and_reactions
	* communities
	* (etc)
  - fb2do.rb
  - config
  - README.md

'README.md' is the file you are reading now

'config' contains the following:

	journal: Facebook
	timezone: Europe/Amsterdam

You can open this file with any text-editor to change the timezone. You can also delete the file if you don't care about the correct times, but if you don't, the script will create entries based on the timezone in Amsterdam.

### Run the script

In Finder go to 'Applications' and then 'Utilities'. Open 'Terminal.app'

Then type:

`~/Downloads/fb2do.rb ~/Downloads/<yourname>/posts/your_posts_1.json` (press enter)

(The '~' means your user-folder, where you keep all your documents and downloads)

The script will run and you'll see output like this:

	2022-02-21 14:18:46
	 (1645449526)

	2022-03-04 15:58:18
	 (1646405898)

	2022-03-05 19:26:40
	 (1646504800)
	media pic found

The long numbers show the timestamp in seconds (as they appear in the Facebook data). 
~~Once it's done, copy the last long number somewhere (I'll see if I can make it save it for later)~~
Scratch that! The script will now save the last timestamp to "~/.lastFBpost"

If you already imported posts before, the script will read this timestamp and skip everything before that time. This will also work if you create a new archive on Facebook and download all your data again, later.
You can also add a timestamp as an argument to make it go from there (this overrides the last saved timestamp)

`~/Downloads/fb2do.rb ~/Downloads/<yourname>/posts/your_posts_1.json 1646405898` (press enter)


 ## (former) Future plans:

- [x] save last timestamp for future use
- [x] check the timestamp, compare to optional argument and only import later posts
- [x] replace @[xxxxx:2048:Name of person] with a link to their profile (the xxxx is a number that makes it possible to use https://www.facebook.com/xxxxx to get to their profile)
- [x] add people's names when they are tagged
- [ ] if external url is image, download and add to entry
- [ ] \(Optional\) import only one post, based on timestamp
- [ ] import group posts



## General info:

This script does require you to use a terminal (it's not that scary!)

**Important note**: if you use Facebook in a different language than English these texts ('updated their status', etc) will be in your selected language. You may or may not have to changed the 'timeline' part in the code (you can do it!)

Some of my posts ended up 'empty', but when I look at the file I get from Facebook, it also has nothing but a timestamp there. This mostly seems to happen when I share a friend's posts and don't type my own message. If I do type a message, it only shows the message. I can't do anything about it, because I don't have the data for the linked post... (still trying to find if it's hidden in the archive, somewhere). I've edited the script to skip these posts so you don't get empty DO-entries.

The script will post photos that are attached to the post (head's up, some of mine seemed damaged...), and will only post the link for a post if the post text doesn't contain it. 

Normally, the 'title' of a post is something like 'Tannie updated her status' or 'Tannie uploaded a photo'. I don't add these to the post-text.
I've made an exception for Goodreads, where I use the title as the post-text, *and** where it says 'Tannie posted to xxxx's timeline', because that usually is a birthday-wish or some silly photo/video/link I found.

If you want to chop your posts-file into smaller sections, feel free to use [this gist](https://gist.github.com/tannie/23872e8f265a7077c875162d5ae348a0)
