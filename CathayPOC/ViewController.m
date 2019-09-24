//
//  ViewController.m
//  CathayPOC
//
//  Created by Apple on 2019/9/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "ViewController.h"
#import "NewFriendsCell.h"
#import "FriendsCell.h"
#import "FriendTopCell.h"
#import "HttpService.h"
#import "NewFriendsCell.h"
#import "UserDataModel.h"
#import "FriendsDataModel.h"


@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray <UserDataModel *> *userDataArray;
    NSMutableArray <FriendsDataModel *> *friendsDataArray;
    NSMutableArray <FriendsDataModel *> *inviteFriendsDataArray;
    NSMutableArray <FriendsDataModel *> *tableViewDataArray;
    UIRefreshControl *refreshControl;
    BOOL sectionClose;
}
@property (weak, nonatomic) IBOutlet UIView *addFriendView;
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UIView *noneFriendsView;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addRefrechControl];
    [self setAddFriendView];
    [self registerXIB];
    self.friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pointView.layer.cornerRadius = self.pointView.frame.size.height/2;
    [self getData];
}

- (void) addRefrechControl{
    refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.friendsTableView addSubview:refreshControl];
}
- (void)refresh:(id)sender{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getData];
    });
}
- (void) getData{
    userDataArray = [NSMutableArray new];
    friendsDataArray = [NSMutableArray new];
    inviteFriendsDataArray = [NSMutableArray new];
    tableViewDataArray = [NSMutableArray new];
    [self getDataFromServer:USERDATA];
    if ([self.inputTypeString isEqualToString:NONEFRIENDSLIST]) {
        self.friendsTableView.hidden = YES;
        self.noneFriendsView.hidden = NO;
        [self getDataFromServer:NONEFRIENDS];
    }else if ([self.inputTypeString isEqualToString:ONLYFIRENDSLIST]){
        self.friendsTableView.hidden = NO;
        self.noneFriendsView.hidden = YES;
        [self getDataFromServer:FRIENDSLIST_1];
        [self getDataFromServer:FRIENDSLIST_2];
    }else if ([self.inputTypeString isEqualToString:FRINFDSANDINVITELIST]){
        self.friendsTableView.hidden = NO;
        self.noneFriendsView.hidden = YES;
        [self getDataFromServer:FRIENDSLIST_1];
        [self getDataFromServer:FRIENDSLIST_2];
        [self getDataFromServer:INVITELIST];
    }
}

