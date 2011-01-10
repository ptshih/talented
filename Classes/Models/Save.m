// 
//  Save.m
//  Talented
//
//  Created by Peter Shih on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Save.h"


@implementation Save 

@dynamic saveSpecTree;
@dynamic saveName;
@dynamic middlePoints;
@dynamic saveString;
@dynamic characterClassId;
@dynamic rightPoints;
@dynamic timestamp;
@dynamic leftPoints;

+ (Save *)addSaveWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
  if (dictionary) {
    Save *newSave = [NSEntityDescription insertNewObjectForEntityForName:@"Save" inManagedObjectContext:context];
    
    newSave.saveSpecTree = [dictionary objectForKey:@"saveSpecTree"];
    newSave.characterClassId = [dictionary objectForKey:@"characterClassId"];
    newSave.saveName = [dictionary objectForKey:@"saveName"];
    newSave.saveString = [dictionary objectForKey:@"saveString"];
    newSave.leftPoints = [dictionary objectForKey:@"leftPoints"];
    newSave.middlePoints = [dictionary objectForKey:@"middlePoints"];
    newSave.rightPoints = [dictionary objectForKey:@"rightPoints"];
    newSave.timestamp = [dictionary objectForKey:@"timestamp"];
    
    return newSave;
  } else {
    return nil;
  }
}

@end
