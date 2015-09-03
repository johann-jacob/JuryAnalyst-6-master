//
//  VoirDireViewController.m
//  Jury
//
//  Created by wuyinsong on 14-1-27.
//  Copyright (c) 2014年 Alioth. All rights reserved.
//

#import "VoirDireViewController.h"

#import "JurorIndividualViewController.h"

#import "DataManager.h"

#import "JurorBigView.h"
#import "JurorSmallView.h"

#import "LocalJurorInfo.h"

#import "EditLocalJurorView.h"

#import "SortView.h"

#import "QuestionInfo.h"

#import "EditQuestionView.h"
#import "JurorResponseView.h"


@interface VoirDireViewController ()<JurorBigViewDelegate, JurorSmallViewDelegate, SortViewDelegate, EditQuestionViewDelegate, JurorResponseViewDelegate, EditLocalJurorViewDelegate, UIActionSheetDelegate>
{
    BOOL _isAskingNow;
}

- (IBAction)onQuestions:(id)sender;
- (IBAction)onJurors:(id)sender;

- (IBAction)onAskNow:(id)sender;
- (IBAction)onAskDone:(id)sender;
- (IBAction)onAskAnother:(id)sender;

- (IBAction)onSort:(id)sender;

- (IBAction)onChangedKeyword:(id)sender;

@property (nonatomic, assign) IBOutlet UITextField *txtKeyword;

@property (nonatomic, assign) IBOutlet UIScrollView *svMainJurors;
@property (nonatomic, assign) IBOutlet UIScrollView *svSelectedJurors;

@property (nonatomic, assign) IBOutlet UILabel *lblStrikeLabel;

@property (nonatomic, assign) IBOutlet UIButton *btnAskDone;
@property (nonatomic, assign) IBOutlet UIButton *btnAskAnother;

@property (nonatomic, assign) IBOutlet UILabel *lblQuestion;

@property (nonatomic, retain) UIImageView *ivMovable;
@property (nonatomic, retain) UIImageView *ivMoveoutable;

@property (nonatomic, retain) NSString *strikeTID;
@property (nonatomic, retain) NSString *actionTID;

@property (nonatomic, assign) SortView *sortView;

@property (nonatomic, assign) EditQuestionView *questionView;
@property (nonatomic, assign) JurorResponseView *responseView;

@property (nonatomic, assign) EditLocalJurorView *editJurorView;

@property (nonatomic, retain) NSMutableArray *arySortedJorursByName;

@property (nonatomic, retain) NSMutableArray *aryJurorInformations;

@property (nonatomic, retain) NSString *askerName;
@property (nonatomic, retain) QuestionInfo *askQuestion;

- (IBAction)onBack:(id)sender;

@end

@implementation VoirDireViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"JurorIndividual"])
    {
        JurorIndividualViewController *jurorIndividualViewController = segue.destinationViewController;
        jurorIndividualViewController.juror = sender;
    }
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
    
    _isAskingNow = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.btnAskDone.hidden = !_isAskingNow;
    self.btnAskAnother.hidden = !_isAskingNow;
    self.lblQuestion.hidden = !_isAskingNow;
    
    if(_isAskingNow && self.askQuestion != nil)
    {
        self.lblQuestion.text = self.askQuestion.question;
    }
    
    [self loadJurors];
}

- (void) loadJurors
{
    if([DataManager shareDataManager].sortOption == SORT_ALPAH)
    {
        [self getSortedJurorsByName];
    }
    
    [self loadMainJurors];
    [self loadSelectedJurors];
    
    [self showStrikeCounts];
}

