//
//  VideoCropFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/4/15.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoCropFilter.h"

@implementation VideoCropFilter

- (instancetype)init {
    self = [super initWithName:kVideoCropEffect];
    if (self) {
        self.cropRegion = CGRectMake(0.0, 0.0, 1.0, 1.0);
    }
    return self;
}

- (NSString *)fragmentShaderFile {
    return @"effect_fragment";
}

- (NSArray<NSNumber *> *)positions {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -1.0, -1.0);
    transform = CGAffineTransformScale(transform, 2.0, 2.0);
    return [self convertRectToArray:CGRectApplyAffineTransform(self.cropRegion, transform)];
}

- (NSArray<NSNumber *> *)textureCoordinates {
    return [self convertRectToArray:self.cropRegion];
}

- (NSArray<NSNumber *> *)convertRectToArray:(CGRect)rect {
    CGFloat minX = rect.origin.x;
    CGFloat minY = rect.origin.y;
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    NSMutableArray<NSNumber*> *cropCoordinates = [NSMutableArray<NSNumber*> new];
    switch(self.rotation) {
        case VideoRotationNoRotation: // Works
        {
            cropCoordinates[0] = @(minX); // 0,0
            cropCoordinates[1] = @(minY);
            
            cropCoordinates[2] = @(maxX); // 1,0
            cropCoordinates[3] = @(minY);

            cropCoordinates[4] = @(minX); // 0,1
            cropCoordinates[5] = @(maxY);

            cropCoordinates[6] = @(maxX); // 1,1
            cropCoordinates[7] = @(maxY);
        }; break;
        case VideoRotationRotateLeft: // Fixed
        {
            cropCoordinates[0] = @(maxY); // 1,0
            cropCoordinates[1] = @(1.0 - maxX);

            cropCoordinates[2] = @(maxY); // 1,1
            cropCoordinates[3] = @(1.0 - minX);

            cropCoordinates[4] = @(minY); // 0,0
            cropCoordinates[5] = @(1.0 - maxX);

            cropCoordinates[6] = @(minY); // 0,1
            cropCoordinates[7] = @(1.0 - minX);
        }; break;
        case VideoRotationRotateRight: // Fixed
        {
            cropCoordinates[0] = @(minY); // 0,1
            cropCoordinates[1] = @(1.0 - minX);

            cropCoordinates[2] = @(minY); // 0,0
            cropCoordinates[3] = @(1.0 - maxX);
            
            cropCoordinates[4] = @(maxY); // 1,1
            cropCoordinates[5] = @(1.0 - minX);

            cropCoordinates[6] = @(maxY); // 1,0
            cropCoordinates[7] = @(1.0 - maxX);
        }; break;
        case VideoRotationFlipVertical: // Works for me
        {
            cropCoordinates[0] = @(minX); // 0,1
            cropCoordinates[1] = @(maxY);

            cropCoordinates[2] = @(maxX); // 1,1
            cropCoordinates[3] = @(maxY);

            cropCoordinates[4] = @(minX); // 0,0
            cropCoordinates[5] = @(minY);
            
            cropCoordinates[6] = @(maxX); // 1,0
            cropCoordinates[7] = @(minY);
        }; break;
        case VideoRotationFlipHorizonal: // Works for me
        {
            cropCoordinates[0] = @(maxX); // 1,0
            cropCoordinates[1] = @(minY);

            cropCoordinates[2] = @(minX); // 0,0
            cropCoordinates[3] = @(minY);
            
            cropCoordinates[4] = @(maxX); // 1,1
            cropCoordinates[5] = @(maxY);
            
            cropCoordinates[6] = @(minX); // 0,1
            cropCoordinates[7] = @(maxY);
        }; break;
        case VideoRotationRotate180: // Fixed
        {
            cropCoordinates[0] = @(maxX); // 1,1
            cropCoordinates[1] = @(maxY);

            cropCoordinates[2] = @(minX); // 0,1
            cropCoordinates[3] = @(maxY);

            cropCoordinates[4] = @(maxX); // 1,0
            cropCoordinates[5] = @(minY);

            cropCoordinates[6] = @(minX); // 0,0
            cropCoordinates[7] = @(minY);
        }; break;
        case VideoRotationRotateRightFlipVertical: // Fixed
        {
            cropCoordinates[0] = @(minY); // 0,0
            cropCoordinates[1] = @(1.0 - maxX);
            
            cropCoordinates[2] = @(minY); // 0,1
            cropCoordinates[3] = @(1.0 - minX);

            cropCoordinates[4] = @(maxY); // 1,0
            cropCoordinates[5] = @(1.0 - maxX);
            
            cropCoordinates[6] = @(maxY); // 1,1
            cropCoordinates[7] = @(1.0 - minX);
        }; break;
        case VideoRotationRotateRightFlipHorizontal: // Fixed
        {
            cropCoordinates[0] = @(maxY); // 1,1
            cropCoordinates[1] = @(1.0 - minX);

            cropCoordinates[2] = @(maxY); // 1,0
            cropCoordinates[3] = @(1.0 - maxX);

            cropCoordinates[4] = @(minY); // 0,1
            cropCoordinates[5] = @(1.0 - minX);

            cropCoordinates[6] = @(minY); // 0,0
            cropCoordinates[7] = @(1.0 - maxX);
        }; break;
    }
    return cropCoordinates;
}

@end
