//
//  SaveQuestionaireView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "SaveQuestionaireView.h"

#import "DataManager.h"
#import "SampleQuestions.h"

#import <QuartzCore/QuartzCore.h>

@interface SaveQuestionaireView()
{

}

@property (nonatomic, assign) IBOutlet UITextField *txtName;
@property (nonatomic, assign) IBOutlet UITextView *txtDescription;

- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;

@end

@implementation SaveQuestionaireView

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

}

- (IBAction)onCancel:(id)sender
{
    self.hidden = YES;
}

- (IBAction)onSave:(id)sender
{
    NSString *name = self.txtName.text;
    NSString *description = self.txtDescription.text;
    
    if(name.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input a questionaire's name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    [[SampleQuestions shareSampleQuestions] saveCurrentQuestionsToQuestionaire:name description:description];
    
    self.hidden = YES;
}

@end
