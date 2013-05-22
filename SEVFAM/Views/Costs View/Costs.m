//
//  Costs.m
//  SEVFAM
//
//  Created by Admir Beciragic on 4/24/12.
//  Copyright (c) 2012 axeltra. All rights reserved.
//

#import "Costs.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation Costs

@synthesize startDateLabel,SpentLabel,endDateLabel,priceLabel,DayesLabel,costLabel;
@synthesize comparisoncostLabel,comparisonDayesLabel,comparisonPriceLabel,comparisonSpentLabel,comparisonEndDateLabel,comparisonStartDateLabel;
@synthesize appDelegate;
@synthesize scrollView;
@synthesize comparisonView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    appDelegate = (SEVFAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    UIColor* clr = [UIColor colorWithRed:0x7b/255.0f
                                   green:0xd5/255.0f
                                    blue:0xeb/255.0f alpha:1];
    
    startDateLabel.textColor = clr;
    SpentLabel.textColor = clr;
    endDateLabel.textColor = clr;
    priceLabel.textColor = clr;
    DayesLabel.textColor = clr;
    costLabel.textColor = clr;
    
    appDelegate.rotateBack = TRUE;
    
    int periods = [[appDelegate.costsData objectForKey:@"periods"] intValue];
    
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:YES];
    [self.parentViewController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
    
    [[self.navigationController view] setBounds:CGRectMake(0, 0, 300, 480)];
    self.parentViewController.view.transform = CGAffineTransformIdentity;
    [[self.navigationController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(-90))];
    self.navigationController.view.frame = CGRectMake(0, 0, 320, 480);
    
    [UIView commitAnimations];
    
    if (!appDelegate.comparison) {
        CGRect tempFrame = self.view.frame;
        tempFrame.size.width=320;//change acco. how much you want to expand
        tempFrame.size.height=460;
        [UIView commitAnimations];    
        self.scrollView.contentSize = CGSizeMake(320, 345);
        self.view.frame = tempFrame;
    }
    else{
        int periodsCompare = [[appDelegate.comparisonCostsData objectForKey:@"periods"] intValue];
        CGRect tempFrame = self.view.frame;
        tempFrame.size.width=320;//change acco. how much you want to expand
        tempFrame.size.height=600;
        [UIView commitAnimations];    
        self.scrollView.contentSize = CGSizeMake(320, 690);
        self.view.frame = tempFrame;
        comparisonView.hidden = FALSE;
        comparisoncostLabel.textColor = clr;
        comparisonDayesLabel.textColor = clr;
        comparisonPriceLabel.textColor = clr;
        comparisonSpentLabel.textColor = clr;
        comparisonEndDateLabel.textColor = clr;
        comparisonStartDateLabel.textColor = clr;
        comparisonView.backgroundColor = [UIColor clearColor];
        if (periodsCompare == 1) {
            comparisonStartDateLabel.text = [dateFormat stringFromDate:appDelegate.compareStartDate];
            comparisonEndDateLabel.text = [dateFormat stringFromDate:appDelegate.compareEndDate];
            comparisonPriceLabel.text = [@""stringByAppendingFormat:@"%@ KR",[appDelegate.comparisonCostsData objectForKey:@"tarif0"] ];
            int numberOfDays = [SEVFAMAppDelegate howManyDaysHavePast:appDelegate.compareStartDate today:appDelegate.compareEndDate];
            comparisonDayesLabel.text = [@""stringByAppendingFormat:@"%i",(numberOfDays+1)];
            double nominalValue = [[appDelegate.comparisonCostsData objectForKey:@"nominal_value"] doubleValue];
            comparisonSpentLabel.text = [@"" stringByAppendingFormat:@"%.3f",nominalValue];
            //double total = [[appDelegate.comparisonCostsData objectForKey:@"value"] doubleValue];
            comparisoncostLabel.text = [@"" stringByAppendingFormat:@"%@", [appDelegate.comparisonCostsData objectForKey:@"value"]];
            //comparisoncostLabel.text = [@"" stringByAppendingFormat:@"%.3f",total];
        }
        else{            
            appDelegate.rotateBack = TRUE;
            
            NSString *data = [appDelegate.comparisonCostsData objectForKey:@"borderDate0"];
            NSString *period = [data stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
            comparisonStartDateLabel.text = [period stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            
            data = [appDelegate.comparisonCostsData objectForKey:@"borderDate1"];
            period = [data stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
            comparisonEndDateLabel.text = [period stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            
            double value1 = [[appDelegate.comparisonCostsData objectForKey:@"tarif0"] doubleValue];
            double value2 = [[appDelegate.comparisonCostsData objectForKey:@"tarif1"] doubleValue];
            comparisonPriceLabel.text = [[@""stringByAppendingFormat:@"%.3f KR",value1]stringByAppendingFormat:[@" \\ "stringByAppendingFormat:@"%.3f KR",value2]];
            
            int valueI1 = [[appDelegate.comparisonCostsData objectForKey:@"period0"] intValue];
            int valueI2 = [[appDelegate.comparisonCostsData objectForKey:@"period1"] intValue];
            comparisonDayesLabel.text = [[@""stringByAppendingFormat:@"%i",valueI1]stringByAppendingFormat:@" \\ %i",valueI2];
            
            value1 = [[appDelegate.comparisonCostsData objectForKey:@"price0"] doubleValue];
            value2 = [[appDelegate.comparisonCostsData objectForKey:@"price1"] doubleValue];
            comparisonSpentLabel.text = [[@""stringByAppendingFormat:@"%.3f",value1]stringByAppendingFormat:[@" \\ "stringByAppendingFormat:@"%.3f",value2]];
            
            value1 = [[appDelegate.comparisonCostsData objectForKey:@"price0t"] doubleValue];
            value2 = [[appDelegate.comparisonCostsData objectForKey:@"price1t"] doubleValue];
            comparisoncostLabel.text = [[@""stringByAppendingFormat:@"%.3f",value1]stringByAppendingFormat:[@" \\ "stringByAppendingFormat:@"%.3f",value2]];

        }
    }
    
        
    if (periods == 1) {
        startDateLabel.text = [dateFormat stringFromDate:appDelegate.startDate];
        endDateLabel.text = [dateFormat stringFromDate:appDelegate.endDate];
        priceLabel.text = [@""stringByAppendingFormat:@"%@ KR",[appDelegate.costsData objectForKey:@"tarif0"] ];
        int numberOfDays = [SEVFAMAppDelegate howManyDaysHavePast:appDelegate.startDate today:appDelegate.endDate];
        DayesLabel.text = [@""stringByAppendingFormat:@"%i",(numberOfDays+1)];
        double nominalValue = [[appDelegate.costsData objectForKey:@"nominal_value"] doubleValue];
        SpentLabel.text = [@"" stringByAppendingFormat:@"%.3f",nominalValue];
        //double total = [[appDelegate.costsData objectForKey:@"value"]doubleValue];
        costLabel.text = [@"" stringByAppendingFormat:@"%@", [appDelegate.costsData objectForKey:@"value"]];
    }
    else{        
        appDelegate.rotateBack = TRUE;
        
        NSString *data = [appDelegate.costsData objectForKey:@"borderDate0"];
        NSString *period = [data stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
        startDateLabel.text = [period stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        data = [appDelegate.costsData objectForKey:@"borderDate1"];
        period = [data stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
        endDateLabel.text = [period stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        double value1 = [[appDelegate.costsData objectForKey:@"tarif0"] doubleValue];
        double value2 = [[appDelegate.costsData objectForKey:@"tarif1"] doubleValue];
        priceLabel.text = [[@""stringByAppendingFormat:@"%.3f KR",value1]stringByAppendingFormat:[@" \\ "stringByAppendingFormat:@"%.3f KR",value2]];
        
        int valueI1 = [[appDelegate.costsData objectForKey:@"period0"] intValue];
        int valueI2 = [[appDelegate.costsData objectForKey:@"period1"] intValue];
        DayesLabel.text = [[@""stringByAppendingFormat:@"%i",valueI1]stringByAppendingFormat:@" \\ %i",valueI2];
        
        value1 = [[appDelegate.costsData objectForKey:@"price0"] doubleValue];
        value2 = [[appDelegate.costsData objectForKey:@"price1"] doubleValue];
        SpentLabel.text = [[@""stringByAppendingFormat:@"%.3f",value1]stringByAppendingFormat:[@" \\ "stringByAppendingFormat:@"%.3f",value2]];
        
        value1 = [[appDelegate.costsData objectForKey:@"price0t"] doubleValue];
        value2 = [[appDelegate.costsData objectForKey:@"price1t"] doubleValue];
        costLabel.text = [[@""stringByAppendingFormat:@"%.3f",value1]stringByAppendingFormat:[@" \\ "stringByAppendingFormat:@"%.3f",value2]];
    }
        
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    int periodsCompare = [[appDelegate.comparisonCostsData objectForKey:@"periods"] intValue];
    int periods = [[appDelegate.costsData objectForKey:@"periods"] intValue];
    // Return YES for supported orientations
    if (periods == 2 || periodsCompare == 2) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    }
    else{
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
}

@end