- (void) getSortedJurorsByName{
    
    if(self.arySortedJorursByName == nil)
    {
        self.arySortedJorursByName = [[NSMutableArray alloc] init];
    }
    
    [self.arySortedJorursByName removeAllObjects];
    
    NSArray *arySorted = [[DataManager shareDataManager].aryLocalJurors sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
//        NSString *lastName1 = [[((LocalJurorInfo *)obj1).name componentsSeparatedByString:@" "] objectAtIndex:1];
//        NSString *lastName2 = [[((LocalJurorInfo *)obj2).name componentsSeparatedByString:@" "] objectAtIndex:1];
        
        NSString *lastName1 = ((LocalJurorInfo *)obj1).name;
        NSString *lastName2 = ((LocalJurorInfo *)obj2).name;
        
        return [lastName1 compare:lastName2];
    }];
    
    for (id object in arySorted) {
        
        [self.arySortedJorursByName addObject:object];
        
    }
}

- (void) showStrikeCounts
{
    NSMutableArray *aryJurors = [DataManager shareDataManager].aryLocalJurors;
    
    int pCount = 0, dCount = 0, sCount = 0;
    for (LocalJurorInfo *juror in aryJurors) {
        
        pCount += juror.preperemptory;
        dCount += juror.defence;
        sCount += juror.cause;
    }
    
    self.lblStrikeLabel.text = [NSString stringWithFormat:@"P%d-D%d-C%d", pCount, dCount, sCount];
}

- (void) loadMainJurors
{
    for (UIView *subview in self.svMainJurors.subviews) {
        
        if(subview.tag != 1000) [subview removeFromSuperview];
    }
    
    NSString *keyword = self.txtKeyword.text;
    
    NSMutableArray *aryJurors = nil;
    
    if([DataManager shareDataManager].sortOption == SORT_ALPAH)
        aryJurors = self.arySortedJorursByName;
    else
        aryJurors = [DataManager shareDataManager].aryLocalJurors;
    
    int index = 0;
    for (LocalJurorInfo *juror in aryJurors) {
        
        BOOL isSelectedJuror = [[DataManager shareDataManager] isSelectedJuror:juror.tid];
        
        if(isSelectedJuror)
            continue;
        
        if([DataManager shareDataManager].sortJurorNumbers != nil)
        {
            if(![[DataManager shareDataManager].sortJurorNumbers containsObject:juror.personality])
                continue;
        }
        
        if(![DataManager shareDataManager].showWithoutStrike)
        {
            if(juror.preperemptory == 0 && juror.cause == 0 && juror.defence == 0)
            {
                continue;
            }
            else
            {
                if(![DataManager shareDataManager].showWithCauseStrike && juror.cause > 0)
                    continue;
                
                if(![DataManager shareDataManager].showWithHardStrike && juror.defence > 0)
                    continue;
                
                if(![DataManager shareDataManager].showWithPreemptStrike && juror.preperemptory > 0)
                    continue;
            }
        }
        else
        {
            if(![DataManager shareDataManager].showWithCauseStrike && juror.cause > 0)
                continue;
            
            if(![DataManager shareDataManager].showWithHardStrike && juror.defence > 0)
                continue;
            
            if(![DataManager shareDataManager].showWithPreemptStrike && juror.preperemptory > 0)
                continue;
        }
        
        if(keyword.length > 0)
        {
            keyword = [keyword lowercaseString];
            
            NSRange rangeName = [[juror.name lowercaseString] rangeOfString:keyword];
            //NSRange rangeNote = [[juror.note lowercaseString] rangeOfString:keyword];
            NSRange rangeNumber = [[juror.personality lowercaseString] rangeOfString:keyword];
            
            if(rangeName.location >= juror.name.length /*&& rangeNote.location >= juror.note.length*/ && rangeNumber.location >= juror.personality.length)
            {
                continue;
            }
        }
        
        JurorBigView *mainJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"JurorBigView" owner:self options:nil] objectAtIndex:0];
        mainJurorView.tag = 10000 + index;
        mainJurorView.viewTop.tag = 10000 + index;
        mainJurorView.frame = CGRectMake((index / 2) * (mainJurorView.frame.size.width + 20), (index % 2) * (mainJurorView.frame.size.height + 20), mainJurorView.frame.size.width, mainJurorView.frame.size.height);
        mainJurorView.delegate = self;
        
        [mainJurorView setLocalJurorInfo:juror];
        
        [self.svMainJurors addSubview:mainJurorView];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveHandle:)];
        [mainJurorView.viewTop addGestureRecognizer:panGestureRecognizer];
        panGestureRecognizer = nil;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJuror:)];
        [mainJurorView addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer = nil;
        
        index ++;
    }
    
    self.svMainJurors.contentSize = CGSizeMake(((index - 1) / 2 + 1) * (190 + 20), self.svMainJurors.frame.size.height);
}

