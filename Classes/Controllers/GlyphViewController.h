//
//  GlyphViewController.h
//  Talented
//
//  Created by Peter Shih on 1/16/11.
//  Copyright 2011 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol GlyphDelegate <NSObject>
@required
- (void)selectedGlyphWithId:(NSNumber *)glyphId atKeyPath:(NSString *)keyPath;
@end

@interface GlyphViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *_glyphTableView;
  IBOutlet UIButton *_primeLeft;
  IBOutlet UIButton *_primeMiddle;
  IBOutlet UIButton *_primeRight;
  IBOutlet UIButton *_majorLeft;
  IBOutlet UIButton *_majorMiddle;
  IBOutlet UIButton *_majorRight;
  IBOutlet UIButton *_minorLeft;
  IBOutlet UIButton *_minorMiddle;
  IBOutlet UIButton *_minorRight;
  NSFetchedResultsController * _fetchedResultsController;
  NSInteger _characterClassId;
  id <GlyphDelegate> _delegate;
}

@property (nonatomic, retain) UITableView *glyphTableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) NSInteger characterClassId;
@property (nonatomic, assign) id <GlyphDelegate> delegate;

- (void)preloadGlyphsWithDict:(NSDictionary *)glyphDict;
- (IBAction)prepareGlyphForButton:(UIButton *)button;
- (IBAction)dismiss;

@end
