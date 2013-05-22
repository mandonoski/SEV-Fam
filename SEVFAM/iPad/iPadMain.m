//
//  iPadMain.m
//  SEVFAM
//
//  Created by Admir Beciragic on 6/12/12.
//  Copyright (c) 2012 axeltra. All rights reserved.
//

#import "iPadMain.h"

#import "SEVFAMAppDelegate.h"
#import "Reachability.h"

#import "iPadCosts.h"
#import "iPadTable.h"
#import "iPadCPTTestAppScatterPlotController.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation iPadMain

@synthesize choiceLabel, bigDisplay;
@synthesize startDateButton, endDateButton,meterChooseBtn,compareBtn,compareStartDateButton,compareEndDateButton,compareStartDateImageButton,compareEndDateImageButton;
@synthesize buttonsHolder;
@synthesize actionSheet,datePickerView,comparisonView;
@synthesize startDateFormat, endDateFormat,comparisonEndDateFormat,comparisonStartDateFormat;
@synthesize appDelegate;
@synthesize meters, metersPicker,chosenMeter;
@synthesize tableUrl,costUrl;
@synthesize scrollView;
@synthesize nameLabel,transparentBackground;
@synthesize axeltraLogo;

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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    self.scrollView.scrollEnabled = TRUE;
    
    validated = FALSE;
    
    requestNumber = 0;
    
    appDelegate = (SEVFAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    /* TEST DATA
     tableUrl = @"http://aaepd.axeltralocal/index/fam/";
     costUrl = @"http://aaepd.axeltralocal/index/costs/";
     */
    
    tableUrl = @"https://w3.sev.fo/mobilefam/meterdata.php";
    costUrl = @"https://w3.sev.fo/mobilefam/charges.php";
    
    requestProces = [[RequestProcessor alloc] init];
    [requestProces setDelegate:self];
    
    self.title = [appDelegate.userData objectForKey:@"cust_name"];
    
    meters = [[NSMutableArray alloc] initWithArray:[appDelegate.userData objectForKey:@"meters"]];
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Útrita" style:UIBarButtonItemStyleBordered target:self action:@selector(doLogOut:)];
	[signOutButton setWidth:25];
	self.navigationItem.rightBarButtonItem = signOutButton;
    [self.navigationItem setHidesBackButton:TRUE];
    
    UIColor* clr = [UIColor colorWithRed:0x7b/255.0f
                                   green:0xd5/255.0f
                                    blue:0xeb/255.0f alpha:1];
    
    choiceLabel.textColor = clr;
    [startDateButton setTitleColor:clr forState:UIControlStateNormal];
    [endDateButton setTitleColor:clr forState:UIControlStateNormal];
    [startDateButton setTitleColor:clr forState:UIControlStateSelected];
    [endDateButton setTitleColor:clr forState:UIControlStateSelected];
    [compareEndDateButton setTitleColor:clr forState:UIControlStateNormal];
    [compareEndDateButton setTitleColor:clr forState:UIControlStateSelected];
    [compareStartDateButton setTitleColor:clr forState:UIControlStateNormal];
    [compareStartDateButton setTitleColor:clr forState:UIControlStateSelected];
    
    [self deactivateComparison];
    
    UIColor* clr1 = [UIColor colorWithRed:0x33/255.0f
                                    green:0x2c/255.0f
                                     blue:0x2c/255.0f alpha:1];
    
    bigDisplay.backgroundColor = clr1;
    
    transparentBackground.backgroundColor = [UIColor clearColor];
    buttonsHolder.backgroundColor = [UIColor clearColor];
    comparisonView.backgroundColor = [UIColor clearColor];
    
    meterPicker = FALSE;
    startDate = FALSE;
    endDate = FALSE;
    comparisonStartDate = FALSE;
    //compareEndDateButton = FALSE;
    tableView = FALSE;
    graphView = FALSE;
    
    chosenMeter = @"";
    
    choiceLabel.text = [meters objectAtIndex:0];
    chosenMeter = [meters objectAtIndex:0];
    
    meterChooseBtn.backgroundColor = [UIColor clearColor];
    
    appDelegate.comparison = false;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)webBrowser:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.axeltra.com/"]];
}

