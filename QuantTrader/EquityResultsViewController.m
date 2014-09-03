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

bool done;

NSNumber *num;

- (void)viewDidLoad {
    [super viewDidLoad];
//    done = NO;

}
- (void) viewDidAppear:(BOOL)animated {

    
    activity.hidden = NO;
    [activity startAnimating];
    
    done = NO;
    eq = [[EquityOption_ alloc] init];
    
    if (!num) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            num = [NSNumber numberWithFloat:0];
            [eq calculate];
            // trigger the main completion handler when this completed
            dispatch_async(dispatch_get_main_queue(), ^{
                activity.hidden = YES;
                [activity stopAnimating];
                done = YES;
                [tableView reloadData];
                num = nil;
            });
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 29;
        return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.textLabel.numberOfLines = 0;
    NSString *value;
    
    if (done) {
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:[@"Black Scholes:\n € " stringByAppendingString:[[NSNumber numberWithDouble:eq.blackScholes_eo] stringValue]]];
                break;
            case 1:
                [cell.textLabel setText:[@"Heston Semi Analytic:\n €" stringByAppendingString:[[NSNumber numberWithDouble:eq.hestonSemiAnalytic_eo]stringValue] ]];
                break;
            case 2:
                [cell.textLabel setText:[@"Bates Semi Analytic:\n €" stringByAppendingString:[[NSNumber numberWithDouble:eq.batesSemiAna_eo] stringValue]]];
                break;
            case 3:
                value = [[NSNumber numberWithDouble:eq.baroneAdesiWhaleySemiAna_eo] stringValue];
                [cell.textLabel setText:[@"Barone Adesi Whaley Semi Analytic:\n €" stringByAppendingString:value]];
                break;
            case 4:
                value = [[NSNumber numberWithDouble:eq.bjerksundStenslandSemiAna_eo] stringValue];
                [cell.textLabel setText:[@"Bjerksund Stensland Semi Analytic:\n €" stringByAppendingString:value]];
                break;
            case 5:
                value = [[NSNumber numberWithDouble:eq.finiteDifference_eo] stringValue];
                [cell.textLabel setText: [@"Finite Difference European Option:\n €" stringByAppendingString:value]];
                break;
            case 6:
                value = [[NSNumber numberWithDouble:eq.binomialJarrowRudd_eo] stringValue];
                [cell.textLabel setText: [@"Binomial Jarrow Rudd:\n €" stringByAppendingString:value] ];
                break;
            case 7:
                value = [[NSNumber numberWithDouble:eq.binomialJarrowRudd_ao] stringValue];
                [cell.textLabel setText:[@"Binomial Jarrow Rudd Americal Option:\n €" stringByAppendingString:value]];
                break;
            case 8:
                value = [[NSNumber numberWithDouble:eq.binomialJarrowRudd_bo] stringValue];
                [cell.textLabel setText:[@"Binomial Jarrow Rudd Bermudian Option:\n €" stringByAppendingString:value]];
                break;
            case 9:
                value = [[NSNumber numberWithDouble:eq.binomialCoxRossRubinstein_eo] stringValue];
                [cell.textLabel setText: [@"Binomial Cox Ross Rubinstein European Option: \n €" stringByAppendingString:value]];
                break;
                
            case 10:
                value = [[NSNumber numberWithDouble:eq.binomialCoxRossRubinstein_bo] stringValue];
                [cell.textLabel setText:[@"Binomial Cox Ross Rubinstein Bermudian Option: \n €" stringByAppendingString:value]];
                break;
            case 11:
                value = [[NSNumber numberWithDouble:eq.binomialCoxRossRubinstein_ao] stringValue];
                [cell.textLabel setText: [@"Binomial Cox Ross Rubinstein Americal Option: \n €" stringByAppendingString:value]];
                break;
            case 12:
                
                value = [[NSNumber numberWithDouble:eq.additiveEquiprobabilities_eo] stringValue];
                [cell.textLabel setText:[@"Additive Equiprobabilities European Option: \n €" stringByAppendingString:value]];
                break;
            case 13:
                value = [[NSNumber numberWithDouble:eq.additiveEquiprobabilities_bo] stringValue];
                 [cell.textLabel setText:[@"Additive Equiprobabilities Bermudian Option: \n €" stringByAppendingString:value] ];
                break;
            case 14:
                
                value = [[NSNumber numberWithDouble:eq.additiveEquiprobabilities_ao] stringValue];
                [cell.textLabel setText:[@"Additive Equiprobabilities American Option: \n €" stringByAppendingString:value] ];
                break;
            case 15:
                value = [[NSNumber numberWithDouble:eq.binomialTrigeorgis_eo] stringValue];
                [cell.textLabel setText:[@"Binomial Trigeoris European Option: \n €" stringByAppendingString:value] ];
                break;
            case 16:
                value = [[NSNumber numberWithDouble:eq.binomialTrigeorgis_bo] stringValue];
                [cell.textLabel setText: [@"Binomial Trigeoris European Option: \n €" stringByAppendingString:value] ];
                break;
            case 17:
                value = [[NSNumber numberWithDouble:eq.binomialTrigeorgis_ao] stringValue];
                [cell.textLabel setText:[@"Binomial Trigeoris European Option: \n €" stringByAppendingString:value] ];
                break;
            case 18:
                value = [[NSNumber numberWithDouble:eq.binomialTian_eo] stringValue];
                [cell.textLabel setText:[@"Binomial Tian European Option: \n €" stringByAppendingString:value]];
                break;
            case 19:
                value = [[NSNumber numberWithDouble:eq.binomialTian_bo] stringValue];
                [cell.textLabel setText:[@"Binomial Tian Bermudian Option: \n €" stringByAppendingString:value]];
                break;
            case 20:
                value = [[NSNumber numberWithDouble:eq.binomialTian_ao] stringValue];
                [cell.textLabel setText:[@"Binomial Tian American Option: \n €" stringByAppendingString:value]];
                break;
            case 21:
                value = [[NSNumber numberWithDouble:eq.binomialLeisenReimer_eo] stringValue];
                [cell.textLabel setText:[@"Binomial Leisen Reimer European Option: \n €" stringByAppendingString:value]];
                break;
            case 22:
                value = [[NSNumber numberWithDouble:eq.binomialLeisenReimer_bo] stringValue];
                [cell.textLabel setText:[@"Binomial Leisen Reimer Bermudian Option: \n €" stringByAppendingString:value]];
                break;
            case 23:
                value = [[NSNumber numberWithDouble:eq.binomialLeisenReimer_ao] stringValue];
                [cell.textLabel setText:[@"Binomial Leisen Reimer American Option: \n €" stringByAppendingString:value]];
                break;
            case 24:
                value = [[NSNumber numberWithDouble:eq.binomialJoshi_eo] stringValue];
                [cell.textLabel setText:[@"Binomial Joshi European Option: \n €" stringByAppendingString:value]];
                break;
            case 25:
                value = [[NSNumber numberWithDouble:eq.binomialJoshi_bo] stringValue];
                [cell.textLabel setText:[@"Binomial Joshi Bermudan Option: \n €" stringByAppendingString:value]];
                break;
            case 26:
                value = [[NSNumber numberWithDouble:eq.binomialJoshi_ao] stringValue];
                [cell.textLabel setText:[@"Binomial Joshi American Option: \n €" stringByAppendingString:value]];
                break;
            case 27:
                value = [[NSNumber numberWithDouble:eq.mcCrude_eo] stringValue];
                [cell.textLabel setText:[@"McCrude European Option: \n €" stringByAppendingString:value]];
                break;
            case 28:
                value = [[NSNumber numberWithDouble:eq.qmcSobol_eo] stringValue];
                [cell.textLabel setText:[@"QmcSobol European Option: \n €" stringByAppendingString:value]];
                break;
            case 29:
                value = [[NSNumber numberWithDouble:eq.mcLongstaffSchwatz_ao] stringValue];
                [cell.textLabel setText:[@"McLongstaff Schwartz American Option: \n €" stringByAppendingString:value]];
            default:
                break;
        }
    }
    if (!done)
        [cell.textLabel setText:@" "];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
*/

@end
