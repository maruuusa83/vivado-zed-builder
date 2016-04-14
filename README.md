ZedBoard Project Auto Builder on Vivado 2015.4
==============================================

This is a project for building ZedBoard project automatically.  

## Usage
To build Vivado project, run command as show next:

``` bash
$ make
```

If you want to use your IP, copy a block design tcl file into `bd/` directory and copy an IP into `ips/` directory.
Then, run `make` command as usual.

## Folders
```
/ -- bd/
  |  # folder for block design file
  |
  |- ips/
  |  # folder for IP
  |
  |- constrs/
  |
  |- builder/
  |- dropbox/
```

---

## Dropbox Auto Upload
This auto builder can upload a BOOT.bin file to your Dropbox.

### dropbox_settings.conf
First, you must write `dropbox_settings.conf`.

``` bash
$ cp dropbox_settings.conf.template dropbox_settings.conf
```

Write your dropbox developer token and upload position.

### Run auto upload
Run `make` command as usual. 
