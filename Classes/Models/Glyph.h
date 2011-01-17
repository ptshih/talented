//
//  Glyph.h
//  Talented
//
//  Created by Peter Shih on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CharacterClass;

@interface Glyph :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * glyphName;
@property (nonatomic, retain) NSNumber * glyphId;
@property (nonatomic, retain) NSString * glyphSpellName;
@property (nonatomic, retain) NSString * tooltip;
@property (nonatomic, retain) NSNumber * glyphType;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) CharacterClass * characterClass;

+ (Glyph *)addGlyphWithDictionary:(NSDictionary *)dictionary forCharacterClass:(CharacterClass *)characterClass inContext:(NSManagedObjectContext *)context;

@end



