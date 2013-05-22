//
//  CPTTestAppScatterPlotController.m
//  CPTTestApp-iPhone
//
//  Created by Brad Larson on 5/11/2009.
//

#import "CPTTestAppScatterPlotController.h"
#import "UIImage-Extensions.h"
#import "TestXYTheme.h"

#define USE_DOUBLEFASTPATH true
#define USE_ONEVALUEPATH   false
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation CPTTestAppScatterPlotController

@synthesize appDelegate;
@synthesize dates,valuesForDates;

#pragma mark -
#pragma mark Initialization and teardown

-(void)dealloc
{
	[graph release];
	[super dealloc];
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

- (UIImage*)captureView:(UIView *)view {
       
    /*CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeTranslation(480, 0.0);
    transform = CGAffineTransformScale(transform, -1.0, 1.0);
    */
	UIGraphicsBeginImageContext(self.view.bounds.size);
    
    /*CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    */
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    //UIImage *returnImage = [imageView.image imageRotatedByDegrees:180];

	return imageView.image;    
}

- (void)saveScreenshotToPhotosAlbum:(UIView *)view {
	//UIImageWriteToSavedPhotosAlbum([self captureView:self.view], nil, nil, nil);
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Check out this image!"];
        
        // Set up recipients
        // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
        // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
        // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
        
        // [picker setToRecipients:toRecipients];
        // [picker setCcRecipients:ccRecipients];   
        // [picker setBccRecipients:bccRecipients];
        
        // Attach an image to the email
        UIImage *coolImage = [self captureView:self.view];
        NSData *myData = UIImagePNGRepresentation(coolImage);
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"coolImage.png"];
        
        // Fill out the email body text
        NSString *emailBody = @"Screenshot is attached";
        [picker setMessageBody:emailBody isHTML:NO];
        
    if ([MFMailComposeViewController canSendMail]){
        [self presentModalViewController:picker animated:YES];
    }
    else{
        NSLog(@"error");
    }
    
        
        [picker release];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
	[super viewDidLoad];
    
    //screen rotation
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:YES];
    [self.parentViewController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
    
    [[self.navigationController view] setBounds:CGRectMake(0, 0, 300, 480)];
    self.parentViewController.view.transform = CGAffineTransformIdentity;
    [[self.navigationController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(-90))];
    self.navigationController.view.frame = CGRectMake(0, 0, 320, 480);
    
    [UIView commitAnimations];
    
    UIBarButtonItem *eventButton = [[UIBarButtonItem alloc] initWithTitle:@"Screenshot" style:UIBarButtonItemStyleBordered target:self action:@selector(saveScreenshotToPhotosAlbum:)];
    [eventButton setWidth:25];
    self.navigationItem.rightBarButtonItem = eventButton;

    
    appDelegate = (SEVFAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    valuesForDates = [[NSMutableArray alloc] initWithArray:[appDelegate.tableData objectForKey:@"value"]];
    dates = [[NSMutableArray alloc] initWithArray:[appDelegate.tableData objectForKey:@"date"]];
    appDelegate.rotateBack = TRUE;
    
	// Create graph from a custom theme
	graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [[TestXYTheme alloc] init];
	[graph applyTheme:theme];
	[theme release];
    
    graph.paddingLeft   = 0.0; 
    graph.paddingTop    = 0.0; 
    graph.paddingRight  = 0.0; 
    graph.paddingBottom = 0.0; 
    
    
    
    NSString *startDate = [dates objectAtIndex:0];
    
    
    NSTimeInterval oneDay = 0;
    // <3 dena 15 minuti
    // <30 dena 2 casa
    // <90 dena 6 casa
    // >90 dena 24 casa
    if (appDelegate.numberOfDays > 90) {
        oneDay = 60*60*24;
    }
    else if(appDelegate.numberOfDays <= 90 && appDelegate.numberOfDays > 30){
        oneDay = 60*60*6;
    }
    else if(appDelegate.numberOfDays <= 30 && appDelegate.numberOfDays > 3){
        oneDay = 60*60*2;
    }
    else if (appDelegate.numberOfDays <= 3) {
        oneDay = 15*60;
    }

	CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
	hostingView.hostedGraph = graph;

    NSArray *niza = valuesForDates;
    
    
    double min = 100000000;
    double max = 0;
    double xMax = oneDay * [niza count];
    numberOfValues = [niza count];
    
    for (int i = 0; i < [niza count]; i ++) {
        double toCompare = [[niza objectAtIndex:i] doubleValue];
        if (toCompare > max) {
            max = toCompare;
        }
        if (toCompare < min) {
            min = toCompare;
        }
    }
    
    
    NSArray *compareNiza;
    if (appDelegate.comparison) {
        double compareMin = 100000000;
        double compareMax = 0;
        compareNiza = [[NSMutableArray alloc] initWithArray:[appDelegate.comparisonTableData objectForKey:@"value"]];
        for (int i = 0; i < [compareNiza count]; i ++) {
            double toCompare = [[compareNiza objectAtIndex:i] doubleValue];
            if (toCompare > compareMax) {
                compareMax = toCompare;
            }
            if (toCompare < compareMin) {
                compareMin = toCompare;
            }
        }
        
        if (max < compareMax) {
            max = compareMax;
        }
        if (min > compareMin) {
            min = compareMin;
        }
        if ([compareNiza count]>numberOfValues) {
            numberOfValues = [compareNiza count];
        }
    }
    
    double tenPercent = min - (max * 0.1); 
	// Setup plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	NSTimeInterval xLow		  = 0.0f; //- xMax*0.1;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(xMax)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(tenPercent) length:CPTDecimalFromFloat(max*1.1)];
    plotSpace.allowsUserInteraction = TRUE;
    
	// Create a blue plot area
	CPTScatterPlot *boundLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
	boundLinePlot.identifier = @"Original values";
        
	CPTMutableLineStyle *lineStyle = [[boundLinePlot.dataLineStyle mutableCopy] autorelease];
	lineStyle.lineWidth			= 1.0f;
	lineStyle.lineColor			= [CPTColor blueColor];
	boundLinePlot.dataLineStyle = lineStyle;

	boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];

	// Create a green plot area
    if (appDelegate.comparison) {
        CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
        dataSourceLinePlot.identifier = @"Comparison values";
        
        lineStyle						 = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
        lineStyle.lineWidth				 = 1.0f;
        lineStyle.lineColor				 = [CPTColor greenColor];
        dataSourceLinePlot.dataLineStyle = lineStyle;
        
        dataSourceLinePlot.dataSource = self;
        [graph addPlot:dataSourceLinePlot];
    }
	    
    //Axes
    NSSet *majorTickLocations = [NSSet setWithObjects:[NSDecimalNumber zero],
                                 [NSDecimalNumber numberWithUnsignedInteger:1*oneDay],
                                 [NSDecimalNumber numberWithUnsignedInteger:2*oneDay],
                                 
                                 nil];
    CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
    axisTitleTextStyle.fontName = @"Helvetica-Bold";
    axisTitleTextStyle.fontSize = 9;
    
    // Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	x.majorIntervalLength		  = CPTDecimalFromFloat(oneDay);
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1");
	x.minorTicksPerInterval		  = 3;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    x.tickDirection = CPTSignNone;
    x.majorTickLocations = majorTickLocations;
    x.preferredNumberOfMajorTicks = 4;
    x.titleTextStyle = axisTitleTextStyle;
    //x.labelRotation = M_PI/2;
    //x.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(19.0f)];
   
    //x.title = @"Jahre";
    //x.titleOffset = 35.0f;
    x.titleLocation = CPTDecimalFromFloat(x.visibleRange.lengthDouble / 2.0);
    
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"]autorelease]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
	CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    NSDate *refDate = [NSDate dateWithNaturalLanguageString:startDate];
	timeFormatter.referenceDate = refDate;
	x.labelFormatter			= timeFormatter;   
    
    NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
    newFormatter.positiveSuffix = @" KW";
    newFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
	CPTXYAxis *y = axisSet.yAxis;
	y.majorIntervalLength		  = CPTDecimalFromString(@"0.5");
	y.minorTicksPerInterval		  = 5;
	y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(oneDay);
    y.labelOffset                 = -50;
    y.labelAlignment              = CPTAlignmentLeft;
    y.labelFormatter              = newFormatter;
    x.majorIntervalLength         = CPTDecimalFromFloat((max*1.1)-tenPercent/6);
    
    x.axisConstraints = [CPTConstraints constraintWithUpperOffset:245];
    y.axisConstraints = [CPTConstraints constraintWithUpperOffset:470];
    
	NSUInteger i;
	for ( i = 0; i < numberOfValues; i++ ) {
        if (i <= ([niza count]-1)) {
            xxx1[i]	= i*oneDay;
            yyy1[i] = [[niza objectAtIndex:i] doubleValue];
        }
        else{
            xxx1[i]	= xxx1[i-1];
            yyy1[i] = yyy1[i-1];
        }
	}
    
    if (appDelegate.comparison) {
        graph.legend = [CPTLegend legendWithGraph:graph];
        graph.legend.textStyle = x.titleTextStyle;
        graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
        graph.legend.borderLineStyle = x.axisLineStyle;
        graph.legend.cornerRadius = 5.0;
        graph.legend.swatchSize = CGSizeMake(25.0, 25.0);
        graph.legendAnchor = CPTRectAnchorRight;
        graph.legendDisplacement = CGPointMake(-5.0, 98.0);
        
        if ([compareNiza count] != [niza count]) {
            oneDay = oneDay * [niza count]/[compareNiza count];
        }
        for (int j = 0; j < numberOfValues; j++ ) {
            if (j <= ([compareNiza count]-1)) {
                xxx2[j]	= j*oneDay;
                yyy2[j] = [[compareNiza objectAtIndex:j] doubleValue];
            }
            else{
                xxx2[j]	= xxx2[j-1];
                yyy2[j] = yyy2[j-1];
            }
        }
    }

#define PERFORMANCE_TEST1
#ifdef PERFORMANCE_TEST1
	//[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif

#ifdef PERFORMANCE_TEST2
	[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadPlots) userInfo:nil repeats:YES];
