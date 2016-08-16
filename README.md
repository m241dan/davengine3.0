#Davengine 3.0
A Mud Engine written in Lua by Daniel R. Koris

This is a third version of the always-in-development Davengine Mud Engine. This Engine is born out of the pairing of two of my passions: Mud Gaming and Lua.

#Engine Concepts
The Mud Engine is an event driven TCP server with the goal of sending visually-impaired-friendly, OR ascetically pleasing and advanced, text outputs to standard telnet clients, and their improved counter parts. 

#Installation

This is setup to run as just a simple Lua 5.3 script with all the libs included except for [luasocket](https://github.com/diegonehab/luasocket). You will need to have luasocket installed on your server.

__HOWEVER:__ For those __NOT__ running this on *Ubuntu 14.04*, you may need to compile your own [time.so](https://github.com/m241dan/lua-time) and [lfs.so](https://github.com/keplerproject/luafilesystem).

For __Windows__, you'll need to compile time and lfs into .dlls, and either have them installed in your system path or put them in /libs and update davengine.lua's package.cpath line to look like the following(I think):
* package.cpath = ";./libs/?.dll"