-(IBAction)compare:(id)sender{
    
    if (appDelegate.comparison) {
        CGRect tempFrame = self.view.frame;
        CGRect buttonsHolderFrame = self.buttonsHolder.frame;
        buttonsHolderFrame.origin.y = 695-36;
        tempFrame.size.width=320;//change acco. how much you want to expand
        tempFrame.size.height=460;
        [UIView commitAnimations];    
        [UIView animateWithDuration:0.3 animations:^(void) {
            //self.scrollView.contentSize = CGSizeMake(320, 460);
            //self.view.frame = tempFrame;
            self.buttonsHolder.frame = buttonsHolderFrame;
            nameLabel.hidden = TRUE;
        }];
        self.comparisonView.hidden = TRUE;
        appDelegate.comparison = FALSE;
    }
    else{
        CGRect tempFrame = self.view.frame;
        CGRect buttonsHolderFrame = self.buttonsHolder.frame;
        buttonsHolderFrame.origin.y = 695+140;
        tempFrame.size.width=320;//change acco. how much you want to expand
        tempFrame.size.height=600;
        [UIView commitAnimations];    
        [UIView animateWithDuration:0.3 animations:^(void) {
            //self.scrollView.contentSize = CGSizeMake(320, 600);
            //self.view.frame = tempFrame;
            self.buttonsHolder.frame = buttonsHolderFrame;
        }
                         completion:^(BOOL finished){
                             self.comparisonView.hidden = false;
                             nameLabel.hidden = false;
                         }];
        appDelegate.comparison = TRUE;
    }
    
}

- (void) validate{
    if (startDateFormat != nil) {
        if (endDateFormat != nil) {
            if ([chosenMeter length] != 0) {
                if (appDelegate.comparison) {
                    if (comparisonStartDateFormat != nil) {
                        if (comparisonEndDateFormat != nil) {
                            validated = TRUE;
                        }
                        else{
                            UIAlertView *alert = [[UIAlertView alloc]
                                                  initWithTitle: NSLocalizedString(@"Error !",nil)
                                                  message: [NSString stringWithFormat:@"Comparison end date not selected"]
                                                  delegate: self
                                                  cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                                                  otherButtonTitles: nil, nil];
                            [alert show];
                            [alert release];
                            validated = FALSE;
                        }
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle: NSLocalizedString(@"Error !",nil)
                                              message: [NSString stringWithFormat:@"Comparison start date not selected"]
                                              delegate: self
                                              cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                                              otherButtonTitles: nil, nil];
                        [alert show];
                        [alert release];
                        validated = FALSE;
                    }
                }
                else{
                    validated = TRUE;
                }
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"Error !",nil)
                                      message: [NSString stringWithFormat:@"No meter selected"]
                                      delegate: self
                                      cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                                      otherButtonTitles: nil, nil];
                [alert show];
                [alert release];
                validated = FALSE;
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"Error !",nil)
                                  message: [NSString stringWithFormat:@"End date not selected"]
                                  delegate: self
                                  cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                                  otherButtonTitles: nil, nil];
            [alert show];
            [alert release]; 
            validated = FALSE;
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Error !",nil)
                              message: [NSString stringWithFormat:@"Start date not selected"]
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                              otherButtonTitles: nil, nil];
        [alert show];
        [alert release];
        validated = FALSE;
    }
    
}

-(IBAction)graphRequest:(id)sender{
    [self validate];
    if (validated) {
        graphView = TRUE;
        [self showHUDWithLabel];
        [requestProces doPostRequest:tableUrl withParameters:[NSArray arrayWithArray:[self packLoginData]]];
        /*if (appDelegate.comparison && [self compareDates]) {
         appDelegate.sameData = TRUE;
         appDelegate.comparison = FALSE;
         }
         else{
         if (appDelegate.comparison) {
         appDelegate.sameData = FALSE;
         [requestProces doPostRequest:tableUrl withParameters:[NSArray arrayWithArray:[self packComparisonLoginData]]]; 
         }
         }*/
    }              
}

-(IBAction)tableRequest:(id)sender{
    [self validate];
    if (validated) {
        [self showHUDWithLabel];
        [requestProces doPostRequest:tableUrl withParameters:[NSArray arrayWithArray:[self packLoginData]]];
        tableView = TRUE;
    }              
}

-(IBAction)costRequest:(id)sender {
    [self validate];
    if (validated) {
        [self showHUDWithLabel];
        [requestProces doPostRequest:costUrl withParameters:[NSArray arrayWithArray:[self packLoginData]]];
    }
}


-(BOOL) compareDates{
    BOOL value = FALSE;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    NSString *startDate = [dateFormat stringFromDate:startDateFormat];
    NSString *endDate = [dateFormat stringFromDate:endDateFormat];
    
    NSString *comparisonStartDate = [dateFormat stringFromDate:comparisonStartDateFormat];
    NSString *comparisonEndDate = [dateFormat stringFromDate:comparisonEndDateFormat];
	
	//NSLog(@"%@", comparisonEndDate);
    
    if ([comparisonStartDate isEqualToString:startDate] && [comparisonEndDate isEqualToString:endDate]) {
        value = TRUE;
    }
    
    return value;
}

