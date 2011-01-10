//
//  Save.h
//  Talented
//
//  Created by Peter Shih on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Save :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * saveSpecTree;
@property (nonatomic, retain) NSString * saveName;
@property (nonatomic, retain) NSNumber * middlePoints;
@property (nonatomic, retain) NSString * saveString;
@property (nonatomic, retain) NSNumber * characterClassId;
@property (nonatomic, retain) NSNumber * rightPoints;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * leftPoints;

+ (Save *)addSaveWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end



