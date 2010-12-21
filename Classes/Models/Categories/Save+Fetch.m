//
//  Save+Fetch.m
//  TalentPad
//
//  Created by Peter Shih on 12/20/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "Save+Fetch.h"
#import "NSManagedObject+Fetch.h"

@implementation Save (Fetch)

+ (NSFetchRequest *)fetchRequestForAllSaves {
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getAllSaves" andSubstitutionVariables:nil];
  return request;
}

+ (NSFetchRequest *)fetchRequestForSavesWithCharacterClassId:(NSInteger)characterClassId {
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getSavesWithCharacterClassId" andSubstitutionVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:characterClassId] forKey:@"characterClassId"]];
  return request;
}

@end
