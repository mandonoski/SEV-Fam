//
//  Table.m
//  SEVFAM
//
//  Created by Admir Beciragic on 4/25/12.
//  Copyright (c) 2012 axeltra. All rights reserved.
//

#import "Table.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation Table

@synthesize appDelegate;
@synthesize dates,valuesForDates,comparisonDates,comparisonValuesForDates;
@synthesize tableViewReference;
@synthesize dateFormat;

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
    valuesForDates = [[NSMutableArray alloc] initWithArray:[appDelegate.tableData objectForKey:@"value"]];
    dates = [[NSMutableArray alloc] initWithArray:[appDelegate.tableData objectForKey:@"date"]];
    comparisonValuesForDates = [[NSMutableArray alloc] initWithArray:[appDelegate.comparisonTableData objectForKey:@"value"]];
    comparisonDates = [[NSMutableArray alloc] initWithArray:[appDelegate.comparisonTableData objectForKey:@"date"]];
    
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:YES];
    [self.parentViewController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
    
    [[self.navigationController view] setBounds:CGRectMake(0, 0, 300, 480)];
    self.parentViewController.view.transform = CGAffineTransformIdentity;
    [[self.navigationController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(-90))];
    self.navigationController.view.frame = CGRectMake(0, 0, 320, 480);
    
    [UIView commitAnimations];
    
    dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setLocale:[[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"]autorelease]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    [dateFormat retain];
    
    appDelegate.rotateBack = TRUE;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
		return YES;
	}
    return NO;
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([dates count] > [comparisonDates count] || [dates count] == [comparisonDates count]) {
        return [dates count];
    }
    else{
        return [comparisonDates count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)] autorelease];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *borderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 43.5, 480, 0.5)] autorelease];
    borderView.backgroundColor = [UIColor blackColor];
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    
    if (appDelegate.comparison) {
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = UITextAlignmentCenter;
        label1.backgroundColor = [UIColor clearColor];
        label1.text = @"#";
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 155, 44)];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = UITextAlignmentCenter;
        label2.backgroundColor = [UIColor clearColor];
        label2.text = @"Dato";
        
        label3 = [[UILabel alloc] initWithFrame:CGRectMake(195, 0, 70, 44)];
        label3.textColor = [UIColor blackColor];
        label3.textAlignment = UITextAlignmentCenter;
        label3.backgroundColor = [UIColor clearColor];
        label3.text = @"KWh"; 
        
        UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(265, 0, 155, 44)];
        label4.textColor = [UIColor blackColor];
        label4.textAlignment = UITextAlignmentCenter;
        label4.backgroundColor = [UIColor clearColor];
        label4.text = @"Samanber dato";
        
        UILabel * label5 = [[UILabel alloc] initWithFrame:CGRectMake(420, 0, 60, 44)];
        label5.textColor = [UIColor blackColor];
        label5.textAlignment = UITextAlignmentCenter;
        label5.backgroundColor = [UIColor clearColor];
        label5.text = @"KWh";   
        
        [headerView addSubview:label4];
        [headerView addSubview:label5];
        
    }
    else{
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = UITextAlignmentCenter;
        label1.backgroundColor = [UIColor clearColor];
        label1.text = @"#";
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 250, 44)];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = UITextAlignmentCenter;
        label2.backgroundColor = [UIColor clearColor];
        label2.text = @"Dato";
        
        label3 = [[UILabel alloc] initWithFrame:CGRectMake(360, 0, 120, 44)];
        label3.textColor = [UIColor blackColor];
        label3.textAlignment = UITextAlignmentCenter;
        label3.backgroundColor = [UIColor clearColor];
        label3.text = @"KWh";        
    }
    [headerView addSubview:label1];
    [headerView addSubview:label2];
    [headerView addSubview:label3];
    [headerView addSubview:borderView];
    
    return headerView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    if (appDelegate.comparison) {
        
        UILabel *red = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [cell.contentView addSubview:red];
        red.text = [@"" stringByAppendingFormat:@"%i",indexPath.row];
        red.textAlignment = UITextAlignmentCenter;
        
        UILabel *blue = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 155, 44)];
        [cell.contentView addSubview:blue];
        if ([dates count]> indexPath.row) {
            NSDate *dateToFormat = [NSDate dateWithNaturalLanguageString:[dates objectAtIndex:indexPath.row]];
            blue.text = [dateFormat stringFromDate:dateToFormat];
        }
        else{
            blue.text = @"";
        }
        blue.textAlignment = UITextAlignmentCenter;
        
        UILabel *green = [[UILabel alloc] initWithFrame:CGRectMake(195, 0, 70, 44)];
        [cell.contentView addSubview:green];
        if ([valuesForDates count]> indexPath.row) {
            green.text = [[valuesForDates objectAtIndex:indexPath.row]stringByReplacingOccurrencesOfString:@"." withString:@","];
        }
        else{
            green.text = @"";
        }
        green.textAlignment = UITextAlignmentCenter;
        
        UILabel *blue1 = [[UILabel alloc] initWithFrame:CGRectMake(265, 0, 155, 44)];
        [cell.contentView addSubview:blue1];
        if ([comparisonDates count]> indexPath.row) {
            NSDate *dateToFormat = [NSDate dateWithNaturalLanguageString:[comparisonDates objectAtIndex:indexPath.row]];
            blue1.text = [dateFormat stringFromDate:dateToFormat];
        }
        else{
            blue1.text = @"";
        }
        blue1.textAlignment = UITextAlignmentCenter;
        
        UILabel *green1 = [[UILabel alloc] initWithFrame:CGRectMake(420, 0, 60, 44)];
        [cell.contentView addSubview:green1];
        if ([comparisonValuesForDates count]> indexPath.row) {
            green1.text = [[comparisonValuesForDates objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"." withString:@","];
        }
        else{
            green1.text = @"";
        }
        green1.textAlignment = UITextAlignmentCenter;
        cell.userInteractionEnabled = FALSE;
        
        red.font = [UIFont systemFontOfSize:15];
        blue.font = [UIFont systemFontOfSize:15];
        green.font = [UIFont systemFontOfSize:15];
        blue1.font = [UIFont systemFontOfSize:15];
        green1.font = [UIFont systemFontOfSize:15];
        
    }
    else{
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        UILabel *red = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 44)];
        [cell.contentView addSubview:red];
        red.text = [@"" stringByAppendingFormat:@"%i",indexPath.row];
        red.textAlignment = UITextAlignmentCenter;
        
        UILabel *blue = [[UILabel alloc] initWithFrame:CGRectMake(107, 0, 266, 44)];
        [cell.contentView addSubview:blue];
        if ([dates count]> indexPath.row) {
            NSDate *dateToFormat = [NSDate dateWithNaturalLanguageString:[dates objectAtIndex:indexPath.row]];
            blue.text = [dateFormat stringFromDate:dateToFormat];
        }
        else{
            blue.text = @"";
        }
        blue.textAlignment = UITextAlignmentCenter;
        
        UILabel *green = [[UILabel alloc] initWithFrame:CGRectMake(373, 0, 107, 44)];
        [cell.contentView addSubview:green];
        if ([valuesForDates count]> indexPath.row) {
            green.text = [[valuesForDates objectAtIndex:indexPath.row]stringByReplacingOccurrencesOfString:@"." withString:@","];
        }
        else{
            green.text = @"";
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
