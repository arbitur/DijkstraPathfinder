//
//  CaveFinder.m
//  A-star-Pathfinder
//
//  Created by Philip Fryklund on 2013-11-05.
//  Copyright (c) 2013 SDKGameMaker. All rights reserved.
//

#import "CaveFinder.h"
#import "ViewController.h"

@implementation CaveFinder
@synthesize pathArray, anchorPointArray;


-(void)addBlockade {
    UIView *blockade = [[UIView alloc] initWithFrame:self.frame];
    [blockade setBackgroundColor:[UIColor purpleColor]];
    [self.superview addSubview:blockade];
    [self.blockArray addObject:blockade];
}
-(void)moveBack {
    while (true) {
        UIView *path = pathArray[pathArray.count-1];
        BOOL br = NO;
        if (CGPointEqualToPoint(path.center, [[anchorPointArray objectAtIndex:anchorPointArray.count-1] CGPointValue])) {
            [self addBlockade];
            br = YES;
        }
        [self setFrame:path.frame];
        [pathArray removeObject:path];
        [path removeFromSuperview];
        if (br) break;
    }
    [anchorPointArray removeObjectAtIndex:anchorPointArray.count-1];
    
    [self performSelector:@selector(move) withObject:nil afterDelay:0];
}

-(void)move {
    NSMutableArray *availablePaths = [[NSMutableArray alloc] init];
    for (int a = 0; a < 4; a++) {
        CGPoint newPoint = [CFunctions CFPointAdd:self.center pointToAdd:CFCheckPoint[a]];
        
        BOOL addPoint = [CFunctions inBoundries:newPoint of:self.superview.frame];
        if (addPoint) for (UIView *wall in [self.vc.wallArray copy]) if (CGPointEqualToPoint(newPoint, wall.center)) addPoint = NO;
        if (addPoint) for (UIView *blockade in [self.blockArray copy]) if (CGPointEqualToPoint(newPoint, blockade.center)) addPoint = NO;
        if (addPoint) for (UIView *path in [self.pathArray copy]) if (CGPointEqualToPoint(newPoint, path.center)) addPoint = NO;
        
        if (addPoint) [availablePaths addObject:[NSValue valueWithCGPoint:newPoint]];
    }
    
    
    if (availablePaths.count > 1) [anchorPointArray addObject:[NSValue valueWithCGPoint:self.center]];
    if (availablePaths.count == 0)  {
        if(anchorPointArray.count > 0) [self moveBack];
        else NSLog(@"DONE");
    }
    else {
        UIView *path = [[UIView alloc] initWithFrame:self.frame];
//        [path setBackgroundColor:[UIColor yellowColor]];
        [self.superview addSubview:path];
        [self.pathArray addObject:path];
        int cost = INT_MAX;
        CGPoint pointToMove = CGPointZero;
        for (NSValue *val in availablePaths) {
            CGPoint point = val.CGPointValue;
            int newCost = [CFunctions hypotenusaFromPoint:point and:self.vc.endPoint];
            if (newCost < cost) {
                cost = newCost;
                pointToMove = point;
            }
        }
        [self setCenter:pointToMove];
        if (!CGPointEqualToPoint(self.center, self.vc.endPoint)) [self performSelector:@selector(move) withObject:nil afterDelay:0];
        else {[self.vc done:pathArray]; [self.vc resetCave];}
    }
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pathArray = [[NSMutableArray alloc] init];
        self.anchorPointArray = [[NSMutableArray alloc] init];
        self.blockArray = [[NSMutableArray alloc] init];
        [self performSelector:@selector(move) withObject:nil afterDelay:0];
    }
    return self;
}

@end