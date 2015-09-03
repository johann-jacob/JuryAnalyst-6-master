//
//  NewVoirDireViewController.m
//  Jury
//
//  Created by wuyinsong on 14-1-27.
//  Copyright (c) 2014年 Alioth. All rights reserved.
//

#import "NewVoirDireViewController.h"

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

#import "SelectJurorView.h"
#import "SearchJurorView.h"

#import "AskNowView.h"

#import "SVProgressHUD.h"

@interface NewVoirDireViewController ()<SelectJurorViewDelegate, SearchJurorViewDelegate, JurorBigViewDelegate, JurorSmallViewDelegate, SortViewDelegate, EditQuestionViewDelegate, JurorResponseViewDelegate, EditLocalJurorViewDelegate, AskNowViewDelegate, UIActionSheetDelegate>
{
    BOOL _isAskingNow;
    NSInteger _currentAskingQuestionIndex;
    
    NSInteger _selectingIndex;
}

- (IBAction)onQuestions:(id)sender;
- (IBAction)onJurors:(id)sender;

- (IBAction)onAskNow:(id)sender;
- (IBAction)onAskDone:(id)sender;
- (IBAction)onAskNext:(id)sender;
- (IBAction)onAskAnother:(id)sender;

- (IBAction)onSort:(id)sender;

- (IBAction)onSearch:(id)sender;

- (IBAction)onChangedKeyword:(id)sender;

@property (nonatomic, assign) IBOutlet UITextField *txtKeyword;

@property (nonatomic, assign) IBOutlet UIScrollView *svMainJurors;
@property (nonatomic, assign) IBOutlet UIScrollView *svSelectedJurors;

@property (nonatomic, assign) IBOutlet UILabel *lblStrikeLabel;

@property (nonatomic, assign) IBOutlet UIButton *btnAskDone;
@property (nonatomic, assign) IBOutlet UIButton *btnAskNext;
@property (nonatomic, assign) IBOutlet UIButton *btnAskAnother;

@property (nonatomic, assign) IBOutlet UILabel *lblQuestion;

@property (nonatomic, retain) UIImageView *ivMovable;
@property (nonatomic, assign) UIImageView *ivMoveoutable;

@property (nonatomic, retain) NSString *strikeTID;
@property (nonatomic, retain) NSString *actionTID;

@property (nonatomic, assign) SortView *sortView;

@property (nonatomic, assign) EditQuestionView *questionView;
@property (nonatomic, assign) JurorResponseView *responseView;

@property (nonatomic, assign) EditLocalJurorView *editJurorView;

@property (nonatomic, assign) SelectJurorView *selectJurorView;
@property (nonatomic, assign) SearchJurorView *searchJurorView;

@property (nonatomic, assign) AskNowView *askNowView;

@property (nonatomic, retain) NSMutableArray *arySortedJorursByName;

@property (nonatomic, retain) NSMutableArray *aryJurorInformations;

@property (nonatomic, retain) NSString *askerName;
@property (nonatomic, retain) QuestionInfo *askQuestion;

- (IBAction)onBack:(id)sender;

@end

@implementation NewVoirDireViewController

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
    
    _selectingIndex = NSNotFound;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _init];
}

- (void) _init
{
    self.btnAskDone.hidden = !_isAskingNow;
    self.btnAskNext.hidden = !_isAskingNow;
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
//    if([DataManager shareDataManager].sortOption == SORT_ALPAH)
//    {
//        [self getSortedJurorsByName];
//    }
    
    //[self loadMainJurors];
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
    
    int pCount = 0, dCount = 0, sCount = 0, nCount = 0;
    for (LocalJurorInfo *juror in aryJurors) {
        
        pCount += juror.preperemptory;
        dCount += juror.defence;
        sCount += juror.cause;
        nCount += juror.newVers;
    }
    
    self.lblStrikeLabel.text = [NSString stringWithFormat:@"H%d-C%d-D%d-P%d", pCount, dCount, sCount, nCount];
}

