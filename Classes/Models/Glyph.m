// 
//  Glyph.m
//  Talented
//
//  Created by Peter Shih on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Glyph.h"

#import "CharacterClass.h"

@implementation Glyph 

@dynamic glyphName;
@dynamic glyphId;
@dynamic glyphSpellName;
@dynamic tooltip;
@dynamic glyphType;
@dynamic icon;
@dynamic characterClass;

//  58705 =         {
//  description = "Increases the duration of your Anti-Magic Shell by 2 sec.";
//  "glyph_id" = 512;
//  icon = "spell_shadow_antimagicshell";
//  name = "Glyph of Anti-Magic Shell";
//  "spell_name" = "Anti-Magic Shell";
//  type = 0;
//};

+ (Glyph *)addGlyphWithDictionary:(NSDictionary *)dictionary forCharacterClass:(CharacterClass *)characterClass inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    
    Glyph *newGlyph = [NSEntityDescription insertNewObjectForEntityForName:@"Glyph" inManagedObjectContext:context];
    
    newGlyph.tooltip = [dictionary objectForKey:@"description"];
    newGlyph.glyphId = [dictionary objectForKey:@"glyph_id"];
    newGlyph.icon = [dictionary objectForKey:@"icon"];
    newGlyph.glyphName = [dictionary objectForKey:@"name"];
    newGlyph.glyphSpellName = [dictionary objectForKey:@"spell_name"];
    
    // Because MMOC lists glyphType in the wrong order, we're gonna translate it here
    // MMOC - TALENTED
    // 0 (major) - 1
    // 1 (minor) - 2
    // 2 (prime) - 0
    switch ([[dictionary objectForKey:@"type"] integerValue]) {
      case 0:
        newGlyph.glyphType = [NSNumber numberWithInteger:1];
        break;
      case 1:
        newGlyph.glyphType = [NSNumber numberWithInteger:2];
        break;
      case 2:
        newGlyph.glyphType = [NSNumber numberWithInteger:0];
        break;
      default:
        newGlyph.glyphType = [NSNumber numberWithInteger:0];
        break;
    }
//    newGlyph.glyphType = [dictionary objectForKey:@"type"];
    
    // Hook up glyph relationship
    newGlyph.characterClass = characterClass;
    
    return newGlyph;
  } else {
    return nil;
  }
}

@end
