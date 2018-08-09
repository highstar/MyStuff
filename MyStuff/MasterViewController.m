//
//  MasterViewController.m
//  MyStuff
//
//  Created by Gao Xing on 2018/8/1.
//  Copyright © 2018年 Gao Xing. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MyWhatsit.h"

@interface MasterViewController () {
    NSMutableArray *things;
}

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)awakeFromNib
{
    things = [@[
                [[MyWhatsit alloc] initWithName:@"Gort"
                                       location:@"den"],
                [[MyWhatsit alloc] initWithName:@"Disappearing TARDIS mug"
                                       location:@"kitchen"],
                [[MyWhatsit alloc] initWithName:@"Robot USB drive"
                                       location:@"office"],
                [[MyWhatsit alloc] initWithName:@"Sad Robot USB hub"
                                       location:@"office"],
                [[MyWhatsit alloc] initWithName:@"Solar Powered Bunny"
                                       location:@"office"]
                ] mutableCopy];
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(whatsitDidChangedNotification:)
                                                 name:kWhatsitDidChangedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)insertNewObject:(id)sender {
    if (!things) {
        things = [[NSMutableArray alloc] init];
    }
    
    static unsigned int itemNumber = 1;
    NSString *newItemName = [NSString stringWithFormat:@"My Item %u", itemNumber++];
    MyWhatsit *newItem = [[MyWhatsit alloc] initWithName:newItemName location:nil];
    [things insertObject:newItem atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MyWhatsit *object = things[indexPath.row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        
        
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return things.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];

    MyWhatsit *thing = things[indexPath.row];
    cell.textLabel.text = thing.name;
    cell.detailTextLabel.text = thing.location;
    cell.imageView.image = thing.viewImage;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [things removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)whatsitDidChangedNotification:(NSNotification*)notification
{
    NSUInteger index = [things indexOfObject:notification.object];
    if (index != NSNotFound)
    {
        NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
