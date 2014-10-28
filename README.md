extra-jpg-cleaner
==========

**UNDER DEVELOPING**

This is a simple tool to remove the JPG files which append to RAW files.

I write this tool just because those unnecessary files took too many of my disk spaces. :(

Usage:

    clean-jpg [--options] [destination]

Options:

    -x, --extname          the extname(s) of your RAW files,
                           case-INsensitive
                           a comma-seperated list is acceptable
                           e.g. "-x nef,cr2,dng"
                                                          [default: "arw,rw2,nef"]
    -r, --rename           the extname used when renaming
                                             [default: "extra-jpg-cleaner-result"]
    -d, --delete           !!!CAUTION!!!
                           Delete DIRECTLY w/ a single confirmation
                           instead of confirming one by one.
                           It WON'T move your files to the recycle bin
                           or trash can.
                           Generally this operation will be unrecoverable.
                           Try this only if you think your luck is overwhelming.
                           Incase something goes wrong,
                           go to buy an EasyRecovery or something similar.
                           Then test your overwhelming luck again...
    -D, --delete-directly  !!!CAUTION!!!
                           Same as "-d" but with
                           only even simpler "Y/N" confirmation.
    -l, --list             just print a list of result, will NOT delete anything
    -v, --verbose          print when renaming / deleting
    -h, --help             print this help message
