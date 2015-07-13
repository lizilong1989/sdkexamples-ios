/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "ContactAtSelectionViewController.h"

#import "EMSearchBar.h"
#import "EMRemarkImageView.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"

@interface ContactAtSelectionViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *selectedContacts;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation ContactAtSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contactsSource = [NSMutableArray array];
        _selectedContacts = [NSMutableArray array];
        
        [self setObjectComparisonStringBlock:^NSString *(id object) {
            EMBuddy *buddy = (EMBuddy *)object;
            return buddy.username;
        }];
        
        [self setComparisonObjectSelector:^NSComparisonResult(id object1, id object2) {
            EMBuddy *buddy1 = (EMBuddy *)object1;
            EMBuddy *buddy2 = (EMBuddy *)object2;
            
            return [buddy1.username caseInsensitiveCompare: buddy2.username];
        }];
    }
    return self;
}

- (instancetype)initWithChatGroupId:(NSString*)chatGroupId
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        EMGroup *chatGroup = nil;
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:chatGroupId]) {
                chatGroup = group;
                break;
            }
        }
        if (chatGroup == nil) {
            chatGroup = [EMGroup groupWithId:chatGroupId];
        }
        _chatGroup = chatGroup;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.searchBar];
//    self.tableView.editing = YES;
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    [self searchController];
    
    [self fetchGroupInfo];
}

#pragma mark - data

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                weakSelf.chatGroup = group;
                [weakSelf loadDataSource];
            }
            else{
                [weakSelf showHint:NSLocalizedString(@"group.fetchInfoFail", @"failed to get the group details, please try again later")];
            }
        });
    } onQueue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactAtSelectionViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            cell.textLabel.text = buddy.username;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if (![weakSelf.selectedContacts containsObject:buddy])
            {
                NSInteger section = [weakSelf sectionForString:buddy.username];
                if (section >= 0) {
                    NSMutableArray *tmpArray = [weakSelf.dataSource objectAtIndex:section];
                    NSInteger row = [tmpArray indexOfObject:buddy];
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [weakSelf.selectedContacts addObject:buddy];
                [weakSelf doneAction:nil];
            }
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactListCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EMBuddy *buddy = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    cell.textLabel.text = cell.textLabel.text = buddy.username;;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (![self.selectedContacts containsObject:object])
    {
        [self.selectedContacts addObject:object];
        [self doneAction:nil];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setCancelButtonTitle:NSLocalizedString(@"ok", @"OK")];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:searchText collationStringSelector:@selector(username) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
                
                for (EMBuddy *buddy in results) {
                    if ([weakSelf.selectedContacts containsObject:buddy])
                    {
                        NSInteger row = [results indexOfObject:buddy];
                        [weakSelf.searchController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                }
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.editing = NO;
}

#pragma mark - public

- (void)loadDataSource
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    [_dataSource removeAllObjects];
    [_contactsSource removeAllObjects];
    
    NSArray *buddyList = _chatGroup.occupants;
    NSString *account = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    for (NSString *username in buddyList) {
        if ([username isEqualToString:account]) {
            continue;
        }
        EMBuddy *buddy = [EMBuddy buddyWithUsername:username];
        [self.contactsSource addObject:buddy];
    }
    
    [_dataSource addObjectsFromArray:[self sortRecords:self.contactsSource]];
    
    [self hideHud];
    [self.tableView reloadData];
}

- (void)doneAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
        [_delegate viewController:self didFinishSelectedSources:self.selectedContacts];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end