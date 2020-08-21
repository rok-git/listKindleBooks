#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EntryStage) {
    NoStage,
    AsinStage,
    TitleStage,
    AuthorsStage,
    PublishersStage
};

@interface BookEntry : NSObject{
} 
-(BookEntry *) init;
@property NSInteger stage;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *asin;
@property (nonatomic,retain) NSArray *authors;    // array of (NSString *)
@property (nonatomic,retain) NSArray *publishers;    // array of (NSString *)
@property (nonatomic,retain) NSString *publicationDate; // yyyy-mm-dd%hh:mm:ss+zzzz
@property (nonatomic,retain) NSString *purchaseDate;
@property (nonatomic,retain) NSString *cdeContentType;
@property (nonatomic,retain) NSString *cntentType;
@end

@implementation BookEntry
-(BookEntry *)init
{
    self.stage = NoStage;
    return [super init];
}
@end

NSArray *allEntries;

@interface ParserDelegate : NSObject <NSXMLParserDelegate> {
    BookEntry *anEntry;
    NSMutableArray *bookEntries;       // array of (BookEntry *)
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
    // do something
    NSLog(@"start parsing");
    bookEntries = [[NSMutableArray alloc] init];
}

- (void) parserDidEndDocument: (NSXMLParser *) parser
{
    NSLog(@"finish parsing");
//    allEntries = bookEntries;
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
            NSLog(@"ASIN: %@", string);
            anEntry.asin = string;
            break;
        case TitleStage:
            NSLog(@"Title: %@", string);
            if(anEntry.title){
                anEntry.title = [anEntry.title stringByAppendingString: string];
            }else{
                anEntry.title = string;
            }
            break;
        case AuthorsStage:
            break;
        case PublishersStage:
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
    NSLog(@"Line: %ld, Column: %ld", [parser lineNumber], [parser columnNumber]);
    NSLog(@"Start reading Tag: %@", elementName);
    NSLog(@"    namespaceURI: %@", namespaceURI);
    NSLog(@"    qualifiedName: %@", qualifiedName);
    NSLog(@"    attributes: %@", attributeDict);

    if([elementName isEqualToString: @"meta_data"]){
        // start of an entry
        NSLog(@"==> start an entry");
        anEntry = [[BookEntry alloc] init];
    }
    if([elementName isEqualToString: @"ASIN"]){
        // start of a asin
        NSLog(@" => start of ASIN");
        anEntry.stage = AsinStage;
    }
    if([elementName isEqualToString: @"title"]){
        // start of a title
        NSLog(@" => start of Title");
        anEntry.stage = TitleStage;
    }
    if([elementName isEqualToString: @"authors"]){
        // start of a authors
        NSLog(@" => start of authors");
        anEntry.stage = AuthorsStage;
    }
    if([elementName isEqualToString: @"publishers"]){
        // start of a publishers
        NSLog(@" => start of publishers");
        anEntry.stage = PublishersStage;
    }
}

- (void) parser: (NSXMLParser *)parser
	 didEndElement: (NSString *) elementName
         namespaceURI:(NSString *) namespaceURI
         qualifiedName: (NSString *) qualifiedName 
{
    NSLog(@"End reading Tag: %@", elementName);
    NSLog(@"    namespaceURI: %@", namespaceURI);
    NSLog(@"    qualifiedName: %@", qualifiedName);
    if([elementName isEqualToString: @"meta_data"]){
        NSLog(@"Entry: %@ finished", anEntry);
        [bookEntries addObject: anEntry];
    }
}

@end

int
main()
{
    @autoreleasepool{
        NSFileHandle *fin = [NSFileHandle fileHandleWithStandardInput];
        NSData *data = [fin readDataToEndOfFile];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData: data ];
	NSLog(@"%@", parser);
	parser.delegate = [[ParserDelegate alloc] init];
	[parser parse]; // now, allEntries contains info for all books

        NSFileHandle *fout = [NSFileHandle fileHandleWithStandardOutput];
        [[(ParserDelegate *)(parser.delegate) entries] enumerateObjectsUsingBlock:
            ^(BookEntry *entry, NSUInteger idx, BOOL *stop){
                // NSLog(@"%lu: %@ %@", idx, entry.asin, entry.title);
                NSString *str = [NSString stringWithFormat: @"\"%@\",\"%@\"\n", entry.asin, [entry.title stringByReplacingOccurrencesOfString: @"\"" withString: @"\"\""]];
                [fout writeData: [str dataUsingEncoding: NSUTF8StringEncoding]];
            }
        ];
	return 0;
    }
}
