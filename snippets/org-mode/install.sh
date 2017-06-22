#!/bin/bash

# Check for command line args.
if [ "$1" = "" ]; then
	echo "Usage: ./install.sh yasnippet-dir"
	echo "Example: ./install.sh ~/.emacs.d/plugins/yasnippet"
    echo "This makes a \"snippets/org-mode\" folder and installs there"
	exit 1
fi

# Create the latex-mode dir.
if [ ! -d "$1"/snippets/org-mode ]; then
	mkdir "$1"/snippets/org-mode
fi

# Copy needed files to the latex-mode dir.
cp *.yasnippet "$1"/snippets/org-mode/
cp .yas-parents "$1"/snippets/org-mode/
cp .yas-ignore-filenames-as-triggers "$1"/snippets/org-mode/
cp .yas-make-groups "$1"/snippets/org-mode/

exit 0
