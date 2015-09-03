//
//  EditQuestionView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "EditQuestionView.h"

#import "DataManager.h"

#import "QuestionInfo.h"
#import "GroupInfo.h"

@interface EditQuestionView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL _isEditingState;
    
    int _responsePos;
    int _responseNag;
}

@property (nonatomic, assign) IBOutlet UITextField *txtQuestion;
@property (nonatomic, assign) IBOutlet UITextField *txtSymbol;
@property (nonatomic, assign) IBOutlet UITextField *txtOption;
@property (nonatomic, assign) IBOutlet UITextField *txtSumQuestion;

@property (nonatomic, assign) IBOutlet UIButton *btnHardShip;
@property (nonatomic, assign) IBOutlet UIButton *btnCause;
@property (nonatomic, assign) IBOutlet UIButton *btnDemographic;

@property (nonatomic, assign) IBOutlet UIButton *btnPosYes;
@property (nonatomic, assign) IBOutlet UIButton *btnPosNo;
@property (nonatomic, assign) IBOutlet UIButton *btnNagYes;
@property (nonatomic, assign) IBOutlet UIButton *btnNagNo;

@property (nonatomic, assign) IBOutlet UIView *viewYesNoOption;
@property (nonatomic, assign) IBOutlet UILabel *lblNoAvailable;

@property (nonatomic, assign) IBOutlet UITextField *txtGroupTitle;

@property (nonatomic, assign) IBOutlet UIView *groupView;
@property (nonatomic, assign) IBOutlet UIPickerView *pickerView;

@property (nonatomic, retain) QuestionInfo *question;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDone:(id)sender;

- (IBAction)onStrike:(id)sender;

- (IBAction)onResponsePos:(id)sender;
- (IBAction)onResponseNag:(id)sender;

@end

@implementation EditQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) _init
{
    self.question = [[QuestionInfo alloc] init];
    
    GroupInfo *groupInfo = [[DataManager shareDataManager] getGroupWithIndex:0];
    if(groupInfo != nil)
    {
        self.question.groupId = [[DataManager shareDataManager] getGroupWithIndex:0].groupId;
    }
    
    _isEditingState = NO;
    
    self.groupView.hidden = YES;
    
    _responsePos = -1;
    _responseNag = -1;
    
    [self showQuestionInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void) _initWithGroupId:(int)groupId
{
    self.question = [[QuestionInfo alloc] init];
    self.question.groupId = groupId;
    
    _isEditingState = NO;
    
    self.groupView.hidden = YES;
    
    _responsePos = -1;
    _responseNag = -1;
    
    [self showQuestionInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void) _initWithQuestion:(QuestionInfo *)question
{
    _isEditingState = YES;
    
    self.groupView.hidden = YES;
    
    self.question = [[QuestionInfo alloc] initWithQuestion:question];
    
    _responsePos = self.question.responsePositive;
    _responseNag = self.question.responseNagative;
    
    [self showQuestionInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void) showQuestionInfo
{
    self.txtQuestion.text = self.question.question;
    self.txtSymbol.text = self.question.symbol;
    self.txtOption.text = self.question.answer;
    self.txtSumQuestion.text = self.question.sumQuestion;
    
    GroupInfo *group = [[DataManager shareDataManager] getGroup:self.question.groupId];
    self.txtGroupTitle.text = group.groupTitle;
    
    [self updateButtons];
}

- (void) onTap:(UITapGestureRecognizer *)gesture
{
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    
    if(self.pickerView.tag == 0)
    {
        GroupInfo *groupInfo = [[DataManager shareDataManager].aryGroups objectAtIndex:index];
        self.txtGroupTitle.text = groupInfo.groupTitle;
    }
    else
    {
        self.txtOption.text = [[DataManager shareDataManager].aryQuestionOptions objectAtIndex:index];
    }
    
    self.groupView.hidden = YES;
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate cancelEditQuestion:self];
}

- (IBAction)onDone:(id)sender
{
    NSString *squestion = self.txtQuestion.text;
    NSString *symbol = self.txtSymbol.text;
    NSString *answer = self.txtOption.text;
    NSString *sumQuestion = self.txtSumQuestion.text;
    
    if(squestion.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please add a valid data." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    self.question.question = squestion;
    self.question.answer = answer;
    self.question.sumQuestion = sumQuestion;
    
    self.question.responsePositive = _responsePos;
    self.question.responseNagative = _responseNag;
    
    self.question.symbol = symbol;
    
    if(_isEditingState)
        [self.delegate doneEditQuestion:self question:self.question];
    else
        [self.delegate doneNewQuestion:self question:self.question];
}

- (IBAction)onStrike:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    BOOL selected = [button isSelected];
    
    [button setSelected:!selected];
    
    [self.btnHardShip setImage:[UIImage imageNamed:(self.btnHardShip.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
    [self.btnCause setImage:[UIImage imageNamed:(self.btnCause.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
    [self.btnDemographic setImage:[UIImage imageNamed:(self.btnDemographic.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
}

- (IBAction)onResponsePos:(id)sender
{
    int tag = (int)((UIButton *)sender).tag;
    
    _responsePos = tag;
    
    [self updateButtons];
}

- (IBAction)onResponseNag:(id)sender
{
    int tag = (int)((UIButton *)sender).tag;
    
    _responseNag = tag;
    
    [self updateButtons];
}

- (void) updateButtons
{
    if(_responseNag == -1 && _responsePos == -1)
    {
        _viewYesNoOption.hidden = YES;
        _lblNoAvailable.hidden = NO;
    }
    else
    {
        _viewYesNoOption.hidden = NO;
        _lblNoAvailable.hidden = YES;
    }
    
    if(_responsePos == 0)
    {
        [self.btnPosYes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnPosNo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else if(_responsePos == 1)
    {
        [self.btnPosYes setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnPosNo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnPosYes setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnPosNo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if(_responseNag == 0)
    {
        [self.btnNagYes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnNagNo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else if(_responseNag == 1)
    {
        [self.btnNagYes setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnNagNo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnNagYes setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnNagNo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

#pragma mark UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
        return [DataManager shareDataManager].aryGroups.count;
    
    return [DataManager shareDataManager].aryQuestionOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
    {
        GroupInfo *groupInfo = [[DataManager shareDataManager].aryGroups objectAtIndex:row];
        
        return groupInfo.groupTitle;
    }
    else
    {
        return [[DataManager shareDataManager].aryQuestionOptions objectAtIndex:row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
    {
        GroupInfo *groupInfo = [[DataManager shareDataManager] getGroupWithIndex:row];
        
        self.txtGroupTitle.text = groupInfo.groupTitle;
        
        self.question.groupId = groupInfo.groupId;
    }
    else
    {
        self.txtOption.text = [[DataManager shareDataManager].aryQuestionOptions objectAtIndex:row];
    }
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtGroupTitle)
    {
        self.pickerView.tag = 0;
        self.groupView.frame = CGRectMake(30, 216, 477, self.groupView.frame.size.height);
        self.groupView.hidden = NO;
        
        [self.pickerView reloadComponent:0];
        
        return NO;
    }
    else if(textField == self.txtOption)
    {
        self.pickerView.tag = 1;
        self.groupView.frame = CGRectMake(30, 108, 204, self.groupView.frame.size.height);
        self.groupView.hidden = NO;
        
        [self.pickerView reloadComponent:0];
        
        return NO;
    }
    
    return YES;
}

@end
