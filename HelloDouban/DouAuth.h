//
//  DouAuth.h
//  HelloDouban
//
//  Created by 万业超 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

#define APIURL          @"https://api.douban.com"

#define GetUserInfo     @"/v2/user/:name"
#define GetCurrentUser	@"/v2/user/~me"
#define SearchUser      @"/v2/user"

#define APPSecret       @"bb1cd908cbc9bc53"
#define Client_id       @"0045e8f3f8d71a6200d1badbea854f26"
#define STATE           @"Xiaovsme"
#define Redirect_URL    @"sudobeta://callback"
#define OAuthURL        @"https://www.douban.com/service/auth2/auth"
#define AccessTokenURL  @"https://www.douban.com/service/auth2/token"


//#define GetCode         [[NSUserDefaults standardUserDefaults]objectForKey:@"code"];


@interface DouAuth : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

+(id)share;


- (void)startAuth:(id)sender;
- (void)getAccessToken:(NSString *)code;


- (void)handleOpenURL:(NSURL *)url;


- (void)makeCall:(NSString *)callURL;

@property (nonatomic,retain) NSMutableData *responseData;



@end
