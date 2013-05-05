//
//  PicMeLoginViewController.h
//  PicMe
//
//  Created by Josh Pearlstein on 4/22/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicMeLoginViewController : UIViewController
@property (nonatomic,retain) NSMutableData *_imageData;
@property (nonatomic,retain) UIImage *profile_picture;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
- (IBAction)logIn:(id)sender;

@end