#endif
}

-(void)reloadPlots
{
	NSArray *plots = [graph allPlots];

	for ( CPTPlot *plot in plots ) {
		[plot reloadData];
	}
}

-(void)changePlotRange
{
	// Setup plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	float ylen				  = numberOfValues * (rand() / (float)RAND_MAX);

	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(numberOfValues)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(ylen)];
}

#pragma mark -
#pragma mark Plot Data

-(double *)valuesForPlotWithIdentifier:(id)identifier field:(NSUInteger)fieldEnum
{
	if ( fieldEnum == 0 ) {
        if ( [identifier isEqualToString:@"Original values"] ) {
			return xxx1;
		}
		else {
			return xxx2;
		}
	}
	else {
		if ( [identifier isEqualToString:@"Original values"] ) {
			return yyy1;
		}
		else {
			return yyy2;
		}
	}
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return numberOfValues;
}

#if USE_DOUBLEFASTPATH
#if USE_ONEVALUEPATH
-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)indx
{
	double *values = [self valuesForPlotWithIdentifier:[plot identifier] field:fieldEnum];

	return values[indx];
}

#else
-(double *)doublesForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
{
	double *values = [self valuesForPlotWithIdentifier:[plot identifier] field:fieldEnum];

	return values + indexRange.location;
}

