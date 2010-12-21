//
//  Save+Fetch.h
//  TalentPad
//
//  Created by Peter Shih on 12/20/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Save.h"

@interface Save (Fetch)

+ (NSFetchRequest *)fetchRequestForAllSaves;
+ (NSFetchRequest *)fetchRequestForSavesWithCharacterClassId:(NSInteger)characterClassId;

@end
