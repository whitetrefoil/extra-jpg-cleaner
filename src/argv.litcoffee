This is a internal lib file.  It will be included at the head of [cleaner.litcoffee](cleaner.html).

Arguments
-----

`"use strict";` always first :)

    'use strict'

Let the help message more colorful~

    require 'colors'

Use [Yargs](https://github.com/chevex/yargs) to build the argv function and help display.

    yargs = require('yargs')

Print the common descriptions.

    .usage '''
           This application will append extra extname to all filtered out JPG files.
           Then you can check the result by your OS\'s search function easily.
           In case there is anything wrong, you can rollback.

           The default destination is here.

           P.S. The priority among -l, -d & -r is -l > -d > -r


           ''' +
           'Usage: clean-jpg [--options] [destination]'.cyan


Set the extname(s) of your RAW files.
You can give a comma-separated list of extnames (e.g. `-x nef,cr2,dng`).

Besides, this is case-**in**sensitive.

My default is "_ARW_" because I'm a NEX user :)

    .options 'x',
      alias: 'extname'
      describe: """
                the extname(s) of your RAW files, case-#{'IN'.yellow}sensitive
                a comma-seperated list is acceptable
                #{'e.g. "-x nef,cr2,dng"'.cyan}

                """
      default: 'arw'

The extname can be overridden if you want.
But we still suggest you can use a outstanding name to prevent confusion with others.
Usually a name will be as safe as long.

    .options 'r',
      alias: 'rename'
      default: 'extra-jpg-cleaner-result'
      describe: 'the extname used when renaming\n'

Delete the files **DIRECTLY**.

The default behavior of this application is rename the target files then you can check it manually.
It's for safety purpose.

This will require a complex confirmation.

    .options 'd',
      alias: 'delete'
      boolean: true
      describe: '!!!CAUTION!!!\n'.yellow.bold +
                """
                Delete DIRECTLY w/ a single confirmation
                instead of confirming one by one.
                It WON'T move your files to the recycle bin
                or trash can.
                Generally this operation will be unrecoverable.
                Try this only if you think your luck is overwhelming.
                Incase something goes wrong,
                go to buy an EasyRecovery or something similar.
                Then test your overwhelming luck again...
                """

Delete the files **DIRECTLY** with only a simple confirmation.

Same as `-d` but will just ask a simple `Y/N`.

    .options 'D',
      alias: 'delete-directly'
      boolean: true
      describe: '!!!CAUTION!!!\n'.red.bold +
                """
                Same as "-d" but with
                only even simpler "Y/N" confirmation.
                """

For such a application (who do the cleanup jobs), allow user to dry run is a good idea.

    .options 'l',
      alias: 'list'
      describe: 'just print a list of result, will NOT delete anything'
      boolean: true

Give more messages...
Actually will print every file when renaming / deleting.

    .options 'v',
      alias: 'verbose'
      describe: 'print when renaming / deleting'
      boolean: true

Print the help text.

    .options 'h',
      alias: 'help'
      describe: 'print this help message'
      boolean: true

Change a new line at the 80th character.

    .wrap 80


Exports the whole yargs instance.

As a result, all properties & results of that are available.

    module.exports = yargs
