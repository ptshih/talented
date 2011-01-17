//
//  Glyph+Fetch.m
//  Talented
//
//  Created by Peter Shih on 1/16/11.
//  Copyright 2011 Seven Minute Apps. All rights reserved.
//

#import "Glyph+Fetch.h"
#import "NSManagedObject+Fetch.h"

@implementation Glyph (Fetch)

+ (NSFetchRequest *)fetchRequestForAllGlyphs {
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getAllGlyphs" andSubstitutionVariables:nil];
  return request;
}

+ (NSFetchRequest *)fetchRequestForGlyphsWithCharacterClassId:(NSInteger)characterClassId {
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getGlyphsWithCharacterClassId" andSubstitutionVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:characterClassId] forKey:@"characterClassId"]];
  return request;
}

@end
