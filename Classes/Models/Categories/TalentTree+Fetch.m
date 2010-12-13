//
//  TalentTree+Fetch.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentTree+Fetch.h"
#import "NSManagedObject+Fetch.h"

@implementation TalentTree (Fetch)

+ (NSFetchRequest *)fetchRequestForTalentTreesWithCharacterClassId:(NSInteger)characterClassId {
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getTalentTreesWithCharacterClassId" andSubstitutionVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:characterClassId] forKey:@"characterClassId"]];
  return request;
}

@end
