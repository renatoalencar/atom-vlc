# Atom VLC

A bottom panel to control VLC media player from Atom

![Screenshot](https://github.com/renatoalencar/atom-vlc/raw/master/atom-vlc-screenshot.png)

## Installation

Atom VLC is available at `apm` index, install from Atom
interface or using `apm` command.

```bash
$ apm install atom-vlc
```

Or Settings ➔ Install ➔ Search for `atom-vlc`

## Features

* Shows playing song info (title, artist, album)
* Shows playing song artwork
* Allows forward, backward, play/pause and stop
* Compact and full mode

## Configuration

Atom VLC uses VLC's Lua HTTP interface to control VLC. So
you need to configure VLC in order to accept connections
from Atom and Atom VLC too.

### VLC

VLC's Lua HTTP interface only works when it's set a
password to access the interface. So go to Tools ➔
Preferences. Bellow `Show settings` area toggle `All` then
go to `Interface` ➔ `Main interfaces` ➔ `Lua`, bellow **Lua HTTP** set
a password.

After that go to View ➔ Add interface ➔ Web.

![VLC Preferences](https://github.com/renatoalencar/atom-vlc/raw/master/vlc-preferences.png)

### Atom VLC

Only `Password` setting is required, the others can work
by default.

Setting|Type|Description
---|---|---
Password|`string`|The password at VLC Interface
Host|`string`|The IP address or hostname of the host running VLC
Compact mode|`boolean`|Show the panel compact

## Developers

### Run from git repository

You only have to clone the repository, install dependencies
and link to a directory in the Atom's package directory.

```bash
$ git clone https:/github.com/renatoalencar/atom-vlc
$ cd atom-vlc
$ npm install
$ cd ..
$ ln -s atom-vlc ~/.atom/packages
```

### Dependencies

* atom-space-pen-views
* font-awesome

## License

[MIT](./LICENSE.md)
