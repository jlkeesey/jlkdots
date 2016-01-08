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
<dt>todo/</dt>
<dd>
This folder contains items that are in progress or have not yet been processed.
Eventually they will be copied to the parent directory. This directory is not
copied to the HOME directory.
</dd>
<dt>bin/</dt>
<dd>
Common commands and scripts.
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
