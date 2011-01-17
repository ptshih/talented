//
//  Glyph+Fetch.h
//  Talented
//
//  Created by Peter Shih on 1/16/11.
//  Copyright 2011 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Glyph.h"

@interface Glyph (Fetch)

+ (NSFetchRequest *)fetchRequestForAllGlyphs;
+ (NSFetchRequest *)fetchRequestForGlyphsWithCharacterClassId:(NSInteger)characterClassId;

@end
