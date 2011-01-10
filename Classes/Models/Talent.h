//
//  Talent.h
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Rank;
@class TalentTree;

@interface Talent :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * col;
@property (nonatomic, retain) NSString * talentName;
@property (nonatomic, retain) NSNumber * talentId;
@property (nonatomic, retain) NSNumber * tier;
@property (nonatomic, retain) NSNumber * req;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * keyAbility;
@property (nonatomic, retain) TalentTree * talentTree;
@property (nonatomic, retain) NSSet* ranks;

+ (Talent *)addTalentWithDictionary:(NSDictionary *)dictionary forTalentTree:(TalentTree *)talentTree forIndex:(NSInteger)index inContext:(NSManagedObjectContext *)context;

@end


@interface Talent (CoreDataGeneratedAccessors)
- (void)addRanksObject:(Rank *)value;
- (void)removeRanksObject:(Rank *)value;
- (void)addRanks:(NSSet *)value;
- (void)removeRanks:(NSSet *)value;

@end

