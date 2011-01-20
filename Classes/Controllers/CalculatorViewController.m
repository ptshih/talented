//
//  CalculatorViewController.m
//  Talented
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "CalculatorViewController.h"
#import "TooltipViewController.h"
#import "SMACoreDataStack.h"
#import "TalentTree.h"
#import "TalentTree+Fetch.h"
#import "Talent.h"
#import "Save.h"
#import "Constants.h"
#import "UIColor+i7HexColor.h"
#import "UIView+Additions.h"

#define SPACING_X 16.0
#define SPACING_Y 16.0
#define MARGIN_X 16.0
#define TOOLTIP_MARGIN_Y 6.0

#define MAX_POINTS 41
#define SPEC_POINTS_LIMIT 31

static UIImage *_redButtonBackground = nil;

@interface CalculatorViewController (Private)

- (void)emailExport;
- (void)specTreeChanged;
- (void)saveWithName:(NSString *)saveName;
- (NSString *)generateSaveString;
- (NSString *)generateExportString;
- (void)resetTreeAtIndex:(NSInteger)index;
- (NSInteger)getRequiredLevel;
- (void)updateFooterLabels;
- (void)updateHeaderPoints;
- (void)updateHeaderState;
- (void)setupHeader;
- (void)setupButtons;
- (void)setSwapButtonTitle;
- (void)fetchTrees;
- (void)prepareSummaries;
- (void)prepareTrees;
- (void)updateStateFromTreeNo:(NSInteger)treeNo;
- (void)updateTreeStateForTree:(NSInteger)treeNo;
- (void)showTooltipForTalentView:(TalentViewController *)talentView inTree:(TreeViewController *)treeView;

@end

@implementation CalculatorViewController

@synthesize tooltipViewController = _tooltipViewController;
@synthesize glyphDict = _glyphDict;
@synthesize treeArray = _treeArray;
@synthesize summaryViewArray = _summaryViewArray;
@synthesize treeViewArray = _treeViewArray;
@synthesize characterClassId = _characterClassId;
@synthesize specTreeNo = _specTreeNo;
@synthesize totalPoints = _totalPoints;
@synthesize state = _state;

