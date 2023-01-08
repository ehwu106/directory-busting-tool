require 'net/http'
require 'erb'
require "optparse"

def draw(url, wordlists, num_threads)
	puts '==============================================================='
	puts 'DirBreaker: Directory Buster', 'By Howard Wu'
	puts '==============================================================='
	puts "$ Threads: #{num_threads}", "$ Target url: #{url}", "$ HTTP method: GET", "$ Wordlist: #{wordlists}"
	puts '==============================================================='
	puts 'Begin Enumerating....'
	puts '==============================================================='
	return
end

def dirb_busting_with_threads(url, wordlists, num_threads)
    fd = File.open(wordlists)#get file descripter of the wordlist
    file_content = fd.readlines
    threads=[]
    count=0
    display_thread = Thread.new do
        loop do
            break if count>=file_content.length()
            print "Progress: #{count.to_s}/#{(file_content.length()).to_s}~\r"
        end
        puts "Progress: "
    end
    words_to_test_per_thread = (file_content.length() / num_threads.to_f).ceil#this line gets the integer value of the num of words in wordlists divided by the num of threads and take the ceiling of it for each thread to test
    new_groups = file_content.each_slice(words_to_test_per_thread).to_a#slice the list of words in the wordlists into sub array with size of words_to_test_per_thread
    new_groups.each_with_index do |sub_group, index|#loop through each of the sub array and create new thread
    	thread = Thread.new do
    		sub_group.each do |word|#loop through sub array of the word lists
    			response = Net::HTTP.get_response(URI(url+'/'+ERB::Util.url_encode(word.chomp)))#make a HTTP request using the word as a path
    			if response.code != '404'#if we receive 200 status code that means the path exists and we print out to stdout	
            			puts "(Status Code): "+response.code+" | "+url+'/'+word.chomp			
        		end
        		count=count+1		
    		end
    	end
    	threads << thread
    end
    fd.close
    display_thread.join
    threads.each(&:join)
    return
end

def is_url?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
end

def main ()
    url=''
    wordlist=''
    threads=15
    options = {}
    while true
        OptionParser.new do |opts|
            opts.on("-t VALUE") do |value|
                threads=value.to_i
            end
            opts.on("-h") do
                puts 'Usage:'
                puts '  dirbreaker [command]'
                puts ''
                puts 'Available Commands:'
                puts '  dir         Directory/file enumeration mode (default)'
                puts '  fuzz        Fuzzing mode. Replace the keyword FUZZ in the URL, headers and the request body'
                puts ''
                puts 'Flags:'
                puts '  -h, help menu           help for the tool'
                puts '  -t, threads int         number of concurrent threads (default is 15)'
                puts '  -u, target URL          the url of the target (exclude "/" at the end e.g http://example.com)'
                puts '  -w, wordlist string     path to the wordlist'
                puts ''
                exit(0)
            end
            opts.on("-u VALUE") do |value|
                url=value
            end
            opts.on("-w VALUE") do |value|
                wordlist=value
            end
            opts.on("dir") do
                #do nothing
            end
        end.parse!
        if url.empty? or wordlist.empty?
            puts 'Please refer to the help menu by typing: dirbreaker -h'
            exit(0)
        end
        break    
    end
    if !is_url?(url)
    	puts 'Please provide a valid URL: (e.g http://example.com)'
    	exit(0)
    end
    start = Time.now
    draw(url, wordlist, threads)
    dirb_busting_with_threads(url, wordlist, threads)
    elapsed_time = Time.now - start
    puts "Finished"
    puts "Elapsed time: #{elapsed_time} seconds"
    puts '==============================================================='
end

main
