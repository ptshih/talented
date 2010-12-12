// 
//  Mastery.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Mastery.h"
#import "TalentTree.h"

@implementation Mastery 

@dynamic reagents;
@dynamic keyAbility;
@dynamic tooltip;
@dynamic masteryId;
@dynamic icon;
@dynamic name;
@dynamic talentTree;

+ (Mastery *)addMasteryWithDictionary:(NSDictionary *)dictionary forTalentTree:(TalentTree *)talentTree inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    Mastery *newMastery = [NSEntityDescription insertNewObjectForEntityForName:@"Mastery" inManagedObjectContext:context];
    
    newMastery.name = [dictionary objectForKey:@"name"];
    newMastery.tooltip = [dictionary objectForKey:@"description"];
    newMastery.masteryId = [dictionary objectForKey:@"spellId"];
    newMastery.icon = [dictionary objectForKey:@"icon"];
    newMastery.keyAbility = [dictionary objectForKey:@"keyAbility"];
//    newMastery.reagents
    
    // Hook up talent relationship
    newMastery.talentTree = talentTree;
    
    return newMastery;
  } else {
    return nil;
  }
}

@end
