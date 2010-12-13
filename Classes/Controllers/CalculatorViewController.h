//
//  CalculatorViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewController.h"

typedef enum {
  CalculatorStateDisabled = 0,
  CalculatorStateEnabled = 1,
  CalculatorStateAllEnabled = 2
} CalculatorState;

@class TooltipViewController;

@interface CalculatorViewController : UIViewController <TreeDelegate> {
  TooltipViewController *_tooltipViewController;
  NSArray *_treeArray;
  NSMutableArray *_treeViewArray;
  NSInteger _characterClassId;
  NSInteger _specTreeNo;
  NSInteger _totalPoints;
  NSInteger _state;
}

@property (nonatomic, retain) TooltipViewController *tooltipViewController;
@property (nonatomic, retain) NSArray *treeArray;
@property (nonatomic, retain) NSMutableArray *treeViewArray;
@property (nonatomic, assign) NSInteger characterClassId;
@property (nonatomic, assign) NSInteger specTreeNo;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) NSInteger state;

- (void)hideTooltip;

@end
