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
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getTalentTreesWithCharacterClassId" andSubstitutionVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:characterClassId] forKey:@"characterClassId"]];
  return request;
}

+ (NSFetchRequest *)fetchRequestForTalentTreeWithCharacterClassId:(NSInteger)characterClassId andTreeNo:(NSInteger)treeNo {
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getTalentTreeWithCharacterClassIdAndTreeNo" andSubstitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:treeNo], @"treeNo", [NSNumber numberWithInteger:characterClassId], @"characterClassId", nil]];
  return request;
}

@end
