//
//  PicMeTableViewCell.h
//  PicMe
//
//  Created by Josh Pearlstein on 5/2/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicMeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *subtitle;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSString *picTitle;
@property (strong,nonatomic) NSString *picSubtitle;

-(void)setNewImage:(UIImage *)newImage;
-(void)setTitle:(NSString *)title;
-(void)setSubtitle:(NSString *)subtitle;
@end
