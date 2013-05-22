//
//  Costs.h
//  SEVFAM
//
//  Created by Admir Beciragic on 4/24/12.
//  Copyright (c) 2012 axeltra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEVFAMAppDelegate.h"

@interface Costs : UIViewController{
    
    IBOutlet UILabel *startDateLabel;
    IBOutlet UILabel *endDateLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *DayesLabel;
    IBOutlet UILabel *SpentLabel;
    IBOutlet UILabel *costLabel;
    
    IBOutlet UILabel *comparisonStartDateLabel;
    IBOutlet UILabel *comparisonEndDateLabel;
    IBOutlet UILabel *comparisonPriceLabel;
    IBOutlet UILabel *comparisonDayesLabel;
    IBOutlet UILabel *comparisonSpentLabel;
    IBOutlet UILabel *comparisoncostLabel;

    
    SEVFAMAppDelegate *appDelegate;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *comparisonView;
    
}

@property (nonatomic ,retain) IBOutlet UILabel *startDateLabel;
@property (nonatomic ,retain) IBOutlet UILabel *endDateLabel;
@property (nonatomic ,retain) IBOutlet UILabel *priceLabel;
@property (nonatomic ,retain) IBOutlet UILabel *DayesLabel;
@property (nonatomic ,retain) IBOutlet UILabel *SpentLabel;
@property (nonatomic ,retain) IBOutlet UILabel *costLabel;

@property (nonatomic ,retain) IBOutlet UILabel *comparisonStartDateLabel;
@property (nonatomic ,retain) IBOutlet UILabel *comparisonEndDateLabel;
@property (nonatomic ,retain) IBOutlet UILabel *comparisonPriceLabel;
@property (nonatomic ,retain) IBOutlet UILabel *comparisonDayesLabel;
@property (nonatomic ,retain) IBOutlet UILabel *comparisonSpentLabel;
@property (nonatomic ,retain) IBOutlet UILabel *comparisoncostLabel;

@property (nonatomic, retain) SEVFAMAppDelegate *appDelegate;

@property (nonatomic, retain) IBOutlet UIView *comparisonView;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
