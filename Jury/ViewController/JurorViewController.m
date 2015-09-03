//
//  JurorViewController.m
//  Jury
//
//  Created by wuyinsong on 14-1-13.
//  Copyright (c) 2014年 Alioth. All rights reserved.
//

#import "JurorViewController.h"

#import "JurorIndividualViewController.h"

#import "DataManager.h"

#import "LocalJurorInfo.h"

#import "EditLocalJurorView.h"

@interface JurorViewController ()<EditLocalJurorViewDelegate>
{
    
}

@property (nonatomic, assign) IBOutlet UITableView *tvJurors;

@property (nonatomic, retain) EditLocalJurorView *editJurorView;

- (IBAction)onAddNewJuror:(id)sender;
- (IBAction)onEmailAll:(id)sender;

@end

@implementation JurorViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"JurorIndividual"])
    {
        JurorIndividualViewController *jurorIndividualViewController = segue.destinationViewController;
        jurorIndividualViewController.juror = sender;
    }
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tvJurors reloadData];
}

- (IBAction)onAddNewJuror:(id)sender
{
    if(self.editJurorView == nil)
    {
        self.editJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"EditLocalJurorView" owner:self options:nil] objectAtIndex:0];
        self.editJurorView.frame = CGRectMake(0, 0, self.editJurorView.frame.size.width, self.editJurorView.frame.size.height);
        self.editJurorView.delegate = self;
        
        [self.view addSubview:self.editJurorView];
    }
    
    self.editJurorView.hidden = NO;
    
    [self.editJurorView _init];
    [self.view bringSubviewToFront:self.editJurorView];
}

- (IBAction)onEmailAll:(id)sender
{
    
}

- (void) editJuror:(LocalJurorInfo *)juror
{
    if(self.editJurorView == nil)
    {
        self.editJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"EditLocalJurorView" owner:self options:nil] objectAtIndex:0];
        self.editJurorView.frame = CGRectMake(0, 0, self.editJurorView.frame.size.width, self.editJurorView.frame.size.height);
        self.editJurorView.delegate = self;
        
        [self.view addSubview:self.editJurorView];
    }
    
    self.editJurorView.hidden = NO;
    
    [self.editJurorView _initWithJuror:juror];
    [self.view bringSubviewToFront:self.editJurorView];
}

- (void) onDeleteJuror:(id)sender
{
    int index = (int)((UIButton *)sender).tag;
    
    [[DataManager shareDataManager] deleteLocalJuror:index];
    
    [self.tvJurors reloadData];
}

- (void) onViewJuror:(id)sender
{
    NSInteger index = ((UIButton *)sender).tag;
    
    LocalJurorInfo *juror = [[DataManager shareDataManager].aryLocalJurors objectAtIndex:index];
    
    [self editJuror:juror];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [DataManager shareDataManager].aryLocalJurors.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        LocalJurorInfo *juror = [[DataManager shareDataManager].aryLocalJurors objectAtIndex:indexPath.row];
        
        cell.textLabel.text = @"";
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 60)];
        lblName.tag = 5;
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.text = juror.name;
        
        [cell.contentView addSubview:lblName];
        
        UILabel *lblEmail = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 250, 60)];
        lblEmail.tag = 6;
        lblEmail.textAlignment = NSTextAlignmentCenter;
        lblEmail.backgroundColor = [UIColor clearColor];
        lblEmail.text = juror.email;
        
        [cell.contentView addSubview:lblEmail];
        
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(750, 0, 80, 60)];
        btnDelete.tag = indexPath.row;
        [btnDelete addTarget:self action:@selector(onDeleteJuror:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [btnDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnDelete setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [cell.contentView addSubview:btnDelete];
        
        UIButton *btnView = [[UIButton alloc] initWithFrame:CGRectMake(830, 0, 80, 60)];
        btnView.tag = indexPath.row;
        [btnView addTarget:self action:@selector(onViewJuror:) forControlEvents:UIControlEventTouchUpInside];
        [btnView setTitle:@"View" forState:UIControlStateNormal];
        [btnView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [cell.contentView addSubview:btnView];
    }
    else
    {
        LocalJurorInfo *juror = [[DataManager shareDataManager].aryLocalJurors objectAtIndex:indexPath.row];
        
        cell.textLabel.text = @"";
        
        UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:5];
        lblName.text = juror.name;
        
        UILabel *lblEmail = (UILabel *)[cell.contentView viewWithTag:6];
        lblEmail.text = juror.email;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LocalJurorInfo *juror = [[DataManager shareDataManager].aryLocalJurors objectAtIndex:indexPath.row];
//    
//    [self performSegueWithIdentifier:@"JurorIndividual" sender:juror];
}

#pragma mark EditLocalJurorViewDelegate

- (void) onDoneEditLocalJuror:(UIView *)view juror:(LocalJurorInfo *)juror
{
    [[DataManager shareDataManager] addLocalJuror:juror];
    
    self.editJurorView.hidden = YES;
    
    [self.tvJurors reloadData];
}

- (void) onCancelEditLocalJuror:(UIView *)view
{
    self.editJurorView.hidden = YES;
}

@end
