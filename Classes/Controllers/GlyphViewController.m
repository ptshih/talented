//
//  GlyphViewController.m
//  Talented
//
//  Created by Peter Shih on 1/16/11.
//  Copyright 2011 Seven Minute Apps. All rights reserved.
//

#import "GlyphViewController.h"
#import "SMACoreDataStack.h"
#import "Glyph.h"
#import "Glyph+Fetch.h"
#import "Constants.h"
#import "TooltipViewController.h"
#import "CalculatorViewController.h"
#import "UIView+Additions.h"

@interface GlyphViewController (Private)

- (void)fetchAllGlyphs;
- (void)fetchGlyphsForCharacterClass;
- (void)resetFetchResultsController;
- (void)showTooltipForButton:(UIButton *)button withGlyph:(Glyph *)glyph;
- (void)hideTooltip;

@end

@implementation GlyphViewController

@synthesize glyphTableView = _glyphTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize characterClassId = _characterClassId;
@synthesize delegate = _delegate;
@synthesize tooltipViewController = _tooltipViewController;
@synthesize calculatorViewController = _calculatorViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _characterClassId = 0;
  }
  return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [self resetFetchResultsController];
}

- (void)resetFetchResultsController {
  if (_fetchedResultsController) _fetchedResultsController = nil;
  if (self.characterClassId > 0) {
    [self fetchGlyphsForCharacterClass];
  } else {
    [self fetchAllGlyphs];
  }
}

- (void)fetchAllGlyphs {
  NSSortDescriptor *characterClassIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"characterClass.characterClassId" ascending:YES];
  NSSortDescriptor *glyphSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"glyphSpellName" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:characterClassIdSortDescriptor, glyphSortDescriptor, nil];
  [characterClassIdSortDescriptor release];
  [glyphSortDescriptor release];
  
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Glyph" inManagedObjectContext:context];
  
  NSFetchRequest *request = [Glyph fetchRequestForAllGlyphs];
  [request setEntity:entity];
  [request setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  
  _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"characterClass.characterClassId" cacheName:nil];
  
  NSError *error;
  if ([self.fetchedResultsController performFetch:&error]) {
    DLog(@"fetch request for all saves succeeded");
  }
}

- (void)fetchGlyphsForCharacterClass {
  NSSortDescriptor *glyphSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"glyphType" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:glyphSortDescriptor, nil];
  [glyphSortDescriptor release];
  
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Glyph" inManagedObjectContext:context];
  
  NSFetchRequest *request = [Glyph fetchRequestForGlyphsWithCharacterClassId:self.characterClassId];
  [request setEntity:entity];
  [request setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  
  _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"glyphType" cacheName:nil];
  
  NSError *error;
  if ([self.fetchedResultsController performFetch:&error]) {
    DLog(@"fetch request for class saves succeeded");
  }
}

- (NSIndexPath *)selectedGlyphIndexPath {
  return [self.glyphTableView indexPathForSelectedRow];
}


- (void)preloadGlyphsWithDict:(NSDictionary *)glyphDict {
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Glyph" inManagedObjectContext:context];
  
  NSArray *allKeys = [glyphDict allKeys];
  for (NSString *key in allKeys) {
    // Fetch glyph from coredata
    NSFetchRequest *request = [Glyph fetchRequestForGlyphWithGlyphId:[[glyphDict valueForKey:key] integerValue]];
    [request setEntity:entity];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    Glyph *glyph = [array objectAtIndex:0];
    UIImage *myImage = [UIImage imageNamed:WOW_ICON_LOCAL(glyph.icon)];
    
    if ([key isEqualToString:@"primeLeft"]) {
      [_primeLeft setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"primeMiddle"]) {
      [_primeMiddle setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"primeRight"]) {
      [_primeRight setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"majorLeft"]) {
      [_majorLeft setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"majorMiddle"]) {
      [_majorMiddle setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"majorRight"]) {
      [_majorRight setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"minorLeft"]) {
      [_minorLeft setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"minorMiddle"]) {
      [_minorMiddle setBackgroundImage:myImage forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"minorRight"]) {
      [_minorRight setBackgroundImage:myImage forState:UIControlStateNormal];
    }
  }
}

