# listKindleBooks

## What?

This program creates a CSV file containing some info (ASIN, title, author, publisher, publicatiopn date, purchase date) for purchaesed kindle books.
These information are picked up from the cache file Kindle.app uses (~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml).

## How?

### How to build:

Xcode and xcode command-line tools must be installed.

Just type `make` to build.

### How to use:

If no arguments are supplied, listKindleBooks read data from default file (~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml).

`./listKindleBooks > ./kindle.csv`

Or you can specify the file as an argument.

`listKindleBooks ~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml`

If '-' is given as an input file name, the program read data from stdin.

`listKindleBooks < ~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml`


To use the CSV file with Microsoft Excel in Japanese environment

`./listKindleBooks | iconv -c -f UTF-8 -t SJIS > ./kindle.csv`

or if you have nkf installed,

`./listKindleBooks | nkf -Ws > ./kindle.csv`

I don't know well about character encoding, I think nkf is preferable than iconv.
