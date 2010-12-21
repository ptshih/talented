    //
//  SaveViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/20/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "SaveViewController.h"
#import "Save.h"
#import "Save+Fetch.h"
#import "TalentTree.h"
#import "TalentTree+Fetch.h"
#import "SMACoreDataStack.h"
#import "Constants.h"

@interface SaveViewController (Private)

- (void)fetchAllSaves;

@end

@implementation SaveViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self fetchAllSaves];
  }
  return self;
}

- (void)fetchAllSaves {
  NSSortDescriptor *characterClassIdSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"characterClassId" ascending:YES];
  NSSortDescriptor *timestampSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:characterClassIdSortDescriptor, timestampSortDescriptor, nil];
  [characterClassIdSortDescriptor release];
  [timestampSortDescriptor release];
  
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Save" inManagedObjectContext:context];
  
  NSFetchRequest *request = [Save fetchRequestForAllSaves];
  [request setEntity:entity];
  [request setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  
  _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"characterClassId" cacheName:nil];
  
  NSError *error;
  BOOL success = [self.fetchedResultsController performFetch:&error];
  DLog(@"fetch request for all saves status: %d", success);
}

- (void)viewDidLoad {
}

#pragma mark IBAction
- (IBAction)add {
}

- (IBAction)done {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Helpers
- (NSString *)treeNameForCharacterClassId:(NSInteger)characterClassId andTreeNo:(NSInteger)treeNo {
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"TalentTree" inManagedObjectContext:context];
  
  NSFetchRequest *request = [TalentTree fetchRequestForTalentTreeWithCharacterClassId:characterClassId andTreeNo:treeNo];
  [request setEntity:entity];
  
  NSError *error;
  NSArray *array = [context executeFetchRequest:request error:&error];
  if(array) {
    TalentTree *specTree = [array objectAtIndex:0];
    return specTree.talentTreeName;
  } else {
    return @"Not Found";
  }
}

- (NSString *)nameForSectionInfo:(id)sectionInfo {
  switch ([[sectionInfo name] integerValue]) {
    case 1:
      return NSLocalizedString(@"Warrior", @"Warrior");
      break;
    case 2:
      return NSLocalizedString(@"Paladin", @"Paladin");
      break;
    case 3:
      return NSLocalizedString(@"Hunter", @"Hunter");
      break;
    case 4:
      return NSLocalizedString(@"Rogue", @"Rogue");
      break;
    case 5:
      return NSLocalizedString(@"Priest", @"Priest");
      break;
    case 6:
      return NSLocalizedString(@"Death Knight", @"Death Knight");
      break;
    case 7:
      return NSLocalizedString(@"Shaman", @"Shaman");
      break;
    case 8:
      return NSLocalizedString(@"Mage", @"Mage");
      break;
    case 9:
      return NSLocalizedString(@"Warlock", @"Warlock");
      break;
    case 11:
      return NSLocalizedString(@"Druid", @"Druid");
      break;
    default:
      return NSLocalizedString(@"Ghostcrawler", @"Ghostcrawler");
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

  return [self nameForSectionInfo:sectionInfo];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//  return [self.fetchedResultsController sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//  return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaveCell"];
	if(cell == nil) { 
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaveCell"] autorelease];
		cell.backgroundColor = [UIColor clearColor];
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell_bg_landscape.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20]];
	}
  
  Save *save = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [self treeNameForCharacterClassId:[[[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] name] integerValue] andTreeNo:[save.saveSpecTree integerValue]];
  
  return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.0;
}

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
  if (_fetchedResultsController) [_fetchedResultsController release];
  [super dealloc];
}

@end
