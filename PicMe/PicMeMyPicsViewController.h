//
//  PicMeMyPicsViewController.h
//  PicMe
//
//  Created by Josh Pearlstein on 5/3/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicMeMyPicsViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *pictures;
@property (nonatomic,retain) NSIndexPath *index;
@end
