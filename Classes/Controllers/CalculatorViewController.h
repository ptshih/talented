//
//  CalculatorViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  CalculatorStateDisabled = 0,
  CalculatorStateEnabled = 1
} CalculatorState;

@interface CalculatorViewController : UIViewController {
  NSArray *_treeArray;
  NSInteger _classId;
  NSInteger _specTreeNo;
  NSInteger _totalPoints;
  NSInteger _state;
}

@property (nonatomic, retain) NSArray *treeArray;
@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, assign) NSInteger specTreeNo;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) NSInteger state;


@end
