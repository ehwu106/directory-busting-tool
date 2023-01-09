# DirBreaker: A Directory Busting Tool
DirBreaker is a tool for brute forcing URIs (directories/files) on a targeted website.

# License
[MIT License](LICENSE)

# Modes
- dir - the basic directory brute forcing
- fuzz - fuzzing, replaces the FUZZ word (soon to be released)
- dns - DNS subdomain brute forcing (soon to be released)

# Help Page
Refer to the help page by typing: `ruby dirbreaker.rb -h`
```bash
Usage:
  dirbreaker [command]

Available Commands:
  dir         Directory/file enumeration mode (default)
  fuzz        Fuzzing mode. Replace the keyword FUZZ in the URL, headers and the request body

Flags:
  -h, help menu           help for the tool
  -t, threads int         number of concurrent threads (default is 15)
  -u, target URL          the url of the target (exclude "/" at the end e.g http://example.com)
  -w, wordlist string     path to the wordlist
```
# Example
```bash
ruby dirb.rb -w /usr/share/wordlists/dirb/common.txt -u http://10.10.87.158 -t 95
```
The above command will give the following output:
```bash
===============================================================
DirBreaker: Directory Buster
By Howard Wu
===============================================================
$ Threads: 95
$ Target url: http://10.10.87.158
$ HTTP method: GET
$ Wordlist: /usr/share/wordlists/dirb/common.txt
===============================================================
Begin Enumerating....
===============================================================
(Status Code): 200 | http://10.10.87.158/
(Status Code): 301 | http://10.10.87.158/simple
(Status Code): 200 | http://10.10.87.158/robots.txt
(Status Code): 403 | http://10.10.87.158/.hta
(Status Code): 200 | http://10.10.87.158/index.html
(Status Code): 403 | http://10.10.87.158/.htaccess
(Status Code): 403 | http://10.10.87.158/server-status
(Status Code): 403 | http://10.10.87.158/.htpasswd
Progress: 4613/4614~
Finished
Elapsed time: 20.252706798 seconds
===============================================================
```
# Run
Since this tool is written in Ruby. Please refer to this page to install Ruby onto your local machine to run this tool: https://www.ruby-lang.org/en/. You could also build this as a docker container and run it without the need of installing Ruby onto your machine. Please refer to the Docker section of this README.
```bash
ruby dirbreaker [command] -t [number_of_threads] -u [target_url] -w [path_to_wordlist]
```
# Docker
Build the image using the below command. Make sure to run this in the same directory as the source code.
```bash
docker build -t dirbreaker .
```
Run it as a container using the below command. Replace the `[PATH_TO_WORDLIST]` and `[WORDLIST]` with the path and the wordlist file (eg subdomain_top1000.txt). Specify your flags for the tool after `dirbreaker`.
```bash
docker run -it --rm --volume "[PATH_TO_WORDLIST]:/app/[WORDLIST]:ro" --name dirbreaker_container dirbreaker -u [TARGETED_WEBSITE] -w [WORDLIST]
```