- (void) loadSelectedJurors
{
    for (UIView *subview in self.svSelectedJurors.subviews) {
        if(subview.tag != 1001) [subview removeFromSuperview];
    }
    
//    NSString *keyword = self.txtKeyword.text;
    
    NSMutableArray *aryJurors = [DataManager shareDataManager].arySelectedJurors;
    
    int index = 0;
    for (LocalJurorInfo *juror in aryJurors) {
        
        LocalJurorInfo *localJuror = [[DataManager shareDataManager] getLocalJuror:juror.tid];
        
//        if(localJuror)
//        {
//            if(![DataManager shareDataManager].showWithoutStrike)
//            {
//                if(juror.preperemptory == 0 && juror.cause == 0 && localJuror.defence == 0)
//                {
//                    continue;
//                }
//                else
//                {
//                    if(![DataManager shareDataManager].showWithCauseStrike && localJuror.cause > 0)
//                        continue;
//                    
//                    if(![DataManager shareDataManager].showWithHardStrike && localJuror.defence > 0)
//                        continue;
//                    
//                    if(![DataManager shareDataManager].showWithPreemptStrike && localJuror.preperemptory > 0)
//                        continue;
//                }
//            }
//            else
//            {
//                if(![DataManager shareDataManager].showWithCauseStrike && localJuror.cause > 0)
//                    continue;
//                
//                if(![DataManager shareDataManager].showWithHardStrike && localJuror.defence > 0)
//                    continue;
//                
//                if(![DataManager shareDataManager].showWithPreemptStrike && localJuror.preperemptory > 0)
//                    continue;
//            }
//        }
//        
//        if(keyword.length > 0)
//        {
//             NSRange range = [localJuror.name rangeOfString:keyword];
//            if(range.location >= localJuror.name.length)
//            {
//                continue;
//            }
//        }
        
        JurorSmallView *smallJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"JurorSmallView" owner:self options:nil] objectAtIndex:0];
        smallJurorView.tag = 50000 + index;
        smallJurorView.viewTop.tag = 50000 + index;
        smallJurorView.frame = CGRectMake(index * (smallJurorView.frame.size.width + 20), 0 , smallJurorView.frame.size.width, smallJurorView.frame.size.height);
        smallJurorView.delegate = self;
        
        if(localJuror == nil)
            [smallJurorView setLocalJurorInfo:juror];
        else
        {
            [smallJurorView setLocalJurorInfo:localJuror];
        }
        
        [self.svSelectedJurors addSubview:smallJurorView];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOutHandle:)];
        [smallJurorView.viewTop addGestureRecognizer:panGestureRecognizer];
        panGestureRecognizer = nil;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJuror:)];
        [smallJurorView addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer = nil;
        
        index ++;
    }
    
    self.svSelectedJurors.contentSize = CGSizeMake(index * (150 + 20), self.svSelectedJurors.frame.size.height);
}

- (IBAction)onQuestions:(id)sender
{
    [self performSegueWithIdentifier:@"Question" sender:nil];
}

- (IBAction)onJurors:(id)sender
{
    //[self performSegueWithIdentifier:@"Juror" sender:nil];
    
    if(self.editJurorView == nil)
    {
        self.editJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"EditLocalJurorView" owner:self options:nil] objectAtIndex:0];
        self.editJurorView.frame = CGRectMake(0, 0, self.editJurorView.frame.size.width, self.editJurorView.frame.size.height);
        self.editJurorView.delegate = self;
        
        [self.view addSubview:self.editJurorView];
    }
    
    self.editJurorView.hidden = NO;
    
    [self.editJurorView _init];
    [self.view bringSubviewToFront:self.editJurorView];
}