#endif

#else
#if USE_ONEVALUEPATH
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)indx
{
	NSNumber *num  = nil;
	double *values = [self valuesForPlotWithIdentifier:[plot identifier] field:fieldEnum];

	if ( values ) {
		num = [NSNumber numberWithDouble:values[indx]];
	}
	return num;
}

#else
-(NSArray *)numbersForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
{
	double *values = [self valuesForPlotWithIdentifier:[plot identifier] field:fieldEnum];

	if ( values == NULL ) {
		return nil;
	}

	NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:indexRange.length];
	for ( NSUInteger i = indexRange.location; i < indexRange.location + indexRange.length; i++ ) {
		NSNumber *number = [[NSNumber alloc] initWithDouble:values[i]];
		[returnArray addObject:number];
		[number release];
	}
	return returnArray;
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
        return NO;
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
		return YES;
	}else{
        return NO;
    }
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}*/

#endif
#endif
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // If you make sure your dates are calculated at noon, you shouldn't have to 
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSDate *refDate = [NSDate dateWithTimeIntervalSinceReferenceDate:31556926 * 10];
    NSTimeInterval oneDay = 24 * 60 * 60;
    
    // Invert graph view to compensate for iOS coordinates
    CGAffineTransform verticalFlip = CGAffineTransformMakeScale(1,-1);
    self.view.transform = verticalFlip;
    
    
    // allocate the graph within the current view bounds
    graph = [[CPTXYGraph alloc] initWithFrame: self.view.bounds];
    
    // assign theme to graph
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    // Setting the graph as our hosting layer
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:hostingView];
    
    hostingView.hostedGraph = graph;
    
    graph.paddingLeft = 0;
    graph.paddingTop = 0;
    graph.paddingRight = 0;
    graph.paddingBottom = 0;
    
    // setup a plot space for the plot to live in
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow = 0.0f;
    // sets the range of x values
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow)
                                                    length:CPTDecimalFromFloat(oneDay*5.0f)];
    // sets the range of y values
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) 
                                                    length:CPTDecimalFromFloat(5)];
    plotSpace.allowsUserInteraction = YES;
    // plotting style is set to line plots
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    // X-axis parameters setting
    CPTXYAxisSet *axisSet = (id)graph.axisSet;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(oneDay);
    axisSet.xAxis.minorTicksPerInterval = 0;
    axisSet.xAxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); //added for date, adjust x line
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.labelOffset = 3.0f;
    axisSet.xAxis.labelingPolicy		= CPTAxisLabelingPolicyAutomatic;
    
    // added for date
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTTimeFormatter *timeFormatter = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    axisSet.xAxis.labelFormatter = timeFormatter;
    
    // Y-axis parameters setting    
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromString(@"0.5");
    axisSet.yAxis.minorTicksPerInterval = 2;
    axisSet.yAxis.orthogonalCoordinateDecimal = CPTDecimalFromFloat(oneDay); // added for date, adjusts y line
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.labelOffset = 3.0f;
    axisSet.yAxis.labelingPolicy		= CPTAxisLabelingPolicyAutomatic;
    
    // This actually performs the plotting
    CPTScatterPlot *xSquaredPlot = [[[CPTScatterPlot alloc] init] autorelease];
    
    CPTMutableLineStyle *dataLineStyle = [CPTMutableLineStyle lineStyle];
    //xSquaredPlot.identifier = @"X Squared Plot";
    xSquaredPlot.identifier = @"Date Plot";
    
    dataLineStyle.lineWidth = 1.0f;
    dataLineStyle.lineColor = [CPTColor redColor];
    xSquaredPlot.dataLineStyle = dataLineStyle;
    xSquaredPlot.dataSource = self;
    
    CPTPlotSymbol *greenCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];
    greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
    xSquaredPlot.plotSymbol = greenCirclePlotSymbol;  
    
    // add plot to graph
    [graph addPlot:xSquaredPlot];
    
    // Add some data
    NSMutableArray *newData = [NSMutableArray array];
    NSUInteger i;
    for ( i = 0; i < 5; i++ ) {
        NSTimeInterval x = oneDay*i;
        id y = [NSDecimalNumber numberWithFloat:1.2*rand()/(float)RAND_MAX + 1.2];
        [newData addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSDecimalNumber numberWithFloat:x], [NSNumber numberWithInt:CPTScatterPlotFieldX], 
          y, [NSNumber numberWithInt:CPTScatterPlotFieldY], 
          nil]];
        NSLog(@"%@",newData);
    }
    plotData = [newData retain];
    
}

#pragma mark - Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return plotData.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = [[plotData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    return num;
}
*/
@end
