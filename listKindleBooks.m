#include <unistd.h>
#import <Foundation/Foundation.h>
#import "BookEntry.h"


@interface ParserDelegate : NSObject <NSXMLParserDelegate> {
    BookEntry *anEntry;
    NSMutableArray *bookEntries;       // array of (BookEntry *)
    NSISO8601DateFormatter *dateFormatter;
    NSString *tmpAuthor;
    NSString *tmpPublisher;
}
-(NSMutableArray *)entries;
@end

@implementation ParserDelegate
-(NSMutableArray *)entries
{
    return bookEntries;
}

- (void) parserDidStartDocument: (NSXMLParser *)parser
{
//    NSLog(@"start parsing");
    bookEntries = [[NSMutableArray alloc] init];
    dateFormatter = [[NSISO8601DateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
}

- (void) parserDidEndDocument: (NSXMLParser *) parser
{
//    NSLog(@"finish parsing");
}

- (void) parser: (NSXMLParser *)parser
	 parseErrorOccurred: (NSError *) parseError
{
    NSLog(@"parse error: %@", parseError);
}

- (void) parser: (NSXMLParser *)parser foundCharacters: (NSString *)string
{
//    NSLog(@" -> %@", string);
    switch(anEntry.stage){
        case AsinStage:
//            NSLog(@"ASIN: %@", string);
            anEntry.asin = string;
            break;
        case TitleStage:
//            NSLog(@"Title: %@", string);
            if(anEntry.title){
                anEntry.title = [anEntry.title stringByAppendingString: string];
            }else{
                anEntry.title = string;
            }
            break;
        case AuthorsStage:
            break;
        case AuthorStage:
//            NSLog(@"Author: %@", string);
            if(tmpAuthor){
                tmpAuthor = [tmpAuthor stringByAppendingString: string];
            }else{
                tmpAuthor = [NSString stringWithString: string];
            }
//            NSLog(@"tmpAuthor: %@", tmpAuthor);
            break;
        case PublishersStage:
            break;
        case PublisherStage:
//            NSLog(@"Publisher: %@", string);
            if(tmpPublisher){
                tmpPublisher = [tmpPublisher stringByAppendingString: string];
            }else{
                tmpPublisher = [NSString stringWithString: string];
            }
//            NSLog(@"tmpPublisher: %@", tmpPublisher);
            break;
        case PublicationDateStage:
//            NSLog(@"Publication Date: %@", string);
            anEntry.publicationDate = [dateFormatter dateFromString: string];
            break;
        case PurchaseDateStage:
//            NSLog(@"Purchase Date: %@", string);
            anEntry.purchaseDate = [dateFormatter dateFromString: string];
            break;
        default:
            ;
    }
}

- (void) parser: (NSXMLParser *)parser
	 didStartElement: (NSString *) elementName
         namespaceURI:(NSString *) namespaceURI
         qualifiedName: (NSString *) qualifiedName 
	 attributes: (NSDictionary *)attributeDict 
{
    /*
    NSLog(@"Line: %ld, Column: %ld", [parser lineNumber], [parser columnNumber]);
    NSLog(@"Start reading Tag: %@", elementName);
    NSLog(@"    namespaceURI: %@", namespaceURI);
    NSLog(@"    qualifiedName: %@", qualifiedName);
    NSLog(@"    attributes: %@", attributeDict);
    */

    if([elementName isEqualToString: @"meta_data"]){
        // start of an entry
//        NSLog(@"==> start an entry");
        anEntry = [[BookEntry alloc] init];
    }else
    if([elementName isEqualToString: @"ASIN"]){
        // start of an asin
//        NSLog(@" => start of ASIN");
        anEntry.stage = AsinStage;
    }else
    if([elementName isEqualToString: @"title"]){
        // start of a title
//        NSLog(@" => start of Title");
        anEntry.stage = TitleStage;
        if(attributeDict && attributeDict[@"pronunciation"]){
            anEntry.titlePron = [attributeDict[@"pronunciation"] copy];
        }
    }else
    if([elementName isEqualToString: @"authors"]){
        // start of authors
//        NSLog(@" => start of authors");
        anEntry.stage = AuthorsStage;
        anEntry.authors = nil;
        tmpAuthor = nil;
    }else
    if([elementName isEqualToString: @"author"]){
        // start of an author
//        NSLog(@" => start of author");
        anEntry.stage = AuthorStage;
        if(attributeDict && attributeDict[@"pronunciation"]){
            if(!anEntry.authorsPron)
                anEntry.authorsPron = [[NSMutableArray alloc] init];
            [anEntry.authorsPron addObject: attributeDict[@"pronunciation"]];
        }
    }else
    if([elementName isEqualToString: @"publishers"]){
        // start of publishers
//        NSLog(@" => start of publishers");
        anEntry.stage = PublishersStage;
        anEntry.publishers = nil;
        tmpPublisher = nil;
    }else
    if([elementName isEqualToString: @"publisher"]){
        // start of a publisher
//        NSLog(@" => start of publisher");
        anEntry.stage = PublisherStage;
    }else
    if([elementName isEqualToString: @"publication_date"]){
        // start of a publication_date
//        NSLog(@" => start of publication_date");
        anEntry.stage = PublicationDateStage;
    }else
    if([elementName isEqualToString: @"purchase_date"]){
        // start of a purchase_date
//        NSLog(@" => start of purchase_date");
        anEntry.stage = PurchaseDateStage;
    }else
        anEntry.stage = NoStage;
}

- (void) parser: (NSXMLParser *)parser
	 didEndElement: (NSString *) elementName
         namespaceURI:(NSString *) namespaceURI
         qualifiedName: (NSString *) qualifiedName 
{
    /*
    NSLog(@"End reading Tag: %@", elementName);
    NSLog(@"    namespaceURI: %@", namespaceURI);
    NSLog(@"    qualifiedName: %@", qualifiedName);
    */
    if([elementName isEqualToString: @"meta_data"]){
//        NSLog(@"Entry: %@ finished", anEntry);
        [bookEntries addObject: anEntry];
    }else
    if([elementName isEqualToString: @"authors"]){
//        NSLog(@"Authors: %@", anEntry.authors);
//      This part is not needed because authors part of anEntry is created when an author name is read.
    }else
    if([elementName isEqualToString: @"author"]){
        if(tmpAuthor){
            if(!anEntry.authors){
                anEntry.authors = [[NSMutableArray alloc] init];
            }
            [anEntry.authors addObject: [NSString stringWithString: tmpAuthor]];
//            NSLog(@"anEntry.authors %@", anEntry.authors);
            tmpAuthor = nil;
        }
    }else
    if([elementName isEqualToString: @"publisher"]){
        if(tmpPublisher){
            if(!anEntry.publishers){
                anEntry.publishers = [[NSMutableArray alloc] init];
            }
            [anEntry.publishers addObject: [NSString stringWithString: tmpPublisher]];
//            NSLog(@"anEntry.publishers %@", anEntry.publishers);
            tmpPublisher = nil;
        }
    }
}

@end

void printHeader(NSFileHandle *fout)
{
    NSArray *headerTitles = @[
        @"\"ASIN\"",
        @"\"Title\"",
        @"\"Author\"",
        @"\"Publisher\"",
        @"\"Date Published\"",
        @"\"Date Purchased\"",
        @"\"Pronunciation of Title\"",
        @"\"Pronunciation of Author\""];

    [fout writeData: [[[headerTitles componentsJoinedByString: @","] stringByAppendingString: @"\n"] dataUsingEncoding: NSUTF8StringEncoding]];
    return;
}


#define StringWithArray(str) [[(str) componentsJoinedByString:@", "] stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""]

#define KindleCache @"~/Library/Application Support/Kindle/Cache/KindleSyncMetadataCache.xml"


int
main(int argc, char *argv[])
{
    NSString *inputFileName;
    NSFileHandle *fin;
    @autoreleasepool{
        char opt;
        BOOL needHeader = NO;
        while((opt = getopt(argc, argv, "h")) != -1){
            if(opt == 'h'){
                needHeader = YES;
            }
        }
//        printf("optind: %d, argc: %d\n", optind, argc);
        if(argc == optind){
            inputFileName = [KindleCache stringByExpandingTildeInPath];
        }else{
            inputFileName = [[NSString stringWithUTF8String: argv[optind]] stringByExpandingTildeInPath];
        }
        if([inputFileName isEqualToString: @"-"]){
            fin = [NSFileHandle fileHandleWithStandardInput];
        }else{
            fin = [NSFileHandle fileHandleForReadingAtPath: inputFileName];
        }
        NSData *data = [fin readDataToEndOfFile];
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];

        ParserDelegate *p = [[ParserDelegate alloc] init];
	parser.delegate = p;
	[parser parse]; // after parsing, ParserDelegate has info for all books

        NSFileHandle *fout = [NSFileHandle fileHandleWithStandardOutput];

        if(needHeader)
            printHeader(fout);
        [[(ParserDelegate *)(parser.delegate) entries] enumerateObjectsUsingBlock:
            ^(BookEntry *entry, NSUInteger idx, BOOL *stop){
                // NSLog(@"%lu: %@ %@", idx, entry.asin, entry.title);
                NSString *str = [NSString stringWithFormat:
                    // ASIN, title, authors, publishers, publication date, purchased date, title's pronunciation, authors' pronunciation
                    @"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
                    entry.asin,
                    [entry.title stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""],
                    StringWithArray(entry.authors),
                    StringWithArray(entry.publishers),
                    entry.publicationDate,
                    entry.purchaseDate,
                    entry.titlePron,
                    StringWithArray(entry.authorsPron)
                ];
                [fout writeData: [str dataUsingEncoding: NSUTF8StringEncoding]];
            }
        ];
    }
    return 0;
}
