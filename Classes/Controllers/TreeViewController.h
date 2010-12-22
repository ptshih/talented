//
//  TreeViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalentViewController.h"

#define MAX_TIERS 7

@class TreeViewController;
@class TalentTree;

@protocol TreeDelegate <NSObject>
@required
- (void)talentTappedForTree:(TreeViewController *)treeView andTalentView:(TalentViewController *)talentView;
@optional
- (void)dismissPopoverFromTree:(TreeViewController *)treeView;
- (void)treeAdd:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView;
- (void)treeSubtract:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView;
- (BOOL)canSubtract:(TreeViewController *)treeView;
@end

typedef enum {
  TreeStateDisabled = 0,
  TreeStateEnabled = 1,
  TreeStateFinished = 2
} TreeState;

@interface TreeViewController : UIViewController <TalentDelegate> {
  IBOutlet UIImageView *_backgroundView;
  IBOutlet UIImageView *_masteryGlow;
  NSArray *_talentArray;
  NSMutableArray *_talentViewArray;
  NSMutableDictionary *_talentViewDict;
  NSMutableDictionary *_childDict; // This is an inverse requirement (child) dictionary used for canSubtract, needs to store array in value (multi dependency)
  NSMutableDictionary *_arrowViewDict;
  NSInteger _pointsInTier[MAX_TIERS];
  NSInteger _pointsInTree;
  NSInteger _characterClassId;
  NSInteger _treeNo;
  NSInteger _state;
  BOOL _isSpecTree;
  
  TalentTree *_talentTree;
  id <TreeDelegate> _delegate;
}

@property (nonatomic, retain) NSArray *talentArray;
@property (nonatomic, retain) NSMutableArray *talentViewArray;
@property (nonatomic, retain) NSMutableDictionary *talentViewDict;
@property (nonatomic, retain) NSMutableDictionary *childDict;
@property (nonatomic, retain) NSMutableDictionary *arrowViewDict;
@property (nonatomic, assign) NSInteger pointsInTree;
@property (nonatomic, assign) NSInteger characterClassId;
@property (nonatomic, assign) NSInteger treeNo;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL isSpecTree;

@property (nonatomic, assign) TalentTree *talentTree;
@property (nonatomic, assign) id <TreeDelegate> delegate;

- (IBAction)dismissPopover;

/**
 Update own state (tree) called by calculator
 */
- (void)updateState;
- (void)resetState; // reset points AND state
- (void)resetTree; // reset points, not state

- (BOOL)canAddPoint:(TalentViewController *)talentView;
- (BOOL)canSubtractPoint:(TalentViewController *)talentView;

- (void)addPoints:(NSInteger)points toTier:(NSInteger)tier;

@end