- (void) loadMainJurors
{
    return;
    
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
            if(juror.preperemptory == 0 && juror.cause == 0 && juror.defence == 0 && juror.newVers == 0)
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
        tapGestureRecognizer.numberOfTapsRequired = 1;
        
        UITapGestureRecognizer *doubleGestureRegonizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapJuror:)];
        doubleGestureRegonizer.numberOfTapsRequired = 2;
        
        [mainJurorView addGestureRecognizer:doubleGestureRegonizer];
        
        [mainJurorView addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer requireGestureRecognizerToFail:doubleGestureRegonizer];
        
        tapGestureRecognizer = nil;
        doubleGestureRegonizer = nil;
        
        index ++;
    }
    
    self.svMainJurors.contentSize = CGSizeMake(((index - 1) / 2 + 1) * (190 + 20), self.svMainJurors.frame.size.height);
}

- (void) loadSelectedJurors
{
    NSArray *subViews = [self.svSelectedJurors subviews];
    for (UIView *subview in subViews) {
        if(subview.tag != 1001)
            [subview removeFromSuperview];
    }
    
    int maxRows = [[DataManager shareDataManager] getCurrectSurveyHeight];
    int maxColumns = [[DataManager shareDataManager] getCurrectSurveyWidth];
    
    float intervalH = 5;
    float intervalV = 5;
    
//    intervalH = (self.svSelectedJurors.frame.size.width - 120 * maxColumns) / (maxColumns - 1);
//    intervalV = (self.svSelectedJurors.frame.size.height - 120 * maxRows) / (maxRows - 1);
    
    float cardWidth = 120;
    float cardHeight = 120;
    
    if(maxRows < 5)
    {
        cardHeight = (self.svSelectedJurors.frame.size.height - intervalV * (maxRows - 1)) / maxRows;
    }
    
    if(maxColumns < 8)
    {
        cardWidth = (self.svSelectedJurors.frame.size.width - intervalH * (maxColumns - 1)) / maxColumns;
    }
    
    float newWidth = MIN(cardWidth, cardHeight);
    
    cardWidth = newWidth;
    cardHeight = newWidth;
    
    float firstRowPosition = 0;
    if(maxRows < 5)
    {
        firstRowPosition = (self.svSelectedJurors.frame.size.height - intervalV * (maxRows - 1) - cardHeight * maxRows) / 2;
    }
    
    float firstColumnPosition = 0;
    if(maxColumns < 8)
    {
        firstColumnPosition = (self.svSelectedJurors.frame.size.width - intervalH * (maxColumns - 1) - cardWidth * maxColumns) / 2;
    }
    
    
    NSMutableArray *aryPoints = [DataManager shareDataManager].aryPoints;

    for (int n = 0 ; n < aryPoints.count && n < maxRows * maxColumns ; n ++) {
        
        int row = n % maxColumns;
        int column = n / maxColumns;
        
        NSString *jurorId = [aryPoints objectAtIndex:n];
        
        JurorSmallView *smallJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"JurorSmallView" owner:self options:nil] objectAtIndex:0];
        
        
        smallJurorView.tag = 50000 + n;
        smallJurorView.viewTop.tag = 50000 + n;
        smallJurorView.frame = CGRectMake(firstColumnPosition + row * (cardWidth + intervalH), firstRowPosition + column * (cardHeight + intervalV) , cardWidth, cardHeight);
        smallJurorView.delegate = self;
        
        if(jurorId == nil || [jurorId isEqualToString:@""])
        {
            [smallJurorView setLocalJurorInfo:nil];
        }
        else
        {
            smallJurorView.layer.borderColor = [[UIColor grayColor] CGColor];
            smallJurorView.layer.borderWidth = 1;
            LocalJurorInfo *localJuror = [[DataManager shareDataManager] getLocalJuror:jurorId];
            
            if(localJuror)
            {
                [smallJurorView setLocalJurorInfo:localJuror];
            }
            
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOutHandle:)];
            [smallJurorView addGestureRecognizer:panGestureRecognizer];
            panGestureRecognizer = nil;
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJuror:)];
            tapGestureRecognizer.numberOfTapsRequired = 1;
            [smallJurorView addGestureRecognizer:tapGestureRecognizer];
            
            UITapGestureRecognizer *doubleGestureRegonizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapJuror:)];
            doubleGestureRegonizer.numberOfTapsRequired = 2;
            
            [smallJurorView addGestureRecognizer:doubleGestureRegonizer];
            
            [tapGestureRecognizer requireGestureRecognizerToFail:doubleGestureRegonizer];
            doubleGestureRegonizer = nil;
            tapGestureRecognizer = nil;
        }
        
        [self.svSelectedJurors addSubview:smallJurorView];
    }
    
    self.svSelectedJurors.contentSize = CGSizeMake(maxColumns * (cardWidth + intervalH), maxRows * (cardHeight + intervalV));
}

