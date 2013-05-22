//
//  SEVFAMAppDelegate.h
//  SEVFAM
//
//  Created by ; Beciragic on 4/20/12.
//  Copyright 2012 axeltra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEVFAMAppDelegate : NSObject <UIApplicationDelegate>{
    
    NSMutableDictionary *userData;
    NSMutableDictionary *costsData;
    NSMutableDictionary *tableData;
    NSMutableDictionary *comparisonCostsData;
    NSMutableDictionary *comparisonTableData;
    
    NSDate *startDate;
    NSDate *endDate;
    NSDate *compareStartDate;
    NSDate *compareEndDate;
    
    int numberOfDays;
    
    BOOL *isIpad;
    BOOL *rotateBack;
    BOOL *comparison;
    BOOL *sameData;
    BOOL *internetActive;
    
    NSString *password;
    
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSMutableDictionary *costsData;
@property (nonatomic, retain) NSMutableDictionary *tableData;
@property (nonatomic, retain) NSMutableDictionary *comparisonCostsData;
@property (nonatomic, retain) NSMutableDictionary *comparisonTableData;


@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *compareStartDate;
@property (nonatomic, retain) NSDate *compareEndDate;

@property (nonatomic, readwrite) BOOL *isIpad;
@property (nonatomic, readwrite) BOOL *rotateBack;
@property (nonatomic, readwrite) BOOL *comparison;
@property (nonatomic, readwrite) BOOL *sameData;
@property (nonatomic, readwrite) BOOL *internetActive;

@property (nonatomic, readwrite) int numberOfDays;

@property (nonatomic, retain) NSString *password;

+ (NSDate *) sub2Days:(NSDate *)date;
+ (int)howManyDaysHavePast:(NSDate*)lastDate today:(NSDate*)today;
+ (NSDate *) substractOneHour:(NSString *)date;
+ (NSDate *) addYear:(NSDate *)date;
+ (NSDate *) subYear:(NSDate *)date;
+ (NSDate *) modifyDate:(NSDate *)date withDays:(int)mod;

@end
