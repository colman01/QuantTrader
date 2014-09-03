//
//  EquityResultsViewController.m
//  QuantTrader
//
//  Created by colman on 03/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "EquityResultsViewController.h"

@interface EquityResultsViewController ()

@end

@implementation EquityResultsViewController

@synthesize tableView;
@synthesize eq;
@synthesize activity;

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void) viewDidAppear:(BOOL)animated {
    
    activity.hidden = NO;
    [activity startAnimating];
    eq = [[EquityOption_ alloc] init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [eq calculate];
        // trigger the main completion handler when this completed
        dispatch_async(dispatch_get_main_queue(), ^{
            activity.hidden = YES;
            [activity stopAnimating];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 29;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
*/

@end