- (IBAction)onImport:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Name"
                                                    message:@"Please Enter the file Name"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Done", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=11;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1  && alertView.tag == 11)
    {
        [SVProgressHUD show];
        
        downloadData = [NSMutableData dataWithCapacity: 1];
        downloadFile = [[BRRequestDownload alloc] initWithDelegate: self];
        downloadFile.path = [NSString stringWithFormat:@"/juryanalystBackups/%@", [[alertView textFieldAtIndex:0] text]];
        downloadFile.hostname = @"itsjaked.webfactional.com";
        downloadFile.username = @"jaked";
        downloadFile.password = @"dev1235@";
        
        //we start the request
        [downloadFile start];
        //[self listDirectoryContents];
        
    }
}

- (IBAction)onExport:(id)sender
{
    [[DataManager shareDataManager] saveSurveyData];
    
    NSString *surveyDataFilePath = [[DataManager shareDataManager] getCurrentSurveyDataFilePath];
    
    NSArray *stringArray = [surveyDataFilePath componentsSeparatedByString:@"/"];
    fileName = [stringArray lastObject];

    
    if(surveyDataFilePath == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no data or file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return;
    }
    
    NSLog(@"In method");
    
    [SVProgressHUD show];
    
    //the upload request needs the input data to be NSData

    uploadData = [NSData dataWithContentsOfFile: surveyDataFilePath];
    
    uploadFile = [[BRRequestUpload alloc] initWithDelegate:self];
    
    uploadFile.path = [NSString stringWithFormat: @"/juryanalystBackups/%@", fileName];
    uploadFile.hostname = @"itsjaked.webfactional.com";
    uploadFile.username = @"jaked";
    uploadFile.password = @"dev1235@";
    
    [uploadFile start];
    
}

-(BOOL) shouldOverwriteFileWithRequest: (BRRequest *) request
{
    //----- set this as appropriate if you want the file to be overwritten
    if (request == uploadFile)
    {
        //----- if uploading a file, we set it to YES
        return YES;
    }
    
    //----- anything else (directories, etc) we set to NO
    return NO;
}

- (void) requestDataAvailable: (BRRequestDownload *) request;
{
    [downloadData appendData: request.receivedData];
}

-(void) requestCompleted: (BRRequest *) request
{
    [SVProgressHUD dismiss];
    
    if (request == uploadFile)
    {
        NSLog(@"%@ completed!", request);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Name" message:[NSString stringWithFormat:@"%@",fileName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        alertView = nil;
        uploadFile = nil;
        fileName = nil;
    }
    
    if (request == downloadFile)
    {
        //called after 'request' is completed successfully
        NSLog(@"%@ completed!", request);
        
        NSData *data = downloadData;//downloadFile.receivedData;
        
        //----- save the NSData as a file object
        BOOL success = [data writeToFile:[[DataManager shareDataManager] getCurrentSurveyDataFilePath] atomically:YES];
        [[DataManager shareDataManager] loadSurveyData];

        downloadFile = nil;
        
        [self _init];
    }
}