- (void)viewWillAppear:(BOOL)animated{
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    requestNumber = 0;
    
    if (appDelegate.sameData) {
        appDelegate.comparison = TRUE;
    }
    
    if (appDelegate.rotateBack) {
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:YES];
        [self.navigationController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationPortrait];
        
        self.navigationController.view.transform = CGAffineTransformIdentity;
        [[self.navigationController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
        [[self.navigationController view] setBounds:CGRectMake(0, 0, 768, 1024)];
        self.navigationController.view.frame = CGRectMake(0, 0, 768, 1024);
        [UIView commitAnimations];
    }
}

- (NSMutableArray *)packLoginData {
 	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];    
    
	NSMutableDictionary *userIdParam = [[NSMutableDictionary alloc] init];
	[userIdParam setValue:@"fromdate" forKey:@"key"];
	[userIdParam setValue:[@"" stringByAppendingFormat:@"%@",[dateFormat stringFromDate:startDateFormat]] forKey:@"value"];
	[tmp addObject:userIdParam];
	[userIdParam release];
	userIdParam = nil;
	
	NSMutableDictionary *contactIdParam = [[NSMutableDictionary alloc] init];
	[contactIdParam setValue:@"todate" forKey:@"key"];
	[contactIdParam setValue:[@"" stringByAppendingFormat:@"%@",[dateFormat stringFromDate:endDateFormat]] forKey:@"value"];
	[tmp addObject:contactIdParam];
	[contactIdParam release];
	contactIdParam = nil;
    
    NSMutableDictionary *meterID = [[NSMutableDictionary alloc] init];
	[meterID setValue:@"meterid" forKey:@"key"];
	[meterID setValue:[@"" stringByAppendingFormat:@"%@",chosenMeter] forKey:@"value"];
	[tmp addObject:meterID];
	[meterID release];
	meterID = nil;
    
    NSString *data = [appDelegate.userData objectForKey:@"cust_number"]; 
    NSMutableDictionary *custNumber = [[NSMutableDictionary alloc] init];
	[custNumber setValue:@"cust_number" forKey:@"key"];
	[custNumber setValue:[@"" stringByAppendingFormat:@"%@",data ] forKey:@"value"];
	[tmp addObject:custNumber];
	[custNumber release];
	custNumber = nil;
    
    NSMutableDictionary *password = [[NSMutableDictionary alloc] init];
	[password setValue:@"password" forKey:@"key"];
	[password setValue:[@"" stringByAppendingFormat:@"%@",appDelegate.password] forKey:@"value"];
	[tmp addObject:password];
	[password release];
	password = nil;
    
    appDelegate.startDate = startDateFormat;
    appDelegate.endDate = endDateFormat;
    
    NSLog(@"%@",tmp);
    
	return tmp;
}

- (NSMutableArray *)packComparisonLoginData{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];    
    
	NSMutableDictionary *userIdParam = [[NSMutableDictionary alloc] init];
	[userIdParam setValue:@"fromdate" forKey:@"key"];
	[userIdParam setValue:[@"" stringByAppendingFormat:@"%@",[dateFormat stringFromDate:comparisonStartDateFormat]] forKey:@"value"];
	[tmp addObject:userIdParam];
	[userIdParam release];
	userIdParam = nil;
	
	NSMutableDictionary *contactIdParam = [[NSMutableDictionary alloc] init];
	[contactIdParam setValue:@"todate" forKey:@"key"];
	[contactIdParam setValue:[@"" stringByAppendingFormat:@"%@",[dateFormat stringFromDate:comparisonEndDateFormat]] forKey:@"value"];
	[tmp addObject:contactIdParam];
	[contactIdParam release];
	contactIdParam = nil;
    
    NSMutableDictionary *meterID = [[NSMutableDictionary alloc] init];
	[meterID setValue:@"meterid" forKey:@"key"];
	[meterID setValue:[@"" stringByAppendingFormat:@"%@",chosenMeter] forKey:@"value"];
	[tmp addObject:meterID];
	[meterID release];
	meterID = nil;
    
    NSString *data = [appDelegate.userData objectForKey:@"cust_number"]; 
    NSMutableDictionary *custNumber = [[NSMutableDictionary alloc] init];
	[custNumber setValue:@"cust_number" forKey:@"key"];
	[custNumber setValue:[@"" stringByAppendingFormat:@"%@",data ] forKey:@"value"];
	[tmp addObject:custNumber];
	[custNumber release];
	custNumber = nil;
    
    NSMutableDictionary *password = [[NSMutableDictionary alloc] init];
	[password setValue:@"password" forKey:@"key"];
	[password setValue:[@"" stringByAppendingFormat:@"%@",appDelegate.password] forKey:@"value"];
	[tmp addObject:password];
	[password release];
	password = nil;
    
    appDelegate.compareStartDate = comparisonStartDateFormat;
    appDelegate.compareEndDate = comparisonEndDateFormat;
    
    NSLog(@"%@",tmp);
    
	return tmp;
}

