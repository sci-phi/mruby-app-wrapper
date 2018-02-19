# mruby-app-wrapper

Developer Tool for Wrapping mruby logic in a binary executable.

#### Work-in-Progress

## Why mruby?

By compiling code written for mruby to bytecode, and embedding the tiny mruby interpreter into a C executable, you can effectively use Ruby to solve problems in spaces you might not otherwise be able to address.

### Docker Development

This toolchain is primarily intended to be used via Docker images.

*TODO: Expand Instructions*

### Mac OS X Setup

In order to allow for native development, a script is provided for setting up a working mruby environment on Mac OS X. Please run the 'regular' Ruby script :

``$ ./setup_mruby_on_mac_os.rb``

Afterwards, you should be able to use the same Rake tasks locally as you would via Docker to build Mac native binaries from mruby.

### Linux Setup

This tool is primarily intended to be used via Docker images, so no special installation is required for Linux environments. The binaries produced by the Ubuntu-based container are usable as-is.

### Windows Setup

To Be Determined (Just use Docker?)
