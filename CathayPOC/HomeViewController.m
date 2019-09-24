//
//  HomeViewController.m
//  CathayPOC
//
//  Created by Apple on 2019/9/22.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)btnPressed:(UIButton *)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    if (sender.tag == 0) {
        vc.inputTypeString = NONEFRIENDSLIST;
    }else if (sender.tag == 1){
        vc.inputTypeString = ONLYFIRENDSLIST;
    }else if (sender.tag == 2){
        vc.inputTypeString = FRINFDSANDINVITELIST;
    }
    [self presentViewController:vc animated:YES completion:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
