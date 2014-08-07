//
//  KnowterNotesTableViewController.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "KnowterNotesTableViewController.h"
#import "KnowterNoteDetailViewController.h"
#import "NoteHelper.h"

@interface KnowterNotesTableViewController ()

@property (strong, nonatomic) NSMutableArray *notes; // of Note

@end

@implementation KnowterNotesTableViewController

#pragma mark - Properties

#pragma mark - Initializers

- (void)setup
{
    // Custom setup that must happen before viewDidLoad
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self loadNotes];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadNotes];
}

- (void)loadNotes {
    self.notes = [[NoteHelper loadNotes] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)newNoteButtonTouch
{
    KnowterNoteDetailViewController *noteDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KnowterNoteDetailViewController"];
    [self prepareNoteDetailViewController:noteDetailViewController withNote:nil];
    
    UINavigationController *noteDetailNavigationController = [[UINavigationController alloc] initWithRootViewController:noteDetailViewController];
    noteDetailNavigationController.navigationBar.translucent = NO;
    noteDetailNavigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self presentViewController:noteDetailNavigationController
                       animated:YES
                     completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NoteCellIdentifier = @"Note Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoteCellIdentifier
                                                            forIndexPath:indexPath];
    
    Note *note = self.notes[indexPath.row];
    cell.textLabel.text = note.content;
    cell.detailTextLabel.text = note.modificationDate;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString *DisplayNoteSegueIdentifier = @"Edit Note";
    
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if ([segue.identifier isEqualToString:DisplayNoteSegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[KnowterNoteDetailViewController class]]) {
            [self prepareNoteDetailViewController:segue.destinationViewController
                                         withNote:indexPath ? self.notes[indexPath.row] : nil];
        }
    }
}

- (void)prepareNoteDetailViewController:(KnowterNoteDetailViewController *)viewController withNote:(Note *)note
{
    viewController.note = note;
}

@end
