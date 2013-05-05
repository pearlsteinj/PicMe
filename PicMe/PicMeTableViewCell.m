//
//  PicMeTableViewCell.m
//  PicMe
//
//  Created by Josh Pearlstein on 5/2/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import "PicMeTableViewCell.h"

@implementation PicMeTableViewCell
@synthesize title,subtitle,image,imageView,picSubtitle,picTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) layoutSubviews{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setNewImage:(UIImage *)newImage{
    imageView = [[UIImageView alloc]init];
    imageView.image = newImage;
}
-(void)setTitle:(NSString *)newTitle{
    title = [[UILabel alloc]init];
    title.text= newTitle;
}
-(void)setSubtitle:(NSString *)newSubtitle{
    subtitle = [[UILabel alloc]init];
    subtitle.text = newSubtitle;
}
@end
