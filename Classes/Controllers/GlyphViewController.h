//
//  GlyphViewController.h
//  Talented
//
//  Created by Peter Shih on 1/16/11.
//  Copyright 2011 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GlyphViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *_glyphTableView;
  NSFetchedResultsController * _fetchedResultsController;
  NSInteger _characterClassId;
}

@property (nonatomic, retain) UITableView *glyphTableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) NSInteger characterClassId;

- (IBAction)dismiss;

@end
