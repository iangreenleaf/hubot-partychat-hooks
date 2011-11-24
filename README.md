# Hubot adapter for Partychat-Hooks #

This is an adapter that connects [hubot](http://hubot.github.com/) to [partychat](http://partychapp.appspot.com/), by way of [partychat-hooks](http://partychat-hooks.appspot.com/).

# Setup #

**Until hubot 2.0, consider this alpha software.**

## Create a hook ##

1. Log into [partychat-hooks](http://partychat-hooks.appspot.com/) and create a
   hook for your chat room.

2. Click `New Post Hook` and enter this as the body:

        {{get_argument("body")}}

   Take note of the HTTP Endpoint. You'll need to pass this to hubot.

3. Click `New Receive Hook`. Enter `*` as the command sequence, and the
   address+port that hubot will run at as the HTTP Endpoint. For example:

        http://hooks.myserver.com:8080

## Set up your hubot ##

1. [Obtain your own Hubot](http://hubot.github.com/).

2. Edit `package.json`, adding this to the dependencies:

        "hubot-partychat-hooks": "0.1.0"

3. Install the needed packages. Yes, this process is weird.

        cd my/hubot/dir
        npm install
        cd node_modules/hubot-partychat-hooks
        npm install
        cd node_modules/hubot # You are now two levels deep. INCEPTION
        npm install

4. Patch your hubot. I had to use
   [this kludge](https://github.com/iangreenleaf/hubot/commit/f978264904845f32fd042d2f64a631488f6b5f2d)
   to get my hubot working. You should probably do the same.

## SYSTEMS ONLINE ##

1. Remember that Post Hook endpoint from earlier? You need it now.

        HUBOT_POST_ENDPOINT=http://partychat-hooks.appspot.com/post/p_xyzabc12 bin/hubot -a partychat-hooks
