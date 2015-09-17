//
//  JurorIndividualViewController.m
//  Jury
//
//  Created by wuyinsong on 14-1-21.
//  Copyright (c) 2014年 Alioth. All rights reserved.
//

#import "JurorIndividualViewController.h"

#import "DataManager.h"
#import "SettingManager.h"

#import "EditLocalJurorView.h"
#import "LocalJurorInfo.h"

#import "JurorResponseView.h"

#import "PersonalityProfileView.h"
#import "SumView.h"

#import "GroupInfo.h"
#import "QuestionInfo.h"

#import "EditQuestionView.h"
#import "NewGroupView.h"

#import "QuestionSettingView.h"

#import "OpenQuestionaireView.h"
#import "SaveQuestionaireView.h"

@interface JurorIndividualViewController ()<EditLocalJurorViewDelegate, JurorResponseViewDelegate, PersonalityProfileViewDelegate, SumViewDelegate,UIActionSheetDelegate, EditQuestionViewDelegate, NewGroupViewDelegate, OpenQuestionaireViewDelegate> {
    int _selectedGroup;
    int _activeGroup;
}

@property (nonatomic, assign) IBOutlet UIImageView *ivAvatar;

@property (nonatomic, assign) IBOutlet UIScrollView *svSymbol;

@property (nonatomic, assign) IBOutlet UIView *viewBackJuror;

@property (nonatomic, assign) IBOutlet UILabel *lblName;
@property (nonatomic, assign) IBOutlet UILabel *lblNumber;
@property (nonatomic, assign) IBOutlet UILabel *lblRate;
@property (nonatomic, assign) IBOutlet UILabel *lblOverride;

@property (nonatomic, assign) IBOutlet UILabel *lblOccupation;
@property (nonatomic, assign) IBOutlet UILabel *lblYears;
@property (nonatomic, assign) IBOutlet UILabel *lblEducation;

@property (nonatomic, assign) IBOutlet UILabel *lblStrike;

@property (nonatomic, assign) IBOutlet UITextView *tvNote;

@property (nonatomic, assign) IBOutlet UITextView *tvResponse;

@property (nonatomic, assign) IBOutlet UITextField *txtSearchKeyword;

@property (nonatomic, assign) IBOutlet UIView *viewAvatars;

@property (nonatomic, assign) IBOutlet UITableView *tvQuestions;

@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol1;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol2;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol3;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol4;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol5;

@property (nonatomic, assign) IBOutlet UILabel *lblPoliticalParty;

@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol1;
@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol2;
@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol3;
@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol4;

@property (nonatomic, assign) IBOutlet UILabel *lblFrivilousSymbol1;
@property (nonatomic, assign) IBOutlet UILabel *lblFrivilousSymbol2;

@property (nonatomic, retain) EditLocalJurorView *editLocalJurorView;
@property (nonatomic, retain) JurorResponseView *jurorResponseView;
@property (nonatomic, retain) PersonalityProfileView *personalityProfileView;
@property (nonatomic, retain) SumView *summaryView;
@property (nonatomic, assign) IBOutlet UITextField *txtSearchQuestions;
@property (nonatomic, retain) NSString *actionTID;

@property (nonatomic, assign) EditQuestionView *viewEditQuestion;
@property (nonatomic, assign) NewGroupView *viewNewGroup;

@property (nonatomic, assign) QuestionSettingView *viewQuestionSetting;

@property (nonatomic, assign) OpenQuestionaireView *openQuestionaireView;
@property (nonatomic, assign) SaveQuestionaireView *saveQuestionaireView;


- (IBAction)onEditJuror:(id)sender;
- (IBAction)onSummaryView:(id)sender;
- (IBAction)onPersonalityType:(id)sender;

- (IBAction)onSort:(id)sender;

- (IBAction)onShowAVatars:(id)sender;
- (IBAction)onSelectAvatar:(id)sender;

- (IBAction)onBack:(id)sender;

@end

@implementation JurorIndividualViewController

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
    
    [self _initLoad];
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

- (void) _initLoad
{
    self.viewAvatars.hidden = YES;
    
    [self _loadJurorInfo];
}

