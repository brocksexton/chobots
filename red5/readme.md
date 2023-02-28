# Red5 Server for Chobots

Red5 is an open-source media server for live streaming and video applications. It is written in Java and can be used to stream audio and video content over the internet.

This Red5 server has been modified to work with Chobots, providing the necessary infrastructure to host the game. To build the server, users can simply run `ant` in the `server` folder or use the build-script.sh file. The built files will be outputted to the `red5` folder, where users can run `python3 ./red5-service-check.py` to start the server.

For more information about Chobots, please visit the main repository's [readme](https://github.com/chobots/chobots/blob/master/readme.md).
