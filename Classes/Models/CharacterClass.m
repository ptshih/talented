// 
//  CharacterClass.m
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CharacterClass.h"
#import "TalentTree.h"

@implementation CharacterClass 

@dynamic powerType;
@dynamic characterClassId;
@dynamic characterClassName;
@dynamic talentTrees;

+ (CharacterClass *)addCharacterClassWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    CharacterClass *newCharacterClass = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterClass" inManagedObjectContext:context];
    
    newCharacterClass.characterClassId = [dictionary objectForKey:@"classId"];
    newCharacterClass.characterClassName = [dictionary objectForKey:@"name"];
    newCharacterClass.powerType = [dictionary objectForKey:@"powerType"];
    
    // Hook up talentTrees relationship
    // The talentTrees relation will be hooked up later
//    newCharacterClass.talentTrees = nil;
    
    return newCharacterClass;
  } else {
    return nil;
  }
}

@end
