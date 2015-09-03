//
//  SurveyView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "NewSurveyView.h"

#import "DataManager.h"
#import "CaseInfo.h"

@interface NewSurveyView()
{
    BOOL _isEditingState;
}

@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

@property (nonatomic, assign) IBOutlet UITextField *txtCaseName;
@property (nonatomic, assign) IBOutlet UITextField *txtCaseNumber;
@property (nonatomic, assign) IBOutlet UITextField *txtCaseLocation;
@property (nonatomic, assign) IBOutlet UITextField *txtCaseJurors;

@property (nonatomic, assign) IBOutlet UITextField *txtJurorWidth;
@property (nonatomic, assign) IBOutlet UITextField *txtJurorHeight;


@property (nonatomic, retain) CaseInfo *caseInfo;

- (IBAction)onCancel:(id)sender;
- (IBAction)onContinue:(id)sender;

@end

@implementation NewSurveyView

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
    self.caseInfo = nil;
    
    self.txtCaseName.text = @"";
    self.txtCaseNumber.text = @"";
    self.txtCaseLocation.text = @"";
    self.txtCaseJurors.text = @"0";
    self.txtJurorWidth.text = @"8";
    self.txtJurorHeight.text = @"5";
    
    _isEditingState = NO;
    
    //self.txtCaseNumber.enabled = YES;
    
    self.lblTitle.text = @"New Case";
}

- (void) _init:(CaseInfo *)mySurvey
{
    self.caseInfo = mySurvey;
    
    self.txtCaseName.text = mySurvey.name;
    self.txtCaseNumber.text = mySurvey.number;
    self.txtCaseLocation.text = mySurvey.location;
    self.txtJurorWidth.text = [NSString stringWithFormat:@"%d", mySurvey.columns];
    self.txtJurorHeight.text = [NSString stringWithFormat:@"%d", mySurvey.rows];
    self.txtCaseJurors.text = [NSString stringWithFormat:@"%d", mySurvey.numberOfJurors];
    
    _isEditingState = YES;
    
    //self.txtCaseNumber.enabled = NO;
    
    self.lblTitle.text = @"Edit Case";
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate canceledNewSurvey:self];
}

- (IBAction)onContinue:(id)sender
{
    NSString *name = self.txtCaseName.text;
    NSString *number = self.txtCaseNumber.text;
    NSString *location = self.txtCaseLocation.text;
    int rows = [self.txtJurorHeight.text intValue];
    int columns = [self.txtJurorWidth.text intValue];
    NSString *jurors = self.txtCaseJurors.text;
    
    if(name.length == 0 || number.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please add a valid data." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    if(rows < 0 || columns < 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input the valid number of width and height." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    CaseInfo *newCaseInfo = [[CaseInfo alloc] init];
    
    newCaseInfo.name = name;
    newCaseInfo.number = number;
    newCaseInfo.location = location;
    newCaseInfo.rows = rows;
    newCaseInfo.columns = columns;
    newCaseInfo.numberOfJurors = [jurors intValue];
    
    if(_isEditingState)
        [self.delegate updateSurvey:self old:self.caseInfo new:newCaseInfo];
    else
        [self.delegate addedNewSurvey:self survey:newCaseInfo];
}

@end
