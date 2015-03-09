
/**
 *  PathCell.m
 *  A-star-Pathfinder
 *
 *  Created by Philip Fryklund on 2013-10-08.
 *  Copyright (c) 2013 SDKGameMaker. All rights reserved.
 */

#import "PathCell.h"
#import "ViewController.h"


@implementation PathCell

/// This method is getting called when a cell this cell created is added on the destination point
-(void)done {
    self.superVC.pathFound = YES; // Set pathFound to YES so the cells stop reproducing
    PathCell *prevView = self; // Declare a PathCell ocject and asign it with this PathCell
    
    // Create a new NSMutableArray to add the cells on the path by adding a cell and then that cells parent and loop that until there are no cells left
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while (true) {
        if (prevView) [array addObject:prevView];
        else break;
        prevView = prevView.parent;
    }
    // Reverse the array
    [self.superVC done:[CFunctions CFReversedArray:array]];
}

/// This is the cells main method, it checks all around itself if there is a wall, a cell or out of screen, if its clear it adds another cell
-(void)add {
    for (int a = 0; a < self.numberOfDirections; a++) { // Loop a fixed number of times to check the directions horizontal and vertical or every direction
        if (self.superVC.pathFound) break; // If another cell has found the path, stop this loop
        CGPoint newPoint = [CFunctions CFPointAdd:self.center pointToAdd:CFCheckPoint[a]]; // Create the CGPoint to check if there are any obstacles
        // Check if there are any obstacles like walls, cells or outside the screen on the newPoint position
        BOOL add = [CFunctions inBoundries:newPoint of:self.superVC.view.frame];
        if (!add) continue;
        for (PathCell *path in [self.superVC.pathArray copy]) if (CGPointEqualToPoint(newPoint, path.center)) add = NO;
        if (add) for (UIView *wall in [self.superVC.wallArray copy]) if (CGPointEqualToPoint(newPoint, wall.center)) add = NO;
        
        // If its clear add a new cell
        if (add && !self.superVC.pathFound) {
            PathCell *newCell = [[PathCell alloc] initWithFrame:self.frame];
            [newCell setCenter:newPoint];
            [newCell setBackgroundColor:[UIColor redColor]]; // For debugging
            [newCell setParent:self];
            [newCell setSuperVC:self.superVC];
            [newCell setNumberOfDirections:self.numberOfDirections];
            [self.superVC.view addSubview:newCell];
            [self.superVC.pathArray addObject:newCell];
            if (CGPointEqualToPoint(newCell.center, self.superVC.endPoint)) { // If the new cell is on endPoint, call method done
                [self done];
                break;
            }
            [self.superVC timeToReset];
        }
    }
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        if (!self.superVC.pathFound)
            [self performSelector:@selector(add) withObject:nil afterDelay:0]; // If the path has not been found, try to add a new cell
    }
    return self;
}

@end
