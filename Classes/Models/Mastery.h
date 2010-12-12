//
//  Mastery.h
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TalentTree;

@interface Mastery :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * reagents;
@property (nonatomic, retain) NSNumber * keyAbility;
@property (nonatomic, retain) NSString * tooltip;
@property (nonatomic, retain) NSNumber * masteryId;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TalentTree * talentTree;

+ (Mastery *)addMasteryWithDictionary:(NSDictionary *)dictionary forTalentTree:(TalentTree *)talentTree inContext:(NSManagedObjectContext *)context;

@end