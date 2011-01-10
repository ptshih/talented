//
//  PrimarySpell.h
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TalentTree;

@interface PrimarySpell :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * tooltip;
@property (nonatomic, retain) NSString * primarySpellName;
@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * castTime;
@property (nonatomic, retain) NSString * reagents;
@property (nonatomic, retain) NSString * requires;
@property (nonatomic, retain) NSString * cooldown;
@property (nonatomic, retain) NSString * spellRange;
@property (nonatomic, retain) NSNumber * keyAbility;
@property (nonatomic, retain) NSNumber * spellId;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) TalentTree * talentTree;

+ (PrimarySpell *)addPrimarySpellWithDictionary:(NSDictionary *)dictionary forTalentTree:(TalentTree *)talentTree forIndex:(NSInteger)index inContext:(NSManagedObjectContext *)context;

@end



