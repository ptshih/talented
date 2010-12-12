//
//  PrimarySpell.h
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TalentTree;

@interface PrimarySpell :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * castTime;
@property (nonatomic, retain) NSString * reagents;
@property (nonatomic, retain) NSString * requires;
@property (nonatomic, retain) NSString * cooldown;
@property (nonatomic, retain) NSString * range;
@property (nonatomic, retain) NSNumber * keyAbility;
@property (nonatomic, retain) NSNumber * spellId;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) TalentTree * talentTree;

+ (PrimarySpell *)addPrimarySpellWithDictionary:(NSDictionary *)dictionary forTalentTree:(TalentTree *)talentTree inContext:(NSManagedObjectContext *)context;

@end



