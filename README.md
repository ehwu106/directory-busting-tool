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
