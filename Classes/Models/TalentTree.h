//
//  TalentTree.h
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CharacterClass;
@class Mastery;
@class PrimarySpell;
@class Talent;

@interface TalentTree :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * treeNo;
@property (nonatomic, retain) NSString * roles;
@property (nonatomic, retain) NSString * overlayColor;
@property (nonatomic, retain) NSString * tooltip;
@property (nonatomic, retain) NSString * backgroundImage;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * talentTreeName;
@property (nonatomic, retain) NSSet* primarySpells;
@property (nonatomic, retain) NSSet* masteries;
@property (nonatomic, retain) CharacterClass * characterClass;
@property (nonatomic, retain) NSSet* talents;

+ (TalentTree *)addTalentTreeWithDictionary:(NSDictionary *)dictionary forCharacterClass:(CharacterClass *)characterClass inContext:(NSManagedObjectContext *)context;

@end


@interface TalentTree (CoreDataGeneratedAccessors)
- (void)addPrimarySpellsObject:(PrimarySpell *)value;
- (void)removePrimarySpellsObject:(PrimarySpell *)value;
- (void)addPrimarySpells:(NSSet *)value;
- (void)removePrimarySpells:(NSSet *)value;

- (void)addMasteriesObject:(Mastery *)value;
- (void)removeMasteriesObject:(Mastery *)value;
- (void)addMasteries:(NSSet *)value;
- (void)removeMasteries:(NSSet *)value;

- (void)addTalentsObject:(Talent *)value;
- (void)removeTalentsObject:(Talent *)value;
- (void)addTalents:(NSSet *)value;
- (void)removeTalents:(NSSet *)value;

@end

