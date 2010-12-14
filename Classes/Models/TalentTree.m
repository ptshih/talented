// 
//  TalentTree.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TalentTree.h"
#import "CharacterClass.h"
#import "Mastery.h"
#import "PrimarySpell.h"
#import "Talent.h"

@implementation TalentTree 

@dynamic treeNo;
@dynamic roles;
@dynamic overlayColor;
@dynamic tooltip;
@dynamic backgroundImage;
@dynamic icon;
@dynamic talentTreeName;
@dynamic primarySpells;
@dynamic masteries;
@dynamic characterClass;
@dynamic talents;

+ (TalentTree *)addTalentTreeWithDictionary:(NSDictionary *)dictionary forCharacterClass:(CharacterClass *)characterClass inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    TalentTree *newTalentTree = [NSEntityDescription insertNewObjectForEntityForName:@"TalentTree" inManagedObjectContext:context];
    
    newTalentTree.treeNo = [dictionary objectForKey:@"treeNo"];
//    newTalentTree.roles
    newTalentTree.overlayColor = [dictionary objectForKey:@"overlayColor"];
    newTalentTree.tooltip = [dictionary objectForKey:@"description"];
    newTalentTree.backgroundImage = [dictionary objectForKey:@"backgroundFile"];
    newTalentTree.icon = [dictionary objectForKey:@"icon"];
    newTalentTree.talentTreeName = [dictionary objectForKey:@"name"];

    
    // Hook up talentTrees relationship
    newTalentTree.characterClass = characterClass;
    
    // Talents
    NSMutableSet *talentsSet = [NSMutableSet set];
    NSArray *talents = [dictionary objectForKey:@"talents"];
    for (NSDictionary *talent in talents) {
      [talentsSet addObject:[Talent addTalentWithDictionary:talent forTalentTree:newTalentTree inContext:context]];
    }
    newTalentTree.talents = talentsSet;
    
    // Masteries
    NSMutableSet *masteriesSet = [NSMutableSet set];
    NSArray *masteries = [dictionary objectForKey:@"masteries"];
    for (NSDictionary *mastery in masteries) {
      [masteriesSet addObject:[Mastery addMasteryWithDictionary:mastery forTalentTree:newTalentTree inContext:context]];
    }
    newTalentTree.masteries = masteriesSet;
    
    // PrimarySpells
    NSMutableSet *primarySpellsSet = [NSMutableSet set];
    NSArray *primarySpells = [dictionary objectForKey:@"primarySpells"];
    
    NSInteger i = 0;
    for (NSDictionary *primarySpell in primarySpells) {
      [primarySpellsSet addObject:[PrimarySpell addPrimarySpellWithDictionary:primarySpell forTalentTree:newTalentTree forIndex:i inContext:context]];
      i++;
    }
    newTalentTree.primarySpells = primarySpellsSet;
    
    return newTalentTree;
  } else {
    return nil;
  }
}

@end
