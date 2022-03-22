# Facebook -> day one
Download your data  at [download information](https://www.facebook.com/dyi/?referrer=yfi_settings) in JSON format, and unzip it to \<path\>

Optionally you can create a 'config' file:

`journal: Facebook`

`timezone: Europe/Amsterdam`

at the same locating from where you run the script (or edit the path)

Alternatively edit line 4 in the script


Then do:

`./fb2do.rb <path>/posts/your_posts.json`


If you want to chop your post-file into smaller sections, feel free to use [this gist](https://gist.github.com/tannie/23872e8f265a7077c875162d5ae348a0)