- (IBAction)onAskNow:(id)sender
{
    //[self performSegueWithIdentifier:@"Ask" sender:nil];
    
    if([DataManager shareDataManager].aryGroups.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You need to add Jurors before you can ask questions." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    _isAskingNow = YES;
    
    self.btnAskDone.hidden = NO;
    self.btnAskAnother.hidden = NO;
    
    [self showQuestionView];
}

- (IBAction)onAskDone:(id)sender
{
    _isAskingNow = NO;
    
    self.btnAskDone.hidden = YES;
    self.btnAskAnother.hidden = YES;
    self.lblQuestion.hidden = YES;
}

- (IBAction)onAskAnother:(id)sender
{
    if([DataManager shareDataManager].aryGroups.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no any group for new question." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    [self showQuestionView];
}

- (void) showQuestionView
{
    if(self.questionView == nil)
    {
        self.questionView =  [[[NSBundle mainBundle] loadNibNamed:@"EditQuestionView" owner:self options:nil] objectAtIndex:0];
        self.questionView.frame = CGRectMake(0, 0, self.questionView.frame.size.width, self.questionView.frame.size.height);
        self.questionView.delegate = self;
        
        [self.questionView _init];
        
        [self.view addSubview:self.questionView];
    }
    
    [self.questionView _init];
    self.questionView.hidden = NO;
    
    [self.view bringSubviewToFront:self.questionView];
}

- (void) showResponseView:(NSString *)tid
{
    if(self.responseView == nil)
    {
        self.responseView =  [[[NSBundle mainBundle] loadNibNamed:@"JurorResponseView" owner:self options:nil] objectAtIndex:0];
        self.responseView.frame = CGRectMake(0, 0, self.responseView.frame.size.width, self.responseView.frame.size.height);
        self.responseView.delegate = self;
        
        [self.responseView _init];
        
        [self.view addSubview:self.responseView];
    }
    
    LocalJurorInfo *juror = [[DataManager shareDataManager] getLocalJuror:tid];
    QuestionInfo *question = [[DataManager shareDataManager] getLocalQuestion:self.askQuestion.qid];
    
    [self.responseView _init:juror question:question];
    self.responseView.hidden = NO;
    
    [self.view bringSubviewToFront:self.responseView];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSort:(id)sender
{
    if(self.sortView == nil)
    {
        self.sortView =  [[[NSBundle mainBundle] loadNibNamed:@"SortView" owner:self options:nil] objectAtIndex:0];
        self.sortView.frame = CGRectMake(0, 0, self.sortView.frame.size.width, self.sortView.frame.size.height);
        self.sortView.delegate = self;
        
        [self.sortView _init];
        
        [self.view addSubview:self.sortView];
    }
    
    [self.sortView _init];
    self.sortView.hidden = NO;

    [self.view bringSubviewToFront:self.sortView];
}

- (IBAction)onChangedKeyword:(id)sender
{
     [self loadJurors];
}

- (UIImage *)getViewImage:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (void) tapJuror:(UITapGestureRecognizer *)gesture
{
    JurorBigView *jurorBigView = (JurorBigView *)gesture.view;
    LocalJurorInfo *juror = jurorBigView.juror;
    
    if(_isAskingNow)
    {
        [self showResponseView:juror.tid];
    }
    else
    {
        CGPoint point = [gesture locationInView:jurorBigView];
        
        if(point.y > 42)
        {
            [self performSegueWithIdentifier:@"JurorIndividual" sender:juror];
        }
        else
        {
            self.actionTID = [[NSString alloc] initWithFormat:@"%@", juror.tid];
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Accept", @"Consider", @"Decline", nil];
            actionSheet.tag = 1;
            
            [actionSheet showInView:self.view];
        }
    }
}

- (void) moveHandle:(UIPanGestureRecognizer *)gesture
{
    JurorBigView *jurorBigView = (JurorBigView *)[self.svMainJurors viewWithTag:gesture.view.tag];
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(self.ivMovable == nil)
        {
            self.ivMovable = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, jurorBigView.frame.size.width, jurorBigView.frame.size.height)];
            self.ivMovable.tag = 1000;
            self.ivMovable.alpha = 0.5f;
            
            [self.svMainJurors addSubview:self.ivMovable];
        }
        
        self.ivMovable.image = [self getViewImage:jurorBigView];
        self.ivMovable.frame = CGRectMake(0, 0, jurorBigView.frame.size.width, jurorBigView.frame.size.height);
        
        self.ivMovable.hidden = NO;
        [self.svMainJurors bringSubviewToFront:self.ivMovable];
        [self.view bringSubviewToFront:self.svMainJurors];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gesture translationInView:jurorBigView];
        self.ivMovable.center = CGPointMake(jurorBigView.center.x  + translation.x, jurorBigView.center.y + translation.y);
        //[gesture setTranslation:CGPointZero inView:self];
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [gesture translationInView:jurorBigView];
        self.ivMovable.center = CGPointMake(jurorBigView.center.x  + translation.x, jurorBigView.center.y + translation.y);
        
        CGPoint ptInMainView = CGPointMake(self.svMainJurors.frame.origin.x + (self.ivMovable.center.x - self.svMainJurors.contentOffset.x), self.svMainJurors.frame.origin.y + (self.ivMovable.center.y - self.svMainJurors.contentOffset.y));
        
        if(CGRectContainsPoint(self.svSelectedJurors.frame, ptInMainView))
        {
            [self addToSelectedJuror:jurorBigView.juror];
            
            self.ivMovable.hidden = YES;
        }
        else if(CGRectContainsPoint(self.svMainJurors.frame, ptInMainView))
        {
            [self moveToCurrentPositionWithView:jurorBigView position:self.ivMovable.center];
            
            self.ivMovable.hidden = YES;
        }
        else
        {
            [self returnToOriginPosition:self.ivMovable destView:jurorBigView];
        }
    }
}

