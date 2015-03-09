
/**
*  ViewController.m
*  A-star-Pathfinder
*
*  Created by Philip Fryklund on 2013-10-08.
*  Copyright (c) 2013 SDKGameMaker. All rights reserved.
*/

#import "ViewController.h"


@implementation ViewController
@synthesize startPoint, endPoint, pathArray, wallArray, pathFound;

/// Refreshesh this UIViewController, ARC takes care of the memory
-(void)clearWalls {
    ViewController *vc = [self.storyboard instantiateInitialViewController];
    [self presentViewController:vc animated:NO completion:nil];
}
/// Removes the PathCells
-(void)resetCell {
    // Remove every cell from the main view, this is called 0 times if there are no objects in the array pathArray
    for (PathCell *cell_ in [pathArray copy]) [cell_ removeFromSuperview];
    pathArray = [[NSMutableArray alloc] init]; // Create a new NSMutableArray
    if (cell) { // If cell is already added, remove it and set pathFound to YES
        [cell removeFromSuperview];
        cell = nil;
        pathFound = YES;
    }
}

-(void)walk:(NSMutableArray *)walkArray index:(int)index {
    // Animate the walker to a point in walkArray[index]
    // Loop this method until walker has walked to every point in the array
    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [walker setCenter:[walkArray[index] CGPointValue]];
    } completion:^(BOOL finished) {
        if (index != walkArray.count-1) [self walk:walkArray index:index+1];
        else {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [walker setCenter:endPoint];
            } completion:nil];
        }
    }];
}
-(void)done:(NSMutableArray *)array {
    // array holds PathCells, we need the cneter point of those, loop through array and add the cell center to walkArray
    NSMutableArray *walkArray = [[NSMutableArray alloc] init];
    for (UIView *path in array) [walkArray addObject:[NSValue valueWithCGPoint:path.center]];

    // Set walker center to the first point in walkArray, and call walk:index: method to move the walker to every point after eatchother
    [walker setCenter:[walkArray[0] CGPointValue]];
    [self walk:walkArray index:1];
    [self resetCell];
}

/// If a path is not found call the resetCell method
-(void)reset {
    if (!pathFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No path found" message:@"A path was not found, a wall is on it or the endPoint is closed from every direction" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self resetCell];
    }
}
-(void)timeToReset {
    if ([resetTimer isValid]) { // If the resetTimer is already going to call the method reset, reset the duration
        [resetTimer invalidate];
        resetTimer = nil;
        resetTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(reset) userInfo:nil repeats:NO];
    }
    else // If it is not going to call method reset, make it call it. This is only used when the first PathCell is added
        resetTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(reset) userInfo:nil repeats:NO];
}

/// Adds a PathCell to the main view
-(void)findPathCell {
    pathArray = [[NSMutableArray alloc] init]; // Create a new NSMutableArray
    pathFound = NO;                            // Set pathFound to NO so the cells know the path is not found
    cell = [[PathCell alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; // Create a new cell with a width and height
    [cell setSuperVC:self];                    // Set the cells superVC to this UIViewController
    if (directionsSegCtrl.selectedSegmentIndex == 0)
        [cell setNumberOfDirections:4]; // If directionsSegCtrl selected index is 0, set the cells number of directions to check to 4
    else
        [cell setNumberOfDirections:8]; // If its not 0, set the cells number of directions to check to 8
    [cell setCenter:startPoint];               // Set the cells center to startPoint
    //[cell setBackgroundColor:[UIColor redColor]]; // Set its background color for debug only
    [self.view addSubview:cell];               // Add the cell to the main view
    [pathArray addObject:cell];                // Add the cell to pathArray
}

/** 
 *  This method takes care of the UIButton actions
 *  @param button The button that called this method
 */
-(IBAction)buttonAction:(UIButton *)button {
    if (button.tag == 0) [self findPathCell];    // If the button tag is 0 start the pathfinding
    else if (button.tag == 1) [self resetCell];  // If the button tag is 1 resmove all the cells
    else if (button.tag == 2) [self clearWalls]; // If the button tag is 2 reload the entire ViewController
}

/**
 *  Adds a wall to the main view
 *  @param point A CGPoint where to add the wall
 */
-(void)addWallAtPoint:(CGPoint)point {
    UIView *wall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [wall setCenter:point];
    [wall setBackgroundColor:[UIColor blackColor]];
    [wallArray addObject:wall];
    [self.view addSubview:wall];
}

// Method pre declared by Apple, it is called when the user touches the screen
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGPoint point = CGPointMake([CFunctions floorTooHalf:touchPoint.x], [CFunctions floorTooHalf:touchPoint.y]);
    if (optionSegCtrl.selectedSegmentIndex == 0) { // Set startPoint
        startPoint = point;
        [startView setCenter:point];
    }
    else if (optionSegCtrl.selectedSegmentIndex == 1) { // Set endPoint
        endPoint = point;
        [endView setCenter:point];
    }
    else if (optionSegCtrl.selectedSegmentIndex == 2) { // Add wall if there isnt already a wall
        BOOL add = YES;
        for (UIView *wall in [wallArray copy]) if (CGPointEqualToPoint(point, wall.center)) {
            add = NO;
            break;
        }
        if (add) [self addWallAtPoint:point];
    }
    else if (optionSegCtrl.selectedSegmentIndex == 3) { // Delete a wall
        for (UIView *wall in [wallArray copy]) if (CGRectContainsPoint(wall.frame, point)) {
            [wallArray removeObject:wall];
            [wall removeFromSuperview];
            break;
        }
    }
}
// Method pre declared by Apple, it is called when the user moves his/her finger on the screen
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (optionSegCtrl.selectedSegmentIndex >= 2) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        CGPoint point = CGPointMake([CFunctions floorTooHalf:touchPoint.x], [CFunctions floorTooHalf:touchPoint.y]);
        if (optionSegCtrl.selectedSegmentIndex == 2) { // Add wall if there isnt already a wall
            BOOL add = YES;
            for (UIView *wall in [wallArray copy]) if (CGPointEqualToPoint(point, wall.center)) {
                add = NO;
                break;
            }
            if (add) [self addWallAtPoint:point];
        }
        else {                                         // Delete a wall
            for (UIView *wall in [wallArray copy]) if (CGPointEqualToPoint(point, wall.center)) {
                [wallArray removeObject:wall];
                [wall removeFromSuperview];
            }
        }
    }
}

// A method for IOS7 to hide the status bar
-(BOOL)prefersStatusBarHidden {return YES;}
// This is the function that gets called automatically when the program starts
-(void)viewDidLoad {
    [super viewDidLoad];
    
    wallArray = [[NSMutableArray alloc] init]; // Create a new NSMutableArray and asign it to wallArray
    
    startPoint = CGPointMake(5+10*1, 5+10*24); // Give startPoint a CGPoint value
    endPoint = CGPointMake(5+10*30, 5+10*24);  // Give endPoint a CGPoint value
    
    // Make the user know where the startPoint is by adding a UIView on that location
    startView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [startView setCenter:startPoint];
    [startView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:startView];
    
    // Make the user know where the endPoint is by adding a UIView on that location
    endView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [endView setCenter:endPoint];
    [endView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:endView];
    
    [self resetCell]; // Call resetCell method to create the pathArray
    
    // Create the walker to let the user know the path later
    walker = [[UIImageView alloc] initWithFrame:CGRectMake(-10, -10, 10, 10)];
    [walker setBackgroundColor:[UIColor brownColor]];
    [self.view addSubview:walker];
}






























@end