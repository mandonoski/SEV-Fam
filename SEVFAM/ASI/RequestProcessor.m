//
//  RequestProcessor.m
//  TestSQL
//
//  Created by Admir Beciragic on 2/20/12.
//  Copyright (c) 2012 Axeltra. All rights reserved.
//

#import "RequestProcessor.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"

@interface RequestProcessor ()
- (void)requestFetchComplete:(ASIHTTPRequest *)request;
- (void)requestFetchFailed:(ASIHTTPRequest *)request;

- (NSMutableArray *)processResponse:(ASIHTTPRequest *)theRequest;
//- (ASIHTTPRequest *)fetchURL:(NSString *)url;
@end

@implementation RequestProcessor

@synthesize requestsInProgress;
@synthesize delegate;

- (void)doPostRequest:(NSString *)urlString withParameters:(NSArray *)params {
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSMutableString *qstring = [[NSMutableString alloc] init];
	for (int i = 0; i < [params count]; i++){
		[request addPostValue:[[params objectAtIndex:i] objectForKey:@"value"] forKey:[[params objectAtIndex:i] objectForKey:@"key"]];
		[qstring appendString:[NSString stringWithFormat:@"&%@=%@", [[params objectAtIndex:i] objectForKey:@"key"], [[params objectAtIndex:i] objectForKey:@"value"]]];
	}
	
	//NSLog(@"\nurl: %@\nparams: %@\n%@", urlString, [request postData], qstring);
	
    [request setValidatesSecureCertificate:NO];
	[request setTimeOutSeconds:20];
	[request setDelegate:self];
	[request setDidStartSelector:@selector(postRequestDidStart:)];
	[request setDidFinishSelector:@selector(postRequestDidFinish:)];
	[request setDidFailSelector:@selector(postRequestDidFail:)];
	[request startAsynchronous];
	
	//[request releaseBlocksOnMainThread];	
}

- (void)doRequest:(NSString *)url {
    NSURL *urlFromString = [NSURL URLWithString:url];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlFromString];
	
	//NSLog(@"\nurl: %@", url);
	
	[request setDelegate:self];
	[request setDidStartSelector:@selector(requestFetchStarted:)];
	[request setDidFinishSelector:@selector(requestFetchComplete:)];
	[request setDidFailSelector:@selector(requestFetchFailed:)];
	[request startAsynchronous];
	
	//[request releaseBlocksOnMainThread];
}
/*
 - (ASIHTTPRequest *)doRequest:(NSString *)url {
 NSURL *urlFromString = [NSURL URLWithString:url];
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlFromString];
 [request setDelegate:self];
 [request setDidStartSelector:@selector(requestFetchStarted:)];
 [request setDidFinishSelector:@selector(requestFetchComplete:)];
 [request setDidFailSelector:@selector(requestFetchFailed:)];
 [request startSynchronous];
 
 return request;
 }
 */

- (NSMutableArray *)processResponse:(NSData *)theResponse {
	SBJSON *parser = [[SBJSON alloc] init];
	NSMutableData *tmpData = [[NSMutableData alloc] initWithData:theResponse];
	NSString *json_string = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
	[tmpData release];
	
	NSError *err = nil;
	NSMutableArray *tmp = [parser objectWithString:json_string error:&err];
	
	//[parser release];
	//parser = nil;
	//[json_string release];
	//json_string = nil;
	
	if (err	!= nil){
		NSLog(@"error: %@", [err localizedDescription]);
		NSLog(@"error: %@", parser.errorTrace);
		
		if ([[err localizedDescription] isEqualToString:@"Unrecognised leading character"] || 
			[[err localizedDescription] isEqualToString:@"Unexpected end of string"]){
            NSLog(@"error data: %@", theResponse);
			UIAlertView *a = [[UIAlertView alloc] 
							  initWithTitle:@"Request Failed" 
							  message:[NSString stringWithFormat:@"There has been an error processing your request: %@", [err localizedDescription]] 
							  delegate:nil 
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
			[a show];
            [a release];
			[err release];
            return nil;
		}
	}
	
	return tmp;
}

// At time of writing ASIWebPageRequests do not support automatic progress tracking across all requests needed for a page
// The code below shows one approach you could use for tracking progress - it creates a new row with a progress indicator for each resource request
// However, you could use the same approach and keep track of an overal total to show progress

- (void)requestFetchStarted:(ASIHTTPRequest *)request {
	if ([delegate respondsToSelector:@selector(requestDidStart:)]){
		[delegate requestDidStart:request];
	}
}

- (void)requestFetchComplete:(ASIHTTPRequest *)request { 
    //NSLog(@"fetch url: %@", [request originalURL]);
	if ([delegate respondsToSelector:@selector(requestDidFinish:)]){
		[delegate requestDidFinish:request];
	}
}

- (void)requestFetchFailed:(ASIHTTPRequest *)request { 
	if ([delegate respondsToSelector:@selector(requestDidFail:)]){
		[delegate requestDidFail:request];
	}
}

- (void)postRequestDidStart:(ASIFormDataRequest *)request {
	if ([delegate respondsToSelector:@selector(postRequestDidStart:)]){
		[delegate postRequestDidStart:request];
	}
}

- (void)postRequestDidFinish:(ASIFormDataRequest *)request {
	if ([delegate respondsToSelector:@selector(postRequestDidFinish:)]){
		[delegate postRequestDidFinish:request];
	}
}

- (void)postRequestDidFail:(ASIFormDataRequest *)request {
	if ([delegate respondsToSelector:@selector(postRequestDidFail:)]){
		[delegate postRequestDidFail:request];
	}
}

- (NSMutableArray *)processResponseByString:(NSString *)theResponse {
	SBJSON *parser = [[SBJSON alloc] init];
	NSString *json_string = [NSString stringWithString:theResponse];
	NSError *err = nil;
	NSMutableArray *tmp = [parser objectWithString:json_string error:&err];
	/*
     [parser release];
     parser = nil;
     [json_string release];
     json_string = nil;
     */
	if (err	!= nil){
		NSLog(@"error: %@", [err localizedDescription]);
		NSLog(@"error: %@", parser.errorTrace);
		
		if ([[err localizedDescription] isEqualToString:@"Unrecognised leading character"] || 
			[[err localizedDescription] isEqualToString:@"Unexpected end of string"]){
            NSLog(@"error data: %@", theResponse);
			UIAlertView *a = [[UIAlertView alloc] 
							  initWithTitle:@"Request Failed" 
							  message:[NSString stringWithFormat:@"There has been an error processing your request: %@", [err localizedDescription]]  
							  delegate:nil 
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
			[a show];
			[a release];
			[err release];
            return nil;
		}
	}
	
	return tmp;
}


@end