- (void)doLogOut:(id)sender {
    
    appDelegate.password = @"";
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    chosenMeter = [meters objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{	
    int size = [[appDelegate.userData objectForKey:@"meters"] count];
    return size;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    
    return [meters objectAtIndex:row];
    
}

-(IBAction)showActionSheetMeterPicker:(id)sender {
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose meter"
                                                   delegate:self cancelButtonTitle:nil 
                                     destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
    
    metersPicker = [[UIPickerView alloc] init];
	[metersPicker setDelegate:self];
	[metersPicker setDataSource:self];
	metersPicker.showsSelectionIndicator = YES;
	
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    metersPicker.frame = CGRectMake(0, 44, 320, 300);
    
    [popoverView addSubview:metersPicker];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 340, 44)];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,340,44)];
    textLabel.text = @"Select meter";
    textLabel.textColor = [UIColor darkGrayColor];
    [button addSubview:textLabel];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    
    UIImage *buttonBackground = [UIImage imageNamed:@"btn_submit.png"];
    [button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chooseMeterAction) forControlEvents:UIControlEventTouchUpInside];
    [popoverView addSubview:button];
    popoverContent.view = popoverView;
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
    
    //create a popover controller
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    //present the popover view non-modal with a
    //refrence to the button pressed within the current view
    [popoverController presentPopoverFromRect:meterChooseBtn.bounds inView:meterChooseBtn permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    //release the popover content
    [popoverView release];
    [popoverContent release];/*
	[actionSheet addSubview:metersPicker];
	[actionSheet showInView:self.navigationController.view];        
	[actionSheet setBounds:CGRectMake(0,0,320, 526)];
	
	[metersPicker setFrame:CGRectMake(0, 102, 320, 216)];
	
    chosenMeter = [meters objectAtIndex:0];
    
	[actionSheet release];
	actionSheet = nil;
    */
    meterPicker = TRUE;
    
}

-(void) chooseMeterAction{
    choiceLabel.text = chosenMeter;
    meterPicker = FALSE;
}

-(IBAction)showActionSheetStartDate:(id)sender {
    
    startDateFormat = nil;
    [self deactivateComparison];
    
    self.datePickerView = [[UIDatePicker alloc] init];
    self.datePickerView.datePickerMode = UIDatePickerModeDate;
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose start date"
                                                   delegate:self cancelButtonTitle:nil 
                                     destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
    
    NSDate *currDate = [NSDate date];
    if (endDateFormat == nil) {
        datePickerView.maximumDate = currDate;
    }
    else{
        datePickerView.maximumDate = endDateFormat;
    }
    
    if (startDateFormat == nil) {
        [datePickerView setDate:currDate animated:NO];
    }
    else{
        [datePickerView setDate:startDateFormat animated:NO];
    }
    
    
    datePickerView.minimumDate = [SEVFAMAppDelegate subYear:currDate];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    datePickerView.frame = CGRectMake(0, 44, 320, 300);
    
    [popoverView addSubview:datePickerView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 340, 44)];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,340,44)];
    textLabel.text = @"Select start date";
    textLabel.textColor = [UIColor darkGrayColor];
    [button addSubview:textLabel];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    
    UIImage *buttonBackground = [UIImage imageNamed:@"btn_submit.png"];
    [button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startDateSelect) forControlEvents:UIControlEventTouchUpInside];
    [popoverView addSubview:button];
    popoverContent.view = popoverView;
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
    
    //create a popover controller
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    //present the popover view non-modal with a
    //refrence to the button pressed within the current view
    [popoverController presentPopoverFromRect:endDateButton.bounds inView:startDateButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    //release the popover content
    [popoverView release];
    [popoverContent release];

    
    /*
    [self.actionSheet showInView:self.navigationController.view];
    [self.actionSheet addSubview:self.datePickerView];
    [self.actionSheet sendSubviewToBack:self.datePickerView];
    [self.actionSheet setBounds:CGRectMake(0,0,320, 526)];
    */
    
    startDate = TRUE;
    
}