- (void) moveOutHandle:(UIPanGestureRecognizer *)gesture
{
    JurorSmallView *jurorSmallView = (JurorSmallView *)[self.svSelectedJurors viewWithTag:gesture.view.tag];
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if(self.ivMoveoutable == nil)
        {
            self.ivMoveoutable = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, jurorSmallView.frame.size.width, jurorSmallView.frame.size.height)];
            self.ivMoveoutable.tag = 1001;
            self.ivMoveoutable.alpha = 0.5f;
            
            [self.svSelectedJurors addSubview:self.ivMoveoutable];
        }
        
        self.ivMoveoutable.image = [self getViewImage:jurorSmallView];
        self.ivMoveoutable.frame = CGRectMake(0, 0, jurorSmallView.frame.size.width, jurorSmallView.frame.size.height);
        
        self.ivMoveoutable.hidden = NO;
        [self.svSelectedJurors bringSubviewToFront:self.ivMoveoutable];
        [self.view bringSubviewToFront:self.svSelectedJurors];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gesture translationInView:jurorSmallView];
        CGPoint newPos = CGPointMake(jurorSmallView.center.x  + translation.x, jurorSmallView.center.y + translation.y);
        self.ivMoveoutable.center = newPos;
        //[gesture setTranslation:CGPointZero inView:self];
        
        NSLog(@"%f, %f", newPos.x, newPos.y);
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [gesture translationInView:jurorSmallView];
        self.ivMoveoutable.center = CGPointMake(jurorSmallView.center.x  + translation.x, jurorSmallView.center.y + translation.y);
        
        CGPoint ptInMainView = CGPointMake(self.svSelectedJurors.frame.origin.x + (self.ivMoveoutable.center.x - self.svSelectedJurors.contentOffset.x), self.svSelectedJurors.frame.origin.y + (self.ivMoveoutable.center.y - self.svSelectedJurors.contentOffset.y));
        
        if(CGRectContainsPoint(self.svMainJurors.frame, ptInMainView))
        {
            [self removeToSelectedJuror:jurorSmallView.juror];
            
            self.ivMoveoutable.hidden = YES;
        }
        else if(CGRectContainsPoint(self.svSelectedJurors.frame, ptInMainView))
        {
            [self moveToCurrentPositionWithSmallView:jurorSmallView position:self.ivMoveoutable.center];
            
            self.ivMoveoutable.hidden = YES;
        }
        else
        {
            [self returnToOriginPosition:self.ivMoveoutable destView: jurorSmallView];
        }
    }
}

