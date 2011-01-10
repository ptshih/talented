// 
//  Rank.m
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Rank.h"
#import "Talent.h"

@implementation Rank 

@dynamic cost;
@dynamic castTime;
@dynamic cooldown;
@dynamic requires;
@dynamic reagents;
@dynamic spellRange;
@dynamic rank;
@dynamic tooltip;
@dynamic talent;

+ (Rank *)addRankWithDictionary:(NSDictionary *)dictionary forTalent:(Talent *)talent forIndex:(NSInteger)index inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    Rank *newRank = [NSEntityDescription insertNewObjectForEntityForName:@"Rank" inManagedObjectContext:context];
    
    newRank.rank = [NSNumber numberWithInteger:index];
    newRank.cost = [dictionary objectForKey:@"cost"];
    newRank.castTime = [dictionary objectForKey:@"castTime"];
    newRank.cooldown = [dictionary objectForKey:@"cooldown"];
    newRank.requires = [dictionary objectForKey:@"requires"];
//    newRank.reagents = [dictionary objectForKey:@"reagents"];
    newRank.spellRange = [dictionary objectForKey:@"range"];
    newRank.tooltip = [dictionary objectForKey:@"description"];
    
    // Hook up talent relationship
    newRank.talent = talent;
    
    return newRank;
  } else {
    return nil;
  }
}

@end