-(void) requestFailed:(BRRequest *) request
{
    [SVProgressHUD dismiss];
    
    if (request == downloadFile)
    {
        NSLog(@"%@", request.error.message);
        
        downloadFile = nil;
    }
    
    if (request == uploadFile)
    {
        NSLog(@"%@", request.error.message);
        
        uploadFile = nil;
    }
    
}

- (NSData *) requestDataToSend: (BRRequestUpload *) request
{
    //----- returns data object or nil when complete
    //----- basically, first time we return the pointer to the NSData.
    //----- and BR will upload the data.
    //----- Second time we return nil which means no more data to send
    NSData *temp = uploadData;                                                  // this is a shallow copy of the pointer, not a deep copy
    
    uploadData = nil;                                                           // next time around, return nil...
    
    return temp;
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You need to add groups and questions before you can ask questions." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    _isAskingNow = YES;
    _currentAskingQuestionIndex = 0;
    
    self.btnAskDone.hidden = NO;
    self.btnAskNext.hidden = NO;
    self.btnAskAnother.hidden = NO;
    
    //[self showQuestionView];
    [self showAskNowView];
}

- (IBAction)onAskDone:(id)sender
{
    _isAskingNow = NO;
    
    self.btnAskDone.hidden = YES;
    self.btnAskNext.hidden = YES;
    self.btnAskAnother.hidden = YES;
    self.lblQuestion.hidden = YES;
}