- (void) _loadJurorInfo
{
    LocalJurorInfo *localJurorInfo = [[DataManager shareDataManager] getLocalJuror:self.juror.tid];
    
    if(localJurorInfo != nil){
        self.lblName.text = localJurorInfo.name;
        self.lblNumber.text = localJurorInfo.personality;
        
        self.lblOccupation.text = localJurorInfo.occupation;
        self.lblYears.text = [NSString stringWithFormat:@"%d", localJurorInfo.age];
        self.lblEducation.text = localJurorInfo.education;
        self.lblRate.text = [NSString stringWithFormat:@"%@", [[DataManager shareDataManager] getJurorFinalCount:self.juror.tid]];
        self.lblOverride.text = localJurorInfo.overide;
        self.lblStrike.text = [NSString stringWithFormat:@"P%d-D%d-C%d", localJurorInfo.preperemptory, localJurorInfo.defence, localJurorInfo.cause];
        
        self.tvNote.text = localJurorInfo.note;
        
        self.ivAvatar.image = [UIImage imageNamed:[NSString stringWithFormat:@"avatar%d.jpg", localJurorInfo.avatarIndex]];
        
        UIColor *backgroundColor = [UIColor blackColor];
        if(self.juror.actionIndex == JA_ACCEPT)
        {
            backgroundColor = [UIColor colorWithRed:63.0f / 255.0f green:127.0f/ 255.0f blue:59.0f/ 255.0f alpha:1.0];
        }
        else if(self.juror.actionIndex == JA_CONSIDER)
        {
            backgroundColor = [UIColor colorWithRed:192.0f / 255.0f green:180.0f/ 255.0f blue:1.0f/ 255.0f alpha:1.0];
        }
        else if(self.juror.actionIndex == JA_DECLINE)
        {
            backgroundColor = [UIColor colorWithRed:133.0f / 255.0f green:32.0f/ 255.0f blue:25.0f/ 255.0f alpha:1.0];
        }
        else
        {
            backgroundColor = [UIColor blackColor];
        }
        
        self.viewBackJuror.backgroundColor = backgroundColor;
        
        UIColor *greenColor = [UIColor colorWithRed:63.0f / 255.0f green:127.0f/ 255.0f blue:59.0f/ 255.0f alpha:1.0];
        UIColor *redColor = [UIColor colorWithRed:133.0f / 255.0f green:32.0f/ 255.0f blue:25.0f/ 255.0f alpha:1.0];
        
        NSMutableArray *aryPersonalityProfileData = [[DataManager shareDataManager] getPersonalityProfileWithJuror:self.juror.tid];
        
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"Symbol for %d: %@", i, [[aryPersonalityProfileData objectAtIndex:i] objectForKey:@"symbol"]);
//        }
        
        if(aryPersonalityProfileData.count > 0)
        {
            NSString *symbol = [[aryPersonalityProfileData objectAtIndex:0] objectForKey:@"symbol"];
            self.lblPersonalitySymbol1.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
            self.lblPersonalitySymbol1.text = symbol;
        }
        if(aryPersonalityProfileData.count > 1)
        {
            NSString *symbol = [[aryPersonalityProfileData objectAtIndex:1] objectForKey:@"symbol"];
            self.lblPersonalitySymbol2.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
            self.lblPersonalitySymbol2.text = symbol;
        }
        if(aryPersonalityProfileData.count > 2)
        {
            NSString *symbol = [[aryPersonalityProfileData objectAtIndex:2] objectForKey:@"symbol"];
            self.lblPersonalitySymbol3.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
            self.lblPersonalitySymbol3.text = symbol;
        }
        if(aryPersonalityProfileData.count > 3)
        {
            NSString *symbol = [[aryPersonalityProfileData objectAtIndex:3] objectForKey:@"symbol"];
            self.lblPersonalitySymbol4.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
            self.lblPersonalitySymbol4.text = symbol;
        }
        if(aryPersonalityProfileData.count > 4)
        {
            NSString *symbol = [[aryPersonalityProfileData objectAtIndex:4] objectForKey:@"symbol"];
            self.lblPersonalitySymbol5.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
            self.lblPersonalitySymbol5.text = symbol;
        }
        
        NSString *politicalParty = [[DataManager shareDataManager] getPoliticalPartySymbol:self.juror.tid];
        
        if(politicalParty != nil && politicalParty.length > 0)
        {
            CGFloat weight = 0.0f;
            if([politicalParty isEqualToString:@"D"])
            {
                weight = [SettingManager shareSettingManager].valueDemocrat;
            }
            else if([politicalParty isEqualToString:@"R"])
            {
                weight = [SettingManager shareSettingManager].valueRepublican;
            }
            else
            {
                weight = [SettingManager shareSettingManager].valueIndependent;
            }
            
            self.lblPoliticalParty.text = politicalParty;
            self.lblPoliticalParty.backgroundColor = (weight > 0 ? greenColor : redColor );
        }
        
        NSMutableArray *aryCauseHardshipSymbols = [[DataManager shareDataManager] getCauseHardshipSymbol:self.juror.tid];
        if(aryCauseHardshipSymbols)
        {
            if(aryCauseHardshipSymbols.count > 0)
            {
                NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:0];
                CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
                
                self.lblCauseHardshipSymbol1.text = [dic objectForKey:@"symbol"];
                //self.lblCauseHardshipSymbol1.backgroundColor = (weight > 0 ? greenColor : redColor);
                if(weight > 0){
                    self.lblCauseHardshipSymbol1.backgroundColor = greenColor;
                }
                else if(weight < 0){
                    self.lblCauseHardshipSymbol1.backgroundColor = redColor;
                }
                else{
                    self.lblCauseHardshipSymbol1.backgroundColor = [UIColor blackColor];
                }
                
                UIButton *btn = [[UIButton alloc] initWithFrame:self.lblCauseHardshipSymbol1.frame];
                btn.titleLabel.text = @"";
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = [[dic objectForKeyedSubscript:@"qid"] integerValue];
                [btn addTarget:self action:@selector(click_symbol:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
            }
            if(aryCauseHardshipSymbols.count > 1)
            {
                NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:1];
                CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
                
                self.lblCauseHardshipSymbol2.text = [dic objectForKey:@"symbol"];
                //self.lblCauseHardshipSymbol2.backgroundColor = (weight > 0 ? greenColor : redColor);
                if(weight > 0){
                    self.lblCauseHardshipSymbol2.backgroundColor = greenColor;
                }
                else if(weight < 0){
                    self.lblCauseHardshipSymbol2.backgroundColor = redColor;
                }
                else{
                    self.lblCauseHardshipSymbol2.backgroundColor = [UIColor blackColor];
                }
                
                UIButton *btn = [[UIButton alloc] initWithFrame:self.lblCauseHardshipSymbol2.frame];
                btn.titleLabel.text = @"";
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = [[dic objectForKeyedSubscript:@"qid"] integerValue];
                [btn addTarget:self action:@selector(click_symbol:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
                
            }
            if(aryCauseHardshipSymbols.count > 2)
            {
                NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:2];
                CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
                
                self.lblCauseHardshipSymbol3.text = [dic objectForKey:@"symbol"];
                //self.lblCauseHardshipSymbol3.backgroundColor = (weight > 0 ? greenColor : redColor);
                if(weight > 0){
                    self.lblCauseHardshipSymbol3.backgroundColor = greenColor;
                }
                else if(weight < 0){
                    self.lblCauseHardshipSymbol3.backgroundColor = redColor;
                }
                else{
                    self.lblCauseHardshipSymbol3.backgroundColor = [UIColor blackColor];
                }
                UIButton *btn = [[UIButton alloc] initWithFrame:self.lblCauseHardshipSymbol3.frame];
                btn.titleLabel.text = @"";
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = [[dic objectForKeyedSubscript:@"qid"] integerValue];
                [btn addTarget:self action:@selector(click_symbol:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
            }
            if(aryCauseHardshipSymbols.count > 3)
            {
                NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:3];
                CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
                
                self.lblCauseHardshipSymbol4.text = [dic objectForKey:@"symbol"];
                //self.lblCauseHardshipSymbol4.backgroundColor = (weight > 0 ? greenColor : redColor);
                if(weight > 0){
                    self.lblCauseHardshipSymbol4.backgroundColor = greenColor;
                }
                else if(weight < 0){
                    self.lblCauseHardshipSymbol4.backgroundColor = redColor;
                }
                else{
                    self.lblCauseHardshipSymbol4.backgroundColor = [UIColor blackColor];
                }
                
                UIButton *btn = [[UIButton alloc] initWithFrame:self.lblCauseHardshipSymbol4.frame];
                btn.titleLabel.text = @"";
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = [[dic objectForKeyedSubscript:@"qid"] integerValue];
                [btn addTarget:self action:@selector(click_symbol:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
            }
        }
        
        NSMutableArray *aryFrivilousSymbols = [[DataManager shareDataManager] getFrivilousSymbol:self.juror.tid];
        if(aryFrivilousSymbols)
        {
            if(aryFrivilousSymbols.count > 0)
            {
                NSMutableDictionary *dic = [aryFrivilousSymbols objectAtIndex:0];
                CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
                
                self.lblFrivilousSymbol1.text = [dic objectForKey:@"symbol"];
                //self.lblFrivilousSymbol1.backgroundColor = (weight > 0 ? greenColor : redColor);
                if(weight > 0){
                    self.lblFrivilousSymbol1.backgroundColor = greenColor;
                }
                else if(weight < 0){
                    self.lblFrivilousSymbol1.backgroundColor = redColor;
                }
                else{
                    self.lblFrivilousSymbol1.backgroundColor = [UIColor blackColor];
                }
                UIButton *btn = [[UIButton alloc] initWithFrame:self.lblFrivilousSymbol1.frame];
                btn.titleLabel.text = @"";
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = [[dic objectForKeyedSubscript:@"qid"] integerValue];
                [btn addTarget:self action:@selector(click_symbol:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
            }
            if(aryFrivilousSymbols.count > 1)
            {
                NSMutableDictionary *dic = [aryFrivilousSymbols objectAtIndex:1];
                CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
                
                self.lblFrivilousSymbol2.text = [dic objectForKey:@"symbol"];
                //self.lblFrivilousSymbol2.backgroundColor = (weight > 0 ? greenColor : redColor);
                if(weight > 0){
                    self.lblFrivilousSymbol2.backgroundColor = greenColor;
                }
                else if(weight < 0){
                    self.lblFrivilousSymbol2.backgroundColor = redColor;
                }
                else{
                    self.lblFrivilousSymbol2.backgroundColor = [UIColor blackColor];
                }
                
                UIButton *btn = [[UIButton alloc] initWithFrame:self.lblFrivilousSymbol2.frame];
                btn.titleLabel.text = @"";
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = [[dic objectForKeyedSubscript:@"qid"] integerValue];
                [btn addTarget:self action:@selector(click_symbol:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
            }
        }
        
        UIView *symbolView = [self getSurveySymbolView_t:self.juror.tid];
        
        if(self.svSymbol.frame.size.width > symbolView.frame.size.width)
            symbolView.center = CGPointMake(self.svSymbol.frame.size.width / 2, self.svSymbol.frame.size.height / 2);
        
        [self.svSymbol addSubview:symbolView];
        self.svSymbol.contentSize = symbolView.frame.size;
        
        
    }
    
    [self.tvQuestions reloadData];
}

- (UIView *) getSurveySymbolView_t:(NSString *)jurorId
{
    int size = 26, inteval = 2;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, size)];
    view.backgroundColor = [UIColor clearColor];
    
    int symbolIndex = 0;
    //    for (NSDictionary *dic in self.aryJurorPersonalityProfileDatas) {
    //
    //        NSString *jurorId_ = [dic objectForKey:@"juror"];
    //
    //        if([jurorId_  isEqualToString:jurorId])
    //        {
    //            NSArray *personalDatas = [dic objectForKey:@"personal"];
    //
    //            for (NSDictionary *personalData in personalDatas) {
    //
    //                symbolIndex ++;
    //
    //                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((size + inteval) * (symbolIndex - 1), 0, 26, 26)];
    //                label.textAlignment = NSTextAlignmentCenter;
    //                label.text = [personalData objectForKey:@"symbol"];
    //                label.textColor = [UIColor whiteColor];
    //                label.font = [UIFont boldSystemFontOfSize:12];
    //
    //                label.backgroundColor = [UIColor greenColor];
    //
    //                [view addSubview:label];
    //                label = nil;
    //            }
    //
    //            break;
    //        }
    //    }
    
    for (QuestionInfo *localQuestion in [DataManager shareDataManager].aryLocalQuestions)
    {
        if(localQuestion.symbol.length == 0) continue;
        
        NSInteger weight = [[DataManager shareDataManager] getWeightValueOnResponseWithJuror:jurorId question:localQuestion.qid];
        
        if(weight == NSNotFound || [[DataManager shareDataManager] includesThisSymbolOnLeftOfJuror:jurorId symbol:localQuestion.symbol]) continue;
        
        symbolIndex ++;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((size + inteval) * (symbolIndex - 1), 0, 26, 26)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((size + inteval) * (symbolIndex - 1), 0, 26, 26)];
        btn.titleLabel.text = @"";
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = localQuestion.qid;
        [btn addTarget:self action:@selector(click_symbol:) forControlEvents:UIControlEventTouchUpInside];
        label.textAlignment = NSTextAlignmentCenter;
        
        // Change N% to the Questions number
        
        if([localQuestion.symbol isEqualToString:@"N%"]){
            label.text = @"25%";
            
            NSMutableDictionary *jurorResponse = [[DataManager shareDataManager].dicResponse objectForKey:jurorId];
            
            if(jurorResponse != nil){
                NSMutableDictionary *responseData = [jurorResponse objectForKey:[NSString stringWithFormat:@"%ld", localQuestion.qid]];
                label.text = [responseData objectForKey:@"response"];
            }
        }
        else{
            label.text = localQuestion.symbol;
        }
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        
        if(weight > 0)
        {
            label.backgroundColor = [UIColor colorWithRed:63.0f / 255.0f green:127.0f/ 255.0f blue:59.0f/ 255.0f alpha:1.0];
        }
        else if (weight < 0)
        {
            label.backgroundColor = [UIColor colorWithRed:133.0f / 255.0f green:32.0f/ 255.0f blue:25.0f/ 255.0f alpha:1.0];
        }
        else{
            label.backgroundColor = [UIColor colorWithRed:31.0f / 255.0f green:40.0f/ 255.0f blue:55.0f/ 255.0f alpha:1.0];
        }
        
        [view addSubview:label];
        [view addSubview:btn];
        label = nil;
    }
    
    view.frame = CGRectMake(0, 0, (size + inteval) * symbolIndex, size);
    
    return view;
}

- (void)click_symbol:(UIButton *)symbol {
    QuestionInfo *question = [[DataManager shareDataManager] getLocalQuestion:symbol.tag];
     [self showJurorResponseView:question];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Action to Open the Summary View
- (IBAction)onSummaryView:(id)sender {
    if(self.summaryView == nil){
        
        self.summaryView = [[[NSBundle mainBundle] loadNibNamed:@"SumView" owner:self options:nil] objectAtIndex:0];
        self.summaryView.delegate = self;
        self.summaryView.frame = CGRectMake(0, 0, self.summaryView.frame.size.width, self.summaryView.frame.size.height);
        //self.summaryView.delegate.jurorID = [self.juror name];
        LocalJurorInfo *localJurorInfo = [[DataManager shareDataManager] getLocalJuror:self.juror.tid];
        [self.summaryView _initWithJuror:localJurorInfo];
        
        [self.view addSubview:self.summaryView];
    }
    
    self.summaryView.hidden = NO;
    
}

#pragma mark NewGroupViewDelegate

- (void) doneNewGroup:(UIView *)view group:(GroupInfo *)group
{
    self.viewNewGroup.hidden = YES;
    
    [self reqAddGroup:group];
    
    [self loadQuestions];
}

- (void) doneEditGroup:(UIView *)view group:(GroupInfo *)group
{
    self.viewNewGroup.hidden = YES;
    
    [self reqEditGroup:group];
    
    [self loadQuestions];
}

- (void) cancelNewGroup:(UIView *)view
{
    self.viewNewGroup.hidden = YES;
}

- (void) reqAddGroup:(GroupInfo *)group
{
    [[DataManager shareDataManager] addNewGroup:group];
}


- (IBAction)onEditGroup:(id)sender
{
    _activeGroup = (int)((UIButton *)sender).tag;
    
    GroupInfo *group = [[DataManager shareDataManager].aryGroups objectAtIndex:_activeGroup];
    
    [self editGroup:group.groupId description:group.groupDesciption];
    
}

- (void) editGroup:(int)groupId description:(NSString *)description
{
    if(self.viewNewGroup == nil)
    {
        self.viewNewGroup =  [[[NSBundle mainBundle] loadNibNamed:@"NewGroupView" owner:self options:nil] objectAtIndex:0];
        self.viewNewGroup.frame = CGRectMake(0, 0, self.viewNewGroup.frame.size.width, self.viewNewGroup.frame.size.height);
        self.viewNewGroup.delegate = self;
        
        [self.view addSubview:self.viewNewGroup];
    }
    
    self.viewNewGroup.hidden = NO;
    
    [self.viewNewGroup _initWithId:groupId];
    [self.view bringSubviewToFront:self.viewNewGroup];
}

- (IBAction)onDeleteGroup:(id)sender
{
    _activeGroup = (int)((UIButton *)sender).tag;
    
    [self reqDeleteGroup:_activeGroup];
    
    [self loadQuestions];
}
- (void) reqEditGroup:(GroupInfo *)group
{
    [[DataManager shareDataManager] editGroup:group];
}

- (void) reqDeleteGroup:(int) groupIndex
{
    [[DataManager shareDataManager] deleteGroup:groupIndex];
}


- (IBAction)onAddQuestion:(id)sender
{
    _activeGroup = (int)((UIButton *)sender).tag;
    
    if(self.viewEditQuestion == nil)
    {
        self.viewEditQuestion =  [[[NSBundle mainBundle] loadNibNamed:@"EditQuestionView" owner:self options:nil] objectAtIndex:0];
        self.viewEditQuestion.frame = CGRectMake(0, 0, self.viewEditQuestion.frame.size.width, self.viewEditQuestion.frame.size.height);
        self.viewEditQuestion.delegate = self;
        
        [self.view addSubview:self.viewEditQuestion];
    }
    
    self.viewEditQuestion.hidden = NO;
    
    GroupInfo *group = [[DataManager shareDataManager] getGroupWithIndex:_activeGroup];
    
    [self.viewEditQuestion _initWithGroupId:(int)group.groupId];
    [self.view bringSubviewToFront:self.viewEditQuestion];
}

- (void) closeSummary:(UIView *)view
{
    self.summaryView.hidden = YES;
}


- (IBAction)onEditJuror:(id)sender
{
    if(self.editLocalJurorView == nil)
    {
        self.editLocalJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"EditLocalJurorView" owner:self options:nil] objectAtIndex:0];
        self.editLocalJurorView.frame = CGRectMake(0, 0, self.editLocalJurorView.frame.size.width, self.editLocalJurorView.frame.size.height);
        self.editLocalJurorView.delegate = self;
        
        
        [self.view addSubview:self.editLocalJurorView];
    }
    
    self.editLocalJurorView.hidden = NO;
    
    LocalJurorInfo *localJurorInfo = [[DataManager shareDataManager] getLocalJuror:self.juror.tid];
    
    if(localJurorInfo)
    {
        [self.editLocalJurorView _initWithJuror:localJurorInfo];
    }
    else
    {
        [self.editLocalJurorView _initWithTID:self.juror.tid];
    }
    
    [self.view bringSubviewToFront:self.editLocalJurorView];
}

- (IBAction)onPersonalityType:(id)sender
{
    if(self.personalityProfileView == nil)
    {
        self.personalityProfileView =  [[[NSBundle mainBundle] loadNibNamed:@"PersonalityProfileView" owner:self options:nil] objectAtIndex:0];
        self.personalityProfileView.frame = CGRectMake(0, 0, self.personalityProfileView.frame.size.width, self.personalityProfileView.frame.size.height);
        self.personalityProfileView.delegate = self;
        
        [self.view addSubview:self.personalityProfileView];
        
    }
    
    self.personalityProfileView.hidden = NO;
    
    NSMutableArray *personalData = [[DataManager shareDataManager] getPersonalityProfileWithJuror:self.juror.tid];
    
    [self.personalityProfileView _initWithPersonalData:personalData];
    [self.view bringSubviewToFront:self.personalityProfileView];
}

- (IBAction)onSort:(id)sender
{
    
}

- (IBAction)onShowAVatars:(id)sender
{
    self.viewAvatars.hidden = NO;
}

- (IBAction)onSelectAvatar:(id)sender
{
    int index = (int)((UIButton *)sender).tag;
    
    self.ivAvatar.image = [UIImage imageNamed:[NSString stringWithFormat:@"avatar%d.jpg", index]];
    
    [[DataManager shareDataManager] updateLocalJurorWithAvatar:index tid:self.juror.tid];
    
    self.viewAvatars.hidden = YES;
}

- (IBAction)onSelectGroup:(id)sender
{
    _selectedGroup = (int)((UIButton *)sender).tag;
    
    [self loadQuestions];
}

- (void) loadQuestions
{
    [self.tvQuestions reloadData];
}

- (void) animationView:(BOOL)up
{
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         self.view.frame = CGRectMake(self.view.frame.origin.x, up ? -340 : 0, self.view.frame.size.width, self.view.frame.size.height);
                         
                     } completion:NULL];
}

- (void) showJurorResponseView:(QuestionInfo *)question
{
    if(self.jurorResponseView == nil)
    {
        self.jurorResponseView =  [[[NSBundle mainBundle] loadNibNamed:@"JurorResponseView" owner:self options:nil] objectAtIndex:0];
        self.jurorResponseView.frame = CGRectMake(0, 0, self.jurorResponseView.frame.size.width, self.jurorResponseView.frame.size.height);
        self.jurorResponseView.delegate = self;
        
        [self.view addSubview:self.jurorResponseView];
        
    }
    
    self.jurorResponseView.hidden = NO;
    
    [self.jurorResponseView _init:self.juror question:question];
    [self.view bringSubviewToFront:self.jurorResponseView];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView == self.tvNote)
    {
        [self animationView:YES];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView == self.tvNote)
    {
        [self animationView:NO];
        
        [[DataManager shareDataManager] updateLocalJurorWithNote:self.tvNote.text tid:self.juror.tid replace:YES];
    }
    
    return YES;
}

