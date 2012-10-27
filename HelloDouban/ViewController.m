//
//  ViewController.m
//  HelloDouban
//
//  Created by 万业超 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DouAuth.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    UIButton *authButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [authButton setBackgroundImage:[UIImage imageNamed:@"login_with_douban_24.png"] forState:UIControlStateNormal];
    [authButton setFrame:CGRectMake(50, 50, 120, 24)];
    [authButton addTarget:self action:@selector(goAuth:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authButton];

    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [userButton setTitle:@"getMyInfo" forState:UIControlStateNormal];
    [userButton setFrame:CGRectMake(50, 100, 120, 24)];
    [userButton addTarget:self action:@selector(getMyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userButton];
    [super viewDidLoad];

}

- (void)getMyInfo:(id)sender{
    NSString  *string = [NSString  stringWithFormat:@"%@%@?uid=%@&access_token=%@",APIURL,GetCurrentUser,
                         [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                         [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    NSLog(@"--------------%@",string);
    [[DouAuth share] makeCall:string];
}

- (void)goAuth:(id)sender{
    [[DouAuth share] startAuth:sender];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
