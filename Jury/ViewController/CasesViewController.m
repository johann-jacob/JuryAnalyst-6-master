//
//  CasesViewController.m
//  Jury
//
//  Created by wuyinsong on 14-1-3.
//  Copyright (c) 2014年 Alioth. All rights reserved.
//

#import "CasesViewController.h"

#import "DataManager.h"

#import "SurveyView.h"
#import "NewSurveyView.h"

#import "CaseInfo.h"

#import "SettingManager.h"

@interface CasesViewController ()<SurveyViewDelegate, NewSurveyViewDelegate, UIActionSheetDelegate>
{
    CaseInfo *_dummySurvey;
}

@property (nonatomic, assign) IBOutlet UIScrollView *svSurveys;
@property (nonatomic, retain) NewSurveyView *viewNewSurvey;

- (IBAction)onAddNewSurvey:(id)sender;

@end

@implementation CasesViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    [self initSurveys];
}

- (void) initSurveys
{
    [self loadSurveys];
}

- (void) loadSurveys
{
    for (UIView *subView in [self.svSurveys subviews]) {
        [subView removeFromSuperview];
    }
    
    NSInteger countOfSurveys = [DataManager shareDataManager].aryMySurveys.count;
    
    float x = 0; int interval = 20; float width = 255;
    for (NSInteger n = countOfSurveys ; n > 0; n --)
    {
//        NSDictionary *survey = [[DataManager shareDataManager].arySurveys objectAtIndex:(n - 1)];
//        NSString *active = [survey objectForKey:@"active"];
        
//        if([active isEqualToString:@"N"])
//            continue;
        
        SurveyView *surveyView = [[[NSBundle mainBundle] loadNibNamed:@"SurveyView" owner:self options:nil] objectAtIndex:0];
        surveyView.tag = n - 1;
        surveyView.frame = CGRectMake(x, 0, surveyView.frame.size.width, surveyView.frame.size.height);
        [surveyView setSurvey:(int)(n - 1)];
        surveyView.delegate = self;
        
        width = surveyView.frame.size.width;
        
        [self.svSurveys addSubview:surveyView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSurveyView:)];
        [surveyView addGestureRecognizer:tap];
        tap = nil;
        
        UITapGestureRecognizer *twotap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwoFingersView:)];
        twotap.numberOfTouchesRequired = 2;
        [surveyView addGestureRecognizer:twotap];
        twotap = nil;
        
        x += width + interval;
    }
    
    self.svSurveys.contentSize = CGSizeMake(x, 255);
}

- (void) tapSurveyView:(UIGestureRecognizer *)gesture
{
    SurveyView *surveyView = (SurveyView *)gesture.view;
    
    [self _selectSurvey:(int)surveyView.tag];
}

- (void) tapTwoFingersView:(UIGestureRecognizer *)gesture
{
    SurveyView *surveyView = (SurveyView *)gesture.view;
    
    [self selectSurvey:nil index:(int)surveyView.tag];
}

- (IBAction)onAddNewSurvey:(id)sender
{
    if(self.viewNewSurvey == nil)
    {
        self.viewNewSurvey =  [[[NSBundle mainBundle] loadNibNamed:@"NewSurveyView" owner:self options:nil] objectAtIndex:0];
        self.viewNewSurvey.frame = CGRectMake(0, 0, self.viewNewSurvey.frame.size.width, self.viewNewSurvey.frame.size.height);
        self.viewNewSurvey.delegate = self;
        
        [self.view addSubview:self.viewNewSurvey];
    }
    
    self.viewNewSurvey.hidden = NO;
    
    [self.viewNewSurvey _init];
    [self.view bringSubviewToFront:self.viewNewSurvey];
}

- (void) reqAddNewSurvey:(CaseInfo *)newSurvey
{
    [[DataManager shareDataManager] addMySurvey:newSurvey];
    
    [self loadSurveys];
}

- (void) _selectSurvey:(int)index
{
    [[DataManager shareDataManager] setSelectedSurveyIndex:index];
    [[SettingManager shareSettingManager] load];

    [self performSegueWithIdentifier:@"VoirDire" sender:self];
}

- (void) _deleteSurvey:(int)index
{
    [[DataManager shareDataManager] deleteMySurvey:index];
}

- (void) _getSurveyProperty:(int)index
{
    CaseInfo *caseInfo = [[DataManager shareDataManager].aryMySurveys objectAtIndex:index];
    
    if(caseInfo == nil)
    {
        caseInfo = [[CaseInfo alloc] init];
    }
    
    [self editSurveyProperty:caseInfo];
}

- (void)editSurveyProperty:(CaseInfo *)mySurvey
{
    if(self.viewNewSurvey == nil)
    {
        self.viewNewSurvey =  [[[NSBundle mainBundle] loadNibNamed:@"NewSurveyView" owner:self options:nil] objectAtIndex:0];
        self.viewNewSurvey.frame = CGRectMake(0, 0, self.viewNewSurvey.frame.size.width, self.viewNewSurvey.frame.size.height);
        self.viewNewSurvey.delegate = self;
        
        [self.view addSubview:self.viewNewSurvey];
    }
    
    self.viewNewSurvey.hidden = NO;
    
    [self.viewNewSurvey _init:mySurvey];
    [self.view bringSubviewToFront:self.viewNewSurvey];
}

#pragma mark SurveyViewDelegate

- (void) selectSurvey:(UIView *)view index:(int)index
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Case", @"Delete Case", nil];
    actionSheet.tag = index;
    
    [actionSheet showInView:self.view];
}

#pragma mark NewSurveyViewDelegate

- (void) addedNewSurvey:(UIView *)view survey:(CaseInfo *)survey
{
    self.viewNewSurvey.hidden = YES;
    
    [self reqAddNewSurvey:survey];
}

- (void) updateSurvey:(UIView *)view old:(CaseInfo *)oldSurvey new:(CaseInfo *)newSurvey
{
    self.viewNewSurvey.hidden = YES;
    
    [[DataManager shareDataManager] updateMySurvey:oldSurvey new:newSurvey];
    
    [self loadSurveys];
}

- (void) canceledNewSurvey:(UIView *)view
{
    self.viewNewSurvey.hidden = YES;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int index = (int)actionSheet.tag;
    
    switch (buttonIndex) {
            
        case 0:
            [self _getSurveyProperty:index];
            break;
            
        case 1:
            [self _deleteSurvey:index];
            break;
            
        default:
            break;
    }
}

@end
