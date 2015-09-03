//
//  PersonalityProfileView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "PersonalityProfileView.h"

#import "DataManager.h"
#import "SettingManager.h"

#import <QuartzCore/QuartzCore.h>

@interface PersonalityProfileView()<UIAlertViewDelegate>
{
    int pageIndex;
    
    int pageDummyIndex;
    
    int pageCount;
}

@property (nonatomic, assign) IBOutlet UIPageControl *pgPages;

@property (nonatomic, assign) IBOutlet UILabel *lblComment;

@property (nonatomic, assign) IBOutlet UILabel *lblQuestion1;
@property (nonatomic, assign) IBOutlet UILabel *lblAnswer11;
@property (nonatomic, assign) IBOutlet UILabel *lblAnswer12;

@property (nonatomic, assign) IBOutlet UIButton *btnAnswer11;
@property (nonatomic, assign) IBOutlet UIButton *btnAnswer12;

@property (nonatomic, assign) IBOutlet UILabel *lblQuestion2;
@property (nonatomic, assign) IBOutlet UILabel *lblAnswer21;
@property (nonatomic, assign) IBOutlet UILabel *lblAnswer22;

@property (nonatomic, assign) IBOutlet UIButton *btnAnswer21;
@property (nonatomic, assign) IBOutlet UIButton *btnAnswer22;

@property (nonatomic, assign) IBOutlet UILabel *lblQuestion3;
@property (nonatomic, assign) IBOutlet UILabel *lblAnswer31;
@property (nonatomic, assign) IBOutlet UILabel *lblAnswer32;

@property (nonatomic, assign) IBOutlet UIButton *btnAnswer31;
@property (nonatomic, assign) IBOutlet UIButton *btnAnswer32;

@property (weak, nonatomic) IBOutlet UILabel *lblQuestion4;
@property (weak, nonatomic) IBOutlet UILabel *lblAnswer41;
@property (weak, nonatomic) IBOutlet UILabel *lblAnswer42;


@property (weak, nonatomic) IBOutlet UIButton *btnAnswer41;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer42;

// The N/A Section
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer13;
@property (weak, nonatomic) IBOutlet UILabel *lblAnswer13;


@property (weak, nonatomic) IBOutlet UILabel *lblAnswer23;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer23;

@property (weak, nonatomic) IBOutlet UILabel *lblAnswer33;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer33;

@property (weak, nonatomic) IBOutlet UILabel *lblAnswer43;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer43;

@property (nonatomic, assign) IBOutlet UIButton *btnPrevious;
@property (nonatomic, assign) IBOutlet UIButton *btnNext;

@property (nonatomic, retain) NSMutableArray *aryResult;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDone:(id)sender;

- (IBAction)onNext:(id)sender;
- (IBAction)onPreview:(id)sender;

- (IBAction)onAnswer:(id)sender;

@end

@implementation PersonalityProfileView

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

- (void) _initWithPersonalData:(NSMutableArray *)aryPersonalData
{
    pageCount = [self getRealPageCount];
    
    if(pageCount == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no personality data." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    self.pgPages.numberOfPages = pageCount;
    pageDummyIndex = 0;
    
    pageIndex = [self getPageIndexFromDummy:pageDummyIndex];
    
    if(aryPersonalData == nil)
    {
        self.aryResult = [[NSMutableArray alloc] init];
    }
    else
    {
        self.aryResult = aryPersonalData;
    }
    
    [self updateUI];
}

- (int) getRealPageCount
{
    int count = 0;
    if([SettingManager shareSettingManager].isEXnotIN)
        count ++;
    
    if([SettingManager shareSettingManager].isYEnotCN)
        count ++;
    
    if([SettingManager shareSettingManager].isSEnotIN)
        count ++;
    
    if([SettingManager shareSettingManager].isTHnotFE)
        count ++;
    
    if([SettingManager shareSettingManager].isPEnotJU)
        count ++;
    
    return count;
}

- (int) getPageIndexFromDummy:(int)dummyIndex
{
    int count = -1;
    if([SettingManager shareSettingManager].isEXnotIN)
        count ++;
    
    if(dummyIndex == count)
        return 0;
    
    if([SettingManager shareSettingManager].isYEnotCN)
        count ++;
    
    if(dummyIndex == count)
        return 1;
    
    if([SettingManager shareSettingManager].isSEnotIN)
        count ++;
    
    if(dummyIndex == count)
        return 2;
    
    if([SettingManager shareSettingManager].isTHnotFE)
        count ++;
    
    if(dummyIndex == count)
        return 3;
    
    if([SettingManager shareSettingManager].isPEnotJU)
        count ++;
    
    if(dummyIndex == count)
        return 4;
    
    return -1;
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate onCancelPersonalityProfile];
}

