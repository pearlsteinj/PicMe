//
//  PicMeLoginViewController.m
//  PicMe
//
//  Created by Josh Pearlstein on 4/22/13.
//  Copyright (c) 2013 Pearlstein. All rights reserved.
//

#import "PicMeLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface PicMeLoginViewController ()

@end

@implementation PicMeLoginViewController
@synthesize _imageData,profile_picture,picture;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"loaded");
    [[self navigationController] setNavigationBarHidden:YES];
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    UIImage *im = [UIImage imageNamed:@"ocean.png"];
    picture = [[UIImageView alloc]init];
    picture.image = im;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
        // The permissions requested from the user
        NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
        
        // Login PFUser using Facebook
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            
            if (!user) {
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                }
            } else if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                [[self navigationController] popViewControllerAnimated:YES];
                
            } else {
                NSLog(@"User with facebook logged in!");
                [self setUpUser];
                [[self navigationController] popViewControllerAnimated:YES];
            }
        }];
}-(void)setUpUser{
    PFUser *user = [PFUser currentUser];
    NSLog(@"%@",[user objectForKey:@"name"]);
    // ...
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            NSLog(@"facebookID");
            [user setObject:facebookID forKey:@"facebookID"];
            NSString *name = userData[@"name"];
            NSLog(@"name");
            [user setObject:name forKey:@"name"];
            NSString *gender = userData[@"gender"];
            [user setObject:gender forKey:@"gender"];
            NSLog(@"gender");
            // Download the user's facebook profile picture
            _imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        }
    }];
    [user saveInBackground];
}
// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    profile_picture = [UIImage imageWithData:_imageData];
    PFFile *picture = [PFFile fileWithData:_imageData];
    NSLog(@"picture");
    [[PFUser currentUser] setObject:picture forKey:@"profile_picture"];
    [[PFUser currentUser] saveInBackground];
}

-(UIImage *)getProfilePicture{
    return profile_picture;
}
@end

