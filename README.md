# Dotfiles for James Keesey ([@jlkeesey](http://twitter.com/jlkeesey))

These are the configuration files used by jlkeesey for Linux, UNIX, and OS/X.

## Structure

<dl>
<dt>archive/</dt>
<dd>
This folder contains items that are no longer used but we want
to retain just in case. At some point they will be removed when we
are sure that they are not needed. This directory will not be copied
to the HOME directory.
</dd>
<dt>dots/</dt>
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
copied to the HOME directory. This folder may include files or whole directories 
from other dot file repos. I have attempted to keep some kind of link back to the
original, but there might be some mistakes or omissions. If so it is not by intent.
</dd>
<dt>install.sh</dt>
<dd>
Script to copy all of the dotfiles to their respective locations.
</dd>
<dt>refresh.sh</dt>
<dd>
Script to copy all of the configuration from their respective locations back to this
directory so that GIT can be updated.
</dd>
</dl>
 
## Installation

  1. Clone the repo
  1. Run the {repo}/tools/install.sh script.
  1. Log out and back in or re-source the ~/.bashrc file to get the settings.


### Sources

This is based on a combination of the dotfiles from various sources.

  * https://bitbucket.org/durdn/cfg/src
  * https://github.com/mathiasbynens/dotfiles

-----
<p style="font-size: smaller">Copyright (C) 2015-2016 by James Keesey.</p>

