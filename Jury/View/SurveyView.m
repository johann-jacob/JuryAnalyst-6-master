//
//  SurveyView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "SurveyView.h"

#import "DataManager.h"
#import "CaseInfo.h"

#import <QuartzCore/QuartzCore.h>

@interface SurveyView()
{
    int _index;
}

@property (nonatomic, assign) IBOutlet UILabel *lblTitle;
@property (nonatomic, assign) IBOutlet UILabel *lblSid;
@property (nonatomic, assign) IBOutlet UILabel *lblAmountOfJuror;
@property (nonatomic, assign) IBOutlet UILabel *lblLocation;

- (IBAction)onClick:(id)sender;

@end

@implementation SurveyView

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


- (void) setSurvey:(int)index
{
    _index = index;
    
    if(index < [DataManager shareDataManager].aryMySurveys.count)
    {
        CaseInfo *mysuryvey = [[DataManager shareDataManager] getMySurvey:index];
        
        if(mysuryvey != nil)
        {
            self.lblSid.text = mysuryvey.number;
            self.lblTitle.text = mysuryvey.name;
            self.lblLocation.text = mysuryvey.location;
            self.lblAmountOfJuror.text = [NSString stringWithFormat:@"%d", mysuryvey.numberOfJurors];
        }
        else
        {
            self.lblSid.text = @"0";
            self.lblTitle.text = @"";
            self.lblLocation.text = @"";
            self.lblAmountOfJuror.text = @"0";
        }
    }
}

- (IBAction)onClick:(id)sender
{
    [self.delegate selectSurvey:self index:_index];
}

@end
