//
//  CharacterClass.h
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TalentTree;

@interface CharacterClass :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * powerType;
@property (nonatomic, retain) NSNumber * characterClassId;
@property (nonatomic, retain) NSString * characterClassName;
@property (nonatomic, retain) NSSet* talentTrees;

+ (CharacterClass *)addCharacterClassWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
