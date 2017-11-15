//
//  helperfunctions.m
//  clothr
//
//  Created by Andrew Guterres on 10/29/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

#import "helperfunctions.h"

#pragma mark - Getting products

@interface helperfunctions()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *salePriceLabel;
@property (nonatomic, copy, readwrite) NSURL *URL;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSMutableArray *buffer;
@property (nonatomic, strong) PSSProduct *product;
@end

typedef void(^myCompletion)(BOOL);
//BOOL check = false;

@implementation helperfunctions

@synthesize products = _products;
//@synthesize buffer = _buffer;
// Given `notes` contains an array of Note objects
//NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notes];
//[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"notes"];
//NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"notes"];
//NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];



- (void)fillProductBuffer:(NSString *)search :(NSNumber *)pagingIndex
{
    __block NSArray *buffer;
    [self searchQuery:search :pagingIndex :^(BOOL finished)
     {
         if(finished){
             //            while(!check){}
             printf("FINISHED");
             NSData *productData = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
             buffer = [NSKeyedUnarchiver unarchiveObjectWithData:productData];
             PSSProduct *thisProduct = buffer[(NSUInteger)0];
             printf("Unarchived name: %s\n", [thisProduct.name UTF8String]);
             //return buffer;
             //filledBuffer=buffer;
         }
     }];
    
    //NSData *productData = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    //NSArray *buffer = [NSKeyedUnarchiver unarchiveObjectWithData:productData];
    //    return buffer;
    
    //    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:myObject] forKey:@"MyObjectKey"];
    //    [defaults synchronize];
}

-(void) searchQuery:(NSString *)searchTerm :(NSNumber*)pagingIndex :(myCompletion) compblock{
    PSSProductQuery *productQuery = [[PSSProductQuery alloc] init];
    productQuery.searchTerm = searchTerm;
    printf("here: %s\n", [productQuery.searchTerm UTF8String]);
    __weak typeof(self) weakSelf = self;
    [[PSSClient sharedClient] searchProductsWithQuery:productQuery offset:pagingIndex limit:[NSNumber numberWithInt:10] success:^(NSUInteger totalCount, NSArray *availableHistogramTypes, NSArray *products) {
        printf("ARCHIVING...\n");
        weakSelf.products = products;
        PSSProduct *thisProduct = self.products[(NSUInteger)0];
        printf("Archive name: %s\n", [thisProduct.name UTF8String]);
        //        printf("website url: %s\n", [thisProduct. UTF8String]);
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setObject:[NSKeyedArchiver archivedDataWithRootObject:products] forKey:@"name"];
        [data synchronize];
        NSData *productData = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        NSArray *buffer = [NSKeyedUnarchiver unarchiveObjectWithData:productData];
        PSSProduct *thisProduct2 = buffer[(NSUInteger)0];
        printf("Unarchived name2: %s\n", [thisProduct2.name UTF8String]);
        //        check=true;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed with error: %@", error);
    }];
    compblock(NO);
    return;
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:self.product forKey:@"name"];
    [encoder encodeObject:self.salePriceLabel forKey:@"salePriceLabel"];
    //[encoder encodeObject:self.product forKey:@"product"];
}

- (id)initWithCoder:(nonnull NSCoder *)decoder {
    if((self = [self init]))
    {
        self.product = [decoder decodeObjectForKey:@"name"];
        self.salePriceLabel=[decoder decodeObjectForKey:@"salePriceLabel"];
        //self.product = [decoder decodeObjectForKey:@"product"];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) copy = [[[self class] allocWithZone:zone] init];
    copy.name= self.name;
    copy.salePriceLabel=self.salePriceLabel;
    copy.product=self.product;
    return copy;
}

@end