#pragma mark IBAction
- (IBAction)prepareGlyphForButton:(UIButton *)button {
  // Find which button this is
  NSString *keyPath = nil;
  if ([button isEqual:_primeLeft]) {
    keyPath = @"primeLeft";
  } else if ([button isEqual:_primeMiddle]) {
    keyPath = @"primeMiddle";
  } else if ([button isEqual:_primeRight]) {
    keyPath = @"primeRight";
  } else if ([button isEqual:_majorLeft]) {
    keyPath = @"majorLeft";
  } else if ([button isEqual:_majorMiddle]) {
    keyPath = @"majorMiddle";
  } else if ([button isEqual:_majorRight]) {
    keyPath = @"majorRight";
  } else if ([button isEqual:_minorLeft]) {
    keyPath = @"minorLeft";
  } else if ([button isEqual:_minorMiddle]) {
    keyPath = @"minorMiddle";
  } else if ([button isEqual:_minorRight]) {
    keyPath = @"minorRight";
  }

  NSIndexPath *selectedIndexPath = [self selectedGlyphIndexPath];
  if (selectedIndexPath) {
    Glyph *glyph = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
    UIImage *myImage = [UIImage imageNamed:WOW_ICON_LOCAL(glyph.icon)];
    [button setBackgroundImage:myImage forState:UIControlStateNormal];
    [self.glyphTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
    // Tell delegate about the selection
    //
    if (self.delegate) {
      [self.delegate retain];
      if ([self.delegate respondsToSelector:@selector(selectedGlyphWithId:atKeyPath:)]) {
        [self.delegate selectedGlyphWithId:glyph.glyphId atKeyPath:keyPath];
      }
      [self.delegate release];
    }
    
  } else {
    // No glyph selected, show tooltip
    // Fetch glyph from coredata
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Glyph" inManagedObjectContext:context];
    NSFetchRequest *request = [Glyph fetchRequestForGlyphWithGlyphId:[[self.calculatorViewController.glyphDict valueForKey:keyPath] integerValue]];
    [request setEntity:entity];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if ([array count] > 0) {
      Glyph *glyph = [array objectAtIndex:0];
      [self showTooltipForButton:button withGlyph:glyph];
    }
  }
}

- (IBAction)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)glyphTypeStringForType:(NSInteger)type {
  switch (type) {
    case 0:
      return NSLocalizedString(@"Prime Glyph", @"Prime Glyph");
      break;
    case 1:
      return NSLocalizedString(@"Major Glyph", @"Major Glyph");
      break;
    case 2:
      return NSLocalizedString(@"Minor Glyph", @"Minor Glyph");
      break;
    default:
      return NSLocalizedString(@"Prime Glyph", @"Prime Glyph");
      break;
  }
}

- (void)showTooltipForButton:(UIButton *)button withGlyph:(Glyph *)glyph {
  if (!self.tooltipViewController) {
    _tooltipViewController = [[TooltipViewController alloc] init];
  } else {
    [self hideTooltip];
  }
  
  self.tooltipViewController.availableHeight = self.view.height;
  
  self.tooltipViewController.glyph = glyph;
  self.tooltipViewController.tooltipSource = TooltipSourceGlyph;
  
  [self.tooltipViewController reloadTooltipData];
  
  NSInteger tooltipTop;
  if ([button isEqual:_primeLeft] || [button isEqual:_primeRight] || [button isEqual:_majorMiddle]) {
    tooltipTop = button.top - self.tooltipViewController.view.height - 6;
  } else {
    tooltipTop = button.bottom + 6;
  }
  
  CGRect tooltipFrame = CGRectMake(button.center.x - 150.0, tooltipTop, self.tooltipViewController.view.width, self.tooltipViewController.view.height);

  self.tooltipViewController.view.frame = tooltipFrame;
  
  self.tooltipViewController.view.alpha = 0.0f;
  [self.view addSubview:self.tooltipViewController.view];
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
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [self glyphTypeStringForType:[[sectionInfo name] integerValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GlyphCell"];
	if(cell == nil) { 
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GlyphCell"] autorelease];
		cell.backgroundColor = [UIColor clearColor];
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyph_cell_bg.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"glyph_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20]];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor lightGrayColor];
    
	}
  
  Glyph *glyph = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = glyph.glyphName;
  cell.detailTextLabel.text = [self glyphTypeStringForType:[glyph.glyphType integerValue]];
  
#ifdef REMOTE_TALENT_IMAGES
  NSURL *imageUrl = [[[NSURL alloc] initWithString:WOW_ICON_URL(glyph.icon)] autorelease];
  NSURLRequest *myRequest = [[[NSURLRequest alloc] initWithURL:imageUrl] autorelease];
  NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  UIImage *myImage  = [[[UIImage alloc] initWithData:returnData] autorelease];
#else
  UIImage *myImage = [UIImage imageNamed:WOW_ICON_LOCAL(glyph.icon)];
#endif
  
#ifdef DOWNLOAD_TALENT_IMAGES
  NSString *filePath = [[SMACoreDataStack applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", glyph.icon]];
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:returnData attributes:nil];
  }
#endif
  
  cell.imageView.image = myImage;
  
  return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.0;
}

#pragma mark Memory Management
// Override to allow orientations other than the default portrait orientation.
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
  if (_glyphTableView) [_glyphTableView release];
  if (_primeLeft) [_primeLeft release];
  if (_primeMiddle) [_primeMiddle release];
  if (_primeRight) [_primeRight release];
  if (_majorLeft) [_majorLeft release];
  if (_majorMiddle) [_majorMiddle release];
  if (_majorRight) [_majorRight release];
  if (_minorLeft) [_minorLeft release];
  if (_minorMiddle) [_minorMiddle release];
  if (_minorRight) [_minorRight release];
  
  if (_tooltipViewController) [_tooltipViewController release];
  if (_fetchedResultsController) [_fetchedResultsController release];
  [super dealloc];
}

@end
