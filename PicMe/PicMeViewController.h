//
//  PicMeViewController.h
//  PicMe
//
//  Created by Josh Pearlstein on 4/22/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicMeViewController : UIViewController <UIImagePickerControllerDelegate,FBFriendPickerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *title;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UITextField *caption;
@property (strong, nonatomic) IBOutlet UIImageView *image_View;
@property (strong,nonatomic) FBFriendPickerViewController *friendPicker;
@property (nonatomic,retain) NSMutableArray *friendsTagged;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *profile_pictures; 
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic,retain) CLLocationManager *location_manager;
@property (nonatomic,retain) CLLocation *location;
@property BOOL *stayup;
- (IBAction)post:(id)sender;
- (IBAction)tagFriends:(id)sender;
@end
