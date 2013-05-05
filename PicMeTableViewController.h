//
//  PicMeTableViewController.h
//  PicMe
//
//  Created by Josh Pearlstein on 5/2/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicMeTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *pictures;
@property (nonatomic,retain) NSIndexPath *index;

@end