- (void) startDateSelect{
    
    [self deactivateComparison];
    if (appDelegate.comparison && startDateFormat != nil && endDateFormat != nil && comparisonStartDateFormat != nil) {
        [self compare:@""];
    }
    startDateFormat = [datePickerView date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *stringToDisplay = [dateFormat stringFromDate:startDateFormat];
    startDateButton.titleLabel.text = stringToDisplay;
    startDate = FALSE;
    if (startDateFormat != nil && endDateFormat != nil) {
        compareStartDateButton.userInteractionEnabled = TRUE;
        compareEndDateImageButton.userInteractionEnabled = TRUE;
        compareStartDateImageButton.userInteractionEnabled = TRUE;
        compareStartDateButton.alpha = 1;
        compareEndDateImageButton.alpha = 1;
        compareStartDateImageButton.alpha = 1;
        compareEndDateButton.alpha = 1;
        compareEndDateButton.userInteractionEnabled = TRUE;
        numberOfDays = [SEVFAMAppDelegate howManyDaysHavePast:startDateFormat today:endDateFormat];
    }
	[startDateFormat retain];
    
}

-(IBAction)showActionSheetEndDate:(id)sender {
    
    endDateFormat = nil;
    [self deactivateComparison];
    
    self.datePickerView = [[UIDatePicker alloc] init];
    self.datePickerView.datePickerMode = UIDatePickerModeDate;
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose end date"
                                                   delegate:self cancelButtonTitle:nil 
                                     destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
    
    NSDate *currDate = [NSDate date];
    datePickerView.minimumDate = [SEVFAMAppDelegate subYear:currDate];
    if (startDateFormat == nil) {
        [datePickerView setDate:currDate animated:NO];
        if (endDateFormat == nil) {
            datePickerView.maximumDate = currDate;
            [datePickerView setDate:currDate animated:NO];
        }
        else{
            [datePickerView setDate:endDateFormat animated:NO];
        }
    }
    else{
        datePickerView.minimumDate = startDateFormat;
        if ([[SEVFAMAppDelegate addYear:startDateFormat] laterDate:currDate]) {
            datePickerView.maximumDate = currDate;
        }
        else{
            datePickerView.maximumDate = [SEVFAMAppDelegate addYear:startDateFormat];
        }
        datePickerView.minimumDate = startDateFormat;
        if (endDateFormat == nil) {
            [datePickerView setDate:currDate animated:NO];
        }
        else{
            [datePickerView setDate:endDateFormat animated:NO];
        }
        
    }
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];

    datePickerView.frame = CGRectMake(0, 44, 320, 300);

    [popoverView addSubview:datePickerView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 340, 44)];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,340,44)];
    textLabel.text = @"Select end date";
    textLabel.textColor = [UIColor darkGrayColor];
    [button addSubview:textLabel];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    
    UIImage *buttonBackground = [UIImage imageNamed:@"btn_submit.png"];
    [button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [button addTarget:self action:@selector(EndDateSelect) forControlEvents:UIControlEventTouchUpInside];
    [popoverView addSubview:button];
    popoverContent.view = popoverView;


    

    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);

    //create a popover controller
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];

    //present the popover view non-modal with a
    //refrence to the button pressed within the current view
    [popoverController presentPopoverFromRect:endDateButton.bounds inView:endDateButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

    //release the popover content
    [popoverView release];
    [popoverContent release];
    
}

