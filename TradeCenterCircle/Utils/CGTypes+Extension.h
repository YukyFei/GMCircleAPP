//
//  CGTypes+Extension.h
//  youka
//
//  Created by leijun on 14-6-15.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//


# ifndef __CGTYPESEXTENSION_9C30CBAC689C4CF9B790D56E59B2BE87_H_INCLUDED
# define __CGTYPESEXTENSION_9C30CBAC689C4CF9B790D56E59B2BE87_H_INCLUDED

# import "Compiler.h"

C_BEGIN

# ifndef REAL_DEFINED
# define REAL_DEFINED
typedef float real;
# endif

# ifndef PADDING_DEFINED
# define PADDING_DEFINED
typedef struct _CGPadding {
    real top, bottom, left, right;
} CGPadding;
# endif

# ifndef MARGIN_DEFINED
# define MARGIN_DEFINED
typedef struct _CGMargin {
    real top, bottom, left, right;
} CGMargin;
# endif

extern CGPadding CGPaddingZero;
extern CGMargin CGMarginZero;

extern CGPadding CGPaddingMake(real t, real b, real l, real r);
extern CGMargin CGMarginMake(real t, real b, real l, real r);


typedef enum {
    kCGDirectionUnknown,
    kCGDirectionHorizontal,
    kCGDirectionVertical,
} CGDirection;

@interface NSSize : NSObject

+ (id)size:(CGSize)sz;
- (id)initWithSize:(CGSize)sz;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width, height;

- (BOOL)isEqual:(id)object;

@end

@interface NSPoint : NSObject

+ (instancetype)point:(CGPoint)pt;
- (id)initWithPoint:(CGPoint)pt;

@property (nonatomic, assign) CGPoint point;

+ (instancetype)randomPointInRect:(CGRect)rc;
- (instancetype)intergral;

@end

@interface NSRect : NSObject

+ (id)rect:(CGRect)rc;
- (id)initWithRect:(CGRect)rc;

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat x, y, width, height;
@property (nonatomic, assign) CGPoint center;

@property (nonatomic, readonly) CGFloat maxX, maxY;

- (NSRect*)offsetX:(CGFloat)x Y:(CGFloat)y;

// 正方形
- (NSRect*)squaredMax;
- (NSRect*)squaredMin;

@end

# define RGB_RED(val) (((val) & 0xff0000) >> 16)
# define RGB_GREEN(val) (((val) & 0xff00) >> 8)
# define RGB_BLUE(val) ((val) & 0xff)
# define RGB_VALUE(r, g, b) (((r & 0xff) << 16) | ((g & 0xff) << 8) | (b & 0xff))

# define ARGB_ALPHA(val) (((val) & 0xff000000) >> 24)
# define ARGB_RED RGB_RED
# define ARGB_GREEN RGB_GREEN
# define ARGB_BLUE RGB_BLUE

# define RGBA_ALPHA(val) ((val) & 0xff)
# define RGBA_RED(val) (((val) & 0xff000000) >> 24)
# define RGBA_GREEN(val) (((val) & 0xff0000) >> 16)
# define RGBA_BLUE(val) (((val) & 0xff00) >> 8)

extern int RGB_BLEACH(int, float);
extern int COLOR_COMPONENT_BLEACHd(int, float);

extern const float FLOAT_1_255;

# define RGB2FLOAT(val) ((val) * FLOAT_1_255)
# define FLOAT2RGB(val) ((val) * 255)

@interface CGDesigner : NSObject

+ (CGFloat)Height:(CGFloat)val;
+ (CGFloat)Width:(CGFloat)val;
+ (CGSize)Size:(CGSize)sz;
+ (CGPoint)Point:(CGPoint)pt;
+ (CGRect)Rect:(CGRect)rc;

# ifdef PADDING_DEFINED

+ (CGPadding)Padding:(CGPadding)pd;

# endif

@end

typedef struct _CGClipRect
{
    CGRect full, work;
} CGClipRect;

extern const CGFloat CGVALUEMAX;
extern CGRect CGRectMax;
extern CGSize CGSizeMax;
extern CGPoint CGPointMax;

