//
//  PicMeDetailViewController.m
//  PicMe
//
//  Created by Josh Pearlstein on 5/2/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import "PicMeDetailViewController.h"

@interface PicMeDetailViewController ()

@end

@implementation PicMeDetailViewController
@synthesize imageView,object,title,tableView,commentField,comments,stayup,objectID;
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
    [self.tableView setOpaque:NO];
    UIImage *image = [UIImage imageWithData:[[object objectForKey:@"picture"] getData]];
    
    imageView.image = image;
    CALayer *layer = imageView.layer;
    [layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [layer setBorderWidth:8.0f];
    [layer setShadowColor: [[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.9f];
    [layer setShadowOffset: CGSizeMake(1, 3)];
    [layer setShadowRadius:4.0];
    [imageView setClipsToBounds:NO];
    title.text = [object objectForKey:@"title"];
    objectID = [object objectId];
    NSLog(@"%@",objectID);
    PFQuery *query = [PFQuery queryWithClassName:@"comments"];
    [query whereKey:@"Identifier" equalTo:objectID];
    [query orderByDescending:@"createdAt"];
    comments = [[query findObjects] mutableCopy];
    NSLog(@"wooo %x",[comments count]);
    commentField.delegate = self;
    
    tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setImage: (PFObject *)newObject{
     object = newObject;
}
#pragma mark - UITableViewDataSource methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    PFObject *temp  = self.comments[indexPath.row];
    [temp fetchIfNeeded];
    cell.textLabel.text = [temp objectForKey:@"comment"];
    cell.detailTextLabel.text = [temp objectForKey:@"createdAt"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Testing: %x",[comments count]);
    return [self.comments count];
}

- (IBAction)submitComment:(id)sender {
    NSString *comment = commentField.text;
    PFObject *newComment = [[PFObject alloc]initWithClassName:@"comments"];
    [newComment setObject:comment forKey:@"comment"];
    NSLog(@"%@",objectID);
    [newComment setObject:objectID forKey:@"Identifier"];
    [newComment save];
    PFQuery *query = [PFQuery queryWithClassName:@"comments"];
    [query whereKey:@"Identifier" equalTo:objectID];
    [query orderByDescending:@"createdAt"];
    comments = [[query findObjects] mutableCopy];
    [self.tableView reloadData];
    [self.commentField resignFirstResponder];
    [self.commentField setText:@""];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [self setViewMoveUp:NO];
}


- (void)keyboardWillShow:(NSNotification *)notif{
    [self setViewMoveUp:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    stayup = YES;
    [self setViewMoveUp:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    stayup = NO;
    [self setViewMoveUp:NO];
}

-(void)setViewMoveUp:(BOOL)moveUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
    if (moveUp)
    {
        if (rect.origin.y == 0 ) {
            rect.origin.y -= 220;
        }
        
    }
    else
    {
        if (stayup == NO) {
            rect.origin.y += 220;
        }
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