- (IBAction)onAskNext:(id)sender
{
    if(_currentAskingQuestionIndex >= [DataManager shareDataManager].aryLocalQuestions.count)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no next question anymore." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    QuestionInfo *question = [[DataManager shareDataManager].aryLocalQuestions objectAtIndex:_currentAskingQuestionIndex];
    
    self.askerName = nil;
    self.askerName = [[NSString alloc] initWithFormat:@"%@", @""];
    
    self.askQuestion = question;
    
    self.lblQuestion.hidden = NO;
    self.lblQuestion.text = self.askQuestion.question;
    
    _currentAskingQuestionIndex ++;
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

- (void) showAskNowView
{
    if(self.askNowView == nil)
    {
        self.askNowView =  [[[NSBundle mainBundle] loadNibNamed:@"AskNowView" owner:self options:nil] objectAtIndex:0];
        self.askNowView.frame = CGRectMake(0, 0, self.askNowView.frame.size.width, self.askNowView.frame.size.height);
        self.askNowView.delegate = self;
        
        [self.askNowView _init];
        
        [self.view addSubview:self.askNowView];
    }
    
    [self.askNowView _init];
    self.askNowView.hidden = NO;
    
    [self.view bringSubviewToFront:self.askNowView];
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

- (IBAction)onSearch:(id)sender
{
    [self showSearchJurorsScreen];
}

- (void) showSearchJurorsScreen
{
    if(self.searchJurorView == nil)
    {
        self.searchJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"SearchJurorView" owner:self options:nil] objectAtIndex:0];
        self.searchJurorView.frame = CGRectMake(0, 0, self.searchJurorView.frame.size.width, self.searchJurorView.frame.size.height);
        self.searchJurorView.delegate = self;
        
        [self.view addSubview:self.searchJurorView];
    }
    
    self.searchJurorView.hidden = NO;
    
    [self.searchJurorView setKeyword:@""];
    [self.view bringSubviewToFront:self.searchJurorView];
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

- (void) doubleTapJuror:(UITapGestureRecognizer *)gesture {
    
    JurorSmallView *jurorSmallView = (JurorSmallView *)gesture.view;
    jurorSmallView.layer.borderWidth = 1;
    jurorSmallView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    if (jurorSmallView.isYellow) {
        jurorSmallView.backgroundColor = [UIColor whiteColor];
        jurorSmallView.isYellow = false;
    }
    else {
        jurorSmallView.backgroundColor = [UIColor yellowColor];
        jurorSmallView.isYellow = true;
    }
//    LocalJurorInfo *juror = jurorSmallView.juror;
    
//    if(juror == nil)
//    {
//        _selectingIndex = jurorSmallView.tag - 50000;
//        
//        if(self.selectJurorView == nil)
//        {
//            self.selectJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"SelectJurorView" owner:self options:nil] objectAtIndex:0];
//            self.selectJurorView.frame = CGRectMake(0, 0, self.selectJurorView.frame.size.width, self.selectJurorView.frame.size.height);
//            self.selectJurorView.delegate = self;
//            
//            [self.view addSubview:self.selectJurorView];
//        }
//        
//        self.selectJurorView.hidden = NO;
//    }
//    else
//    {
//        if(_isAskingNow)
//        {
//            [self showResponseView:juror.tid];
//        }
//        else
//        {
//                self.actionTID = [[NSString alloc] initWithFormat:@"%@", juror.tid];
//                int buttonIndex = 0;
//                buttonIndex = [[DataManager shareDataManager] getActionindex:self.actionTID];
//                
//                if(buttonIndex == 0)
//                {
//                    [[DataManager shareDataManager] updateLocalJurorWithAction:JA_CONSIDER tid:self.actionTID];
//                }
//                else if(buttonIndex == 1)
//                {
//                    [[DataManager shareDataManager] updateLocalJurorWithAction:JA_DECLINE tid:self.actionTID];
//                }
//                else if(buttonIndex == 2)
//                {
//                    [[DataManager shareDataManager] updateLocalJurorWithAction:JA_NEUTRAL tid:self.actionTID];
//                }
//                else if(buttonIndex == 3)
//                {
//                    [[DataManager shareDataManager] updateLocalJurorWithAction:JA_ACCEPT tid:self.actionTID];
//                }
//                
//                [self loadJurors];
//
//        }
//    }



}

- (void) tapJuror:(UITapGestureRecognizer *)gesture
{
    JurorSmallView *jurorSmallView = (JurorSmallView *)gesture.view;
    jurorSmallView.layer.borderWidth = 1;
    jurorSmallView.layer.borderColor = [[UIColor grayColor] CGColor];

    LocalJurorInfo *juror = jurorSmallView.juror;
    
    if(juror == nil)
    {
        _selectingIndex = jurorSmallView.tag - 50000;
        
        if(self.selectJurorView == nil)
        {
            self.selectJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"SelectJurorView" owner:self options:nil] objectAtIndex:0];
            self.selectJurorView.frame = CGRectMake(0, 0, self.selectJurorView.frame.size.width, self.selectJurorView.frame.size.height);
            self.selectJurorView.delegate = self;
            
            [self.view addSubview:self.selectJurorView];
        }
        
        self.selectJurorView.hidden = NO;
    }
    else
    {
        if(_isAskingNow)
        {
            [self showResponseView:juror.tid];
        }
        else
        {
            CGPoint point = [gesture locationInView:jurorSmallView];
            
            if(point.y > 42)
            {
                [self performSegueWithIdentifier:@"JurorIndividual" sender:juror];
            }
            else
            {
                self.actionTID = [[NSString alloc] initWithFormat:@"%@", juror.tid];
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Accept", @"Consider", @"Decline", @"Neutral", nil];
                actionSheet.tag = 1;
                
                [actionSheet showInView:self.view];
            }
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
            UIImageView *ivMoveoutable = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, jurorSmallView.frame.size.width, jurorSmallView.frame.size.height)];
            ivMoveoutable.tag = 1001;
            ivMoveoutable.alpha = 0.5f;
            
            [self.svSelectedJurors addSubview:ivMoveoutable];
            self.ivMoveoutable = ivMoveoutable;
        }
        
        self.ivMoveoutable.image = [self getViewImage:jurorSmallView];
        [self.svSelectedJurors bringSubviewToFront:self.ivMoveoutable];
        
        [self.view bringSubviewToFront:self.svSelectedJurors];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        self.ivMoveoutable.hidden = NO;
        
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
        
