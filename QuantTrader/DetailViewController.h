//
//  DetailViewController.h
//  QuantTrader
//
//  Created by xcode user on 27.05.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
