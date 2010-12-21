//
//  SaveViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/20/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Save;

@protocol SaveDelegate <NSObject>
@required
- (void)loadSave:(Save *)save fromSender:(id)sender;
@end

@interface SaveViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate> {
  IBOutlet UITableView *_tableView;
  NSFetchedResultsController * _fetchedResultsController;
  
  NSInteger _characterClassId;
  
  id <SaveDelegate> _delegate;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) NSInteger characterClassId;
@property (nonatomic, assign) id <SaveDelegate> delegate;

- (IBAction)add;
- (IBAction)done;

@end