extern CGPoint CGPointAddPoint(CGPoint, CGPoint);
extern CGPoint CGPointSubPoint(CGPoint, CGPoint);
extern CGPoint CGRectCenter(CGRect);
extern CGPoint CGSizeCenter(CGSize);
extern CGSize CGSizeIntegral(CGSize);
extern CGSize CGSizeBBXIntegral(CGSize);
extern CGPoint CGPointIntegral(CGPoint);
extern CGRect CGRectIntegralEx(CGRect);
extern CGRect CGRectMakeWithSize(CGSize);
extern CGRect CGRectMakeWithPointAndSize(CGPoint, CGSize);
extern CGRect CGRectDeflate(CGRect, CGFloat x, CGFloat y);
extern CGRect CGRectDeflateWithRatio(CGRect, CGFloat dx, CGFloat dy);
extern CGRect CGRectMultiply(CGRect, CGFloat x, CGFloat y, CGFloat w, CGFloat h);
extern CGRect CGRectClipCenterBySize(CGRect, CGSize);
extern CGRect CGRectSetSize(CGRect, CGSize);
extern CGRect CGRectSetWidth(CGRect, CGFloat);
extern CGRect CGRectSetHeight(CGRect, CGFloat);
extern CGRect CGRectSetCenter(CGRect, CGPoint);
extern CGRect CGRectSetX(CGRect, CGFloat);
extern CGRect CGRectSetY(CGRect, CGFloat);
extern CGRect CGRectSetPoint(CGRect, CGPoint);
extern CGRect CGRectOffsetByPoint(CGRect, CGPoint);
extern BOOL CGRectContainsX(CGRect, CGFloat);
extern BOOL CGRectContainsY(CGRect, CGFloat);
extern CGPoint CGRectLeftTop(CGRect);
extern CGPoint CGRectRightTop(CGRect);
extern CGPoint CGRectLeftBottom(CGRect);
extern CGPoint CGRectRightBottom(CGRect);
extern CGPoint CGRectLeftCenter(CGRect);
extern CGPoint CGRectRightCenter(CGRect);
extern CGPoint CGRectTopCenter(CGRect);
extern CGPoint CGRectBottomCenter(CGRect);
extern CGPoint CGPointOffset(CGPoint, CGFloat x, CGFloat y);
extern CGPoint CGPointOffsetByPoint(CGPoint, CGPoint);
extern CGPoint CGPointMultiply(CGPoint, CGFloat x, CGFloat y);
extern CGPoint CGPointSetX(CGPoint, CGFloat);
extern CGPoint CGPointSetY(CGPoint, CGFloat);
extern CGPoint UIEdgeInsetsInsetPoint(CGPoint, UIEdgeInsets);
extern BOOL CGSizeContainSize(CGSize, CGSize);
extern CGSize CGSizeSetWidth(CGSize, CGFloat);
extern CGSize CGSizeSetHeight(CGSize, CGFloat);
extern CGSize CGSizeMultiply(CGSize, CGFloat w, CGFloat h);
extern CGRect CGRectApplyOffset(CGRect, CGPoint);
extern CGClipRect CGSizeMapInSize(CGSize, CGSize, UIViewContentMode);

typedef enum {
    kCGEdgeMax,
    kCGEdgeMin,
} CGEdgeType;
extern CGSize CGSizeSquare(CGSize, CGEdgeType);
extern CGRect CGRectSquare(CGRect, CGEdgeType);

# ifdef PADDING_DEFINED

extern CGFloat CGPaddingHeight(CGPadding);
extern CGFloat CGPaddingWidth(CGPadding);
extern CGRect CGRectApplyPadding(CGRect, CGPadding);
extern CGRect CGRectUnapplyPadding(CGRect, CGPadding);
extern CGSize CGSizeApplyPadding(CGSize, CGPadding);
extern CGSize CGSizeUnapplyPadding(CGSize, CGPadding);
extern CGPadding CGPaddingSetLeft(CGPadding, CGFloat);
extern CGPadding CGPaddingSetRight(CGPadding, CGFloat);
extern CGPadding CGPaddingSetLeftRight(CGPadding, CGFloat l, CGFloat r);
extern CGPadding CGPaddingSetTopBottom(CGPadding, CGFloat t, CGFloat b);
extern CGPadding CGPaddingMultiply(CGPadding, CGFloat t, CGFloat b, CGFloat l, CGFloat r);
extern CGPadding CGPaddingMakeSize(CGFloat w, CGFloat h);
extern BOOL CGPaddingEqualToPadding(CGPadding, CGPadding);

@interface NSRandom : NSObject

+ (CGFloat)valueBoundary:(CGFloat)low To:(CGFloat)high;

@end

@interface NSPadding : NSObject

+ (instancetype)padding:(CGPadding)pad;

@property (nonatomic, assign) CGPadding padding;