- (void) addToSelectedJuror:(LocalJurorInfo *)juror
{
    [[DataManager shareDataManager] addSelectedJuror:juror];
    
    [self loadJurors];
}

- (void) moveToCurrentPositionWithView:(JurorBigView *)jurorView position:(CGPoint)point
{
    int focusViewIndex = -1;
    
    NSArray *subViews = [self.svMainJurors subviews];
    
    for (UIView *subview in subViews) {
        if([subview isKindOfClass:[JurorBigView class]] && CGRectContainsPoint(subview.frame, point))
        {
            focusViewIndex = (int)subview.tag - 10000;
            
            break;
        }
    }
    
    if(focusViewIndex != -1)
    {
        NSMutableArray *aryJurors = nil;
        
        if([DataManager shareDataManager].sortOption == SORT_ALPAH)
            aryJurors = self.arySortedJorursByName;
        else
            aryJurors = [DataManager shareDataManager].aryLocalJurors;
        
        if(focusViewIndex >= aryJurors.count)
            return;
        
        id selectedObj = [aryJurors objectAtIndex:(jurorView.tag - 10000)];
        
        [aryJurors removeObject:selectedObj];
        [aryJurors insertObject:selectedObj atIndex:focusViewIndex];
        
        if([DataManager shareDataManager].sortOption == SORT_LOCATION)
            [[DataManager shareDataManager] saveSurveyData];
        
        [self loadMainJurors];
    }
}

- (void) moveToCurrentPositionWithSmallView:(JurorSmallView *)jurorView position:(CGPoint)point
{
    int focusViewIndex = -1;
    
    NSArray *subViews = [self.svSelectedJurors subviews];
    
    for (UIView *subview in subViews) {
        if([subview isKindOfClass:[JurorSmallView class]] && CGRectContainsPoint(subview.frame, point))
        {
            focusViewIndex = (int)subview.tag - 50000;
            
            break;
        }
    }
    
    if(focusViewIndex != -1)
    {
        NSMutableArray *aryJurors = [DataManager shareDataManager].arySelectedJurors;
        
        id selectedObj = [aryJurors objectAtIndex:(jurorView.tag - 50000)];
        
        [aryJurors removeObject:selectedObj];
        [aryJurors insertObject:selectedObj atIndex:focusViewIndex];
        
        [[DataManager shareDataManager] saveSurveyData];
        
        [self loadSelectedJurors];
    }
}

- (void) removeToSelectedJuror:(LocalJurorInfo *)juror
{
    [[DataManager shareDataManager] removeSelectedJuror:juror];
    
    [self loadJurors];
}

- (void) returnToOriginPosition:(UIView *)moveView destView:(UIView *)originView
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         moveView.center = originView.center;
        
                     }completion:^(BOOL finished){
                         
                         moveView.hidden = YES;
                     }];
}

- (void) strikePreperemptory
{
    [[DataManager shareDataManager] setStrike:self.strikeTID type:0];
}

- (void) strikeDefence
{
    [[DataManager shareDataManager] setStrike:self.strikeTID type:1];
}

- (void) strikeCause
{
    [[DataManager shareDataManager] setStrike:self.strikeTID type:2];
}

- (void) unStrike
{
    [[DataManager shareDataManager] setStrike:self.strikeTID type:3];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    return YES;
}

