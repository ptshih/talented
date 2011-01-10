//
//  SMACoreDataStack.h
//  Talented
//
//  Created by Peter Shih on 11/24/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMACoreDataStack : NSObject {

}

+ (NSManagedObjectModel *)managedObjectModel;
+ (NSManagedObjectContext *)managedObjectContext;
+ (NSString *)applicationDocumentsDirectory;

@end
