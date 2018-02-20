//
//  CreateClass.m
//  iDNA
//
//  Created by Somkid on 2/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "CreateClass.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "CreateClassThread.h"
#import "ClasssRepo.h"
#import "Classs.h"

@interface CreateClass (){
    ClasssRepo* classsRepo;
}
@end

@implementation CreateClass
@synthesize imagePicker;
@synthesize popoverController;

@synthesize imageProfile, textfieldName, fction, item_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    classsRepo = [[ClasssRepo alloc] init];
    
    imageProfile.userInteractionEnabled = YES;
    [imageProfile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];
    
    if ([fction isEqualToString:@"edit"]) {
        NSArray *array_classs=  [classsRepo get:item_id];
        
        // NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
        NSData *data =  [[array_classs objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([f objectForKey:@"image_url"]) {
            [imageProfile clear];
            [imageProfile showLoadingWheel];
            [imageProfile setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [f objectForKey:@"image_url"]]]];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageProfile];
        }else{
            
        }
        
        [textfieldName setText:[f objectForKey:@"name"]];
        NSLog(@"");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectImage:(UITapGestureRecognizer *)gestureRecognizer{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:/*@"Take Photo",*/ @"Library", nil];
    
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            /*
        case 0:{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
            */
            
        case 0:{
            self.imagePicker = [[GKImagePicker alloc] init];
            self.imagePicker.cropSize = CGSizeMake(280, 280);
            self.imagePicker.delegate = self;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
                [self.popoverController presentPopoverFromRect:CGRectMake(100, 500, 10, 10)
                                                        inView:self.view
                                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                                      animated:YES];
            } else {
                [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{

    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        // [self.popoverController dismissPopoverAnimated:YES];
        
        [self.popoverController dismissPopoverAnimated:NO];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
    
    [imageProfile setImage:image];
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onCreate:(id)sender {
    
    UIImage* image = imageProfile.image;
    NSString* name = [textfieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (image == nil || [name isEqualToString:@""]) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Picture or Name Empty."];
        return;
    }
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    CreateClassThread *createClassThread = [[CreateClassThread alloc] init];
    [createClassThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            NSString*item_id = jsonDict[@"item_id"];
            if ([jsonDict[@"fction"] isEqualToString:@"add"]) {
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateClasss:item_id :jsonDict[@"value"]];
                
            }else if ([jsonDict[@"fction"] isEqualToString:@"edit"]) {
                NSDictionary * value = jsonDict[@"value"];
                
                NSArray *array_classs=  [classsRepo get:item_id];
                
                // NSString *item_id = [value objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"item_id"]];
                NSData *data =  [[array_classs objectAtIndex:[classsRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSMutableDictionary *f = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSMutableDictionary *newClasss = [[NSMutableDictionary alloc] init];
                [newClasss addEntriesFromDictionary:f];
                [newClasss removeObjectForKey:@"name"];
                [newClasss removeObjectForKey:@"image_url"];
                
                [newClasss setValue:[value objectForKey:@"name"] forKey:@"name"];
                [newClasss setValue:[value objectForKey:@"image_url"] forKey:@"image_url"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateClasss:item_id : newClasss];
            }
            
            [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:@"Update success."];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
    [createClassThread setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];    
    [createClassThread start:fction :item_id :image :name];
}
@end
