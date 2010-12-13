//
//  TreeViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalentViewController.h"

@class TreeViewController;
@class TalentTree;

@protocol TreeDelegate <NSObject>
@required
- (void)treeAdd:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView;
- (void)treeSubtract:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView;
@end

typedef enum {
  TreeStateDisabled = 0,
  TreeStateEnabled = 1,
  TreeStateFinished = 2
} TreeState;

@interface TreeViewController : UIViewController <TalentDelegate> {
  NSArray *_talentArray;
  NSMutableDictionary *_talentViewDict;
  NSArray *_pointsInTier;
  NSInteger _pointsInTree;
  NSInteger _characterClassId;
  NSInteger _treeNo;
  NSInteger _state;
  BOOL _isSpecTree;
  
  TalentTree *_talentTree;
  id <TreeDelegate> _delegate;
}

@property (nonatomic, retain) NSArray *talentArray;
@property (nonatomic, retain) NSMutableDictionary *talentViewDict;
@property (nonatomic, retain) NSArray *pointsInTier;
@property (nonatomic, assign) NSInteger pointsInTree;
@property (nonatomic, assign) NSInteger characterClassId;
@property (nonatomic, assign) NSInteger treeNo;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL isSpecTree;

@property (nonatomic, assign) TalentTree *talentTree;
@property (nonatomic, assign) id <TreeDelegate> delegate;

/**
 Update own state (tree) called by calculator
 */
- (void)updateState;

- (BOOL)canAddPoint:(TalentViewController *)talentView;

@end
