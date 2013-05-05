//
//  PicMeMyPicsViewController.m
//  PicMe
//
//  Created by Josh Pearlstein on 5/3/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import "PicMeMyPicsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PicMeDetailViewController.h"
@interface PicMeMyPicsViewController ()

@end

@implementation PicMeMyPicsViewController

@synthesize tableView,pictures,index;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    UIImage *pattern = [UIImage imageNamed:@"dark_fish_skin.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:pattern];
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed: 70.0/255.0 green: 130.0/255.0 blue:200.0/255.0 alpha: 1.0]];
    self.navigationController.navigationBar.topItem.title = @"PicMe";
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed: 70.0/255.0 green: 130.0/255.0 blue:200.0/255.0 alpha: 1.0]];
    
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed: 120.0/255.0 green: 180.0/255.0 blue:250.0/255.0 alpha: 1.0]];
    PFQuery *query = [PFQuery queryWithClassName:@"Pictures"];
    [query orderByDescending:@"createdAt"];
    pictures = [query findObjects];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    NSString *t = [[PFUser currentUser]objectForKey:@"facebookID"];
    for(PFObject *obj in pictures){
        for(NSString *id1 in [obj objectForKey:@"tagged"]){
            if([id1 isEqualToString:t]){
                [temp addObject:obj];
                break;
            }
        }
    }
    pictures = temp;
    if(!([PFUser currentUser] && // Check if a user is cached
         [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])){
        [self performSegueWithIdentifier:@"logIn" sender:self];
    }
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *myPics = [[UIBarButtonItem alloc] initWithTitle:@"My Pictures" style:UIBarButtonItemStyleBordered target:nil action:@selector(myPics)];
    self.navigationItem.rightBarButtonItem= myPics;
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to Refresh"];
    refresh.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlRequest) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refresh];
}
-(void)refreshControlRequest{
    NSLog(@"Here");
    [self performSelector:@selector(refreshMyView)withObject:nil];
    [[self refreshControl]endRefreshing];
}
-(void)refreshMyView{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    NSLog(@"Here");
    PFQuery *query = [PFQuery queryWithClassName:@"Pictures"];
    [query orderByDescending:@"createdAt"];
    pictures = [query findObjects];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    NSString *t = [[PFUser currentUser]objectForKey:@"facebookID"];
    for(PFObject *obj in pictures){
        for(NSString *id1 in [obj objectForKey:@"tagged"]){
            if([id1 isEqualToString:t]){
                [temp addObject:obj];
                break;
            }
        }
    }
    pictures = temp;
    [self.tableView reloadData];
    [[self refreshControl]endRefreshing];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    PFObject *temp  = self.pictures[indexPath.row];
    [temp fetchIfNeeded];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = [temp objectForKey:@"title"];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:101];
    label2.text = [temp objectForKey:@"caption"];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:10];
    CALayer *layer = image.layer;
    [layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [layer setBorderWidth:8.0f];
    [layer setShadowColor: [[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.9f];
    [layer setShadowOffset: CGSizeMake(1, 3)];
    [layer setShadowRadius:4.0];
    [image setClipsToBounds:NO];
    image.image = [UIImage imageWithData:[[temp objectForKey:@"picture"] getData]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [pictures count];
}

#pragma mark - UITableView DataSource Methods



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if(![segue.identifier isEqualToString:@"logIn"]){
        PicMeDetailViewController *controller = (PicMeDetailViewController *)[segue destinationViewController];
        [controller setObject:pictures[[self.tableView indexPathForSelectedRow].row]];
        index=nil;
    }
    
}
@end
