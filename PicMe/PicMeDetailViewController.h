//
//  PicMeDetailViewController.h
//  PicMe
//
//  Created by Josh Pearlstein on 5/2/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface PicMeDetailViewController : UIViewController <UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) PFObject *object;
-(void)setObject: (PFObject *)newObject;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UITextField *commentField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *comments;
@property (strong,nonatomic) NSString *objectID;
@property BOOL stayup;
- (IBAction)submitComment:(id)sender;
@end
