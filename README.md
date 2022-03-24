# Facebook -> day one
Download your data  at [download information](https://www.facebook.com/dyi/?referrer=yfi_settings) in JSON format, and unzip it to \<path\>

Optionally you can create a 'config' file:

`journal: Facebook`

`timezone: Europe/Amsterdam`

at the same locating from where you run the script (or edit the path)

Alternatively edit line 4 in the script:
`opts = { 'journal' => 'Facebook', 'timezone' => nil }`


Then do:

`./fb2do.rb <path>/posts/your_posts.json`

If you already imported posts before, use the timestamp (in seconds) from the last post you imported as an argument. The script will skip everything before that time.

If you want to chop your posts-file into smaller sections, feel free to use [this gist](https://gist.github.com/tannie/23872e8f265a7077c875162d5ae348a0)

 ## Future plans:
✓ check the timestamp, compare to optional argument and only import later posts


## General info:

This script does require you to use a terminal (it's really not that scary!)
Some of my posts end up 'empty', but when I look at the file I get from Facebook, it also has nothing but a timestamp there. This mostly seems to happen when I share a friend's posts and don't type my own message. If I do type a message, it only shows the message. I can't do anything about it, because I don't have the data for the linked post... (still trying to find if it's hidden in the archive, somewhere).

The script will post photos that are attached to the post (head's up, some of mine seemed damaged...), and will only post the link for a post if the post text doesn't contain it. 

Normally, the 'title' of a post is something like 'Tannie updated her status' or 'Tannie uploaded a photo'. I don't add these to the post-text.
I've made an exception for Goodreads, where I use the title as the post-text, and where it says 'Tannie posted to xxxx's timeline', because that usually is a birthday-wish or some silly photo/video/link I found.

Important note: if you use Facebook in a different language than English these texts ('updated their status', etc) will be in your selected language. You may or may not have to changed the 'timeline' part in the code (you can do it!)