//        CGPoint ptInMainView = CGPointMake(self.svSelectedJurors.frame.origin.x + (self.ivMoveoutable.center.x - self.svSelectedJurors.contentOffset.x), self.svSelectedJurors.frame.origin.y + (self.ivMoveoutable.center.y - self.svSelectedJurors.contentOffset.y));
        
//        if(CGRectContainsPoint(self.svMainJurors.frame, ptInMainView))
//        {
//            [self removeToSelectedJuror:jurorSmallView.juror];
//            
//            self.ivMoveoutable.hidden = YES;
//        }
//        else if(CGRectContainsPoint(self.svSelectedJurors.frame, ptInMainView))
//        {
//            [self moveToCurrentPositionWithSmallView:jurorSmallView position:self.ivMoveoutable.center];
//            
//            self.ivMoveoutable.hidden = YES;
//        }
//        else
//        {
//            [self returnToOriginPosition:self.ivMoveoutable destView: jurorSmallView];
//        }
        
        [self moveToCurrentPositionWithSmallView:jurorSmallView position:self.ivMoveoutable.center];
        
        self.ivMoveoutable.hidden = YES;
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
    if(jurorView.juror == nil)
        return;
    
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
        NSMutableArray *aryJurors = [DataManager shareDataManager].aryPoints;
        
        NSInteger selectedIndex = jurorView.tag - 50000;
        
        NSString *focusJurorId = [aryJurors objectAtIndex:focusViewIndex];
        
        [aryJurors replaceObjectAtIndex:selectedIndex withObject:focusJurorId];
        [aryJurors replaceObjectAtIndex:focusViewIndex withObject:jurorView.juror.tid];
        
        [[DataManager shareDataManager] saveSurveyData];
        
        [self loadJurors];
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
    
    [[DataManager shareDataManager] removeJurorIdFromSelectedList:self.strikeTID];
}

- (void) strikeDefence
{
    [[DataManager shareDataManager] setStrike:self.strikeTID type:1];
    
    [[DataManager shareDataManager] removeJurorIdFromSelectedList:self.strikeTID];
}

- (void) strikeCause
{
    [[DataManager shareDataManager] setStrike:self.strikeTID type:2];
    [[DataManager shareDataManager] removeJurorIdFromSelectedList:self.strikeTID];
}

- (void) strikeNewVersion
{
    [[DataManager shareDataManager] setStrike:self.strikeTID type:4];
    [[DataManager shareDataManager] removeJurorIdFromSelectedList:self.strikeTID];
}

- (void) hideJuror
{
    [[DataManager shareDataManager] removeJurorIdFromSelectedList:self.strikeTID];
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
    NSLog(@"Is Striked? %hhd", [[DataManager shareDataManager] isStrikedAlready:tid]);
    if([[DataManager shareDataManager] isStrikedAlready:tid])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Strike type!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hardship", @"Cause", @"Defense Premptotory", @"Peremptory Peremptory", @"Hide Juror", @"Un-strike", nil];
        actionSheet.tag = 0;
        
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Strike type!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hardship", @"Cause", @"Defense Premptotory", @"Peremptory Peremptory",@"Hide Juror", nil];
        actionSheet.tag = 0;
        
        [actionSheet showInView:self.view];
    }
}

#pragma mark JurorSmallViewDelegate

- (void) onJurorSmallViewStriked:(NSString *)tid
{
    self.strikeTID = [[NSString alloc] initWithFormat:@"%@", tid];
    NSLog(@"Is Striked? %hhd", [[DataManager shareDataManager] isStrikedAlready:tid]);
    if([[DataManager shareDataManager] isStrikedAlready:tid])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Strike type!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hardship", @"Cause", @"Defense Premptotory", @"Peremptory Peremptory",@"Hide Juror", @"Un-strike", nil];
        actionSheet.tag = 0;
        
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Strike type!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Hardship", @"Cause", @"Defense Premptotory", @"Peremptory Peremptory", @"Hide Juror",nil];
        actionSheet.tag = 0;
        
        [actionSheet showInView:self.view];
    }
}