#pragma mark EditLocalJurorViewDelegate

- (void) onDoneEditLocalJuror:(UIView *)view juror:(LocalJurorInfo *)juror
{
    self.editLocalJurorView.hidden = YES;
    
    [[DataManager shareDataManager] addLocalJuror:juror];
    
    [self _loadJurorInfo];
}

- (void) onCancelEditLocalJuror:(UIView *)view
{
    self.editLocalJurorView.hidden = YES;
}

#pragma mark JurorResponseViewDelegate

- (void) cancelJurorResponse
{
    [self.tvQuestions reloadData];
}

- (void) doneJurorResponse:(NSString *)tid response:(NSString *)response
{
    [self _loadJurorInfo];
}

#pragma mark - Table view data source

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return [DataManager shareDataManager].aryLocalQuestions.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//        //cell.frame = CGRectMake(0, 0, self.tvQuestions.frame.size.width, self.tvQuestions.frame.size.height);
//        
//        UILabel *lblQuestion = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tvQuestions.frame.size.width - 80, 40)];
//        lblQuestion.tag = 100;
//        lblQuestion.numberOfLines = 3;
//        lblQuestion.adjustsFontSizeToFitWidth = YES;
//        lblQuestion.font = [UIFont boldSystemFontOfSize:16];
//        lblQuestion.textColor = [UIColor blackColor];
//        lblQuestion.backgroundColor = [UIColor clearColor];
//        
//        [cell addSubview:lblQuestion];
//        
//        UILabel *lblAnswer = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.tvQuestions.frame.size.width - 80, 40)];
//        lblAnswer.tag = 101;
//        lblQuestion.numberOfLines = 2;
//        lblQuestion.adjustsFontSizeToFitWidth = YES;
//        lblAnswer.font = [UIFont systemFontOfSize:15];
//        lblAnswer.textColor = [UIColor blackColor];
//        lblAnswer.backgroundColor = [UIColor clearColor];
//        
//        [cell addSubview:lblAnswer];
//        
//        UILabel *lblWeight = [[UILabel alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 60, 0, 60, 80)];
//        lblWeight.tag = 102;
//        lblWeight.font = [UIFont systemFontOfSize:18];
//        lblWeight.textAlignment = NSTextAlignmentCenter;
//        lblWeight.textColor = [UIColor blackColor];
//        lblWeight.backgroundColor = [UIColor clearColor];
//        
//        [cell addSubview:lblWeight];
//    }
//    
//    QuestionInfo *question = [[DataManager shareDataManager].aryLocalQuestions objectAtIndex:indexPath.row];
//    
//    UILabel *lblQuestion = (UILabel *)[cell viewWithTag:100];
//    lblQuestion.text = question.question;
//    
//    NSMutableDictionary *responseData = [[DataManager shareDataManager] getResponseWithJuror:self.juror.tid question:question];
//    
//    UILabel *lblAnswer = (UILabel *)[cell viewWithTag:101];
//    lblAnswer.text = [responseData objectForKey:@"response"];
//    
//    UILabel *lblWeight = (UILabel *)[cell viewWithTag:102];
//    lblWeight.text = [NSString stringWithFormat:@"%d", (int)[[responseData objectForKey:@"weight"] floatValue]];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    QuestionInfo *question = [[DataManager shareDataManager].aryLocalQuestions objectAtIndex:indexPath.row];
//    
//    [self showJurorResponseView:question];
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [DataManager shareDataManager].aryGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section != _selectedGroup)
        return 0;
    
    GroupInfo *group = [[DataManager shareDataManager].aryGroups objectAtIndex:section];
    
    int count = 0;
    for (QuestionInfo *question in [DataManager shareDataManager].aryLocalQuestions)
    {
        if(group.groupId == question.groupId)
        {
            NSString *searchKey = self.txtSearchQuestions.text;
            NSString *questionContent = question.question;
            
            if(searchKey.length > 0)
            {
                NSRange range = [questionContent rangeOfString:searchKey];
                if(range.location < questionContent.length)
                {
                    count ++;
                }
            }
            else
                count ++;
        }
    }
    
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDictionary *group = [[DataManager shareDataManager].aryGroups objectAtIndex:section];
//
//    return [group objectForKey:@"group_name"];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GroupInfo *group = [[DataManager shareDataManager].aryGroups objectAtIndex:section];
    
    int count = 0;
    for (QuestionInfo *question in [DataManager shareDataManager].aryLocalQuestions)
    {
        if(group.groupId == question.groupId)
        {
            NSString *searchKey = self.txtSearchQuestions.text;
            NSString *questionContent = question.question;
            
            if(searchKey.length > 0)
            {
                NSRange range = [questionContent rangeOfString:searchKey];
                if(range.location < questionContent.length)
                {
                    count ++;
                }
            }
            else
                count ++;
        }
    }
    
    NSString *groupTitle = group.groupTitle;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tvQuestions.frame.size.width, 60)];
    float color = (230.0f - (float)48.0f * (float)section / (float)[DataManager shareDataManager].aryGroups.count) / 255.0f;
    view.backgroundColor = [UIColor colorWithRed:color green:color blue:color alpha:1.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 60)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = (section == _selectedGroup ? [UIImage imageNamed:@"question_image_arrowDown"] : [UIImage imageNamed:@"question_image_arrowRight"]);
    
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 60)];
    
    //    if(section != _selectedGroup)
    //    {
    //        label.text = groupTitle;
    //
    //        UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 100, 0, 100, 60)];
    //        labelCount.textAlignment = NSTextAlignmentCenter;
    //        labelCount.textColor = [UIColor blackColor];
    //        labelCount.backgroundColor = [UIColor clearColor];
    //
    //        labelCount.text = [NSString stringWithFormat:@"%d", count];
    //
    //        [view addSubview:labelCount];
    //    }
    //    else
    {
        label.text = [NSString stringWithFormat:@"%@ (%d)", groupTitle, count];
    }
    
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tvQuestions.frame.size.width, 60)];
    button.tag = section;
    [button addTarget:self action:@selector(onSelectGroup:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    
    [view addSubview:button];
    
    //if(section == _selectedGroup)
    {
        UIButton *buttonAddQuestion = [[UIButton alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 320, 0, 130, 60)];
        buttonAddQuestion.tag = section;
        [buttonAddQuestion setTitle:@"Add Question - " forState:UIControlStateNormal];
        [buttonAddQuestion setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonAddQuestion setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [buttonAddQuestion addTarget:self action:@selector(onAddQuestion:) forControlEvents:UIControlEventTouchUpInside];
        buttonAddQuestion.backgroundColor = [UIColor clearColor];
        
//        [view addSubview:buttonAddQuestion];
        
        UIButton *buttonEdit = [[UIButton alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 190, 0, 50, 60)];
        buttonEdit.tag = section;
        [buttonEdit setTitle:@"Edit - " forState:UIControlStateNormal];
        [buttonEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonEdit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [buttonEdit addTarget:self action:@selector(onEditGroup:) forControlEvents:UIControlEventTouchUpInside];
        buttonEdit.backgroundColor = [UIColor clearColor];
        
//        [view addSubview:buttonEdit];
        
        UIButton *buttonDelete = [[UIButton alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 144, 0, 60, 60)];
        buttonDelete.tag = section;
        [buttonDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [buttonDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonDelete setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [buttonDelete addTarget:self action:@selector(onDeleteGroup:) forControlEvents:UIControlEventTouchUpInside];
        buttonDelete.backgroundColor = [UIColor clearColor];
        
//        [view addSubview:buttonDelete];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *lblQuestion = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tvQuestions.frame.size.width - 80, 40)];
        lblQuestion.tag = 100;
        lblQuestion.numberOfLines = 3;
        lblQuestion.adjustsFontSizeToFitWidth = YES;
        lblQuestion.font = [UIFont boldSystemFontOfSize:16];
        lblQuestion.textColor = [UIColor blackColor];
        lblQuestion.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:lblQuestion];
        
        UILabel *lblAnswer = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.tvQuestions.frame.size.width - 80, 40)];
        lblAnswer.tag = 101;
        lblQuestion.numberOfLines = 2;
        lblQuestion.adjustsFontSizeToFitWidth = YES;
        lblAnswer.font = [UIFont systemFontOfSize:15];
        lblAnswer.textColor = [UIColor blackColor];
        lblAnswer.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:lblAnswer];
        
        UILabel *lblWeight = [[UILabel alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 60, 0, 60, 80)];
        lblWeight.tag = 102;
        lblWeight.font = [UIFont systemFontOfSize:18];
        lblWeight.textAlignment = NSTextAlignmentCenter;
        lblWeight.textColor = [UIColor blackColor];
        lblWeight.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:lblWeight];

    }
    
    GroupInfo *group = [[DataManager shareDataManager].aryGroups objectAtIndex:indexPath.section];
    
    int count = 0; QuestionInfo *question = nil;
    for (question in [DataManager shareDataManager].aryLocalQuestions)
    {
        if(group.groupId == question.groupId)
        {
            NSString *searchKey = self.txtSearchQuestions.text;
            NSString *questionContent = question.question;
            
            if(searchKey.length > 0)
            {
                NSRange range = [questionContent rangeOfString:searchKey];
                if(range.location < questionContent.length)
                {
                    count ++;
                }
            }
            else
                count ++;
        }
        
        if(count == indexPath.row + 1)
            break;
    }
    
    
    UILabel *lblQuestion = (UILabel *)[cell viewWithTag:100];
    lblQuestion.text = question.question;
    
    NSMutableDictionary *responseData = [[DataManager shareDataManager] getResponseWithJuror:self.juror.tid question:question];
    
    UILabel *lblAnswer = (UILabel *)[cell viewWithTag:101];
    lblAnswer.text = [responseData objectForKey:@"response"];
    
    UILabel *lblWeight = (UILabel *)[cell viewWithTag:102];
    lblWeight.text = [NSString stringWithFormat:@"%d", (int)[[responseData objectForKey:@"weight"] floatValue]];

//    cell.textLabel.text = question.question;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onDeleteQuestion:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = indexPath.row;
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"question_image_delete"] forState:UIControlStateNormal];
    
