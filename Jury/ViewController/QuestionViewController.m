//
//  QuestionViewController.m
//  Jury
//
//  Created by wuyinsong on 14-1-3.
//  Copyright (c) 2014年 Alioth. All rights reserved.
//

#import "QuestionViewController.h"

#import "EditQuestionView.h"
#import "NewGroupView.h"

#import "DataManager.h"

#import "SampleQuestions.h"

#import "GroupInfo.h"
#import "QuestionInfo.h"

#import "QuestionSettingView.h"

#import "OpenQuestionaireView.h"
#import "SaveQuestionaireView.h"

@interface QuestionViewController ()<EditQuestionViewDelegate, NewGroupViewDelegate, OpenQuestionaireViewDelegate>
{
    int _selectedGroup;
    int _activeGroup;
}

@property (nonatomic, assign) IBOutlet UITableView *tvQuestions;
@property (nonatomic, assign) IBOutlet UITextField *txtSearchQuestions;

@property (nonatomic, assign) EditQuestionView *viewEditQuestion;
@property (nonatomic, assign) NewGroupView *viewNewGroup;

@property (nonatomic, assign) QuestionSettingView *viewQuestionSetting;

@property (nonatomic, assign) OpenQuestionaireView *openQuestionaireView;
@property (nonatomic, assign) SaveQuestionaireView *saveQuestionaireView;

- (IBAction)onBack:(id)sender;

- (IBAction)onAddQuestion:(id)sender;
- (IBAction)onAddGroup:(id)sender;
- (IBAction)onDeleteGroup:(id)sender;

- (IBAction)onSelectGroup:(id)sender;

- (IBAction)onGotoJuror:(id)sender;

- (IBAction)onSetting:(id)sender;

- (IBAction)onAddQuestionnaire:(id)sender;
- (IBAction)onSaveQuestionnaire:(id)sender;

@end

@implementation QuestionViewController

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
    
    [self _init];
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
    
    self.tvQuestions.sectionFooterHeight = 0;
    
    [self.tvQuestions reloadData];
}

- (void) _init
{
    _selectedGroup = 0;
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

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)onDeleteQuestion:(id)sender
{
    int questionIndex = (int)((UIButton *)sender).tag;
    
    GroupInfo *group = [[DataManager shareDataManager].aryGroups objectAtIndex:_selectedGroup];
    
    [self reqDeleteQuestion:(int)group.groupId index:questionIndex];
    
    [self.tvQuestions reloadData];
}

- (IBAction)onAddGroup:(id)sender
{
    if(self.viewNewGroup == nil)
    {
        self.viewNewGroup =  [[[NSBundle mainBundle] loadNibNamed:@"NewGroupView" owner:self options:nil] objectAtIndex:0];
        self.viewNewGroup.frame = CGRectMake(0, 0, self.viewNewGroup.frame.size.width, self.viewNewGroup.frame.size.height);
        self.viewNewGroup.delegate = self;
        
        [self.view addSubview:self.viewNewGroup];
    }
    
    self.viewNewGroup.hidden = NO;
    
    [self.viewNewGroup _init];
    [self.view bringSubviewToFront:self.viewNewGroup];
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

- (IBAction)onSelectGroup:(id)sender
{
    _selectedGroup = (int)((UIButton *)sender).tag;
    
    [self loadQuestions];
}

- (IBAction)onGotoJuror:(id)sender
{
    [self performSegueWithIdentifier:@"Juror" sender:nil];
}

- (IBAction)onSetting:(id)sender
{
    if(self.viewQuestionSetting == nil)
    {
        self.viewQuestionSetting =  [[[NSBundle mainBundle] loadNibNamed:@"QuestionSettingView" owner:self options:nil] objectAtIndex:0];
        self.viewQuestionSetting.frame = CGRectMake(0, 0, self.viewQuestionSetting.frame.size.width, self.viewQuestionSetting.frame.size.height);
        
        [self.view addSubview:self.viewQuestionSetting];
    }
    
    self.viewQuestionSetting.hidden = NO;

    [self.view bringSubviewToFront:self.viewQuestionSetting];
}

- (IBAction)onAddQuestionnaire:(id)sender
{
    if(self.openQuestionaireView == nil)
    {
        self.openQuestionaireView =  [[[NSBundle mainBundle] loadNibNamed:@"OpenQuestionaireView" owner:self options:nil] objectAtIndex:0];
        self.openQuestionaireView.frame = CGRectMake(0, 0, self.openQuestionaireView.frame.size.width, self.openQuestionaireView.frame.size.height);
        self.openQuestionaireView.delegate = self;
        
        [self.view addSubview:self.openQuestionaireView];
    }
    
    [self.openQuestionaireView _init];
    
    self.openQuestionaireView.hidden = NO;
    
    [self.view bringSubviewToFront:self.openQuestionaireView];
}

- (IBAction)onSaveQuestionnaire:(id)sender
{
    if(self.saveQuestionaireView == nil)
    {
        self.saveQuestionaireView =  [[[NSBundle mainBundle] loadNibNamed:@"SaveQuestionaireView" owner:self options:nil] objectAtIndex:0];
        self.saveQuestionaireView.frame = CGRectMake(0, 0, self.saveQuestionaireView.frame.size.width, self.saveQuestionaireView.frame.size.height);
        
        [self.view addSubview:self.saveQuestionaireView];
    }
    
    self.saveQuestionaireView.hidden = NO;
    
    [self.view bringSubviewToFront:self.saveQuestionaireView];
}

- (void) reqAddGroup:(GroupInfo *)group
{
    [[DataManager shareDataManager] addNewGroup:group];
}

- (void) reqEditGroup:(GroupInfo *)group
{
    [[DataManager shareDataManager] editGroup:group];
}

- (void) reqDeleteGroup:(int) groupIndex
{
    [[DataManager shareDataManager] deleteGroup:groupIndex];
}

- (void) reqDeleteQuestion:(int)groupId index:(int)index
{
    [[DataManager shareDataManager] deleteQuestion:groupId index:index];
}

- (void) loadQuestions
{
    [self.tvQuestions reloadData];
}

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
    return 60;
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
        
        [view addSubview:buttonAddQuestion];
        
        UIButton *buttonEdit = [[UIButton alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 190, 0, 50, 60)];
        buttonEdit.tag = section;
        [buttonEdit setTitle:@"Edit - " forState:UIControlStateNormal];
        [buttonEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonEdit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [buttonEdit addTarget:self action:@selector(onEditGroup:) forControlEvents:UIControlEventTouchUpInside];
        buttonEdit.backgroundColor = [UIColor clearColor];
        
        [view addSubview:buttonEdit];
        
        UIButton *buttonDelete = [[UIButton alloc] initWithFrame:CGRectMake(self.tvQuestions.frame.size.width - 144, 0, 60, 60)];
        buttonDelete.tag = section;
        [buttonDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [buttonDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonDelete setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [buttonDelete addTarget:self action:@selector(onDeleteGroup:) forControlEvents:UIControlEventTouchUpInside];
        buttonDelete.backgroundColor = [UIColor clearColor];
        
        [view addSubview:buttonDelete];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    cell.textLabel.text = question.question;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onDeleteQuestion:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = indexPath.row;
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"question_image_delete"] forState:UIControlStateNormal];
    
    cell.accessoryView = button;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
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
    
    [self editQuestion:question];
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

#pragma mark OpenQuestionaireDelegate

- (void) onOpenQuestionaire
{
    [self.tvQuestions reloadData];
}

@end