- (void) onSelectJurorWithView:(UIView *)view
{
    _selectingIndex = view.tag - 50000;
    
    [self selectJurorWithSelection];
    
//    if(self.selectJurorView == nil)
//    {
//        self.selectJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"SelectJurorView" owner:self options:nil] objectAtIndex:0];
//        self.selectJurorView.frame = CGRectMake(0, 0, self.selectJurorView.frame.size.width, self.selectJurorView.frame.size.height);
//        self.selectJurorView.delegate = self;
//        
//        [self.view addSubview:self.selectJurorView];
//    }
//    
//    self.selectJurorView.hidden = NO;
//    [self.view bringSubviewToFront:self.selectJurorView];
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
            [self strikeNewVersion];
        }
        else if (buttonIndex == 4){
            [self hideJuror];
        }
        else if(buttonIndex == 5)
        {
            [self unStrike];
        }
        [[DataManager shareDataManager] updateLocalJurorWithAction:JA_STRIKE tid:self.actionTID];
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
        else if(buttonIndex == 3)
        {
            [[DataManager shareDataManager] updateLocalJurorWithAction:JA_NEUTRAL tid:self.actionTID];
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
        self.btnAskNext.hidden = YES;
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
    self.editJurorView.hidden = YES;
    
    [[DataManager shareDataManager] addLocalJuror:juror];
    
    if(_selectingIndex != NSNotFound)
    {
        [[DataManager shareDataManager] setJurorPoint:_selectingIndex tid:juror.tid];
    }
    
    _selectingIndex = NSNotFound;
    
    [self loadJurors];
}

- (void) onCancelEditLocalJuror:(UIView *)view
{
    self.editJurorView.hidden = YES;
    
    _selectingIndex = NSNotFound;
}

#pragma mark SelectJurorViewDelegate

- (void) cancelWithSelection
{
    self.selectJurorView.hidden = YES;
    
    _selectingIndex = NSNotFound;
}

- (void) createJurorWithSelection
{
    self.selectJurorView.hidden = YES;
    
    [self onJurors:nil];
}

- (void) selectJurorWithSelection
{
    self.selectJurorView.hidden = YES;
    
    if(self.searchJurorView == nil)
    {
        self.searchJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"SearchJurorView" owner:self options:nil] objectAtIndex:0];
        self.searchJurorView.frame = CGRectMake(0, 0, self.searchJurorView.frame.size.width, self.searchJurorView.frame.size.height);
        self.searchJurorView.delegate = self;
        
        [self.view addSubview:self.searchJurorView];
    }
    
    self.searchJurorView.hidden = NO;
    
    [self.searchJurorView _init];
    [self.view bringSubviewToFront:self.searchJurorView];
}

#pragma mark SearchJurorViewDelegate

- (void) cancelWithSearchJuror
{
    self.searchJurorView.hidden = YES;
    
    _selectingIndex = NSNotFound;
}

- (void) selectWithSearchJuror:(NSString *)tid
{
    self.searchJurorView.hidden = YES;
    
    [[DataManager shareDataManager] setJurorPoint:_selectingIndex tid:tid];
    
    _selectingIndex = NSNotFound;
    
    [self loadJurors];
}

- (void) showWithSearchJuror:(NSString *)tid
{
    LocalJurorInfo *juror = [[DataManager shareDataManager] getLocalJuror:tid];
    
    if(juror)
        [self performSegueWithIdentifier:@"JurorIndividual" sender:juror];
}

- (void) addNewJurorWithSearchJuror
{
    self.searchJurorView.hidden = YES;
    
    [self onJurors:nil];
}

#pragma mark AskNowViewDelegate

- (void) onAskNowWithNew
{
    [self showQuestionView];
}

- (void) onAskNowWithIsAlreadyQuestion:(int)index
{
    _currentAskingQuestionIndex = index;
    
    [self onAskNext:nil];
}

@end
