//
//  DouAuth.m
//  HelloDouban
//
//  Created by 万业超 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DouAuth.h"

@implementation DouAuth
@synthesize responseData;


static DouAuth *douAuth;

+ (id)share{
    if(nil==douAuth){
        douAuth = [[DouAuth alloc] init];
    }
    
    return  douAuth;
}

#pragma mark -
#pragma mark getAccessToken


- (void)startAuth:(id)sender{
    NSString *req = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&state=%@",
                     OAuthURL,Client_id,Redirect_URL,STATE];
    
    NSLog(@"%@",req);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:req]];
    
}



- (void)handleOpenURL:(NSURL *)url{
    NSLog(@"%@",[url query]);
    
    NSString *code = [[url query] substringWithRange:NSMakeRange([[url query] length]-31, 16)];
    [[NSUserDefaults standardUserDefaults] setValue:code forKey:@"code"];
    NSLog(@"Code:%@",code);
    [self getAccessToken:code];
    
}


- (void)getAccessToken:(NSString *)code{
    NSURL *url = [NSURL URLWithString:AccessTokenURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
 
    NSMutableData *bodyData = [[[NSMutableData alloc] initWithLength:0] autorelease];
    [bodyData appendData: [[NSString stringWithFormat:@"client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code&code=%@",Client_id,APPSecret,Redirect_URL,code] dataUsingEncoding:NSUTF8StringEncoding]];
    

    [request setHTTPBody:bodyData];
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    [request setValue:[NSString stringWithFormat:@"Authorization: Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] initWithLength:0];
    [conn start];
    
    NSLog(@"header:%@",[request allHTTPHeaderFields]);
    
}

- (void)makeCall:(NSString *)callURL{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    
    NSURL *url = [NSURL URLWithString:callURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
    NSLog(@"header:%@",[request allHTTPHeaderFields]);
}

#pragma mark -
#pragma mark network delegate methods


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error%@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response:%@",response);
    NSDictionary *dict = [response objectFromJSONString];
    
    NSLog(@"dict:%@",dict);
    
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"access_token"] forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"douban_user_id"] forKey:@"uid"];
    
    NSLog(@"Finished");
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

@end
