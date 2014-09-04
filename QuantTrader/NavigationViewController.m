//
//  NavigationViewController.m
//  QuantTrader
//
//  Created by colman on 17/07/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "NavigationViewController.h"
#import "BondSetValueViewController.h"
#import "MasterViewController.h"
#import "EquityOptionViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (BOOL) shouldAutorotate {
    UIViewController *vc = self.topViewController;
    
    if ( [vc isKindOfClass:[EquityOptionViewController class]]) {
        return NO;
    }
    
    if ( [vc isKindOfClass:[MasterViewController class]]) {
        return NO;
    }
    
    if ( ![vc isKindOfClass:[BondSetValueViewController class]]) {
        
        return YES;
    }
    return NO;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    UIViewController *vc = self.topViewController;
    if ([vc isKindOfClass:[BondSetValueViewController class]] || [vc isKindOfClass:[MasterViewController class]])
        if (toInterfaceOrientation != UIInterfaceOrientationPortrait) {
            return NO;
        }
    return YES;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
