//
//  TreeViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  TreeStateDisabled = 0,
  TreeStateEnabled = 1
} TreeState;

@interface TreeViewController : UIViewController {
  NSArray *_talentArray;
  NSArray *_pointsInTier;
  NSInteger _classId;
  NSInteger _treeNo;
  NSInteger _state;
  BOOL _isSpecTree;
}

@property (nonatomic, retain) NSArray *talentArray;
@property (nonatomic, retain) NSArray *pointsInTier;
@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, assign) NSInteger treeNo;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL isSpecTree;

@end
