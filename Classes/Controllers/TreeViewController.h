//
//  TreeViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TreeViewController : UIViewController {
  NSInteger _classId;
  NSInteger _treeNo;
  NSInteger _state;
  BOOL _isSpecTree;
}

@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, assign) NSInteger treeNo;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL isSpecTree;

@end
