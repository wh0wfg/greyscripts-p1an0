# greyscripts-p1an0

**greyscript src files for steam game [greyhack](https://store.steampowered.com/app/605230/Grey_Hack/)**

use [greybel-js](https://github.com/ayecue/greybel-js) or [greybel-vs](https://github.com/ayecue/greybel-vs) to compile src file in ./src folder

# [p1an0Xshell](src/p1an0Xshell.src)

Lightweight shell with automated hacking tools.

Warning, the current version is very imperfect, has a lot of bugs, but the associated libs may be able to help you and any suggestions are always welcome!

## TODO:

* [X] cd, ls, rm ,sudo, ping, chmod, terminal, decipher,ps, kill and appearances
* [X] relative path and "~" parsing
* [X] Using a tree structure to store lan([network.src](lib/network.src)): LAN is considered as a tree and each router or machine is considered as a node, storing exploits, credentials, lan ip and other related information.
* [X] Scanning lan: use "lan [router ip: public/local]". It will construct a LAN tree.
* [X] Targeted attack: "xpl [opt: lan ip]" use exploits again; "lan [router ip] [opt: lan ip]" If the lan ip is provided, a bounce attack is attempted and only the target machine is attacked, otherwise the entire LAN is attacked.
* [X] Bank, mail, and user information display: "creds [opt: lan ip]" Display the information of stored credentials in the LAN tree, if the lan ip is provided, only display the target ip, otherwise display the whole LAN
* [X] Log clear for commands "lan" and "xpl": "cl [opt: -l]". If the -l flag is provided, clean up the logs in the LAN tree, otherwise only clean up the local machine.
* [X] Jump to remote mechine: "jump [opt: -l]". If the -l flag is provided, the database will not be transfered.
* [X] Reverse shell creation and management: "bd [host ip] [host port] [opt: process name]" leaves rshell client on the local machine. "rs" starts the reverse shell service and chooses	 which shell to use
* [ ] Distributed database of vulnerable addresses and values: It is currently stored in a single file in json format with context length limit. Maybe it can be splited into multiple files or even  put in multiple folders.
* [ ] Remote server acceleration for vulnerability scanning: It is very slow when jumping into a router to scan for LAN vulnerabilities, giving the lib version number to a remote server to scan or lookup and return the results might speed things up.
* [ ] Encryption of file storage: Currently databases are stored in clear text, leading to a fear of storing password data. A library of encryption algorithms could be implemented to encrypt the storage and enter the password each time the shell is used. Do something interesting if the password is wrong.
* [ ] More basic commands for the OS
* [ ] User-friendly manuals
* [ ] Automatic lan pivoting?: The LAN tree was originally constructed for this purpose, but it seems the game mechanics don't allow it?

# src

automission: Unavailable due to [p1an0Xcore](src/p1an0Xcore.src) refactoring

mailcracker: Unavailable due to [p1an0Xcore](src/p1an0Xcore.src) refactoring

# lib

argparse.src: Used by [p1an0Xshell](src/p1an0Xshell.src) to parse command flags

json.src: Modified from[ 117-a-json-parser-for-and-in-miniscript](https://forums.miniscript.org/d/117-a-json-parser-for-and-in-miniscript) due to compatible in the game

logger.src: TODO: save log file

mail.src: seems useless

network.src: stroe LAN tree structure

p1an0Xcore.src: Includes all automated hack function that you can probably use for other things. demo: [automission](src/automission.src), [mailcracker](src/mailcracker)

pystring.src: seems useless

## TODO:

* [X] argparse.src: Parsing flags in command arguments and providing error messages
* [X] logger.src: Simple logger
* [X] mail.src: mail management for automission use
* [X] p1an0Xcore.src: Functions about autohack isolated from p1an0Xshell.src
* [X] network.src: LAN tree structure management
* [ ] database.src: Distributed storage and remote database services
* [ ] socket.src: Use the game's existing services to implement http or tcp/udp-like protocols
* [ ] hashlib.src: Implementing common cryptographic algorithms
* [ ] api document or annotation of functions
