# Dotfiles for James Keesey ([@jlkeesey](http://twitter.com/jlkeesey))

These are the configuration dotfiles used by jlkeesey.

## Structure

<dl>
<dt>archive/</dt>
<dd>
This folder contains items that are no longer used but we want
to retain just in case. At some point they will be removed when we
are sure that they are not needed. This directory will not be copied
to the HOME directory.
</dd>
<dt>dots</dt>
<dd>
This folder contains all of the configuration or "dot files" that are tracked
in this system. Everything else is support or bookkeeping for the project.
</dd>
<dt>dots/bin/</dt>
<dd>
Common commands and scripts. These will be copied along with the dot files to
the ~/bin/ directory without affecting any other files in ~/bin/.
</dd>
<dt>future/</dt>
<dd>
This folder contains items that are in progress or have not yet been processed.
Eventually they will be copied to the parent directory. This directory is not
copied to the HOME directory.
</dd>
<dt>install.sh</dt>
<dd>
Script to copy all of the dotfiles to their respective locations.
</dd>
<dt>refresh.sh</dt>
<dd>
Script to copy all of the dotfiles from their respective locations back to this
directory so that GIT can be updated.
</dd>
</dl>
 
## Installation

Do something.


### Sources

This is based on a combination of the dotfiles from
https://bitbucket.org/durdn/cfg/src and https://github.com/mathiasbynens/dotfiles.
