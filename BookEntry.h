#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, EntryStage) {
    NoStage,
    AsinStage,
    TitleStage,
    AuthorsStage,
    AuthorStage,
    PublishersStage,
    PublisherStage,
    PublicationDateStage,
    PurchaseDateStage
};

@interface BookEntry : NSObject{
}
-(BookEntry *) init;
@property EntryStage stage;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *titlePron;
@property (nonatomic,retain) NSString *asin;
@property (nonatomic,retain) NSMutableArray *authors;    // array of (NSString *)
@property (nonatomic,retain) NSMutableArray *authorsPron; // array of (NSMutableArray *)
@property (nonatomic,retain) NSMutableArray *publishers;    // array of (NSString *)
@property (nonatomic,retain) NSDate *publicationDate; // converted from yyyy-mm-dd%hh:mm:ss+zzzz
@property (nonatomic,retain) NSDate *purchaseDate;
@property (nonatomic,retain) NSString *cdeContentType;
@property (nonatomic,retain) NSString *contentType;
@end

