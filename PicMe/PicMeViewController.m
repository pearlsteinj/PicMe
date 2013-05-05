//
//  PicMeViewController.m
//  PicMe
//
//  Created by Josh Pearlstein on 4/22/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import "PicMeViewController.h"
#import "PicMeTableViewController.h"
#import "PicMeLoginViewController.h"
#import "PicMeCollectionCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
@interface PicMeViewController ()

@end

@implementation PicMeViewController
@synthesize image,image_View,tapRecognizer,caption,friendPicker,friendsTagged,profile_pictures,progress,location_manager,location,title,collectionView,stayup;
-(void)viewWillAppear:(BOOL)animated{
    UIImage *pattern = [UIImage imageNamed:@"dark_fish_skin.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:pattern];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed: 70.0/255.0 green: 130.0/255.0 blue:200.0/255.0 alpha: 1.0]];
    self.navigationController.navigationBar.topItem.title = @"PicMe";
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed: 70.0/255.0 green: 130.0/255.0 blue:200.0/255.0 alpha: 1.0]];
    
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed: 120.0/255.0 green: 180.0/255.0 blue:250.0/255.0 alpha: 1.0]];
    [progress setHidden:YES];
    if(!(image_View == NULL)){
    UIImagePickerController *camera = [[UIImagePickerController alloc]init];
    camera.delegate = self;
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        friendPicker = [[FBFriendPickerViewController alloc]init];
        [friendPicker loadData];
    [self presentViewController:camera
                       animated:YES completion:nil];
    }
    profile_pictures = [[NSMutableArray alloc]init];
    UIImage *temp = [UIImage imageWithData:[[[PFUser currentUser]objectForKey:@"profile_picture"]getData]];
    [profile_pictures addObject:temp];
    NSLog(@"Here: %d",[profile_pictures count]);
    location = [[CLLocation alloc]init];
    location_manager = [[CLLocationManager alloc]init];
    location_manager.delegate = self;
    location_manager.desiredAccuracy = kCLLocationAccuracyBest;
    [location_manager startUpdatingLocation];
    caption.delegate = self;
    /*collectionView = [[UICollectionView alloc]init];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView reloadData];*/
}
-(void)viewWillDisappear:(BOOL)animated{
    image_View = NULL;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    if(!([PFUser currentUser] && // Check if a user is cached
         [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])){
        [self performSegueWithIdentifier:@"logIn" sender:self];
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    friendsTagged = [[NSMutableArray alloc]init];
    [friendsTagged addObject:[[PFUser currentUser] objectForKey:@"facebookID"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Called every time a chunk of the data is received

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [caption resignFirstResponder];
    [title resignFirstResponder];
}

#pragma mark - location 
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    location = newLocation;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location Services Are Turned Off" message:@"In order to continue, please turn location services on" delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"OK", nil];
    [alert show];
}
#pragma mark - UIImagePickerController Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *temp_image = info[UIImagePickerControllerOriginalImage];
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [temp_image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = smallImage;
    CALayer *layer = image_View.layer;
    [layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [layer setBorderWidth:8.0f];
    [layer setShadowColor: [[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.9f];
    [layer setShadowOffset: CGSizeMake(1, 3)];
    [layer setShadowRadius:4.0];
    [image_View setClipsToBounds:NO];
    image_View.image = smallImage;
}

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    PicMeTableViewController *controller = [[PicMeTableViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - FacebookFriendPicker Controller Field
- (IBAction)tagFriends:(id)sender {
    
    NSSet *fields = [NSSet setWithObjects:@"installed", nil];
    friendPicker.fieldsForRequest = fields;
    friendPicker.delegate = self;
    
    [self presentViewController:friendPicker animated:YES completion:nil];
}
-(BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user{
    BOOL installed = [user objectForKey:@"installed"] != nil;
    return installed;
}
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    
    for(id<FBGraphUser> user in self.friendPicker.selection){
        NSLog(@"%@",[user id]);
        [friendsTagged addObject:[user id]];
    }
    NSLog(@"%lu",(unsigned long)[friendsTagged count]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Posting Methods
-(NSData *)compressImage:(UIImage *)imageToCompress{
    CGFloat compression = 0.05f;
    CGFloat maxCompression = 0.05f;
    int maxFileSize = 640*960;
    
    NSData *imageData = UIImageJPEGRepresentation(imageToCompress, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(imageToCompress, compression);
    }
    return imageData;
}
-(void)showAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Picture has Been Uploaded!" message:@"You can now view your picture in the feed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok!", nil];
    
    [alert show];
    
}
- (IBAction)post:(id)sender {
    NSLog(@"Here");
    PFObject *new_picture = [[PFObject alloc]initWithClassName:@"Pictures"];
    NSData *data = [[NSData alloc]initWithData:[self compressImage:image]];
    PFFile *picture = [PFFile fileWithData:data];
    [picture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded){
                            }
                            else{
                                NSLog(@"%@",[error localizedDescription]);
                            }
                    }   
                         progressBlock:^(int percentDone){
                             if(percentDone != 100){
                                 [progress setHidden:NO];
                                 [progress setProgress:percentDone];
                                 NSLog(@"%d",percentDone);
                             }
                             else{
                                 [progress setHidden:YES];
                                 [self showAlert];
                             }
        }];
    [new_picture setObject:picture forKey:@"picture"];
    [new_picture setObject:title.text forKey:@"title"];
    [new_picture setObject:caption.text forKey:@"caption"];
    NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSLog(@"%f",location.coordinate.latitude);
    NSLog(@"(%@,%@)",latitude,longitude);
    [new_picture setValue:latitude forKey:@"latitude"];
    [new_picture setValue:longitude forKey:@"longitude"];
    NSLog(@"Uploading: %d",[friendsTagged count]);
    [new_picture setObject:friendsTagged forKey:@"tagged"];
    [new_picture saveInBackground];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [self setViewMoveUp:NO];
    [self.view removeGestureRecognizer:tapRecognizer];

}


- (void)keyboardWillShow:(NSNotification *)notif{
    [self.view addGestureRecognizer:tapRecognizer];

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
            rect.origin.y -= 100;
        }
        
    }
    else
    {
        if (stayup == NO) {
            rect.origin.y += 100;
        }
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Push Notifications
-(void)notifyTagged{
    NSString *self2 = [[PFUser currentUser]objectForKey:@"facebookID"];
    for(NSString *str in friendsTagged){
        if(![str isEqualToString:self2]){
            //Send push notification code
        }
    }
}

@end
