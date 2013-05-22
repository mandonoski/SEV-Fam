//
//  iPadTable.h
//  SEVFAM
//
//  Created by Admir Beciragic on 6/12/12.
//  Copyright (c) 2012 axeltra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEVFAMAppDelegate.h"

@interface iPadTable : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITableView *tableViewReference;
    
    SEVFAMAppDelegate *appDelegate;
    
    NSMutableArray *dates;
    NSMutableArray *valuesForDates;
    
    NSMutableArray *comparisonDates;
    NSMutableArray *comparisonValuesForDates;
    
    NSDateFormatter *dateFormat;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewReference;

@property (nonatomic, retain) SEVFAMAppDelegate *appDelegate;

@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic, retain) NSMutableArray *valuesForDates;

@property (nonatomic, retain) NSMutableArray *comparisonDates;
@property (nonatomic, retain) NSMutableArray *comparisonValuesForDates;

@property (nonatomic, retain) NSDateFormatter *dateFormat;

@end
