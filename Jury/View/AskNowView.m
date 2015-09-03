//
//  AskNowView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "AskNowView.h"

#import "DataManager.h"
#import "QuestionInfo.h"

@interface AskNowView()<UITextFieldDelegate>
{

}

@property (nonatomic, assign) IBOutlet UITableView *tvQuestions;

- (IBAction)onCancel:(id)sender;
- (IBAction)onNew:(id)sender;

@end

@implementation AskNowView

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
    [self.tvQuestions reloadData];
}

- (IBAction)onCancel:(id)sender
{
    self.hidden = YES;
}

- (IBAction)onNew:(id)sender
{
    self.hidden = YES;
    
    [self.delegate onAskNowWithNew];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [DataManager shareDataManager].aryLocalQuestions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d",  indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    QuestionInfo *question = [[DataManager shareDataManager].aryLocalQuestions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = question.question;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate onAskNowWithIsAlreadyQuestion:indexPath.row];
    
    self.hidden = YES;
}

@end
