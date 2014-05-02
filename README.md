extra-jpg-cleaner
==========

This is a simple tool to remove the JPG files which append to RAW files.

I write this tool just because those unnecessary files took too many of my disk spaces. :(

Usage:

    clean-jpg [--options] [destinations]

Options:

    -x, --extname  the extname(s) of your RAW files, case-INsensitive
                   a comma-seperated list is acceptable, e.g. "-x nef,cr2,dng"
                   (default: arw)
    -r, --rename   the extname used when renaming
                   (default: extra-jpg-cleaner-result)
    -D, --delete   !!!CAUTION!!!
                   delete files DIRECTLY w/o any confirmation
                   it WON'T move your files to the recycle bin or trash can
                   generally this operation will be unrecoverable
                   try this only if you think your luck is overwhelming
                   incase something goes wrong
                   go to buy a EasyRecovery or something similar
                   then test your overwhelming luck again...
    -d, --dry-run  just print a list of result, will NOT delete anything
    -h, --help     print this help message
