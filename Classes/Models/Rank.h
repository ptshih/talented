//
//  Rank.h
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Talent;

@interface Rank :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * castTime;
@property (nonatomic, retain) NSString * cooldown;
@property (nonatomic, retain) NSString * requires;
@property (nonatomic, retain) NSString * reagents;
@property (nonatomic, retain) NSString * range;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * tooltip;
@property (nonatomic, retain) Talent * talent;

+ (Rank *)addRankWithDictionary:(NSDictionary *)dictionary forTalent:(Talent *)talent forIndex:(NSInteger)index inContext:(NSManagedObjectContext *)context;

@end