- (IBAction)onDone:(id)sender
{
    [self getResult];
    
    [self.delegate onDonePersonalityProfile:self.aryResult];
}

- (IBAction)onNext:(id)sender
{
    [self getResult];
    
    pageDummyIndex ++;
    pageDummyIndex  = MIN(pageCount - 1, pageDummyIndex);
    
    pageIndex = [self getPageIndexFromDummy:pageDummyIndex];
    
    [self updateUI];
}

- (IBAction)onPreview:(id)sender
{
    [self getResult];
    
    pageDummyIndex --;
    pageDummyIndex = MAX(0, pageDummyIndex);
    
    pageIndex = [self getPageIndexFromDummy:pageDummyIndex];
    
    [self updateUI];
}

- (IBAction)onAnswer:(id)sender
{
    int tag = (int)((UIButton *)sender).tag;
    
    [self updateOptionButton:tag];
}

- (void) updateOptionButton:(int)index
{
    NSLog(@"Index %d", index);
    switch (index) {
        case 0:
        {
            [self.btnAnswer11 setSelected:YES];
            [self.btnAnswer12 setSelected:NO];
            [self.btnAnswer13 setSelected:NO];
            [self.btnAnswer11 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer12 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer13 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
            
        case 1:
        {
            [self.btnAnswer11 setSelected:NO];
            [self.btnAnswer12 setSelected:YES];
            [self.btnAnswer13 setSelected:NO];
            [self.btnAnswer11 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer12 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer13 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
            
        case 2:
        {
            [self.btnAnswer11 setSelected:NO];
            [self.btnAnswer12 setSelected:NO];
            [self.btnAnswer13 setSelected:YES];
            [self.btnAnswer11 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer12 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer13 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
        }
            break;
            
        case 3:
        {
            [self.btnAnswer21 setSelected:YES];
            [self.btnAnswer22 setSelected:NO];
            [self.btnAnswer23 setSelected:NO];
            [self.btnAnswer21 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer22 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer23 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
            
        case 4:
        {
            [self.btnAnswer21 setSelected:NO];
            [self.btnAnswer22 setSelected:YES];
            [self.btnAnswer23 setSelected:NO];
            [self.btnAnswer21 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer22 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer23 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
        
        case 5:
        {
            [self.btnAnswer21 setSelected:NO];
            [self.btnAnswer22 setSelected:NO];
            [self.btnAnswer23 setSelected:YES];
            [self.btnAnswer21 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer22 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer23 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
        }
            break;
            
        case 6:
        {
            [self.btnAnswer31 setSelected:YES];
            [self.btnAnswer32 setSelected:NO];
            [self.btnAnswer33 setSelected:NO];
            [self.btnAnswer31 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer32 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer33 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
            
        case 7:
        {
            [self.btnAnswer31 setSelected:NO];
            [self.btnAnswer32 setSelected:YES];
            [self.btnAnswer33 setSelected:NO];
            [self.btnAnswer31 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer32 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer33 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
        
        case 8:
        {
            [self.btnAnswer31 setSelected:NO];
            [self.btnAnswer32 setSelected:NO];
            [self.btnAnswer33 setSelected:YES];
            [self.btnAnswer31 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer32 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer33 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
        }
            break;
            
        case 9:
        {
            [self.btnAnswer41 setSelected:YES];
            [self.btnAnswer42 setSelected:NO];
            [self.btnAnswer43 setSelected:NO];
            [self.btnAnswer41 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer42 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer43 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
            
        case 10:
        {
            [self.btnAnswer41 setSelected:NO];
            [self.btnAnswer42 setSelected:YES];
            [self.btnAnswer43 setSelected:NO];
            [self.btnAnswer41 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer42 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
            [self.btnAnswer43 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
        }
            break;
        
        case 11:
        {
            [self.btnAnswer41 setSelected:NO];
            [self.btnAnswer42 setSelected:NO];
            [self.btnAnswer43 setSelected:YES];
            [self.btnAnswer41 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer42 setImage:[UIImage imageNamed:@"image_uncheck"] forState:UIControlStateNormal];
            [self.btnAnswer43 setImage:[UIImage imageNamed:@"image_check"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void) updateUI
{
    self.pgPages.currentPage = pageDummyIndex;
    
    self.btnPrevious.hidden = (pageDummyIndex == 0);
    self.btnNext.hidden = (pageDummyIndex == (pageCount - 1));
    
    NSDictionary *groupOriginData = nil;
    for (NSDictionary *dic in self.aryResult) {
        
        int groupIndex = [[dic objectForKey:@"group"] intValue];
        
        if(groupIndex == pageIndex)
        {
            groupOriginData = dic;
            
            break;
        }
    }
    
    if(groupOriginData == nil)
    {
        [self updateOptionButton:2];
        [self updateOptionButton:5];
        [self updateOptionButton:8];
        [self updateOptionButton:11];
    }
    else
    {
        int answer1 = [[groupOriginData objectForKey:@"answer1"] intValue];
        [self updateOptionButton:answer1];
        int answer2 = [[groupOriginData objectForKey:@"answer2"] intValue];
        [self updateOptionButton:(3 + answer2)];
        int answer3 = [[groupOriginData objectForKey:@"answer3"] intValue];
        [self updateOptionButton:(6 + answer3)];
        int answer4 = [[groupOriginData objectForKey:@"answer4"] intValue];
        [self updateOptionButton:(9 + answer4)];
    }
    
    NSArray *groupData = [[DataManager shareDataManager].aryPersonalityProfileData objectAtIndex:pageIndex];
    
    NSDictionary *quesitonData1 = [groupData objectAtIndex:0];
    
    NSString *question1 = [[quesitonData1 allKeys] objectAtIndex:0];
    self.lblQuestion1.text = question1;
    
    NSArray *answers1 = [quesitonData1 objectForKey:question1];
    self.lblAnswer11.text = [[[answers1 objectAtIndex:0] allKeys] objectAtIndex:0];
    self.lblAnswer12.text = [[[answers1 objectAtIndex:1] allKeys] objectAtIndex:0];
    
    //-------------------------------------------
    
    NSDictionary *quesitonData2 = [groupData objectAtIndex:1];
    
    NSString *question2 = [[quesitonData2 allKeys] objectAtIndex:0];
    self.lblQuestion2.text = question2;
    
    NSArray *answers2 = [quesitonData2 objectForKey:question2];
    self.lblAnswer21.text = [[[answers2 objectAtIndex:0] allKeys] objectAtIndex:0];
    self.lblAnswer22.text = [[[answers2 objectAtIndex:1] allKeys] objectAtIndex:0];
    
    //-------------------------------------------
    
    NSDictionary *quesitonData3 = [groupData objectAtIndex:2];
    
    NSString *question3 = [[quesitonData3 allKeys] objectAtIndex:0];
    self.lblQuestion3.text = question3;
    
    NSArray *answers3 = [quesitonData3 objectForKey:question3];
    self.lblAnswer31.text = [[[answers3 objectAtIndex:0] allKeys] objectAtIndex:0];
    self.lblAnswer32.text = [[[answers3 objectAtIndex:1] allKeys] objectAtIndex:0];
    
    //-------------------------------------------
    if ([groupData count] > 3) {
        self.btnAnswer41.hidden = NO;
        self.btnAnswer42.hidden = NO;
        self.btnAnswer43.hidden = NO;
    NSDictionary *quesitonData4 = [groupData objectAtIndex:3];
    
    NSString *question4 = [[quesitonData4 allKeys] objectAtIndex:0];
    self.lblQuestion4.text = question4;
    
    NSArray *answers4 = [quesitonData4 objectForKey:question4];
    self.lblAnswer41.text = [[[answers4 objectAtIndex:0] allKeys] objectAtIndex:0];
    self.lblAnswer42.text = [[[answers4 objectAtIndex:1] allKeys] objectAtIndex:0];
        self.lblAnswer43.text = @"N/A";
    }
    else{
        self.lblQuestion4.text = @"";
        self.lblAnswer41.text = @"";
        self.lblAnswer42.text = @"";
        self.lblAnswer43.text = @"";
        
        self.btnAnswer41.hidden = YES;
        self.btnAnswer42.hidden = YES;
        self.btnAnswer43.hidden = YES;
    }
    //-------------------------------------------
    
    switch (pageIndex) {
        case 0:
            self.lblComment.text = @"Extrovert(EX) -or- Introvert(IN)";
            break;
            
        case 1:
            self.lblComment.text = @"Yeilding(YE) -or- Controlling(CN)";
            break;
            
        case 2:
            self.lblComment.text = @"Modifying(MO) -or- Accommodating(AC)";
            break;
            
        case 3:
            self.lblComment.text = @"Leader(LR) -or- Acquieser(AQ)";
            break;
            
        case 4:
            self.lblComment.text = @"Nurturer(NR) -or- Individuator(ID)";
            break;
            
        default:
            break;
    }
}

- (void) getResult
{
    for (NSDictionary *oldDic in self.aryResult) {
        
        int group = [[oldDic objectForKey:@"group"] intValue];
        
        if(group == pageIndex)
        {
            [self.aryResult removeObject:oldDic];
            
            break;
        }
        
    }
    NSNumber *answer1;
    NSNumber *answer2;
    NSNumber *answer3;
    NSNumber *answer4;
    
    if(self.btnAnswer11.isSelected){
        answer1 = [NSNumber numberWithInt:0];
    }
    else if(self.btnAnswer12.isSelected){
        answer1 = [NSNumber numberWithInt:1];
    }
    else{
        answer1 = [NSNumber numberWithInt:2];
    }
    
    if(self.btnAnswer21.isSelected){
        answer2 = [NSNumber numberWithInt:0];
    }
    else if(self.btnAnswer22.isSelected){
        answer2 = [NSNumber numberWithInt:1];
    }
    else{
        answer2 = [NSNumber numberWithInt:2];
    }
    
    if(self.btnAnswer31.isSelected){
        answer3 = [NSNumber numberWithInt:0];
    }
    else if(self.btnAnswer32.isSelected){
        answer3 = [NSNumber numberWithInt:1];
    }
    else{
        answer3 = [NSNumber numberWithInt:2];
    }
    
    if(self.btnAnswer41.isSelected){
        answer4 = [NSNumber numberWithInt:0];
    }
    else if(self.btnAnswer42.isSelected){
        answer4 = [NSNumber numberWithInt:1];
    }
    else{
        answer4 = [NSNumber numberWithInt:2];
    }
    
    NSLog(@"Answer 1: %@", answer1);
    NSLog(@"Answer 2: %@", answer2);
    NSLog(@"Answer 3: %@", answer3);
    NSLog(@"Answer 4: %@", answer4);
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:pageIndex], @"group",
                         answer1, @"answer1",
                         answer2, @"answer2",
                         answer3, @"answer3",
                        answer4, @"answer4",
                         nil];
    

    [self.aryResult addObject:dic];
    
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self onCancel:nil];
}

@end
