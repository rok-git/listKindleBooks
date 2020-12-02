# listKindleBooks

## What?

This program creates a CSV file containing some info (ASIN, title, author, publisher, publicatiopn date, purchase date, pronunciation of the title, pronunciation of authors) for purchaesed kindle books.
These information are picked up from the cache file Kindle.app uses (~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml).

## How?

### How to build:

Xcode and xcode command-line tools must be installed.

Just type `make` to build.
Type `sudo make install` if you want to install the command at /usr/local/bin.

### How to use:

If no arguments are supplied, listKindleBooks reads data from default file (~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml).

`listKindleBooks > ./kindle.csv`

Or you can specify the file as an argument.

`listKindleBooks ~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml`

If '-' is given as an input file name, the program reads data from stdin.

`listKindleBooks - < ~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml`


Apple's Numbers can read CSV files in UTF-8 encodeing (default).  But to use the CSV file with Microsoft Excel in Japanese environment you have to convert encodings like below.

`listKindleBooks | iconv -c -f UTF-8 -t SJIS > ./kindle.csv`

Or if you have nkf installed,

`./listKindleBooks | nkf -Ws > ./kindle.csv`

I don't know well about character encodings, I think nkf is preferable than iconv.
