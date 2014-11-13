# SKB Mallodroid

One of the checkers we use in the SKB is `mallodroid`.
Unfortunately `mallodroid` depends on `androguard` which is a massive pain to install.

To help avoid problems in the future I've packaged it up into a Docker container (glorified LXC sandbox) and included a wrapper to let you run it as if it were a normal application.