-(void) EndDateSelect{
    [self deactivateComparison];
    if (appDelegate.comparison && startDateFormat != nil && endDateFormat != nil && comparisonStartDateFormat != nil) {
        [self compare:@""];
    }
    endDateFormat = [datePickerView date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *stringToDisplay = [dateFormat stringFromDate:endDateFormat];
    endDateButton.titleLabel.text = stringToDisplay;
    endDate = FALSE;
    if (startDateFormat != nil && endDateFormat != nil) {
        compareStartDateButton.userInteractionEnabled = TRUE;
        compareEndDateImageButton.userInteractionEnabled = TRUE;
        compareStartDateImageButton.userInteractionEnabled = TRUE;
        compareStartDateButton.alpha = 1;
        compareStartDateImageButton.alpha = 1;
        compareEndDateImageButton.alpha = 1;
        compareEndDateButton.alpha = 1;
        compareEndDateButton.userInteractionEnabled = TRUE;
        numberOfDays = [SEVFAMAppDelegate howManyDaysHavePast:startDateFormat today:endDateFormat];
    }
    [endDateFormat retain];
}

-(IBAction)showComparionActionSheetStartDate:(id)sender {
    
    comparisonStartDateFormat = nil;
    
    self.datePickerView = [[UIDatePicker alloc] init];
    self.datePickerView.datePickerMode = UIDatePickerModeDate;
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose comparison start date"
                                                   delegate:self cancelButtonTitle:nil 
                                     destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
    
    NSDate *currDate = [NSDate date];
    if (comparisonStartDateFormat == nil) {
        if (comparisonEndDateFormat == nil) {
            datePickerView.maximumDate = [SEVFAMAppDelegate modifyDate:currDate withDays:-numberOfDays];
            [datePickerView setDate:datePickerView.maximumDate animated:NO];
        }
        else{
            if ([[SEVFAMAppDelegate modifyDate:currDate withDays:-numberOfDays] laterDate:comparisonEndDateFormat]) {
                datePickerView.maximumDate = [SEVFAMAppDelegate modifyDate:currDate withDays:-numberOfDays];         
            }
            else{
                datePickerView.maximumDate = comparisonEndDateFormat;   
            }
            [datePickerView setDate:datePickerView.maximumDate animated:NO];
        }
    }
    else{
        if (comparisonEndDateFormat == nil) {
            datePickerView.maximumDate = [SEVFAMAppDelegate modifyDate:currDate withDays:-numberOfDays];
        }
        else{
            if ([[SEVFAMAppDelegate modifyDate:currDate withDays:-numberOfDays] laterDate:comparisonEndDateFormat]) {
                datePickerView.maximumDate = [SEVFAMAppDelegate modifyDate:currDate withDays:-numberOfDays];         
            }
            else{
                datePickerView.maximumDate = comparisonEndDateFormat;   
            }
        }
        [datePickerView setDate:comparisonStartDateFormat animated:NO];
    }
    datePickerView.minimumDate = [SEVFAMAppDelegate subYear:currDate];
    
    
    /*[self.actionSheet showInView:self.navigationController.view];
    [self.actionSheet addSubview:self.datePickerView];
    [self.actionSheet sendSubviewToBack:self.datePickerView];
    [self.actionSheet setBounds:CGRectMake(0,0,320, 526)];
    */
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    datePickerView.frame = CGRectMake(0, 44, 320, 300);
    
    [popoverView addSubview:datePickerView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 340, 44)];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,340,44)];
    textLabel.text = @"Select compare start date";
    textLabel.textColor = [UIColor darkGrayColor];
    [button addSubview:textLabel];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    
    UIImage *buttonBackground = [UIImage imageNamed:@"btn_submit.png"];
    [button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [button addTarget:self action:@selector(CompareStartDateSelect) forControlEvents:UIControlEventTouchUpInside];
    [popoverView addSubview:button];
    popoverContent.view = popoverView;
    
    
    
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
    
    //create a popover controller
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    //present the popover view non-modal with a
    //refrence to the button pressed within the current view
    [popoverController presentPopoverFromRect:compareStartDateButton.bounds inView:compareStartDateButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    //release the popover content
    [popoverView release];
    [popoverContent release];
    
    comparisonStartDate = TRUE;
    
}

-(void) CompareStartDateSelect{
    comparisonEndDateFormat = [datePickerView date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *stringToDisplay = [dateFormat stringFromDate:comparisonEndDateFormat];
    compareEndDateButton.titleLabel.text = stringToDisplay;
    comparisonStartDateFormat = [SEVFAMAppDelegate modifyDate:comparisonEndDateFormat withDays:-numberOfDays];
    [comparisonStartDateFormat retain];
    stringToDisplay = [dateFormat stringFromDate:comparisonStartDateFormat];
    compareStartDateButton.titleLabel.text = stringToDisplay;
    cmparisonEndDate = FALSE;
	
	[comparisonStartDateFormat retain];
	[comparisonEndDateFormat retain];
}

-(IBAction)showComparionActionSheetEndDate:(id)sender {
    
    comparisonEndDateFormat = nil;
    
    self.datePickerView = [[UIDatePicker alloc] init];
    self.datePickerView.datePickerMode = UIDatePickerModeDate;
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose comparison end date"
                                                   delegate:self cancelButtonTitle:nil 
                                     destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
    
    NSDate *currDate = [NSDate date];
    
    if (comparisonStartDateFormat == nil) {
        if (comparisonEndDateFormat == nil) {
            datePickerView.maximumDate = currDate;
            [datePickerView setDate:datePickerView.maximumDate animated:NO];
        }
        else{
            if ([[SEVFAMAppDelegate modifyDate:currDate withDays:-numberOfDays] laterDate:comparisonEndDateFormat]) {
                datePickerView.maximumDate = comparisonEndDateFormat;            
            }
            else{
                datePickerView.maximumDate = currDate;
            }
            [datePickerView setDate:comparisonStartDateFormat animated:NO];
        }
    }
    else{
        
        if ([[SEVFAMAppDelegate addYear:comparisonStartDateFormat] laterDate:[SEVFAMAppDelegate sub2Days:currDate]]) {
            datePickerView.maximumDate = currDate;
        }
        else{
            datePickerView.maximumDate = [SEVFAMAppDelegate addYear:comparisonStartDateFormat];
        }
        
        if (comparisonEndDateFormat == nil) {
            [datePickerView setDate:currDate];
        }
        else{
            [datePickerView setDate:comparisonEndDateFormat animated:NO];
        }
        
    }
    datePickerView.minimumDate = [SEVFAMAppDelegate modifyDate:[SEVFAMAppDelegate subYear:currDate] withDays:numberOfDays];
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    datePickerView.frame = CGRectMake(0, 44, 320, 300);
    
    [popoverView addSubview:datePickerView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 340, 44)];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,340,44)];
    textLabel.text = @"Select compare end date";
    textLabel.textColor = [UIColor darkGrayColor];
    [button addSubview:textLabel];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    
    UIImage *buttonBackground = [UIImage imageNamed:@"btn_submit.png"];
    [button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [button addTarget:self action:@selector(CompareStartDateSelect) forControlEvents:UIControlEventTouchUpInside];
    [popoverView addSubview:button];
    popoverContent.view = popoverView;
    
    
    
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
    
    //create a popover controller
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    //present the popover view non-modal with a
    //refrence to the button pressed within the current view
    [popoverController presentPopoverFromRect:compareEndDateButton.bounds inView:compareEndDateButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    //release the popover content
    [popoverView release];
    [popoverContent release];    
    cmparisonEndDate = TRUE;
    
}

-(void)CompareEndDateSelect{
    comparisonStartDateFormat = [datePickerView date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *stringToDisplay = [dateFormat stringFromDate:comparisonStartDateFormat];
    compareStartDateButton.titleLabel.text = stringToDisplay;
    comparisonEndDateFormat = [SEVFAMAppDelegate modifyDate:comparisonStartDateFormat withDays:numberOfDays];
    [comparisonEndDateFormat retain];
    stringToDisplay = [dateFormat stringFromDate:comparisonEndDateFormat];
    compareEndDateButton.titleLabel.text = stringToDisplay;
    comparisonStartDate = FALSE;
	
	[comparisonStartDateFormat retain];
	[comparisonEndDateFormat retain];
}

-(void)deactivateComparison{
    compareStartDateButton.userInteractionEnabled = FALSE;
    compareEndDateButton.userInteractionEnabled = FALSE;
    compareEndDateImageButton.userInteractionEnabled = FALSE;
    compareStartDateImageButton.userInteractionEnabled = FALSE;
    compareStartDateButton.alpha = 0.2;
    compareEndDateButton.alpha = 0.2;
    compareEndDateImageButton.alpha = 0.2;
    compareStartDateImageButton.alpha = 0.2;
    
    compareEndDateButton.titleLabel.text = @"__ - __ - ____ ";
    compareStartDateButton.titleLabel.text = @"__ - __ - ____ ";
    comparisonStartDateFormat = nil;
    comparisonEndDateFormat = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)postRequestDidStart:(ASIFormDataRequest *)request {
	//NSLog(@"post request started");
}

- (void)postRequestDidFinish:(ASIFormDataRequest *)request {
    NSLog(@"post request finished: %@", [request responseString]);
    NSString *mainUrl = [NSString stringWithFormat:@"%@", [request originalURL]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    if ([mainUrl isEqualToString:costUrl]) {
        NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:[requestProces processResponseByString:[request responseString]] copyItems:YES];
        if (!tmp || !tmp.count) {
            [self hudWasHidden:HUD];
            requestNumber = 0;
        }
        else{
            if([tmp count] > 0){
                int error =[[[tmp objectAtIndex:0] objectForKey:@"error"] intValue]; 
                
                if ( error == 0){
                    if ((requestNumber == 1 && appDelegate.comparison) || (requestNumber == 0 && !appDelegate.comparison)) {
                        [self hudWasHidden:HUD];
                    }
                    NSMutableDictionary *temp = [tmp objectAtIndex:0];
                    if ([[temp objectForKey:@"startDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.startDate]] && [[temp objectForKey:@"endDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.endDate]]) {
                        appDelegate.costsData = temp;
                        requestNumber++;
                        if (appDelegate.comparison && [self compareDates]) {
                            appDelegate.sameData = TRUE;
                            appDelegate.comparison = FALSE;
							appDelegate.comparisonTableData = temp;	
                        }
                        else{
                            if (appDelegate.comparison) {
                                appDelegate.sameData = FALSE;
                                [requestProces doPostRequest:costUrl withParameters:[NSArray arrayWithArray:[self packComparisonLoginData]]];
                            }
                            
                        }
                    }
                    if ([[temp objectForKey:@"startDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.compareStartDate]] && [[temp objectForKey:@"endDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.compareEndDate]] && appDelegate.comparison) {
                        appDelegate.comparisonCostsData = temp;
                        requestNumber++;
                    }
					if (appDelegate.sameData) {
                        [self hudWasHidden:HUD];
                    }
                    if ((requestNumber == 2 && appDelegate.comparison) || (requestNumber == 1 && !appDelegate.comparison)) {
                        iPadCosts *vievForm = [[iPadCosts alloc] initWithNibName:@"iPadCosts" bundle:nil];
                        [self.navigationController pushViewController:vievForm animated:YES];
                        [vievForm release];
                        vievForm = nil;
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: NSLocalizedString(@"Error !",nil)
                                          message: [NSString stringWithFormat:@"%@",[[tmp objectAtIndex:0] objectForKey:@"errorMessage"]]
                                          delegate: self
                                          cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                                          otherButtonTitles: nil, nil];
                    [alert show];
                    [alert release];
                    [self hudWasHidden:HUD];
                }
            }
        }
    }
    else if([mainUrl isEqualToString:tableUrl]){
        NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:[requestProces processResponseByString:[request responseString]] copyItems:YES];
        if (!tmp || !tmp.count) {
            [self hudWasHidden:HUD];
            requestNumber = 0;
        }
        else{
            if([tmp count] > 0){
                int error =[[[tmp objectAtIndex:0] objectForKey:@"error"] intValue]; 
                
                if ( error == 0){
                    if ((requestNumber == 1 && appDelegate.comparison) || (requestNumber == 0 && !appDelegate.comparison)) {
                        [self hudWasHidden:HUD];
                    }
                    NSMutableDictionary *temp = [tmp objectAtIndex:0];
                    if ([[temp objectForKey:@"startDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.startDate]] && [[temp objectForKey:@"endDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.endDate]]) {
                        appDelegate.tableData = temp;
                        requestNumber++;
                        if (appDelegate.comparison && [self compareDates]) {
                            appDelegate.sameData = TRUE;
                            appDelegate.comparison = FALSE;
							appDelegate.comparisonTableData = temp;
                        }
                        else{
                            if (appDelegate.comparison) {
                                appDelegate.sameData = FALSE;
                                [requestProces doPostRequest:tableUrl withParameters:[NSArray arrayWithArray:[self packComparisonLoginData]]];
                            }
                        }
                    }
                    if ([[temp objectForKey:@"startDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.compareStartDate]] && [[temp objectForKey:@"endDate"] isEqualToString:[dateFormat stringFromDate:appDelegate.compareEndDate]] && appDelegate.comparison) {
                        appDelegate.comparisonTableData = temp;
                        requestNumber++;
                    }
					if (appDelegate.sameData) {
                        [self hudWasHidden:HUD];
                    }
                    if((requestNumber == 2 && appDelegate.comparison) || (requestNumber == 1 && !appDelegate.comparison)){
                        if (graphView) {
                            appDelegate.numberOfDays = [SEVFAMAppDelegate howManyDaysHavePast:appDelegate.startDate today:appDelegate.endDate]; 
                            graphView = FALSE;
                            iPadCPTTestAppScatterPlotController *vievForm = [[iPadCPTTestAppScatterPlotController alloc] initWithNibName:@"iPadScatterPlot" bundle:nil];
                            [self.navigationController pushViewController:vievForm animated:YES];
                            [vievForm release];
                            vievForm = nil;
                        }
                        else{
                            iPadTable *vievForm = [[iPadTable alloc] initWithNibName:@"iPadTable" bundle:nil];
                            [self.navigationController pushViewController:vievForm animated:YES];
                            [vievForm release];
                            vievForm = nil;
                        }
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: NSLocalizedString(@"Error !",nil)
                                          message: [NSString stringWithFormat:@"%@",[[tmp objectAtIndex:0] objectForKey:@"errorMessage"]]
                                          delegate: self
                                          cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                                          otherButtonTitles: nil, nil];
                    [alert show];
                    [alert release];
                    [self hudWasHidden:HUD];
                }
            }
        }
    }
}

- (void)postRequestDidFail:(ASIFormDataRequest *)request {
	NSLog(@"post request failed");
    Reachability *internetReach = [[Reachability reachabilityForInternetConnection] retain];
    [self hudWasHidden:HUD];
    if ([internetReach isReachable]) {
        NSLog(@"post request failed");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Error !",nil)
                              message: [NSString stringWithFormat:@"Your servers are down please try again later"]
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                              otherButtonTitles: nil, nil];
        [alert show];
        [alert release];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Log In Error",nil)
                              message: [NSString stringWithFormat:@"No internet conection"]
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                              otherButtonTitles: nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)requestDidStart:(ASIHTTPRequest *)request { 
	//NSLog(@"request started");
}

- (void)requestDidFinish:(ASIHTTPRequest *)request {
    //NSString *mainUrl = [NSString stringWithFormat:@"%@", [request originalURL]];
}

- (void)requestDidFail:(ASIHTTPRequest *)request { 
    //NSLog(@"request failed");
    [self hudWasHidden:HUD];
} 

- (void)showHUDWithLabel {
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Loading...";
	
    // Show the HUD while the provided method executes in a new thread
    //[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
	[HUD show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	//NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
