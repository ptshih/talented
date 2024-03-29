//
//  TalentTree+Fetch.h
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TalentTree.h"

@interface TalentTree (Fetch)

+ (NSFetchRequest *)fetchRequestForTalentTreesWithCharacterClassId:(NSInteger)characterClassId;
+ (NSFetchRequest *)fetchRequestForTalentTreeWithCharacterClassId:(NSInteger)characterClassId andTreeNo:(NSInteger)treeNo;

@end