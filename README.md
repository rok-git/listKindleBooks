# listKindleBooks

## What?

This program creates a CSV file containing some info (ASIN, title, author, publisher, publicatiopn date, purchase date) for purchaesed kindle books.
These information are picked up from the cache file Kindle.app uses (~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml).

## How?

### How to build:

Xcode and xcode command-line tools must be installed.

Just type `make` to build.

### How to use:

`./listKindleBooks < ~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml > ./kindle.csv`

To use the CSV file with Microsoft Excel in Japanese environment

`./listKindleBooks < ~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml | iconv -c -f UTF-8 -t SJIS > ./kindle.csv`

or if you have nkf installed,

`./listKindleBooks < ~/Library/Application\ Support/Kindle/Cache/KindleSyncMetadataCache.xml | nkf -Ws > ./kindle.csv`

I don't know well about character encoding, I think nkf is preferable than iconv.