//    cell.accessoryView = button;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (IBAction)onDeleteQuestion:(id)sender
{
    int questionIndex = (int)((UIButton *)sender).tag;
    
    GroupInfo *group = [[DataManager shareDataManager].aryGroups objectAtIndex:_selectedGroup];
    
    [self reqDeleteQuestion:(int)group.groupId index:questionIndex];
    
    [self.tvQuestions reloadData];
}

- (void) reqDeleteQuestion:(int)groupId index:(int)index
{
    [[DataManager shareDataManager] deleteQuestion:groupId index:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfo *group = [[DataManager shareDataManager].aryGroups objectAtIndex:indexPath.section];
    
    int count = 0; QuestionInfo *question = nil;
    for (question in [DataManager shareDataManager].aryLocalQuestions)
    {
        if(group.groupId == question.groupId)
        {
            NSString *searchKey = self.txtSearchQuestions.text;
            NSString *questionContent = question.question;
            
            if(searchKey.length > 0)
            {
                NSRange range = [questionContent rangeOfString:searchKey];
                if(range.location < questionContent.length)
                {
                    count ++;
                }
            }
            else
                count ++;
        }
        
        if(count == indexPath.row + 1)
            break;
    }
//    QuestionInfo *question = [[DataManager shareDataManager].aryLocalQuestions objectAtIndex:indexPath.row];
    
    [self showJurorResponseView:question];
//    [self editQuestion:question];
}

- (void) editQuestion:(QuestionInfo *)question
{
    if(self.viewEditQuestion == nil)
    {
        self.viewEditQuestion =  [[[NSBundle mainBundle] loadNibNamed:@"EditQuestionView" owner:self options:nil] objectAtIndex:0];
        self.viewEditQuestion.frame = CGRectMake(0, 0, self.viewEditQuestion.frame.size.width, self.viewEditQuestion.frame.size.height);
        self.viewEditQuestion.delegate = self;
        
        [self.view addSubview:self.viewEditQuestion];
    }
    
    self.viewEditQuestion.hidden = NO;
    
    [self.viewEditQuestion _initWithQuestion:question];
    [self.view bringSubviewToFront:self.viewEditQuestion];
}

#pragma mark EditQuestionViewDelegate

- (void) doneNewQuestion:(UIView *)view question:(QuestionInfo *)question
{
    self.viewEditQuestion.hidden = YES;
    
    [[DataManager shareDataManager] addQuestion:question];
    
    [self loadQuestions];
}

- (void) doneEditQuestion:(UIView *)view question:(QuestionInfo *)question
{
    self.viewEditQuestion.hidden = YES;
    
    [[DataManager shareDataManager] addQuestion:question];
    
    [self loadQuestions];
}

- (void) cancelEditQuestion:(UIView *)view
{
    self.viewEditQuestion.hidden = YES;
}
#pragma mark PersonalityProfileViewDelegate

- (void) onCancelPersonalityProfile
{
    self.personalityProfileView.hidden = YES;
}

- (void) onDonePersonalityProfile:(NSMutableArray *)aryPersonalData
{
    [[DataManager shareDataManager] updatePersonalityProfileWithJuror:self.juror.tid personalityData:aryPersonalData];
    
    self.personalityProfileView.hidden = YES;
    
    [self _loadJurorInfo];
}

- (IBAction)changeTop:(id)sender {
    NSLog(@"In the event");
    self.actionTID = [[NSString alloc] initWithFormat:@"%@", _juror.tid];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Accept", @"Consider", @"Decline", @"Neutral", nil];
    actionSheet.tag = 1;
    
    [actionSheet showInView:self.view];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1)
    {
        if(buttonIndex == 0)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_ACCEPT tid:self.juror.tid];
        }
        else if(buttonIndex == 1)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_CONSIDER tid:self.juror.tid];
        }
        else if(buttonIndex == 2)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_DECLINE tid:self.juror.tid];
        }
        else if(buttonIndex == 3)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_NEUTRAL tid:self.juror.tid];
        }
        
        [self _loadJurorInfo];
    }
}


@end