+ (void)initialize {
  _redButtonBackground = [[[UIImage imageNamed:@"red_button.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] retain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _glyphDict = [[NSMutableDictionary alloc] init];
    _summaryViewArray = [[NSMutableArray alloc] init];
    _treeViewArray = [[NSMutableArray alloc] init];
    _characterClassId = 0;
    _specTreeNo = -1;
    _newSpecTreeNo = -1;
    _totalPoints = 0;
    _state = CalculatorStateEnabled;
    _isLoad = NO;
    _hasSaved = NO;
    _hasChanged = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Fetch trees from core data
  [self fetchTrees];
  
  // Prepare Summaries
  [self prepareSummaries];
  
  // Add Trees to View
  [self prepareTrees];
  
  // Setup Footer
  [self setSwapButtonTitle];
  
  // Setup Header
  [self setupHeader];
  [self updateHeaderState];
  [self updateHeaderPoints];
  
  // Setup Footer
  [self updateFooterLabels];
  
  // Setup Buttons (red buttons)
  [self setupButtons];
}

#pragma mark Navigation
- (IBAction)back {
  // If the current calculator has more than 0 points, create a temporary save
  // Next time the user enters a class, if we have a temporary save, ask the user if they want to load from it
  if ((self.totalPoints > 0 && !_hasSaved) || (_isLoad && _hasChanged)) {
    // Generate the save string
    NSString *recentSaveString = [self generateSaveString];
    // Save the specTreeNo
    NSNumber *recentSaveSpecTreeNo = [NSNumber numberWithInteger:self.specTreeNo];
//    // Save the characterClassId
//    NSNumber *recentSaveCharacterClassId = [NSNumber numberWithInteger:self.characterClassId];
    NSDictionary *recentSaveDict = [NSDictionary dictionaryWithObjectsAndKeys:recentSaveSpecTreeNo, @"specTreeNo", recentSaveString, @"saveString", nil];
    NSString *recentSavePath = [NSString stringWithFormat:@"recent_save_%d", self.characterClassId];
    NSString *recentGlyphPath = [NSString stringWithFormat:@"recent_glyph_%d", self.characterClassId];
    [[NSUserDefaults standardUserDefaults] setObject:recentSaveDict forKey:recentSavePath];
    [[NSUserDefaults standardUserDefaults] setObject:self.glyphDict forKey:recentGlyphPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark AlertDelegate
- (void)alertCancelled {
  [_alertPopoverController dismissPopoverAnimated:YES];
}

- (void)alertSavedWithName:(NSString *)saveName {
  [_alertPopoverController dismissPopoverAnimated:YES];
  [self saveWithName:saveName];
}

#pragma mark Export to WoWHead
- (NSString *)classNameForCharacterClassId:(NSInteger)characterClassId {
  NSString *className;
  switch (characterClassId) {
    case 1:
      className = @"warrior";
      break;
    case 2:
      className = @"paladin";
      break;
    case 3:
      className = @"hunter";
      break;
    case 4:
      className = @"rogue";
      break;
    case 5:
      className = @"priest";
      break;
    case 6:
      className = @"deathknight";
      break;
    case 7:
      className = @"shaman";
      break;
    case 8:
      className = @"mage";
      break;
    case 9:
      className = @"warlock";
      break;
    case 11:
      className = @"druid";
      break;
    default:
      className = @"ghostcrawler";
      break;
  }
  return className;
}

- (IBAction)export {
  if (self.totalPoints > 0) {
    [self emailExport];
  } else {
    UIAlertView *exportAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oh Noes!", @"Oh Noes!") message:NSLocalizedString(@"Cannot export an empty talent build", @"Cannot export an empty talent build") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [exportAlert show];
    [exportAlert autorelease];
  }

}

- (void)emailExport {
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
		mailVC.navigationBar.barStyle = UIBarStyleBlackOpaque;
		mailVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
		NSString *emailBody = [NSString stringWithFormat:@"Paste/Click the following link in your browser to view your talent build on WoWHead.\n\n%@", [self generateExportString]];
		[mailVC setMailComposeDelegate:self];
		NSString *subject = [NSString stringWithFormat:@"Talented: %@ - Exported for WoWHead", [[self classNameForCharacterClassId:self.characterClassId] capitalizedString]];
		[mailVC setSubject:subject];
		[mailVC setMessageBody:emailBody isHTML:NO];
		[self presentModalViewController:mailVC animated:YES];
    
		[mailVC release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Mail Accounts Found", @"No Mail Accounts Found") message:NSLocalizedString(@"You must setup a Mail account before using this feature", @"You must setup a Mail account before using this feature") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
  
}

- (IBAction)glyph {
  GlyphViewController *gvc = [[GlyphViewController alloc] initWithNibName:@"GlyphViewController" bundle:nil];
  gvc.characterClassId = self.characterClassId;
  gvc.delegate = self;
  gvc.calculatorViewController = self;
  [self presentModalViewController:gvc animated:YES];
  if ([self.glyphDict count] > 0) {
    [gvc preloadGlyphsWithDict:self.glyphDict];
  }
  [gvc release];
}

#pragma mark GlyphDelegate
- (void)selectedGlyphWithId:(NSNumber *)glyphId atKeyPath:(NSString *)keyPath {
  [self.glyphDict setValue:glyphId forKey:keyPath];
}

#pragma mark MFMailCompose
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Save/Load
- (IBAction)save {
  // Make sure a specTree has been selected, else alert error
  if (self.specTreeNo >= 0) {
    AlertViewController *avc = [[AlertViewController alloc] initWithNibName:@"AlertViewController" bundle:nil];
    avc.delegate = self;
    _alertPopoverController = [[UIPopoverController alloc] initWithContentViewController:avc];
    
    _alertPopoverController.popoverContentSize = avc.view.frame.size;
    CGRect popoverRect = CGRectMake((self.view.width / 2), 142.0, avc.view.width, avc.view.height);
    [_alertPopoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:NO animated:YES];
    
    [avc release];
  } else {
    UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Save Talents", @"Cannot Save Talents") message:NSLocalizedString(@"Please select a specialization tree", @"Please select a specialization tree") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [saveAlert show];
    [saveAlert autorelease];
  }
}

- (IBAction)load {
  if (!_saveViewController) {
    _saveViewController = [[SaveViewController alloc] initWithNibName:@"SaveViewController" bundle:nil];
    _saveViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    _saveViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _saveViewController.delegate = self;
  }
  _saveViewController.characterClassId = self.characterClassId;
  [self presentModalViewController:_saveViewController animated:YES];
  
//  NSString *tmpString = @"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,3,1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
//  [self loadWithSaveString:tmpString andSpecTree:1];
}

- (void)loadWithSaveString:(NSString *)saveString andSpecTree:(NSInteger)specTree andGlyphDict:(NSDictionary *)glyphDict isRecent:(BOOL)isRecent {
  if (!isRecent) {
    _isLoad = YES;
    _hasSaved = YES;
  }
  _hasChanged = NO;
  [self resetAll];
  self.specTreeNo = specTree;
  self.glyphDict = [NSDictionary dictionaryWithDictionary:glyphDict];
  NSArray *saveArray = [saveString componentsSeparatedByString:@","];
  NSInteger i = 0;
  NSInteger j = 0;
  for (TreeViewController *treeVC in self.treeViewArray) {
    [treeVC resetState];
    j = 0;
    for (TalentViewController *talentVC in treeVC.talentViewArray) {
      talentVC.currentRank = [[saveArray objectAtIndex:i] integerValue];
      i++;
      j+= talentVC.currentRank;
      [treeVC addPoints:talentVC.currentRank toTier:[talentVC.talent.tier integerValue]];
    }
    if (treeVC.treeNo == self.specTreeNo) treeVC.isSpecTree = YES;
    treeVC.pointsInTree = j;
    self.totalPoints += j;
  }
  [self updateStateFromTreeNo:self.specTreeNo];
  
  // Go back to talentView view if on summaryView
  UIView *activeView = [self.view.subviews objectAtIndex:1];
  if ([activeView isEqual:_summaryView]) {
    [self swapViews];
  }
}

- (void)saveWithName:(NSString *)saveName {
  _hasSaved = YES;
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  
  // Serialize glyphDict to NSData
  NSString *error;
  NSData *glyphData = [NSPropertyListSerialization dataFromPropertyList:self.glyphDict format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
  
  NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.characterClassId], @"characterClassId", [NSNumber numberWithInteger:self.specTreeNo], @"saveSpecTree", saveName, @"saveName", [self generateSaveString], @"saveString", [NSNumber numberWithInteger:[[self.treeViewArray objectAtIndex:0] pointsInTree]], @"leftPoints", [NSNumber numberWithInteger:[[self.treeViewArray objectAtIndex:1] pointsInTree]], @"middlePoints", [NSNumber numberWithInteger:[[self.treeViewArray objectAtIndex:2] pointsInTree]], @"rightPoints", [NSDate date], @"timestamp", glyphData, @"glyphData", nil];
  
  Save *newSave = [Save addSaveWithDictionary:saveDict inContext:context];
  
  if (newSave) {
    if (context.hasChanges) {
      if (![context save:nil]) {
      }
    }
  }
}

- (NSString *)generateSaveString {
  NSMutableArray *saveArray = [NSMutableArray array];
  // Dump talent's current ranks
  for (TreeViewController *treeVC in self.treeViewArray) {
    for (TalentViewController *talentVC in treeVC.talentViewArray) {
      [saveArray addObject:[NSString stringWithFormat:@"%d", talentVC.currentRank]];
    }
  }
  return [saveArray componentsJoinedByString:@","];
}

- (NSString *)generateExportString {
  NSString *wowheadBaseUrl = @"http://www.wowhead.com/talent#";
  NSMutableArray *exportArray = [NSMutableArray array];
  // Dump talent's current ranks
  for (TreeViewController *treeVC in self.treeViewArray) {
    for (TalentViewController *talentVC in treeVC.talentViewArray) {
      [exportArray addObject:[NSString stringWithFormat:@"%d", talentVC.currentRank]];
    }
  }
  NSString *exportString = [NSString stringWithFormat:@"%@%@-%@", wowheadBaseUrl, [self classNameForCharacterClassId:self.characterClassId], [exportArray componentsJoinedByString:@""]];
  return exportString;
}

#pragma mark SaveDelegate
- (void)loadSave:(Save *)save fromSender:(id)sender {
  [sender dismissModalViewControllerAnimated:NO];
  DLog(@"loading save: %@", save);
  self.characterClassId = [save.characterClassId integerValue];
  self.specTreeNo = [save.saveSpecTree integerValue];
  
  NSString *error;
  NSPropertyListFormat format;
  NSDictionary *glyphDict = [NSPropertyListSerialization propertyListFromData:save.glyphData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
  
  [self loadWithSaveString:save.saveString andSpecTree:[save.saveSpecTree integerValue] andGlyphDict:glyphDict isRecent:NO];
}

#pragma mark Reset
- (IBAction)resetLeft {
  [self resetTreeAtIndex:0];
}

- (IBAction)resetMiddle {
  [self resetTreeAtIndex:1];
}

- (IBAction)resetRight {
  [self resetTreeAtIndex:2];
}

- (void)resetTreeAtIndex:(NSInteger)index {
  // If we are resetting the spec tree, make sure we aren't in EnabledAll state
  // If the side two trees are enabled, we have to reset the side trees also
  if (self.specTreeNo == index && (self.state == CalculatorStateAllEnabled || self.state == CalculatorStateFinished)) {
    // LOGIC NEEDED
    NSInteger pointsInOtherTrees = 0;
    for (TreeViewController *tree in self.treeViewArray) {
      if (tree.treeNo == self.specTreeNo) continue;
      pointsInOtherTrees += tree.pointsInTree;
    }
    if (pointsInOtherTrees > 0) {
      UIAlertView *resetAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can't Reset Tree", @"Can't Reset Tree") message:NSLocalizedString(@"Can't reset specialization tree until other two talent trees have 0 points allocated", @"Can't Reset Tree Message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
      [resetAlertView show];
      [resetAlertView autorelease];
      return;
    }
  }
  
  if ([[self.treeViewArray objectAtIndex:index] state] == TreeStateDisabled) {
    return;
  }
  
  TreeViewController *tvc = [self.treeViewArray objectAtIndex:index];
  self.totalPoints -= tvc.pointsInTree;
  self.state = CalculatorStateEnabled;
  
  [self hideTooltip];
  [tvc resetTree];
  
  [self updateStateFromTreeNo:index];
}

- (IBAction)resetAll {
  self.totalPoints = 0;
  self.state = CalculatorStateEnabled;
  self.specTreeNo = -1;
  
  [self hideTooltip];
  
  for (TreeViewController *tvc in self.treeViewArray) {
    tvc.isSpecTree = NO;
    [tvc resetState];
    [tvc updateState];
  }
  
  [self updateHeaderState];
  [self updateHeaderPoints];
  [self updateFooterLabels];
  
  // Go back to summary view if on talentView
  UIView *activeView = [self.view.subviews objectAtIndex:1];
  if ([activeView isEqual:_talentTreeView]) {
    [self swapViews];
  }
  
}

- (IBAction)swapViews {
  // Animate dissolve this
  [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
  [self setSwapButtonTitle];
}

- (void)setSwapButtonTitle {
  UIView *activeView = [self.view.subviews objectAtIndex:1];
  if ([activeView isEqual:_talentTreeView]) {
    [_swapButton setTitle:NSLocalizedString(@"View Summaries", @"View Summaries") forState:UIControlStateNormal];
  } else {
    [_swapButton setTitle:NSLocalizedString(@"View Talents", @"View Summaries") forState:UIControlStateNormal];
  }
}

- (void)setupButtons {
  [_glyphButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];
  [_exportButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];
  [_backButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];
  [_loadButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];
  [_saveButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];
  [_swapButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];
  [_resetButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];

  [_glyphButton setTitle:NSLocalizedString(@"Glyphs", @"Glyphs") forState:UIControlStateNormal];
  [_exportButton setTitle:NSLocalizedString(@"Export", @"Export") forState:UIControlStateNormal];
  [_backButton setTitle:NSLocalizedString(@"Choose a Class", @"Choose a Class") forState:UIControlStateNormal];
  [_loadButton setTitle:NSLocalizedString(@"Load", @"Load") forState:UIControlStateNormal];
  [_saveButton setTitle:NSLocalizedString(@"Save", @"Save") forState:UIControlStateNormal];
  [_resetButton setTitle:NSLocalizedString(@"Reset All", @"Reset All") forState:UIControlStateNormal];
}

- (void)setupHeader {  
#ifdef REMOTE_TALENT_IMAGES
  NSURL *imageUrl = [[[NSURL alloc] initWithString:WOW_ICON_URL([[self.treeArray objectAtIndex:0] icon])] autorelease];
  NSURLRequest *myRequest = [[[NSURLRequest alloc] initWithURL:imageUrl] autorelease];
  NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  UIImage *myImage  = [[[UIImage alloc] initWithData:returnData] autorelease];
#else
  UIImage *myImage = [UIImage imageNamed:WOW_ICON_LOCAL([[self.treeArray objectAtIndex:0] icon])];
#endif
  
#ifdef DOWNLOAD_TALENT_IMAGES
  NSString *filePath = [[SMACoreDataStack applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [[self.treeArray objectAtIndex:0] icon]]];
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:returnData attributes:nil];
  }
#endif
  
  _leftIcon.image = myImage;
  _leftLabel.text = [[self.treeArray objectAtIndex:0] talentTreeName];
  
#ifdef REMOTE_TALENT_IMAGES
  imageUrl = [[[NSURL alloc] initWithString:WOW_ICON_URL([[self.treeArray objectAtIndex:1] icon])] autorelease];
  myRequest = [[[NSURLRequest alloc] initWithURL:imageUrl] autorelease];
  returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  myImage  = [[[UIImage alloc] initWithData:returnData] autorelease];
#else
  myImage = [UIImage imageNamed:WOW_ICON_LOCAL([[self.treeArray objectAtIndex:1] icon])];
#endif
  
#ifdef DOWNLOAD_TALENT_IMAGES
  filePath = [[SMACoreDataStack applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [[self.treeArray objectAtIndex:1] icon]]];
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:returnData attributes:nil];
  }
#endif
  
  _middleIcon.image = myImage;
  _middleLabel.text = [[self.treeArray objectAtIndex:1] talentTreeName];
  
#ifdef REMOTE_TALENT_IMAGES
  imageUrl = [[[NSURL alloc] initWithString:WOW_ICON_URL([[self.treeArray objectAtIndex:2] icon])] autorelease];
  myRequest = [[[NSURLRequest alloc] initWithURL:imageUrl] autorelease];
  returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  myImage  = [[[UIImage alloc] initWithData:returnData] autorelease];
#else
  myImage = [UIImage imageNamed:WOW_ICON_LOCAL([[self.treeArray objectAtIndex:2] icon])];
#endif
  
#ifdef DOWNLOAD_TALENT_IMAGES
  filePath = [[SMACoreDataStack applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [[self.treeArray objectAtIndex:2] icon]]];
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:returnData attributes:nil];
  }
#endif
  
  _rightIcon.image = myImage;
  _rightLabel.text = [[self.treeArray objectAtIndex:2] talentTreeName];
}

#pragma mark Fetch Trees from CoreData
- (void)fetchTrees {
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"TalentTree" inManagedObjectContext:context];
  
  NSFetchRequest *request = [TalentTree fetchRequestForTalentTreesWithCharacterClassId:self.characterClassId];
  [request setEntity:entity];
  
  // Set an ASC sort on treeNo
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"treeNo" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [sortDescriptor release];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error;
  NSArray *array = [context executeFetchRequest:request error:&error];
  if(array) {
    self.treeArray = array;
  }
  
  DLog(@"Loaded at index 0: %@", [[self.treeArray objectAtIndex:0] talentTreeName]);
  DLog(@"Loaded at index 1: %@", [[self.treeArray objectAtIndex:1] talentTreeName]);
  DLog(@"Loaded at index 2: %@", [[self.treeArray objectAtIndex:2] talentTreeName]);

}

- (void)prepareSummaries {
  NSInteger treeNo = 0;
  for (TalentTree *talentTree in self.treeArray) {
    treeNo = [[talentTree treeNo] integerValue];
    SummaryViewController *svc = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    svc.talentTree = talentTree;
    svc.delegate = self;
    svc.view.frame = CGRectMake(SPACING_X + (SPACING_X * treeNo) + (320 * treeNo), 0, svc.view.frame.size.width, svc.view.frame.size.height);
    [_summaryView addSubview:svc.view];
    [self.summaryViewArray addObject:svc];
    [svc release];
  }
}

#pragma mark Prepare Trees
- (void)prepareTrees {
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [sortDescriptor release];
  
  for (TalentTree *talentTree in self.treeArray) {
    TreeViewController *tvc = [[TreeViewController alloc] initWithNibName:@"TreeViewController" bundle:nil];
    tvc.talentTree = talentTree;
    tvc.delegate = self;
    tvc.talentArray = [[talentTree.talents allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    tvc.characterClassId = self.characterClassId;
    tvc.treeNo = [[talentTree treeNo] integerValue];
    tvc.isSpecTree = (tvc.treeNo == self.specTreeNo) ? YES : NO;
    tvc.view.frame = CGRectMake(SPACING_X + (SPACING_X * tvc.treeNo) + (320 * tvc.treeNo), 0, tvc.view.frame.size.width, tvc.view.frame.size.height);
    [_talentTreeView addSubview:tvc.view];
    [self.treeViewArray addObject:tvc];
    [tvc release];
  }
  
  [self updateTreeStateForTree:0];
  [self updateTreeStateForTree:1];
  [self updateTreeStateForTree:2];
}

#pragma mark Calculator Logic
- (void)updateStateFromTreeNo:(NSInteger)treeNo {
  // Check for max points in calculator
  if (self.totalPoints == MAX_POINTS) {
    self.state = CalculatorStateFinished;
  } else {
    if (self.state != CalculatorStateAllEnabled) {
      self.state = CalculatorStateEnabled;
    }
  }
  
  // Check to see if spec tree has reached 31
  if ([[self.treeViewArray objectAtIndex:self.specTreeNo] pointsInTree] >= SPEC_POINTS_LIMIT && self.state == CalculatorStateEnabled) {
    self.state = CalculatorStateAllEnabled;
    [self updateTreeStateForTree:0];
    [self updateTreeStateForTree:1];
    [self updateTreeStateForTree:2];
  } else if ([[self.treeViewArray objectAtIndex:self.specTreeNo] pointsInTree] < SPEC_POINTS_LIMIT) {
    self.state = CalculatorStateEnabled;
    [self updateTreeStateForTree:0];
    [self updateTreeStateForTree:1];
    [self updateTreeStateForTree:2];
  } else {
    [self updateTreeStateForTree:treeNo];
  }
  
  [self updateHeaderState];
  [self updateHeaderPoints];
  [self updateFooterLabels];
}

- (void)updateTreeStateForTree:(NSInteger)treeNo {
  // If calculator is disabled, then tell all trees
  if (self.state == CalculatorStateFinished) {
    for (TreeViewController *tvc in self.treeViewArray) {
      tvc.state = TreeStateFinished;
      [tvc updateState];
    }
    return;
  }
  
  BOOL isSpecLimitReached = NO;
  
  // Check to see if spec tree has reached 31
  if (self.specTreeNo >= 0) {
    if ([[self.treeViewArray objectAtIndex:self.specTreeNo] pointsInTree] >= SPEC_POINTS_LIMIT) {
      isSpecLimitReached = YES;
    }
  }
  
  for (TreeViewController *tvc in self.treeViewArray) {
    // If we have reached 31pts in spec tree, enable all 3 trees
    if (isSpecLimitReached) {
      tvc.state = TreeStateEnabled;
    } else {
      if (tvc.treeNo == self.specTreeNo) {
        tvc.state = TreeStateEnabled;
      } else {
        tvc.state = TreeStateDisabled;
      }
    }

    [tvc updateState];
  }
  
}

#pragma mark TreeDelegate
- (void)dismissPopoverFromTree:(TreeViewController *)treeView {
  [self hideTooltip];
}

- (void)talentTappedForTree:(TreeViewController *)treeView andTalentView:(TalentViewController *)talentView {
  [self showTooltipForTalentView:talentView inTree:treeView];
}

- (void)treeAdd:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView {
  DLog(@"Adding a point for tree: %d", treeView.treeNo);
  self.totalPoints++;
  
  [self updateStateFromTreeNo:treeView.treeNo];
  _hasChanged = YES;
}

- (void)treeSubtract:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView {
  DLog(@"Subtracting a point for tree: %d", treeView.treeNo);
  self.totalPoints--;

  [self updateStateFromTreeNo:treeView.treeNo];
  _hasChanged = YES;
}

- (BOOL)canSubtract:(TreeViewController *)treeView {
  if (self.state == CalculatorStateAllEnabled || self.state == CalculatorStateFinished) {
    for (TreeViewController *tree in self.treeViewArray) {
      if (tree.treeNo == self.specTreeNo) continue;
      if (tree.pointsInTree > 0) {
        return NO;
      }
    }
  } else {
    return YES;
  }
  return YES;
}

#pragma mark SummaryDelegate
- (void)specTreeSelected:(NSInteger)treeNo {
  // If selected spec tree is the same as the current spec tree, do nothing
  if (self.specTreeNo == treeNo) {
    [self swapViews];
    return;
  }
  
  // Set the new spec tree num temp variable in case we end up changing the spec tree
  _newSpecTreeNo = treeNo;

  // If there are currently points allocated in any of the trees, ask the user if we should reset
  if (self.totalPoints > 0) {
    UIAlertView *specTreeChangeAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset Specialization", @"Reset Specialization") message:NSLocalizedString(@"Changing your specialization will reset all allocated talent points. Would you like to continue?", @"Changing your specialization will reset all allocated talent points. Would you like to continue?") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
    [specTreeChangeAlert show];
    [specTreeChangeAlert autorelease];
  } else {
    [self specTreeChanged];
  }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex != alertView.cancelButtonIndex) {
    [self resetAll];
    [self specTreeChanged];
  }
}

- (void)specTreeChanged {
  // Update the primary spec tree
  self.specTreeNo = _newSpecTreeNo;
  for (TreeViewController *tree in self.treeViewArray) {
    if (tree.treeNo == self.specTreeNo) {
      tree.isSpecTree = YES;
    } else {
      tree.isSpecTree = NO;
    }
    [self updateTreeStateForTree:tree.treeNo];
  }
  [self updateHeaderState];
  [self swapViews];
}


#pragma mark Header Updates
- (void)updateHeaderPoints {
  _leftPoints.text = [NSString stringWithFormat:@"%d", [[self.treeViewArray objectAtIndex:0] pointsInTree]];
  _middlePoints.text = [NSString stringWithFormat:@"%d", [[self.treeViewArray objectAtIndex:1] pointsInTree]];
  _rightPoints.text = [NSString stringWithFormat:@"%d", [[self.treeViewArray objectAtIndex:2] pointsInTree]];
}

- (void)updateHeaderState { 
  // Update Borders and Points
  if (self.state == CalculatorStateAllEnabled || self.state == CalculatorStateFinished) {
    _leftPoints.hidden = NO;
    _middlePoints.hidden = NO;
    _rightPoints.hidden = NO;
    
    _leftBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
    _middleBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
    _rightBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
  } else {
    switch (self.specTreeNo) {
      case 0:
        _leftPoints.hidden = NO;
        _middlePoints.hidden = YES;
        _rightPoints.hidden = YES;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        break;
      case 1:
        _leftPoints.hidden = YES;
        _middlePoints.hidden = NO;
        _rightPoints.hidden = YES;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        break;
      case 2:
        _leftPoints.hidden = YES;
        _middlePoints.hidden = YES;
        _rightPoints.hidden = NO;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
        break;
      default:
        // Reset state (-1)
        _leftPoints.hidden = YES;
        _middlePoints.hidden = YES;
        _rightPoints.hidden = YES;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        break;
    }
  }
}

#pragma mark Footer Updates
- (void)updateFooterLabels {
  _requiredLevel.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Required Level", @"Required Level"), [self getRequiredLevel]];
  _pointsLeft.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Points Left", @"Points Left"), MAX_POINTS - self.totalPoints];
  _pointsSpent.text = [NSString stringWithFormat:@"%@: %d / %d / %d", NSLocalizedString(@"Points Spent", @"Points Spent"), [[self.treeViewArray objectAtIndex:0] pointsInTree], [[self.treeViewArray objectAtIndex:1] pointsInTree], [[self.treeViewArray objectAtIndex:2] pointsInTree]];
}

- (NSInteger)getRequiredLevel {
  if (self.totalPoints == 0) return 0;
 
  NSInteger reqLevel = 9;
  NSInteger points = self.totalPoints;
  
  // First 2 points = every 1 level
  NSInteger part = MIN(2, points);
  if (part > 0) {
    reqLevel += part;
    points -= part;
  }
  
  // Next 35 points = every 2 levels
  part = MIN(35, points);
  if (part > 0) {
    reqLevel += part * 2;
    points -= part;
  }
  
  // Last 4 points = every 1 level
  part = MIN(5, points);
  if (part > 0) {
    reqLevel += part;
//    points -= part;
  }
  
  return reqLevel;
}

#pragma mark Tooltip Methods
- (void)showTooltipForTalentView:(TalentViewController *)talentView inTree:(TreeViewController *)treeView {
  if (!self.tooltipViewController) {
    _tooltipViewController = [[TooltipViewController alloc] init];
  } else {
    [self hideTooltip];
  }

  
//  if (!_tooltipPopoverController) {
//    _tooltipPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.tooltipViewController];
//  } else {
//    [_tooltipPopoverController dismissPopoverAnimated:NO];
//  }
  
  // Calculate available height based on tier selected
  CGFloat availableHeight = 0.0;
  if ([talentView.talent.tier integerValue] >= 4) {
    availableHeight = talentView.view.top - TOOLTIP_MARGIN_Y * 2;
  } else {
    availableHeight = _talentTreeView.height - (talentView.view.bottom + TOOLTIP_MARGIN_Y * 2);
  }
  DLog(@"availHeight = %f", availableHeight);
  self.tooltipViewController.availableHeight = availableHeight;
  
  self.tooltipViewController.treeView = treeView;
  self.tooltipViewController.talentView = talentView;
  [self.tooltipViewController reloadTooltipData];
  
//  _tooltipPopoverController.popoverContentSize = self.tooltipViewController.view.frame.size;
//  
//  NSMutableArray *views = [NSMutableArray array];
//  for (TreeViewController *tvc in self.treeViewArray) {
//    [views addObject:tvc.view];
//  }
//  _tooltipPopoverController.passthroughViews = views;
  
  // Calculate Popover positioning
  // Invert, etc...
  // IF tier >= 4, invert
  NSInteger tooltipTop;
  if ([talentView.talent.tier integerValue] >= 4) {
    tooltipTop = talentView.view.top - self.tooltipViewController.view.height - TOOLTIP_MARGIN_Y;
  } else {
    tooltipTop = talentView.view.bottom + TOOLTIP_MARGIN_Y;
  }
  
  CGRect tooltipFrame = CGRectMake(treeView.view.left + 10.0, tooltipTop, treeView.view.width, self.tooltipViewController.view.height);
//  [_tooltipPopoverController presentPopoverFromRect:popoverFrame inView:_talentTreeView permittedArrowDirections:NO animated:YES];
//  
  self.tooltipViewController.view.frame = tooltipFrame;
  
  self.tooltipViewController.view.alpha = 0.0f;
  [_talentTreeView addSubview:self.tooltipViewController.view];
  [UIView beginAnimations:@"TooltipTransition" context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];  
  [UIView setAnimationDuration:0.2f];
  self.tooltipViewController.view.alpha = 1.0f;
  [UIView commitAnimations];

}


- (void)hideTooltip {
  if (self.tooltipViewController) {
    [self.tooltipViewController.view removeFromSuperview];
  }
//	if(_tooltipPopoverController) {
//    [_tooltipPopoverController dismissPopoverAnimated:animated];
//	}
}

#pragma mark Memory Management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  // IBOutlets
  if (_glyphButton) [_glyphButton release];
  if (_exportButton) [_exportButton release];
  if (_swapButton) [_swapButton release];
  if (_resetButton) [_resetButton release];
  if (_backButton) [_backButton release];
  if (_loadButton) [_loadButton release];
  if (_saveButton) [_saveButton release];
  if (_leftIcon) [_leftIcon release];
  if (_middleIcon) [_middleIcon release];
  if (_rightIcon) [_rightIcon release];
  if (_leftLabel) [_leftLabel release];
  if (_middleLabel) [_middleLabel release];
  if (_rightLabel) [_rightLabel release];
  if (_leftBorder) [_leftBorder release];
  if (_middleBorder) [_middleBorder release];
  if (_rightBorder) [_rightBorder release];
  if (_leftPoints) [_leftPoints release];
  if (_middlePoints) [_middlePoints release];
  if (_rightPoints) [_rightPoints release];
  if (_requiredLevel) [_requiredLevel release];
  if (_pointsLeft) [_pointsLeft release];
  if (_pointsSpent) [_pointsSpent release];
  if (_talentTreeView) [_talentTreeView release];
  if (_summaryView) [_summaryView release];
  
  if (_tooltipViewController) [_tooltipViewController release];
  if (_summaryViewArray) [_summaryViewArray release];
  if (_treeViewArray) [_treeViewArray release];
  if (_treeArray) [_treeArray release];
  if (_glyphDict) [_glyphDict release];
  
  if (_alertPopoverController) [_alertPopoverController release];
  if (_saveViewController) [_saveViewController release];
  [super dealloc];
}

@end
