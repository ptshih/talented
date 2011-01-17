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

@interface GlyphViewController (Private)

- (void)fetchAllGlyphs;
- (void)fetchGlyphsForCharacterClass;
- (void)resetFetchResultsController;

@end

@implementation GlyphViewController

@synthesize glyphTableView = _glyphTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize characterClassId = _characterClassId;

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

#pragma mark IBAction
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
  if (_glyphTableView) [_glyphTableView release];
  if (_fetchedResultsController) [_fetchedResultsController release];
  [super dealloc];
}

@end
