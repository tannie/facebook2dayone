#!/usr/bin/ruby

require "json"
require "csv"
opts = { 'journal' => 'Facebook', 'timezone' => nil }
if File.file?('config')
  IO.readlines("config").each do |ec|
    a = ec.strip.split(/\s*:\s*/)
    opts[a[0]] = a[1]
  end
end
extraoptions = "-j #{opts['journal']} "
$dir = File.dirname(File.expand_path(ARGV[0]))

if (opts['timezone'] != nil)
  extraoptions.concat("-z #{opts['timezone']} ")
end
bytes_re = /((?:\\\\)+|[^\\])(?:\\u[0-9a-f]{4})+/

txt = File.read(ARGV[0]).gsub(bytes_re) do |bad_unicode|
  $1 + eval(%Q{"#{bad_unicode[$1.size..-1].gsub('\u00', '\x')}"}).to_json[1...-1]
end

facebook = JSON.load(txt)

facebook.each do |item|
  humandate = `/bin/date -r #{item['timestamp']} '+%Y-%m-%d %H:%M:%S'`
  puts "\n#{humandate} (#{item['timestamp']})"
  next if ARGV[1].to_i + 1 > item['timestamp']

  # puts item['title']
  alloptions = extraoptions
  postTextComplete = ""
  location = ""
  photooptions = ""
  #  unless (defined?(item['data'][0]['post'])).nil?
  if item['title'].to_s["Timeline"]
    postTextComplete.concat("#{item['title']}\n\n")
  end
  if item['title'].to_s["timeline"]
    postTextComplete.concat("#{item['title']}\n\n")
  end
  if defined?(item['attachments'][0]['data'][0]['media']['description'])
	posttext = "#{item['attachments'][0]['data'][0]['media']['description']}"
    postTextComplete.concat("#{posttext}")
  elsif defined?(item['data'][0]['post'])
    # puts item['data'][0]['post']
    posttext = "#{item['data'][0]['post']}"
    postTextComplete.concat("#{posttext}")
  else
    posttext = "#{item['title']}"
    postTextComplete.concat("#{posttext}")
  end
unless (defined?(item['tags'][0])).nil?
	people = []
	item['tags'].each do |person|
	people << person['name'] 
	end
	postTextComplete.concat("\n👥: ")
	postTextComplete.concat(people.to_csv.gsub(/,/,', '))
end
  unless (defined?(item['attachments'][0])).nil?
    item['attachments'].each do |attachment|
      # puts "attachment"
      unless (defined?(item['attachments'][0]['data'])).nil?
        item['attachments'].each do |attachments|
          # puts "checking places"
          unless (defined?(attachments['data'][0]['place'][0])).nil?
            attachments['data'].each do |key1, value1| # each item
              unless (defined?(key1['place']['coordinate']['latitude'])).nil?
                puts "place found"
                latitude = key1['place']['coordinate']['latitude']
                longitude = key1['place']['coordinate']['longitude']
                location = " --coordinate #{latitude} #{longitude}"
              end # coordinates
            end # each place
          end # place
          # puts "checking media"
          unless (defined?(attachments['data'][0]['media'][0])).nil?
            photooptions.concat(" -p")
            attachments['data'].each do |key1, value1|
              unless (defined?(key1['media']['uri'])).nil?
                puts "media pic found"
                dir = File.dirname(File.expand_path(ARGV[0]))
                newdir = dir.gsub("posts", "")
                photooptions.concat(" #{newdir}/#{key1['media']['uri']}")
              end # unless media uri defined
            end # each attachment for media
          end # unless media defined
          # puts "checking urls"
          unless (defined?(attachments['data'][0]['external_context'][0])).nil?
            if (item['attachments'][0]['data'][0]['external_context']['source'] == "Goodreads")
                  if (item['attachments'][0]['data'][0]['external_context']['name'] == nil)
                    postTextComplete.concat("\n\n#{url}")
                  else
                    url = attachments['data'][0]['external_context']['url']
                    urltitle = item['attachments'][0]['data'][0]['external_context']['name']
                    postTextComplete.concat("\n[#{urltitle}](#{url})")
                  end # external context name
            else
              # print "ext is defined\n"
              unless (defined?(attachments['data'][0]['external_context']['url'])).nil?
                url = attachments['data'][0]['external_context']['url']
                if posttext["#{url}"]
                # do nothing
                else
                  if (item['attachments'][0]['data'][0]['external_context']['name'] == nil)
                    postTextComplete.concat("\n\n#{url}")
                  else
                    urltitle = item['attachments'][0]['data'][0]['external_context']['name']
                    postTextComplete.concat("\n#{urltitle}\n\n#{url}")
                  end # external context name
                end # check for url in posttext
              end
            end # goodreads
          end # external context
        end # each attachments
      end # unless attachments
    end
  end # defined attachments
  #puts postTextComplete.length
  next if postTextComplete.length < 1
  #puts postTextComplete
  postTextComplete.gsub!(/@\[([0-9]*)\:[0-9]*\:(.*)\]/,'[\2](https://www.facebook.com/\1)')
  #puts postTextComplete

  f = File.new("/tmp/" + `uuidgen`.strip + ".txt", "w+")
  f.puts postTextComplete
  f.close

  cmd = `cat #{f.path.strip} | dayone2 new  -d '#{humandate}' #{alloptions} #{location} #{photooptions}`
  # puts cmd
end