#pragma mark JurorBigViewDelegate

- (void) onJurorStriked:(NSString *)tid
{
    self.strikeTID = [[NSString alloc] initWithFormat:@"%@", tid];
    
    if([[DataManager shareDataManager] isStrikedAlready:tid])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Strike type!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Peremptory", @"Defense", @"Cause", @"Un-strike", nil];
        actionSheet.tag = 0;
        
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Strike type!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Peremptory", @"Defense", @"Cause", nil];
        actionSheet.tag = 0;
        
        [actionSheet showInView:self.view];
    }
}

#pragma mark JurorSmallViewDelegate

- (void) onJurorSmallViewStriked:(NSString *)tid
{
    self.strikeTID = [[NSString alloc] initWithFormat:@"%@", tid];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Strike type!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Peremptory", @"Defense", @"Cause", nil];
    actionSheet.tag = 0;
    
    [actionSheet showInView:self.view];
}

#pragma mark SortViewDelegate

- (void) onDoneSortSetting
{
    self.sortView.hidden = YES;
    
    [self loadJurors];
}

- (void) onCancelSortSetting
{
    self.sortView.hidden = YES;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 0)
    {
        if(buttonIndex == 0)
        {
            [self strikePreperemptory];
        }
        else if(buttonIndex == 1)
        {
            [self strikeDefence];
        }
        else if(buttonIndex == 2)
        {
            [self strikeCause];
        }
        else if(buttonIndex == 3)
        {
            [self unStrike];
        }
        
        [self loadJurors];
    }
    else if(actionSheet.tag == 1)
    {
        if(buttonIndex == 0)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_ACCEPT tid:self.actionTID];
        }
        else if(buttonIndex == 1)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_CONSIDER tid:self.actionTID];
        }
        else if(buttonIndex == 2)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_DECLINE tid:self.actionTID];
        }
        
        [self loadJurors];
    }
}

#pragma mark EditQuestionViewDelegate

- (void) doneNewQuestion:(UIView *)view question:(QuestionInfo *)question
{
    self.questionView.hidden = YES;
    
    self.askerName = nil;
    self.askerName = [[NSString alloc] initWithFormat:@"%@", @""];
    
    self.askQuestion = question;
    
    self.lblQuestion.hidden = NO;
    self.lblQuestion.text = self.askQuestion.question;
    
    [[DataManager shareDataManager] addQuestion:question];
}

- (void) doneEditQuestion:(UIView *)view question:(QuestionInfo *)question
{
    
}

- (void) cancelEditQuestion:(UIView *)view
{
    self.questionView.hidden = YES;
    
    if(self.askQuestion == nil || self.askQuestion.question.length == 0)
    {
        _isAskingNow = NO;
        
        self.btnAskDone.hidden = YES;
        self.btnAskAnother.hidden = YES;
        self.lblQuestion.hidden = YES;
    }
}

#pragma mark JurorResponseViewDelegate

- (void) cancelJurorResponse
{
    self.responseView.hidden = YES;
}

- (void) doneJurorResponse:(NSString *)tid response:(NSString *)response
{
    self.responseView.hidden = YES;
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"hh:mm - MM/dd/yyyy"];
//    
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//    
//    NSString *newResponse = [NSString stringWithFormat:@"%@[%@]:%@\n%@",self.askerName, dateString, self.askQuestion, response];
//    
//    [[DataManager shareDataManager] updateLocalJurorWithNote:newResponse tid:tid replace:NO];
    
    [self loadJurors];
}

#pragma mark EditLocalJurorViewDelegate

- (void) onDoneEditLocalJuror:(UIView *)view juror:(LocalJurorInfo *)juror
{
    [[DataManager shareDataManager] addLocalJuror:juror];
    
    self.editJurorView.hidden = YES;
    
    [self loadJurors];
}

- (void) onCancelEditLocalJuror:(UIView *)view
{
    self.editJurorView.hidden = YES;
}

@end
