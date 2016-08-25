//
//  PWWebViewController.m
//  PWWebViewController
//
//  Copyright (c) 2009 Matthias Plappert <mplappert@phaps.de>
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//  to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "PWWebViewController.h"
//#import "RegexKitLite.h"

//忽略证书验证的方法，在release时不能要，不然苹果发布不能通过

#ifdef  kReleaseH


#else

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end

#endif

@interface PWWebViewController (Private)

// This is used internally to check if the forward/back buttons are enabled
- (void)checkNavigationStatus;

@end


@implementation PWWebViewController

- (void)dealloc
{
    //清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)setUp
{
    self.hidesBottomBarWhenPushed = YES;
    
    // Create toolbar (to make sure that we can access it at any time)
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    
    _showToolBar = YES;
}

- (id)initWithRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        _request = request;
        [self rectView];
		[self setUp];
    }
    return self;
}


- (id)initWithRequestUrl:(NSString *)url query:(NSDictionary*)query  {
	
	NSString *link ;
	
	if(query==nil){
		
		
		link = [[NSString alloc] initWithFormat:@"http://%@",url];
		
	}
	else{
		
		link = [query objectForKey:@"link"];
		
	}
	
	
    if (self = [super init]) {
		
		NSURL *_url =[[NSURL alloc ]initWithString:link];
		
		
        _request = [[NSURLRequest alloc ]initWithURL:_url];
		
        
        
		
		self.hidesBottomBarWhenPushed = YES;
		
		// Create toolbar (to make sure that we can access it at any time)
		_toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    }
    
    
    return self;	
}


- (id)initWithRequestUrl:(NSString *)url
{
    if (self = [super init]) {
		
		NSString *url1 = [[NSString alloc] initWithFormat:@"http://%@",url];
		
		NSURL *_url =[[NSURL alloc ]initWithString:url1];
		
        _request = [[NSURLRequest alloc ]initWithURL:_url];
		
		
		
        [self setUp];
    }
    return self;	
	
}

- (id)initWithHtmlString:(NSString *)html
{
    if (self = [super init])
    {
        _htmlString = html;
        [self setUp];
    }
    return self;
}

- (void)loadView
{
	// Loads correctly setup view. We setup the view in portrait mode and it get's transformed by the auto resizing.
	[super loadView];
	
	// Get frames

}

-(void)rectView{
    CGRect frame = self.view.bounds;
    
    // Load web view
    CGFloat toolBarHeight = _showToolBar ? 44.0f : 0;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - toolBarHeight)];

    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight |
                                 UIViewAutoresizingFlexibleBottomMargin);
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    // Load content of web view
//    DLog(@"%@",_request);
    if (_request)
    {
        [_webView loadRequest:_request];
    }
    else if (_htmlString)
    {
        [_webView loadHTMLString:_htmlString baseURL:nil];
    }

    // Create reload button to reload the current page
    _reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                  target:self
                                                                  action:@selector(reload)];
    
    // Create loading button that is displayed if the web view is loading anything
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView startAnimating];
    _loadingButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    
    // Shows the next page, is disabled by default. Web view checks if it can go forward and disables the button if neccessary
    _forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PWWebViewControllerArrowRight.png"] style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(goForward)];
    _forwardButton.enabled = NO;
    
    // Shows the last page, is disabled by default. Web view checks if it can go back and disables the button if neccessary
    _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PWWebViewControllerArrowLeft.png"] style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(goBack)];
    _backButton.enabled = NO;
    
    // Setup toolbar
    if (_showToolBar)
    {
        _toolbar.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - 44.0, frame.size.width, 44.0);
        _toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleHeight);
        
        //_toolbar.backgroundColor = [UIColor colorWithHex:@"#f56177"];
        [self.view addSubview:_toolbar];
        
        // Flexible space
        _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        
        // Assign buttons to toolbar
        if (_toolbar.frame.size.width > 0) {
            _toolbar.items = @[_backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton];
        }
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidUnload
{
	// Save last request
	_request = _webView.request;
	
	_webView = nil;
	
	_reloadButton = nil;
	
	_loadingButton = nil;
	
	_forwardButton = nil;
	
	_backButton = nil;
	
	_flexibleSpace = nil;
}


