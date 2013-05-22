//
//  SEVFAMAppDelegate.m
//  SEVFAM
//
//  Created by Admir Beciragic on 4/20/12.
//  Copyright 2012 axeltra. All rights reserved.
//

#import "SEVFAMAppDelegate.h"

@implementation SEVFAMAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize userData,costsData,tableData, comparisonCostsData, comparisonTableData;
@synthesize startDate,endDate,compareEndDate,compareStartDate;
@synthesize rotateBack, comparison, internetActive,sameData, isIpad;
@synthesize numberOfDays;
@synthesize password;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	// Add the navigation controller's view to the window and display.
    
    NSString *model = [[UIDevice currentDevice] model];
    NSString *device = [[model componentsSeparatedByString:@" "] objectAtIndex:0];
    //NSLog(@"Current device model: \"%@\"", device);
    
    if ([device isEqualToString:@"iPad"]) {
        isIpad = TRUE;
    }
    else{
        isIpad = FALSE;
    }
    
    userData = [[NSMutableDictionary alloc] init];
    
    rotateBack = FALSE;
    comparison = FALSE;
    sameData = FALSE;
    
	self.window.rootViewController = self.navigationController;
	[self.window makeKeyAndVisible];
    return YES;
}

+ (NSDate *) sub2Days:(NSDate *)date{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1];
    NSDate *lastPassedMonth = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    
    return lastPassedMonth;
}

+ (NSDate *) modifyDate:(NSDate *)date withDays:(int)mod{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:mod];
    NSDate *lastPassedMonth = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    
    return lastPassedMonth;
}

+ (NSDate *) addYear:(NSDate *)date{
       
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:+1];
    NSDate *lastPassedMonth = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    
    //NSString *returnValue = [dateFormat stringFromDate:lastPassedMonth];
    
    return lastPassedMonth;
}

+ (NSDate *) subYear:(NSDate *)date{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-1];
    NSDate *lastPassedMonth = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    
    //NSString *returnValue = [dateFormat stringFromDate:lastPassedMonth];
    
    return lastPassedMonth;
}


+ (int)howManyDaysHavePast:(NSDate*)lastDate today:(NSDate*)today {
	NSDate *startDate = lastDate;
	NSDate *endDate = today;
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	int days = [components day];
	return days;
}

+ (NSDate *) substractOneHour:(NSDate *)date{
    
    NSDate *today = date;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:-2]; // note that I'm setting it to -1
    NSDate *lastPassedMonth = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    return lastPassedMonth;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[_window release];
	[_navigationController release];
    [super dealloc];
}

@end
