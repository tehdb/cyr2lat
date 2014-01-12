# cyr2lat.js

node.js module to rename files/directories in given directory and its subdirectories from cyrillic to latin

## prerequisites
Node.js http://nodejs.org/
CoffeeScript http://coffeescript.org/


## install
```bash
  npm install
```

## usage
```bash
# EXTENSION - exclude all files except those specified with the extension
coffee cyr2lat.coffee PATH-TO-DIR [EXTENSION]

## example:
coffee cyr2lat.coffee ./testdir txt
```

# run tests
```bash
jasmine-node --coffee --autotest spec
```

