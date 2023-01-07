require 'net/http'

def draw(url, wordlists, num_threads)
	puts '-----------------------------------------'
	puts 'MY_TOOL_NAME', 'By Howard Wu'
	puts '-----------------------------------------'
	puts "$ Threads: #{num_threads}", "$ Target url: #{url}", "$ HTTP method: GET", "$ Wordlist: #{wordlists}"
	puts '-----------------------------------------'
	return
end

def dirb_busting_with_threads(url, wordlists, num_threads)
    fd = File.open(wordlists)								                            #get file descripter of the wordlist
    file_content = fd.readlines
    threads=[]
    words_to_test_per_thread = (file_content.length() / num_threads.to_f).ceil		    #this line gets the integer value of the num of words in wordlists divided by the num of threads and take the ceiling of it for each thread to test
    new_groups = file_content.each_slice(words_to_test_per_thread).to_a			        #slice the list of words in the wordlists into sub array with size of words_to_test_per_thread
    new_groups.each_with_index do |sub_group, index|					                #loop through each of the sub array and create new thread
    	thread = Thread.new do
    		sub_group.each do |word|						                            #loop through sub array of the word lists
    			response = Net::HTTP.get_response(URI("#{url}/#{word.chomp}"))	        #make a HTTP request using the word as a path
    			if response.code == 200						                            #if we receive 200 status code that means the path exists and we print out to stdout	
            			puts "Found directory: #{url}/#{word.chomp}"
        		end	
    		end
    	end
    	threads << thread
    end
    fd.close
    threads.each(&:join)
    return true
end

def dirb_busting(url, wordlists)
    fd = File.open(wordlists)
    file_content = fd.readlines
    file_content.each {|word|
        response = Net::HTTP.get_response(URI("#{url}/#{word.chomp}"))
        if response.code == 200
            puts "Found directory: #{url}/#{word.chomp}"
        end
    }
    fd.close
    return
end


start = Time.now
stop=false
thread = Thread.new do
    loop do
        break if stop
        current_time = Time.now
        elapsed_time = current_time - start
        puts "Elapsed time: #{elapsed_time} seconds"
        sleep(0.1)
    end
end
draw('http://precious.htb', '/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt', 95)
stop=dirb_busting_with_threads('http://precious.htb', '/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt', 95)
thread.join
#dirb_busting('http://precious.htb', 'test.txt')
#puts Time.now - start
