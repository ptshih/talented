//
//  CalculatorViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewController.h"
#import "SummaryViewController.h"

typedef enum {
  CalculatorStateDisabled = 0,
  CalculatorStateEnabled = 1,
  CalculatorStateAllEnabled = 2
} CalculatorState;

@class TooltipViewController;

@interface CalculatorViewController : UIViewController <TreeDelegate, SummaryDelegate> {
  IBOutlet UIView *_talentTreeView;
  IBOutlet UIView *_summaryView;
  IBOutlet UIButton *_swapButton;
  IBOutlet UIButton *_resetButton;
  
  // Header Stuff
  IBOutlet UIImageView *_leftIcon;
  IBOutlet UIImageView *_middleIcon;
  IBOutlet UIImageView *_rightIcon;
  IBOutlet UILabel *_leftLabel;
  IBOutlet UILabel *_middleLabel;
  IBOutlet UILabel *_rightLabel;
  IBOutlet UIImageView *_leftBorder;
  IBOutlet UIImageView *_middleBorder;
  IBOutlet UIImageView *_rightBorder;
  IBOutlet UILabel *_leftPoints;
  IBOutlet UILabel *_middlePoints;
  IBOutlet UILabel *_rightPoints;  
  
  TooltipViewController *_tooltipViewController;
  UIPopoverController *_tooltipPopoverController;
  NSArray *_treeArray;
  NSMutableArray *_treeViewArray;
  NSMutableArray *_summaryViewArray;
  NSInteger _characterClassId;
  NSInteger _specTreeNo;
  NSInteger _totalPoints;
  NSInteger _state;
}

@property (nonatomic, retain) TooltipViewController *tooltipViewController;
@property (nonatomic, retain) NSArray *treeArray;
@property (nonatomic, retain) NSMutableArray *treeViewArray;
@property (nonatomic, retain) NSMutableArray *summaryViewArray;
@property (nonatomic, assign) NSInteger characterClassId;
@property (nonatomic, assign) NSInteger specTreeNo;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) NSInteger state;

- (IBAction)resetAll;
- (IBAction)swapViews;
- (void)hideTooltip:(BOOL)animated;

@end
