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

+ (NSFetchRequest *)fetchRequestForTalentTreesWithClassId:(NSInteger)classId {
  NSFetchRequest *request = [NSManagedObject fetchRequestWithName:@"getTalentTreesWithClassId" andSubstitutionVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:classId] forKey:@"classId"]];
  return request;
}

@end
