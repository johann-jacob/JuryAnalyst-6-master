//
//  OpenQuestionaireView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "OpenQuestionaireView.h"

#import "DataManager.h"
#import "SampleQuestions.h"

#import <QuartzCore/QuartzCore.h>

@interface OpenQuestionaireView()
{

}

@property (nonatomic, assign) IBOutlet UIScrollView *svQuestionaire;

@property (nonatomic, retain) NSMutableArray *aryCheckButtons;

- (IBAction)onCancel:(id)sender;
- (IBAction)onAdd:(id)sender;

@end

@implementation OpenQuestionaireView

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
    [self loadQuestionaries];
}

- (void) loadQuestionaries
{
    for (UIView *subview in self.svQuestionaire.subviews) {
        [subview removeFromSuperview];
    }
    
    if(self.aryCheckButtons == nil)
    {
        self.aryCheckButtons = [[NSMutableArray alloc] init];
    }
    
    [self.aryCheckButtons removeAllObjects];
    
    CGFloat height = 40;
    NSInteger index = 0;
    
    for (NSMutableDictionary *questionaire in [SampleQuestions shareSampleQuestions].aryQuestionaires) {
        
        NSString *name = [questionaire objectForKey:@"name"];
        NSString *description = [questionaire objectForKey:@"description"];
        
        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, height * index, self.svQuestionaire.frame.size.width, height)];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width * 0.8, height / 2)];
        labelName.backgroundColor = [UIColor clearColor];
        labelName.textColor = [UIColor blackColor];
        labelName.font = [UIFont systemFontOfSize:16];
        labelName.text = name;
        
        [cell addSubview:labelName];
        
        UILabel *labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 2, cell.frame.size.width * 0.8, height / 2)];
        labelDescription.backgroundColor = [UIColor clearColor];
        labelDescription.textColor = [UIColor grayColor];
        labelDescription.font = [UIFont systemFontOfSize:12];
        labelDescription.numberOfLines = 2;
        labelDescription.text = description;
        
        [cell addSubview:labelDescription];
        
        UIButton *btnCheck = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCheck.tag = index;
        [btnCheck addTarget:self action:@selector(onCheck:) forControlEvents:UIControlEventTouchUpInside];
        btnCheck.frame = CGRectMake(0, 0, height / 2, height / 2);
        btnCheck.center = CGPointMake(cell.frame.size.width * 0.9, height / 2);
        [btnCheck setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
        
        [cell addSubview:btnCheck];
        
        [self.aryCheckButtons addObject:btnCheck];
        
        [self.svQuestionaire addSubview:cell];
        
        index ++;
    }
}

- (void) onCheck:(UIButton *)button
{
    BOOL isSelected = !button.isSelected;
    
    [button setSelected:isSelected];
    
    if(isSelected)
    {
        [button setImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)onCancel:(id)sender
{
    self.hidden = YES;
}

- (IBAction)onAdd:(id)sender
{
    for (UIButton *button in self.aryCheckButtons) {
     
        BOOL isSelected = button.isSelected;
        
        if(isSelected)
        {
            NSInteger index = button.tag;
            
            NSMutableDictionary *questionaire = [[SampleQuestions shareSampleQuestions].aryQuestionaires objectAtIndex:index];
            NSString *name = [questionaire objectForKey:@"name"];
            
            [[SampleQuestions shareSampleQuestions] addQuestionaire:name];
        }
    }
    
    [self.delegate onOpenQuestionaire];
    
    self.hidden = YES;
}

@end
