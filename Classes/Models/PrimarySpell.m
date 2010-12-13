// 
//  PrimarySpell.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrimarySpell.h"
#import "TalentTree.h"

@implementation PrimarySpell 

@dynamic primarySpellName;
@dynamic cost;
@dynamic castTime;
@dynamic reagents;
@dynamic requires;
@dynamic cooldown;
@dynamic spellRange;
@dynamic keyAbility;
@dynamic spellId;
@dynamic icon;
@dynamic talentTree;

+ (PrimarySpell *)addPrimarySpellWithDictionary:(NSDictionary *)dictionary forTalentTree:(TalentTree *)talentTree inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    PrimarySpell *newPrimarySpell = [NSEntityDescription insertNewObjectForEntityForName:@"PrimarySpell" inManagedObjectContext:context];
    
    newPrimarySpell.primarySpellName = [dictionary objectForKey:@"name"];
    newPrimarySpell.cost = [dictionary objectForKey:@"cost"];
    newPrimarySpell.castTime = [dictionary objectForKey:@"castTime"];
//    newPrimarySpell.reagents
    newPrimarySpell.requires = [dictionary objectForKey:@"requires"];
    newPrimarySpell.cooldown = [dictionary objectForKey:@"cooldown"];
    newPrimarySpell.spellRange = [dictionary objectForKey:@"range"];
    newPrimarySpell.keyAbility = [dictionary objectForKey:@"keyAbility"];
    newPrimarySpell.spellId = [dictionary objectForKey:@"spellId"];
    newPrimarySpell.icon = [dictionary objectForKey:@"icon"];
    
    // Hook up talent relationship
    newPrimarySpell.talentTree = talentTree;
    
    return newPrimarySpell;
  } else {
    return nil;
  }
}

@end
