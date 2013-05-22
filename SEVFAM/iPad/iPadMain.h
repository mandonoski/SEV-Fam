//
//  iPadMain.h
//  SEVFAM
//
//  Created by Admir Beciragic on 6/12/12.
//  Copyright (c) 2012 axeltra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestProcessor.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "SEVFAMAppDelegate.h"


@interface iPadMain : UIViewController<UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate, ASIHTTPRequestDelegate>{
    
    IBOutlet UILabel *choiceLabel;
    IBOutlet UIView *bigDisplay;
    IBOutlet UIView *comparisonView;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *startDateButton;
    IBOutlet UIButton *endDateButton;
    IBOutlet UIButton *meterChooseBtn;
    IBOutlet UIButton *compareBtn;
    IBOutlet UIButton *compareStartDateButton;
    IBOutlet UIButton *compareEndDateButton;
    IBOutlet UIButton *compareStartDateImageButton;
    IBOutlet UIButton *compareEndDateImageButton;
    IBOutlet UILabel *nameLabel;
    
    IBOutlet UIView *buttonsHolder;
    
    IBOutlet UIView *transparentBackground;
    
    IBOutlet UIDatePicker *datePickerView;
    IBOutlet UIActionSheet *actionSheet;
    
    int requestNumber;
    int numberOfDays;
    
    BOOL startDate;
    BOOL endDate;
    BOOL comparisonStartDate;
    BOOL cmparisonEndDate;
    BOOL meterPicker;
    
    BOOL tableView;
    BOOL graphView;
    
    BOOL validated;
    
    NSDate *startDateFormat;
    NSDate *endDateFormat;
    NSDate *comparisonStartDateFormat;
    NSDate *comparisonEndDateFormat;
    
    RequestProcessor *requestProces;
    MBProgressHUD *HUD;
    SEVFAMAppDelegate *appDelegate;
    
    NSMutableArray *meters;
    NSString *chosenMeter;
    
    NSString *costUrl;
    NSString *tableUrl;
    
    UIPickerView *metersPicker;
    
    IBOutlet UIButton *axeltraLogo;    
}

@property (nonatomic, retain) IBOutlet UILabel *choiceLabel;
@property (nonatomic, retain) IBOutlet UIView *bigDisplay;
@property (nonatomic, retain) IBOutlet UIButton *startDateButton;
@property (nonatomic, retain) IBOutlet UIButton *endDateButton;
@property (nonatomic, retain) IBOutlet UIButton *meterChooseBtn;
@property (nonatomic, retain) IBOutlet UIButton *compareBtn;
@property (nonatomic, retain) IBOutlet UIView *buttonsHolder;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePickerView;
@property (nonatomic, retain) IBOutlet UIActionSheet *actionSheet;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *comparisonView;
@property (nonatomic, retain) IBOutlet UIButton *compareStartDateButton;
@property (nonatomic, retain) IBOutlet UIButton *compareEndDateButton;
@property (nonatomic, retain) IBOutlet UIButton *compareStartDateImageButton;
@property (nonatomic, retain) IBOutlet UIButton *compareEndDateImageButton;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *transparentBackground;

@property (nonatomic, retain) NSDate *startDateFormat;
@property (nonatomic, retain) NSDate *endDateFormat;
@property (nonatomic, retain) NSDate *comparisonStartDateFormat;
@property (nonatomic, retain) NSDate *comparisonEndDateFormat;

@property (nonatomic, retain) SEVFAMAppDelegate *appDelegate; 

@property (nonatomic, retain) NSMutableArray *meters;
@property (nonatomic, retain) NSString *chosenMeter;

@property (nonatomic, retain) UIPickerView *metersPicker;

@property (nonatomic, retain) NSString *costUrl; 
@property (nonatomic, retain) NSString *tableUrl;

@property (nonatomic, retain) IBOutlet UIButton *axeltraLogo;

-(IBAction)showActionSheetMeterPicker:(id)sender;
-(IBAction)showActionSheetStartDate:(id)sender;
-(IBAction)showActionSheetEndDate:(id)sender;
-(IBAction)costRequest:(id)sender;
-(IBAction)tableRequest:(id)sender;
-(IBAction)graphRequest:(id)sender;
-(IBAction)compare:(id)sender;
-(IBAction)showComparionActionSheetEndDate:(id)sender;
-(IBAction)showComparionActionSheetStartDate:(id)sender;
-(void)validate;
-(void)deactivateComparison;

- (void)showHUDWithLabel;
- (void)hudWasHidden:(MBProgressHUD *)hud;
- (NSMutableArray *)packLoginData;

- (BOOL) compareDates;

- (IBAction)webBrowser:(id)sender;

+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector frame:(CGRect)frame image:(UIImage *)image imagePressed:(UIImage *)imagePressed darkTextColor:(BOOL)darkTextColor;

@end
