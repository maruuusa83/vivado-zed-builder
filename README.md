ZedBoard Project Auto Builder on Vivado 2015.4
==============================================

This is a project for building ZedBoard project automatically.  

## Usage
To build Vivado project, run command as show next:

``` bash
make
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