- (void) getDataFromServer:(NSString *)apiName{
    NSDictionary *dic = [NSDictionary new];
    [HttpService requestWithParams:dic AndAPIKey:apiName AndSuccessBlock:^(id  _Nonnull model, NSString *apiKey) {
        NSError *error;
        if ([apiKey isEqualToString:NONEFRIENDS]) {
        }else if ([apiKey isEqualToString:USERDATA]){
            self->userDataArray = [UserDataModel arrayOfModelsFromDictionaries:model error:&error];
            if (error == nil) {
                self.userNameLabel.text = self->userDataArray[0].name;
                self.userIDLabel.text = [NSString stringWithFormat:@"KOKO ID：%@",self->userDataArray[0].kokoid];
                self.pointView.hidden = YES;
            }
        }else if ([apiKey isEqualToString:FRIENDSLIST_1]){
            [self checkFriendsList:[FriendsDataModel arrayOfModelsFromDictionaries:model error:&error]];
        }else if ([apiKey isEqualToString:FRIENDSLIST_2]){
            [self checkFriendsList:[FriendsDataModel arrayOfModelsFromDictionaries:model error:&error]];
        }else if ([apiKey isEqualToString:INVITELIST]){
            self->inviteFriendsDataArray = [FriendsDataModel arrayOfModelsFromDictionaries:model error:&error];
            [self.friendsTableView reloadData];
        }
        [self->refreshControl endRefreshing];
    } AndErrorBlock:^(NSString * _Nonnull code) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"請確認網路連線" message:code preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
- (void)checkFriendsList:(NSArray <FriendsDataModel*> *)array{
    [friendsDataArray addObjectsFromArray:array];
    NSMutableArray *groupArray = [NSMutableArray new];
    NSMutableArray *groupfid = [NSMutableArray new];
    for (FriendsDataModel *group in friendsDataArray) {
        if ([groupfid indexOfObject:group.fid] == NSNotFound) {
            [groupfid addObject:group.fid];
            [groupArray addObject:group];
        }
    }
    friendsDataArray = groupArray;
    for (int i = 0 ; i < friendsDataArray.count ; i++) {
        for (int j = 0 ; j < array.count ; j++) {
            if ([friendsDataArray[i].fid isEqualToString:array[j].fid]){
                if (friendsDataArray[i].updateDate.integerValue < array[j].updateDate.integerValue) {
                    friendsDataArray[i] = array[j];
                }
            }
        }
    }
    tableViewDataArray = friendsDataArray;
    [self.friendsTableView reloadData];
}
- (void)registerXIB{
    [self.friendsTableView registerNib:[UINib nibWithNibName:NEWFRIENDSCELLID bundle:nil] forCellReuseIdentifier:NEWFRIENDSCELLID];
    [self.friendsTableView registerNib:[UINib nibWithNibName:FRIENDSCELLID bundle:nil] forCellReuseIdentifier:FRIENDSCELLID];
    [self.friendsTableView registerNib:[UINib nibWithNibName:FRIENDSTOPCELLID bundle:nil] forCellReuseIdentifier:FRIENDSTOPCELLID];
}
- (void)setAddFriendView{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.cornerRadius = self.addFriendView.frame.size.height/2;
    gradient.frame = self.addFriendView.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
    gradient.colors = @[(id)[UIColor colorWithRed:86/255.0 green:179/255.0 blue:11/255.0 alpha:1].CGColor, (id)[UIColor colorWithRed:166/255.0 green:204/255.0 blue:66/255.0 alpha:1].CGColor];
    [self.addFriendView.layer insertSublayer:gradient atIndex:0];
}
- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.friendsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableArray <FriendsDataModel*> *ary = [NSMutableArray new];
    for (int i = 0 ; i < friendsDataArray.count; i++) {
        if ([friendsDataArray[i].name rangeOfString:textField.text].location != NSNotFound) {
            [ary addObject:friendsDataArray[i]];
        }
    }
    if (ary.count == 0) {
        ary = friendsDataArray;
    }
    tableViewDataArray = ary;
    [self.friendsTableView reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (sectionClose) {
            return 1;
        }else{
            return inviteFriendsDataArray.count;
        }
    }else{
        return tableViewDataArray.count+1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NewFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:NEWFRIENDSCELLID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = inviteFriendsDataArray[indexPath.row].name;
        cell.subLabel.text = @"邀請你成為好友：）";
        cell.subView.hidden = YES;
        return cell;
    }else{
        if (indexPath.row == 0) {
            FriendTopCell *cell = [tableView dequeueReusableCellWithIdentifier:FRIENDSTOPCELLID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.inputTxt.delegate = self;
            return cell;
        }else{
            FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:FRIENDSCELLID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([tableViewDataArray[indexPath.row - 1].isTop isEqualToString:@"1"]) {
                cell.startImageView.hidden = YES;
            }else{
                cell.startImageView.hidden = NO;
            }
            if ([tableViewDataArray[indexPath.row - 1].status isEqualToString:@"0"]) {
                cell.inviteView.hidden = NO;
                cell.moreView.hidden = YES;
            }else{
                cell.inviteView.hidden = YES;
                cell.moreView.hidden = NO;
            }
            cell.nameLabel.text = tableViewDataArray[indexPath.row - 1].name;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSMutableArray <NSIndexPath *> *array = [NSMutableArray new];
        for (int i = 1 ; i < inviteFriendsDataArray.count ; i++) {
            [array addObject:[NSIndexPath indexPathForItem:i inSection:indexPath.section]];
        }
        [self.friendsTableView beginUpdates];
        NewFriendsCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        cell.subView.hidden = sectionClose;
        if (sectionClose) {
            [self.friendsTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            sectionClose = NO;
        }else{
            [self.friendsTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            sectionClose = YES;
        }
        [self.friendsTableView endUpdates];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.friendsTableView layoutIfNeeded];
        });
    }
}


@end
