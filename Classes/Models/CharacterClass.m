// 
//  CharacterClass.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CharacterClass.h"
#import "TalentTree.h"

@implementation CharacterClass 

@dynamic powerType;
@dynamic classId;
@dynamic name;
@dynamic talentTrees;

+ (CharacterClass *)addCharacterClassWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    CharacterClass *newCharacterClass = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterClass" inManagedObjectContext:context];
    
    newCharacterClass.classId = [dictionary objectForKey:@"classId"];
    newCharacterClass.name = [dictionary objectForKey:@"name"];
    newCharacterClass.powerType = [dictionary objectForKey:@"powerType"];
    
    // Hook up talentTrees relationship
    newCharacterClass.talentTrees = nil;
    
    return newCharacterClass;
  } else {
    return nil;
  }
}

@end
