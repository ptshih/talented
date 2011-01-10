//
//  PrimarySpellButton.h
//  Talented
//
//  Created by Peter Shih on 12/14/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrimarySpellButton : UIButton {
  UIView *_parentView;
  NSInteger _primarySpellIndex;
}

@property (nonatomic, assign) UIView *parentView;
@property (nonatomic, assign) NSInteger primarySpellIndex;

@end
