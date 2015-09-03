//
//  EditLocalJurorView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "EditLocalJurorView.h"

#import "DataManager.h"

#import "LocalJurorInfo.h"

@interface EditLocalJurorView()
{
    BOOL _isEditingState;
    
    int _gender;
}

@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

@property (nonatomic, assign) IBOutlet UITextField *txtJurorName;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorAge;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorEducation;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorPoliticalParty;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorOccupation;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorEthnicity;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorNumber;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorOveride;

@property (nonatomic, assign) IBOutlet UIButton *btnMale;
@property (nonatomic, assign) IBOutlet UIButton *btnFemale;

@property (nonatomic, assign) IBOutlet UIView *ethnicityView;
@property (nonatomic, assign) IBOutlet UIPickerView *pickerView;

@property (nonatomic, retain) LocalJurorInfo *juror;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDone:(id)sender;

- (IBAction)onGender:(id)sender;

@end

@implementation EditLocalJurorView

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
    self.juror = [[LocalJurorInfo alloc] init];
    self.juror.tid = [NSString stringWithFormat:@"%d", (int)[DataManager shareDataManager].aryLocalJurors.count];
    
    self.lblTitle.text = @"Add Juror";
    
    [self showJurorInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
    
    _isEditingState = NO;
}

- (void) onTap:(UITapGestureRecognizer *)gesture
{
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    
    if(self.pickerView.tag == 0)
    {
        self.juror.ethnicity = (int)index;
        self.txtJurorEthnicity.text = [[DataManager shareDataManager].aryEthnicity objectAtIndex:index];
    }
    else if(self.pickerView.tag == 1)
    {
        self.juror.education = [[DataManager shareDataManager].aryEducations objectAtIndex:index];
        self.txtJurorEducation.text = [[DataManager shareDataManager].aryEducations objectAtIndex:index];
    }
    else if(self.pickerView.tag == 2)
    {
        self.juror.politicalParty = [[DataManager shareDataManager].aryPolicityPartys objectAtIndex:index];
        self.txtJurorPoliticalParty.text = [[DataManager shareDataManager].aryPolicityPartys objectAtIndex:index];
    }
    
    self.ethnicityView.hidden = YES;
}

- (void) _initWithTID:(NSString *)tid
{
    self.juror = [[LocalJurorInfo alloc] init];
    self.juror.tid = tid;
    
    self.lblTitle.text = @"Edit Juror";
    
    [self showJurorInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
    
    _isEditingState = YES;
}

- (void) _initWithJuror:(LocalJurorInfo *)juror
{
    self.juror = [[LocalJurorInfo alloc] initWithJuror:juror];
    
    self.lblTitle.text = @"Edit Juror";
    
    [self showJurorInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
    
    _isEditingState = YES;
}

- (void) showJurorInfo
{
    self.txtJurorName.text = self.juror.name;
    
    _gender = self.juror.gender;
    
    NSLog(@"Gender %d", _gender);
    
    if(_gender == 0)
    {
        [self.btnMale setImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
        [self.btnFemale setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnMale setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
        [self.btnFemale setImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
    }
    
    self.txtJurorNumber.text = self.juror.personality;
    
    if(self.juror.age < 1)
        self.txtJurorAge.text = @"";
    else
        self.txtJurorAge.text = [NSString stringWithFormat:@"%d", self.juror.age];
    
    self.txtJurorEthnicity.text = [[DataManager shareDataManager].aryEthnicity objectAtIndex:self.juror.ethnicity];
    
    self.txtJurorEducation.text = self.juror.education;
    self.txtJurorPoliticalParty.text = self.juror.politicalParty;
    self.txtJurorOccupation.text = self.juror.occupation;
    self.txtJurorOveride.text = self.juror.overide;
}

- (IBAction)onGender:(id)sender
{
    _gender = (int)((UIButton *)sender).tag;
    
    if(_gender == 0)
    {
        [self.btnMale setImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
        [self.btnFemale setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnMale setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
        [self.btnFemale setImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
    }
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate onCancelEditLocalJuror:self];
}

- (IBAction)onDone:(id)sender
{
    NSString *name = self.txtJurorName.text;
    NSString *education = self.txtJurorEducation.text;
    NSString *politicalParty = self.txtJurorPoliticalParty.text;
    NSString *occupation = self.txtJurorOccupation.text;
    NSString *number = self.txtJurorNumber.text;
    
    int age = [self.txtJurorAge.text intValue];
    
    if(name.length == 0/* || occupation.length == 0 || education.length == 0*/)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please add a valid name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    self.juror.name = name;
    self.juror.personality = number;
    self.juror.education = education;
    self.juror.politicalParty = politicalParty;
    self.juror.occupation = occupation;
    self.juror.age = age;
    self.juror.gender = _gender;
    self.juror.avatarIndex = _gender * 10 + self.juror.ethnicity;
    self.juror.overide = _txtJurorOveride.text;
        
    [self.delegate onDoneEditLocalJuror:self juror:self.juror];
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
        return [DataManager shareDataManager].aryEthnicity.count;
    else if(pickerView.tag == 1)
        return [DataManager shareDataManager].aryEducations.count;
    else if(pickerView.tag == 2)
        return [DataManager shareDataManager].aryPolicityPartys.count;
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
        return [[DataManager shareDataManager].aryEthnicity objectAtIndex:row];
    else if(pickerView.tag == 1)
        return [[DataManager shareDataManager].aryEducations objectAtIndex:row];
    else if(pickerView.tag == 2)
        return [[DataManager shareDataManager].aryPolicityPartys objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 0)
    {
        self.juror.ethnicity = (int)row;
        
        self.txtJurorEthnicity.text = [[DataManager shareDataManager].aryEthnicity objectAtIndex:row];
    }
    else if(pickerView.tag == 1)
    {
        self.juror.education = [[DataManager shareDataManager].aryEducations objectAtIndex:row];
        self.txtJurorEducation.text = [[DataManager shareDataManager].aryEducations objectAtIndex:row];
    }
    else if(pickerView.tag == 2)
    {
        self.juror.politicalParty = [[DataManager shareDataManager].aryPolicityPartys objectAtIndex:row];
        self.txtJurorPoliticalParty.text = [[DataManager shareDataManager].aryPolicityPartys objectAtIndex:row];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtJurorEthnicity)
    {
        self.pickerView.tag = 0;
        
        self.ethnicityView.frame = CGRectMake(self.ethnicityView.frame.origin.x, 195, 305, self.ethnicityView.frame.size.height);
        self.ethnicityView.hidden = NO;
        
        [self.pickerView reloadComponent:0];
        
        return NO;
    }
    else if(textField == self.txtJurorEducation)
    {
        self.pickerView.tag = 1;
        
        self.ethnicityView.frame = CGRectMake(self.ethnicityView.frame.origin.x, 80, 400, self.ethnicityView.frame.size.height);
        self.ethnicityView.hidden = NO;
        
        [self.pickerView reloadComponent:0];
        
        return NO;
    }
    else if(textField == self.txtJurorPoliticalParty)
    {
        self.pickerView.tag = 2;
        
        self.ethnicityView.frame = CGRectMake(self.ethnicityView.frame.origin.x, 150, 400, self.ethnicityView.frame.size.height);
        self.ethnicityView.hidden = NO;
        
        [self.pickerView reloadComponent:0];
        
        return NO;
    }
    
    return YES;
}

@end