#pragma mark -
#pragma mark Accessors

- (UIWebView *)webView
{
	return _webView;
}

- (UIToolbar *)toolbar
{
	return _toolbar;
}

#pragma mark -
#pragma mark Button actions

- (void)reload
{
	[self.webView reload];
}

- (void)goBack
{
	if (self.webView.canGoBack == YES) {
		// We can go back. So make the web view load the previous page.
		[self.webView goBack];
		
		// Check the status of the forward/back buttons
		[self checkNavigationStatus];
	}
}

- (void)goForward
{
	if (self.webView.canGoForward == YES) {
		// We can go forward. So make the web view load the next page.
		[self.webView goForward];
		
		// Check the status of the forward/back buttons
		[self checkNavigationStatus];
	}
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //检查登录
    /*
    if (![UserCenter defaultCenter].isLogined)
    {
        NSString *requestString = [[request URL] absoluteString];
        DLog(@"requestString %@",requestString);
        
        NSRange range = [requestString rangeOfString:@"isSNMobileLogin"];
        if (range.length > 0 && ![UserCenter defaultCenter].isLogined)
        {
            [self checkLoginWithLoginedBlock:^{
                
                [self.webView loadRequest:request];
                
            } loginCancelBlock:^{
                
                //pop
                [self.navigationController popViewControllerAnimated:YES];
            }];
            return NO;
        }
        else if ([requestString rangeOfString:@"suningredirect:login" options:NSCaseInsensitiveSearch].location != NSNotFound && ![UserCenter defaultCenter].isLogined )
        {
            NSRange range = [requestString rangeOfString:@"?"];
            NSString *result = [requestString substringFromIndex:range.location+1];
            NSDictionary *paramDic = [result queryDictionaryUsingEncoding:NSUTF8StringEncoding];
            NSString *redirectUrlStr = paramDic[@"URL"];
            NSURL *redirectUrl = [NSURL URLWithString:redirectUrlStr];
            
            if (redirectUrl)
            {
                [self checkLoginWithLoginedBlock:^{
                    
                    NSURLRequest *redirectRequest = [NSURLRequest requestWithURL:redirectUrl];
                    [self.webView loadRequest:redirectRequest];
                    
                } loginCancelBlock:^{
                    //do nothing
                }];
            }
            else
            {
                DLog(@"invalid redirect url %@", redirectUrlStr);
            }
            
            return NO;
        }
    }
    */
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// Change toolbar items
    if (_toolbar.frame.size.width > 0) {
        _toolbar.items = @[_backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton];
    }
	
	// Set title
	self.title = self.navtitle;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// Change toolbar items
    if (_toolbar.frame.size.width > 0) {
     	_toolbar.items = @[_backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton];
    }
	
	// Set title
//	NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	self.title = self.navtitle;
	// Check if forward/back buttons are available
	[self checkNavigationStatus];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// Change toolbar items
    if (_toolbar.frame.size.width > 0) {
     	_toolbar.items = @[_backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton];
    }
	
	
	// Check if forward/back buttons are available
	[self checkNavigationStatus];
	
	// Set title
	self.title = @"页面未找到";
    
    if (error)
    {
//        [self presentSheet:[error localizedDescription]];
    }
}

#pragma mark -
#pragma mark Private methods

- (void)checkNavigationStatus
{
	// Check if we can go forward or back
	_backButton.enabled = self.webView.canGoBack;
	_forwardButton.enabled = self.webView.canGoForward;
}

-(void)backForePage{
         
//
//  Created by Chenxi Cai on 14-11-11.
//  Copyright (c) 2014年 Chilies. All rights reserved.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
