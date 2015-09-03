//
//  JurorResponseView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "JurorResponseView.h"

#import "DataManager.h"
#import "CaseInfo.h"

#import "QuestionInfo.h"
#import "LocalJurorInfo.h"

#import <QuartzCore/QuartzCore.h>

@interface JurorResponseView()
{

}

@property (nonatomic, assign) IBOutlet UILabel *lblQuestion;
@property (nonatomic, assign) IBOutlet UITextView *tvResponse;

@property (nonatomic, assign) IBOutlet UILabel *lblWeight;

@property (nonatomic, assign) IBOutlet UISlider *sldWeight;

@property (nonatomic, retain) LocalJurorInfo *juror;

@property (nonatomic, retain) QuestionInfo *question;

- (IBAction)onCancel:(id)sender;
- (IBAction)onOk:(id)sender;

- (IBAction)onSliderChange:(id)sender;

@end

@implementation JurorResponseView

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
    self.lblQuestion.text = @"";
    self.tvResponse.text = @"";
}

- (void) _init:(LocalJurorInfo *)juror question:(QuestionInfo *)question
{
    self.juror = juror;
    self.question = question;
    
    self.lblQuestion.text = question.question;
    
    NSMutableDictionary *responseData = [[DataManager shareDataManager] getResponseWithJuror:self.juror.tid question:question];
    
    if(responseData)
    {
        self.tvResponse.text = [responseData objectForKey:@"response"];
        self.lblWeight.text = [NSString stringWithFormat:@"%d", (int)[[responseData objectForKey:@"weight"] floatValue]];
        
        self.sldWeight.value = [[responseData objectForKey:@"weight"] floatValue];
    }
    else
    {
        self.tvResponse.text = @"";
        self.lblWeight.text = @"0";
        
        self.sldWeight.value = 0.0f;
    }
}

- (IBAction)onCancel:(id)sender
{
    [self.tvResponse resignFirstResponder];
    
    [self.delegate cancelJurorResponse];
    
    self.hidden = YES;
}

- (IBAction)onOk:(id)sender
{
    [self.tvResponse resignFirstResponder];
    
    NSString *response = self.tvResponse.text;
    
    if(response.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please add the answer." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    self.hidden = YES;
    
    [[DataManager shareDataManager] addResponse:self.juror.tid question:self.question response:self.tvResponse.text weight:self.sldWeight.value];
    
    [self.delegate doneJurorResponse:self.juror.tid response:response];
}

- (IBAction)onSliderChange:(id)sender
{
    int value = ((UISlider *)sender).value;
    
    self.lblWeight.text = [NSString stringWithFormat:@"%d", value];
}

@end