@end

# endif

# ifdef MARGIN_DEFINED

extern CGRect CGRectApplyMargin(CGRect, CGMargin);

# endif

@interface CGShadow : NSObject <NSCopying>

@property CGColorRef color;
@property float opacity;
@property CGSize offset;
@property CGFloat radius;
@property BOOL hidden;

+ (CGShadow*)Normal;
+ (CGShadow*)TopEdge;
+ (CGShadow*)BottomEdge;

- (instancetype)shadowWithColor:(CGColorRef)color;

- (void)setIn:(CALayer*)layer;

@end

@interface CGBlur : NSObject <NSCopying>

@property CGFloat radius;
@property CGColorRef tintColor;
@property CGFloat saturation;
@property BOOL autoUpdate;

+ (instancetype)Subtle;
+ (instancetype)Light;
+ (instancetype)ExtraLight;
+ (instancetype)Dark;
+ (instancetype)Hoodinn;

- (instancetype)blurWithAutoUpdate;
- (instancetype)blurWithColor:(CGColorRef)color;
- (instancetype)blurWithSaturation:(CGFloat)sa;

@end

@interface CGLine : NSObject

@property (nonatomic, retain) CGShadow *shadow;

// 线的颜色，默认为nil
@property CGColorRef color;

// 线宽，默认为1
@property CGFloat width;

+ (instancetype)lineWithColor:(CGColorRef)color;
+ (instancetype)lineWithWidth:(CGFloat)width;
+ (instancetype)lineWithColor:(CGColorRef)color width:(CGFloat)width;
+ (instancetype)BadgeEdgeLine;

- (void)setIn:(CGContextRef)context;
- (void)drawLineFrom:(CGPoint)from to:(CGPoint)to inContext:(CGContextRef)context;

@end

// 采用欧拉几何坐标系
@interface CGAngle : NSObject {
    CGFloat _rad;
}

@property (nonatomic, readonly) CGFloat value;

// 不经过任何转换
+ (instancetype)Rad:(CGFloat)rad;

// 自动调整坐标系
+ (instancetype)RegularDegree:(CGFloat)deg;
+ (instancetype)RegularRad:(CGFloat)rad;

- (instancetype)angleAddDegree:(CGFloat)deg;
- (instancetype)angleAddRad:(CGFloat)rad;
- (id)addDegree:(CGFloat)deg;
- (id)addRad:(CGFloat)rad;

+ (CGFloat)Degree2Rad:(CGFloat)deg;
- (CGFloat)distance:(CGAngle*)r;

@end

@class CGGraphic;

@interface CGPen : NSObject

@property CGColorRef color;
@property CGFloat width;

+ (instancetype)Pen:(CGColorRef)color width:(CGFloat)width;

- (void)setIn:(CGGraphic*)gra;

@end

@interface CGBrush : NSObject

@property CGColorRef color;

+ (instancetype)Brush:(CGColorRef)color;

- (void)setIn:(CGGraphic*)gra;

@end

@interface CGGraphic : NSObject {
    CGContextRef _ctx;
}

@property (nonatomic, readonly) CGContextRef context;
@property (nonatomic, readonly) NSRect* bbx;

- (instancetype)initWithContext:(CGContextRef)ctx;
+ (instancetype)Current;
+ (instancetype)Current:(CGRect)rc;

- (id)move:(CGPoint)pt;
- (id)line:(CGPoint)pt pen:(CGPen*)pen;
- (id)rect:(CGRect)rc pen:(CGPen*)pen brush:(CGBrush*)br;
- (id)ellipse:(CGRect)rc pen:(CGPen*)pen brush:(CGBrush*)br;
- (id)arc:(CGPoint)center radius:(CGFloat)radius start:(CGAngle*)start end:(CGAngle*)end clockwise:(int)clockwise pen:(CGPen*)pen brush:(CGBrush*)br;
- (id)arc:(CGFloat)radius from:(CGPoint)from to:(CGPoint)to pen:(CGPen*)pen brush:(CGBrush*)br;
- (id)path:(void(^)(CGGraphic* graphic))block;
- (id)fill:(CGBrush*)br;
- (id)fillRect:(CGRect)rc brush:(CGBrush*)br;
- (id)stroke:(CGPen*)pen;

// 完成一次绘图
- (id)perform;

- (id)push;
- (id)pop;

@end



# define M_2PI 6.2831853071795862319959269370884
# define M_DEGREE 0.01745329251994329508887757483
C_END
#endif

