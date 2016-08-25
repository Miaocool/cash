//
//  AnimatedImageView.h
//  RabbitTiger
//
//  Created by Chenxi Cai on 14-10-29.
//  Copyright (c) 2014年 RabbitTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedGifFrame : NSObject
{
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end


@interface AnimatedImageView : UIImageView
{
	NSData *GIF_pointer;
	NSMutableData *GIF_buffer;
	NSMutableData *GIF_screen;
	NSMutableData *GIF_global;
	NSMutableArray *GIF_frames;
	
	int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
	int animatedGifDelay;
	
	int dataPointer;
}

@property (nonatomic, strong) NSMutableArray *GIF_frames;

@property (nonatomic, copy)   NSString    *imageFileName;
@property (nonatomic, strong) NSData      *imageFileData;

- (void)loadImageData;

+ (BOOL)isGifImage:(NSData*)imageData;

- (void)decodeGIF:(NSData *)GIFData;
- (void)GIFReadExtensions;
- (void)GIFReadDescriptor;
- (BOOL)GIFGetBytes:(int)length;
- (BOOL)GIFSkipBytes: (int) length;
- (NSData*)getFrameAsDataAtIndex:(int)index;
- (UIImage*)getFrameAsImageAtIndex:(int)index;

@end
