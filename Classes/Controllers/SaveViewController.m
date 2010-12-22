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
#import "SMACoreDataStack.h"
#import "Constants.h"
#import "SaveCell.h"

static UIImage *_backgroundGradientImage = nil;

@interface SaveViewController (Private)

- (void)fetchAllSaves;
- (void)fetchSavesForCharacterClass;
- (void)resetFetchResultsController;

@end

@implementation SaveViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchResultsArray = _searchResultsArray;
@synthesize characterClassId = _characterClassId;
@synthesize delegate = _delegate;

+ (void)initialize {
  _backgroundGradientImage = [[UIImage imageNamed:@"table_background_gradient.png"] retain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _characterClassId = 0;
    _searchResultsArray = [[NSArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self resetFetchResultsController];
  _navItem.leftBarButtonItem = self.editButtonItem;
  _tableView.backgroundColor = [UIColor colorWithPatternImage:_backgroundGradientImage];
  self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithPatternImage:_backgroundGradientImage];
  self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)resetFetchResultsController {
  if (_fetchedResultsController) _fetchedResultsController = nil;
  if (self.characterClassId > 0) {
    [self fetchSavesForCharacterClass];
  } else {
    [self fetchAllSaves];
  }
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
  if ([self.fetchedResultsController performFetch:&error]) {
    DLog(@"fetch request for all saves succeeded");
  }
}

- (void)fetchSavesForCharacterClass {
  NSSortDescriptor *timestampSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:timestampSortDescriptor, nil];
  [timestampSortDescriptor release];
  
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Save" inManagedObjectContext:context];
  
  NSFetchRequest *request = [Save fetchRequestForSavesWithCharacterClassId:self.characterClassId];
  [request setEntity:entity];
  [request setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  
  _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
  
  NSError *error;
  if ([self.fetchedResultsController performFetch:&error]) {
    DLog(@"fetch request for class saves succeeded");
  }
}

#pragma mark IBAction
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [_tableView setEditing:editing animated:YES];
}

- (IBAction)done {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Helpers

- (NSString *)nameForCharacterClassId:(NSInteger)characterClassId {
  switch (characterClassId) {
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
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return 1;
  } else {
    return [[self.fetchedResultsController sections] count];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return [self.searchResultsArray count];
  } else {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return NSLocalizedString(@"Search Results", @"Search Results");
  } else {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    if (self.characterClassId > 0) {
      return [self nameForCharacterClassId:self.characterClassId];
    } else {
      return [self nameForCharacterClassId:[[sectionInfo name] integerValue]];
    }
  }
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//  return [self.fetchedResultsController sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//  return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SaveCell *cell = (SaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SaveCell"];
	if(cell == nil) { 
		cell = [[[SaveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SaveCell"] autorelease];
		cell.backgroundColor = [UIColor clearColor];
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell_bg_landscape.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"table_cell_bg_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:20]];
	}
  
  Save *save = nil;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    save = [self.searchResultsArray objectAtIndex:indexPath.row];
  } else {
    save = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  [SaveCell fillCell:cell withSave:save];
  
  return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return UITableViewCellEditingStyleNone;
  } else {
    return UITableViewCellEditingStyleDelete;
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Remove this save from Core Data
    Save *save = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    [context deleteObject:save];
    NSError *error;
    [context save:&error];
    
    [self resetFetchResultsController];
    
    [tableView beginUpdates];
    if ([tableView numberOfRowsInSection:indexPath.section] <= 1) {
      [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
  }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Save *save = nil;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    save = [self.searchResultsArray objectAtIndex:indexPath.row];
  } else {
    save = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  
  if (self.delegate) {
    [self.delegate loadSave:save fromSender:self];
  }
}



#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"saveName BEGINSWITH[cd] %@", searchText];
  self.searchResultsArray = [[[self fetchedResultsController] fetchedObjects] filteredArrayUsingPredicate:predicate];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  [self filterContentForSearchText:searchString scope:nil];
  
  // Return YES to cause the search result table view to be reloaded.
  return YES;
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
  if (_tableView) [_tableView release];
  if (_navItem) [_navItem release];
  if (_fetchedResultsController) [_fetchedResultsController release];
  if (_searchResultsArray) [_searchResultsArray release];

  [super dealloc];
}

@end
