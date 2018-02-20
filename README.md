# mruby-app-wrapper

Developer Tool for Wrapping mruby logic in a binary executable.

###

ALPHA : Not suitable for general use. You probably want to consider using [mruby-cli](http://mruby-cli.org) instead.

## Why mruby?

By compiling code written for mruby to bytecode, and embedding the tiny mruby interpreter into a C executable, you can effectively use Ruby to solve problems in spaces you might not otherwise be able to address.

### Docker Development

This toolchain is primarily intended to be used via Docker images.

#### Building the Docker Image

In the terminal, cd to this source directory and run the terminal command to build the custom :

``$ docker build -t mruby-app-wrapper .``

This will pull the base image ("sciphi/mruby-base") and apply the customizations in the template file "*custom_build_config.rb*" in a new docker image "*mruby-app-wrapper*"

## Installed Versions

  Ubuntu : 17.10
  Ruby (CRuby/YARV) : 2.3.3p222
  mruby (Rite) : 1.3.0 (2017-07-04)


## Working with mruby in the docker shell

Run the docker image you built :

``$ docker run -tiP --rm -v $(pwd):/Code/project -w /Code/project mruby-app-wrapper shell``

This docker shell is the work context for building the linux executable. Because the above command mounts the working directory on your host machine as the working directory in the running docker container, you can edit files in the host  environment and use them immediately in the docker shell.

## Explore mruby via mirb REPL

    root@0a228058f090:/Code/project# mirb
    mirb - Embeddable Interactive Ruby Shell

    > 2 + 2

    => 4

## Run mruby script (Traditional CRuby usage)

    root@0a228058f090:/Code/project# mruby demo_mruby.rb

### Mac OS X Setup

In order to allow for native development, a script is provided for setting up a working mruby environment on Mac OS X. Please run the 'regular' Ruby script :

``$ ./setup_mruby_on_mac_os.rb``

Afterwards, you should be able to use the same Rake tasks locally as you would via Docker to build Mac native binaries from mruby.

### Linux Setup

This tool is primarily intended to be used via Docker images, so no special installation is required for Linux environments. The binaries produced by the Ubuntu-based container are usable as-is.

### Windows Setup

To Be Determined (Just use Docker?)
