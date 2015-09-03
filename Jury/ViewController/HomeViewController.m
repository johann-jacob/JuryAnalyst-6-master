//
//  HomeViewController.m
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import "HomeViewController.h"

#import "AppDelegate.h"

@interface HomeViewController ()

- (IBAction)onStart:(id)sender;

@end

@implementation HomeViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)onStart:(id)sender
{
    [self performSegueWithIdentifier:@"Cases" sender:self];
}

@end
