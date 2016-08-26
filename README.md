#Davengine 3.0
A Mud Engine written in Lua by Daniel R. Koris

This is a third version of the always-in-development Davengine Mud Engine. This Engine is born out of the pairing of two of my passions: Mud Gaming and Lua.

#Engine Concepts
The Mud Engine is an event driven TCP server with the goal of sending visually-impaired-friendly, OR ascetically pleasing and advanced, text outputs to standard telnet clients, and their improved counter parts. 

#Installation

This is setup to run as just a simple Lua 5.3 script on __Linux__ or __Mac__ with all the libs included except for [luasocket](https://github.com/diegonehab/luasocket) and [luaposix](https://github.com/luaposix/luaposix). You have to get that setup on your server using your own ability, and make sure libs/server.lua can require it. 

__HOWEVER:__ For those __NOT__ running this on *Ubuntu 14.04*, you may need to compile your own [time.so](https://github.com/m241dan/lua-time) and [lfs.so](https://github.com/keplerproject/luafilesystem), and drop them in "/libs".

For __Windows__, you'll need to compile [time](https://github.com/m241dan/lua-time) and [lfs](https://github.com/keplerproject/luafilesystem) into .dlls, and either have them installed in your system path or put them in /libs and update davengine.lua's package.cpath line to look like the following(I think):
* package.cpath = package.cpath .. ";./libs/?.dll"
