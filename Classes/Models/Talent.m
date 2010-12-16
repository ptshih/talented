// 
//  Talent.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Talent.h"
#import "TalentTree.h"
#import "Rank.h"

@implementation Talent 

@dynamic index;
@dynamic col;
@dynamic talentName;
@dynamic talentId;
@dynamic tier;
@dynamic req;
@dynamic icon;
@dynamic keyAbility;
@dynamic talentTree;
@dynamic ranks;

+ (Talent *)addTalentWithDictionary:(NSDictionary *)dictionary forTalentTree:(TalentTree *)talentTree forIndex:(NSInteger)index inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    // Check for dupes
    
    Talent *newTalent = [NSEntityDescription insertNewObjectForEntityForName:@"Talent" inManagedObjectContext:context];
    
    newTalent.index = [NSNumber numberWithInteger:index];
    newTalent.talentId = [dictionary objectForKey:@"id"];
    newTalent.req = [dictionary objectForKey:@"req"];
    newTalent.talentName = [dictionary objectForKey:@"name"];
    newTalent.icon = [dictionary objectForKey:@"icon"];
    newTalent.col = [dictionary objectForKey:@"x"];
    newTalent.tier = [dictionary objectForKey:@"y"];
    newTalent.keyAbility = [dictionary objectForKey:@"keyAbility"];
    
    // Parse and create ranks and create relationship
    NSMutableSet *ranksSet = [NSMutableSet set];
    NSArray *ranks = [dictionary valueForKey:@"ranks"];
    NSInteger i = 0;
    for(NSDictionary *rank in ranks) {
      [ranksSet addObject:[Rank addRankWithDictionary:rank forTalent:newTalent forIndex:i inContext:context]];
      i++;
    }
    newTalent.ranks = ranksSet;
    
    return newTalent;
  } else {
    return nil;
  }
}

@end
