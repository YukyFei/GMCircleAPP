//
//  CGTypes+Extension.m
//  youka
//
//  Created by leijun on 14-6-15.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//

# import "CGTypes+Extension.h"
CGPadding CGPaddingZero;
CGMargin CGMarginZero;

CGPadding CGPaddingMake(real t, real b, real l, real r) {
    CGPadding ret = {t, b, l, r};
    return ret;
}

CGMargin CGMarginMake(real t, real b, real l, real r) {
    CGMargin ret = {t, b, l, r};
    return ret;
}


real CGPaddingGetWidth(CGPadding const* pd) {
    return pd->right + pd->left;
}

real CGPaddingGetHeight(CGPadding const* pd) {
    return pd->bottom + pd->top;
}


int COLOR_COMPONENT_BLEACHd(int v, float r) {
    v += (255 - v) * r;
    if (v > 255)
        v = 255;
    return v;
}

int RGB_BLEACH(int v, float rt) {
    int r = RGB_RED(v);
    int g = RGB_GREEN(v);
    int b = RGB_BLUE(v);
    r = COLOR_COMPONENT_BLEACHd(r, rt);
    g = COLOR_COMPONENT_BLEACHd(g, rt);
    b = COLOR_COMPONENT_BLEACHd(b, rt);
    return RGB_VALUE(r, g, b);
}

const CGFloat CGVALUEMAX = 99999;
CGFloat CGHeightMax = CGVALUEMAX;
CGFloat CGWidthMax = CGVALUEMAX;
CGRect CGRectMax = {0, 0, CGVALUEMAX, CGVALUEMAX};
CGSize CGSizeMax = {CGVALUEMAX, CGVALUEMAX};
CGPoint CGPointMax = {CGVALUEMAX, CGVALUEMAX};

const float FLOAT_1_255 = 1.f / 255;

@implementation NSSize

+ (id)size:(CGSize)sz {
    return [[NSSize alloc] initWithSize:sz];
}

- (id)initWithSize:(CGSize)sz {
    self = [super init];
    _size = sz;
    return self;
}

@dynamic width, height;

- (void)setWidth:(CGFloat)width {
    _size.width = width;
}

- (CGFloat)width {
    return _size.width;
}

- (void)setHeight:(CGFloat)height {
    _size.height = height;
}

- (CGFloat)height {
    return _size.height;
}

//- (BOOL)isEqual:(id)object {
//    return CGSizeEqualToSize(self.size, [object size]);
//}

- (NSString*)description {
    return NSStringFromCGSize(_size);
}

@end

@implementation NSPoint

+ (id)point:(CGPoint)pt {
    return [[self alloc] initWithPoint:pt];
}

- (id)initWithPoint:(CGPoint)pt {
    self = [super init];
    _point = pt;
    return self;
}

+ (instancetype)randomPointInRect:(CGRect)rc {
    CGPoint pt = rc.origin;
    pt.x += [NSRandom valueBoundary:0 To:rc.size.width];
    pt.y += [NSRandom valueBoundary:0 To:rc.size.height];
    return [self point:pt];
}

- (instancetype)intergral {
    _point = CGPointIntegral(_point);
    return self;
}

- (NSString*)description {
    return NSStringFromCGPoint(_point);
}

@end

@implementation NSRect

+ (id)rect:(CGRect)rc {
    return [[self alloc] initWithRect:rc];
}

- (id)initWithRect:(CGRect)rc {
    self = [super init];
    _rect = rc;
    return self;
}

- (NSString*)description {
    return NSStringFromCGRect(_rect);
}

@dynamic origin, size;

- (void)setOrigin:(CGPoint)origin {
    _rect.origin = origin;
}

- (CGPoint)origin {
    return _rect.origin;
}

- (void)setSize:(CGSize)size {
    _rect.size = size;
}

- (CGSize)size {
    return _rect.size;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(_rect);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(_rect);
}

- (CGFloat)x {
    return _rect.origin.x;
}

- (void)setX:(CGFloat)x {
    _rect.origin.x = x;
}

- (CGFloat)y {
    return _rect.origin.y;
}

- (void)setY:(CGFloat)y {
    _rect.origin.y = y;
}

- (CGFloat)width {
    return _rect.size.width;
}

- (void)setWidth:(CGFloat)width {
    _rect.size.width = width;
}

- (CGFloat)height {
    return _rect.size.height;
}

- (void)setHeight:(CGFloat)height {
    _rect.size.height = height;
}

- (CGPoint)center {
    return CGRectCenter(_rect);
}

- (void)setCenter:(CGPoint)pt {
    _rect = CGRectSetCenter(_rect, pt);
}

- (NSRect*)offsetX:(CGFloat)x Y:(CGFloat)y {
    CGRect rc = CGRectOffset(_rect, x, y);
    return [NSRect rect:rc];
}

- (NSRect*)squaredMax {
    CGFloat val = MAX(_rect.size.width, _rect.size.height);
    CGRect rc = _rect;
    rc.size.width = rc.size.height = val;
    return [NSRect rect:rc];
}

- (NSRect*)squaredMin {
    CGFloat val = MIN(_rect.size.width, _rect.size.height);
    CGRect rc = _rect;
    rc.size.width = rc.size.height = val;
    return [NSRect rect:rc];
}

@end

@implementation CGDesigner

+ (CGFloat)Height:(CGFloat)val {
    return val * .5f;
}

+ (CGFloat)Width:(CGFloat)val {
    return val * .5f;
}

+ (CGSize)Size:(CGSize)sz {
    sz.height *= .5f;
    sz.width *= .5f;
    return sz;
}

+ (CGPoint)Point:(CGPoint)pt {
    pt.x *= .5f;
    pt.y *= .5f;
    return pt;
}

+ (CGRect)Rect:(CGRect)rc {
    rc.origin = [CGDesigner Point:rc.origin];
    rc.size = [CGDesigner Size:rc.size];
    return rc;
}

+ (CGPadding)Padding:(CGPadding)pd {
    pd.left = [CGDesigner Width:pd.left];
    pd.right = [CGDesigner Width:pd.right];
    pd.top = [CGDesigner Height:pd.top];
    pd.bottom = [CGDesigner Height:pd.bottom];
    return pd;
}

@end

@implementation NSRandom

+ (CGFloat)valueBoundary:(CGFloat)low To:(CGFloat)high {
    CGFloat val = rand();
    val /= RAND_MAX;
    val = val * (high - low) + low;
    return val;
}

@end

@implementation NSPadding

+ (instancetype)padding:(CGPadding)pad {
    NSPadding* ret = [[self alloc] init];
    ret.padding = pad;
    return ret;
}

@end

CGPoint CGPointAddPoint(CGPoint l, CGPoint r) {
    return CGPointMake(l.x + r.x, l.y + r.y);
}

CGPoint CGPointSubPoint(CGPoint l, CGPoint r) {
    return CGPointMake(l.x - r.x, l.y - r.y);
}

CGPoint CGRectCenter(CGRect rc) {
    CGPoint pt = rc.origin;
    pt.x += rc.size.width * .5f;
    pt.y += rc.size.height * .5f;
    return pt;
}

CGPoint CGSizeCenter(CGSize sz) {
    CGPoint pt = {0};
    pt.x = sz.width * .5f;
    pt.y = sz.height * .5f;
    return pt;
}

CGRect CGRectMakeWithSize(CGSize sz) {
    return CGRectMake(0, 0, sz.width, sz.height);
}

CGRect CGRectMakeWithPointAndSize(CGPoint pt, CGSize sz) {
    CGRect ret = {pt, sz};
    return ret;
}

CGRect CGRectDeflate(CGRect rc, CGFloat x, CGFloat y) {
    CGRect ret = rc;
    ret.origin.x += x;
    ret.origin.y += y;
    ret.size.width -= x + x;
    ret.size.height -= y + y;
    return ret;
}

CGRect CGRectDeflateWithRatio(CGRect rc, CGFloat dx, CGFloat dy) {
    CGFloat x = dx * rc.size.width * .5f;
    CGFloat y = dy * rc.size.height * .5f;
    return CGRectDeflate(rc, x, y);
}

CGRect CGRectMultiply(CGRect rc, CGFloat x, CGFloat y, CGFloat w, CGFloat h) {
    CGRect ret = rc;
    ret.origin.x *= x;
    ret.origin.y *= y;
    ret.size.width *= w;
    ret.size.height *= h;
    return ret;
}

CGRect CGRectClipCenterBySize(CGRect rc, CGSize sz) {
    CGRect ret = rc;
    if (sz.width) {
        ret.origin.x = rc.origin.x + (rc.size.width - sz.width) * .5f;
        ret.size.width = sz.width;
    }
    if (sz.height) {
        ret.origin.y = rc.origin.y + (rc.size.height - sz.height) * .5f;
        ret.size.height = sz.height;
    }
    return ret;
}

BOOL CGRectContainsX(CGRect rc, CGFloat x) {
    return (x > rc.origin.x) && (x < rc.origin.x + rc.size.width);
}

BOOL CGRectContainsY(CGRect rc, CGFloat y) {
    return (y > rc.origin.y) && (y < rc.origin.y + rc.size.height);
}

CGRect CGRectSetSize(CGRect rc, CGSize sz) {
    rc.size = sz;
    return rc;
}

CGRect CGRectSetX(CGRect rc, CGFloat v) {
    rc.origin.x = v;
    return rc;
}

CGRect CGRectSetY(CGRect rc, CGFloat v) {
    rc.origin.y = v;
    return rc;
}

CGRect CGRectSetPoint(CGRect rc, CGPoint pt) {
    rc.origin = pt;
    return rc;
}

CGRect CGRectOffsetByPoint(CGRect rc, CGPoint pt) {
    rc = CGRectOffset(rc, pt.x, pt.y);
    return rc;
}

CGRect CGRectSetWidth(CGRect rc, CGFloat val) {
    rc.size.width = val;
    return rc;
}

CGRect CGRectSetHeight(CGRect rc, CGFloat val) {
    rc.size.height = val;
    return rc;
}

CGRect CGRectSetCenter(CGRect rc, CGPoint pt) {
    rc.origin.x = pt.x - rc.size.width * .5f;
    rc.origin.y = pt.y - rc.size.height * .5f;
    return rc;
}

CGPoint CGRectLeftTop(CGRect rc) {
    return rc.origin;
}

CGPoint CGRectRightTop(CGRect rc) {
    CGPoint pt = rc.origin;
    pt.x += rc.size.width;
    return pt;
}

CGPoint CGRectLeftBottom(CGRect rc) {
    CGPoint pt = rc.origin;
    pt.y += rc.size.height;
    return pt;
}

CGPoint CGRectRightBottom(CGRect rc) {
    CGPoint pt = rc.origin;
    pt.x += rc.size.width;
    pt.y += rc.size.height;
    return pt;
}

CGPoint CGRectLeftCenter(CGRect rc) {
    CGPoint pt = rc.origin;
    pt.y += rc.size.height * .5f;
    return pt;
}

CGPoint CGRectRightCenter(CGRect rc) {
    CGPoint pt = CGRectRightTop(rc);
    pt.y += rc.size.height * .5f;
    return pt;
}

CGPoint CGRectTopCenter(CGRect rc) {
    CGPoint pt = rc.origin;
    pt.x += rc.size.width * .5f;
    return pt;
}

CGPoint CGRectBottomCenter(CGRect rc) {
    CGPoint pt = CGRectLeftBottom(rc);
    pt.x += rc.size.width * .5f;
    return pt;
}

CGClipRect CGSizeMapInSize(CGSize insz, CGSize sz, UIViewContentMode mode) {
    CGClipRect ret;
    ret.full = ret.work = CGRectMakeWithSize(sz);
    
    CGFloat aspsrc = insz.width / insz.height;
    CGFloat aspdes = sz.width / sz.height;
    
    switch (mode) {
        default: {} break;
        case UIViewContentModeScaleAspectFill: {
            if (aspsrc >= aspdes) {
                ret.full.size.height = sz.height;
                ret.full.size.width = ret.full.size.height * aspsrc;
                ret.full.origin.x = (sz.width - ret.full.size.width) * .5f;
            } else {
                ret.full.size.width = sz.width;
                ret.full.size.height = ret.full.size.width / aspsrc;
                ret.full.origin.y = (sz.height - ret.full.size.height) * .5f;
            }
        } break;
        case UIViewContentModeScaleAspectFit: {
            if (aspsrc >= aspdes) {
                ret.full.size.width = sz.width;
                ret.full.size.height = ret.full.size.width / aspsrc;
                ret.full.origin.y = (sz.height - ret.full.size.height) * .5f;
            } else {
                ret.full.size.height = sz.height;
                ret.full.size.width = ret.full.size.height * aspsrc;
                ret.full.origin.x = (sz.width - ret.full.size.width) * .5f;
            }
            ret.work = ret.full;
        } break;
    }
    return ret;
}

CGPoint CGPointOffset(CGPoint p, CGFloat x, CGFloat y) {
    p.x += x;
    p.y += y;
    return p;
}

CGPoint CGPointOffsetByPoint(CGPoint p, CGPoint t) {
    return CGPointOffset(p, t.x, t.y);
}

CGPoint CGPointMultiply(CGPoint pt, CGFloat x, CGFloat y) {
    pt.x *= x;
    pt.y *= y;
    return pt;
}

CGPoint CGPointSetX(CGPoint p, CGFloat v) {
    p.x = v;
    return p;
}

CGPoint CGPointSetY(CGPoint p, CGFloat v) {
    p.y = v;
    return p;
}

CGPoint UIEdgeInsetsInsetPoint(CGPoint pt, UIEdgeInsets is) {
    pt.x += is.left;
    pt.y += is.top;
    return pt;
}

CGRect CGRectApplyPadding(CGRect rc, CGPadding pad) {
    rc.origin.x += pad.left;
    rc.origin.y += pad.top;
    rc.size.width -= pad.left + pad.right;
    rc.size.height -= pad.top + pad.bottom;
    return rc;
}

CGRect CGRectApplyMargin(CGRect rc, CGMargin mag) {
    rc.origin.x += mag.left;
    rc.origin.y += mag.top;
    rc.size.width -= mag.left + mag.right;
    rc.size.height -= mag.top + mag.bottom;
    return rc;
}

CGRect CGRectUnapplyPadding(CGRect rc, CGPadding pad) {
    return CGRectApplyPadding(rc, CGPaddingMultiply(pad, -1, -1, -1, -1));
}

CGSize CGSizeApplyPadding(CGSize sz, CGPadding pad) {
    sz.width -= pad.left + pad.right;
    sz.height -= pad.top + pad.bottom;
    return sz;
}

CGSize CGSizeUnapplyPadding(CGSize sz, CGPadding pad) {
    return CGSizeApplyPadding(sz, CGPaddingMultiply(pad, -1, -1, -1, -1));
}

CGPadding CGPaddingMultiply(CGPadding pad, CGFloat t, CGFloat b, CGFloat l, CGFloat r) {
    pad.top *= t;
    pad.bottom *= b;
    pad.left *= l;
    pad.right *= r;
    return pad;
}

/*
 BOOL CGPaddingEqualToPadding(CGPadding l, CGPadding r) {
 return l.top == r.top &&
 l.bottom == r.bottom &&
 l.left == r.left &&
 l.right == r.right;
 }
 */

CGRect CGRectApplyOffset(CGRect rc, CGPoint of) {
    return CGRectOffset(rc, of.x, of.y);
}

CGFloat CGPaddingHeight(CGPadding pd) {
    return pd.top + pd.bottom;
}

CGFloat CGPaddingWidth(CGPadding pd) {
    return pd.left + pd.right;
}

CGPadding CGPaddingSetLeft(CGPadding pd, CGFloat v) {
    pd.left = v;
    return pd;
}

CGPadding CGPaddingSetRight(CGPadding pd, CGFloat v) {
    pd.right = v;
    return pd;
}

CGPadding CGPaddingSetLeftRight(CGPadding pd, CGFloat l, CGFloat r) {
    pd.left = l;
    pd.right = r;
    return pd;
}

CGPadding CGPaddingSetTopBottom(CGPadding pd, CGFloat t, CGFloat b) {
    pd.top = t;
    pd.bottom = b;
    return pd;
}

CGPadding CGPaddingMakeSize(CGFloat w, CGFloat h) {
    return CGPaddingMake(h, h, w, w);
}

BOOL CGSizeContainSize(CGSize l, CGSize r) {
    return l.width >= r.width &&
    l.height >= r.height;
}

CGSize CGSizeSetWidth(CGSize sz, CGFloat v) {
    sz.width = v;
    return sz;
}

CGSize CGSizeSetHeight(CGSize sz, CGFloat v) {
    sz.height = v;
    return sz;
}

CGSize CGSizeMultiply(CGSize sz, CGFloat w, CGFloat h) {
    sz.width *= w;
    sz.height *= h;
    return sz;
}

CGSize CGSizeSquare(CGSize sz, CGEdgeType type) {
    CGFloat val = type == kCGEdgeMax ? MAX(sz.width, sz.height) : MIN(sz.width, sz.height);
    return CGSizeMake(val, val);
}

CGRect CGRectSquare(CGRect rc, CGEdgeType type) {
    CGPoint cn = CGRectCenter(rc);
    rc.size = CGSizeSquare(rc.size, type);
    rc = CGRectSetCenter(rc, cn);
    return rc;
}

CGSize CGSizeIntegral(CGSize sz) {
    sz.width = floorf(sz.width);
    sz.height = floorf(sz.height);
    return sz;
}

CGSize CGSizeBBXIntegral(CGSize sz) {
    sz.width = ceilf(sz.width);
    sz.height = ceilf(sz.height);
    return sz;
}

CGPoint CGPointIntegral(CGPoint pt) {
    pt.x = floorf(pt.x);
    pt.y = floorf(pt.y);
    return pt;
}

CGRect CGRectIntegralEx(CGRect rc) {
    rc.origin = CGPointIntegral(rc.origin);
    rc.size = CGSizeIntegral(rc.size);
    return rc;
}

@implementation CGShadow

@synthesize color;

- (id)init {
    self = [super init];
    
    self.color = [UIColor blackColor].CGColor;
    self.opacity = 0;
    self.offset = CGSizeMake(0, -3);
    self.radius = 3;
    self.hidden = NO;
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    CGShadow* ret = [[[self class] alloc] init];
    ret.color = self.color;
    ret.opacity = self.opacity;
    ret.offset = self.offset;
    ret.radius = self.radius;
    ret.hidden = self.hidden;
    return ret;
}

- (void)setColor:(CGColorRef)val {
    color = val;
}

- (CGColorRef)color {
    return color;
}

- (void)setIn:(CALayer *)layer {
    if (_hidden)
        return;
    
    layer.shadowColor = self.color;
    layer.shadowOpacity = self.opacity;
    layer.shadowOffset = self.offset;
    layer.masksToBounds = NO;
}

+ (CGShadow*)Normal {
    CGShadow* ret = [[CGShadow alloc] init];
    ret.opacity = .3f;
    return ret;
}

+ (CGShadow*)TopEdge {
    CGShadow* ret = [[CGShadow alloc] init];
    ret.opacity = .2f;
    ret.offset = CGSizeMake(0, -2);
    return ret;
}

+ (CGShadow*)BottomEdge {
    CGShadow* ret = [[CGShadow alloc] init];
    ret.opacity = .2f;
    ret.offset = CGSizeMake(0, 2);
    return ret;
}

- (instancetype)shadowWithColor:(CGColorRef)val {
    CGShadow* ret = [self copy];
    ret.color = val;
    return ret;
}

@end

@implementation CGBlur

@synthesize tintColor;

- (id)init {
    self = [super init];
    _autoUpdate = NO;
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    CGBlur* ret = [[[self class] alloc] init];
    ret.radius = self.radius;
    ret.tintColor = self.tintColor;
    ret.saturation = self.saturation;
    ret.autoUpdate = self.autoUpdate;
    return ret;
}

- (void)setTintColor:(CGColorRef)color {
    tintColor = color;
}

- (CGColorRef)tintColor {
    return tintColor;
}

+ (CGBlur*)Subtle {
    CGBlur* ret = [[CGBlur alloc] init];
    ret.tintColor = [UIColor colorWithWhite:1 alpha:.3].CGColor;
    ret.radius = 5;
    ret.saturation = 1.8;
    return ret;
}

+ (CGBlur*)Light {
    CGBlur* ret = [[CGBlur alloc] init];
    ret.tintColor = [UIColor colorWithWhite:0 alpha:.15].CGColor;
    ret.radius = 30;
    ret.saturation = 1.8;
    return ret;
}

+ (CGBlur*)ExtraLight {
    CGBlur* ret = [[CGBlur alloc] init];
    ret.tintColor = [UIColor colorWithWhite:0.97 alpha:.82].CGColor;
    ret.radius = 20;
    ret.saturation = 1.8;
    return ret;
}

+ (CGBlur*)Dark {
    CGBlur* ret = [[CGBlur alloc] init];
    ret.tintColor = [UIColor colorWithWhite:0.11 alpha:.73].CGColor;
    ret.radius = 20;
    ret.saturation = 1.8;
    return ret;
}

+ (CGBlur*)Hoodinn {
    CGBlur* ret = [[CGBlur alloc] init];
    ret.tintColor = [UIColor colorWithWhite:0.11 alpha:.15].CGColor;
    ret.radius = 10;
    ret.saturation = 1.8;
    return ret;
}

- (instancetype)blurWithAutoUpdate {
    CGBlur* ret = [self copy];
    ret.autoUpdate = YES;
    return ret;
}

- (instancetype)blurWithColor:(CGColorRef)color {
    CGBlur* ret = [self copy];
    ret.tintColor = color;
    return ret;
}

- (instancetype)blurWithSaturation:(CGFloat)sa {
    CGBlur* ret = [self copy];
    ret.saturation = sa;
    return ret;
}

@end

@implementation CGLine

@synthesize color;

- (id)init {
    self = [super init];
    self.color = nil;
    self.width = 1;
    return self;
}


+ (instancetype)lineWithColor:(CGColorRef)color {
    CGLine* ret = [[self alloc] init];
    ret.color = color;
    return ret;
}

+ (instancetype)lineWithWidth:(CGFloat)width {
    CGLine* ret = [[self alloc] init];
    ret.width = width;
    return ret;
}

+ (instancetype)lineWithColor:(CGColorRef)color width:(CGFloat)width {
    CGLine* ret = [[self alloc] init];
    ret.color = color;
    ret.width = width;
    return ret;
}

- (void)setColor:(CGColorRef)val {
    color = val;
}

- (CGColorRef)color {
    return color;
}

+ (CGLine*)BadgeEdgeLine {
    CGLine* ret = [[self alloc] init];
    ret.color = [UIColor whiteColor].CGColor;
    ret.width = 2;
    ret.shadow = [CGShadow Normal];
    return ret;
}

- (void)setIn:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, self.color);
    CGContextSetLineWidth(context, self.width);
}

- (void)drawLineFrom:(CGPoint)from to:(CGPoint)to inContext:(CGContextRef)context {
    CGContextSaveGState(context);
    [self setIn:context];
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end

@implementation CGAngle

@synthesize value = _rad;

+ (CGAngle*)RegularDegree:(CGFloat)deg {
    CGAngle* ret = [[self alloc] init];
    deg = -deg + 180;
    ret->_rad = [CGAngle Degree2Rad:deg];
    return ret;
}

+ (CGAngle*)RegularRad:(CGFloat)rad {
    CGAngle* ret = [[self alloc] init];
    ret->_rad = -rad + M_PI;
    return ret;
}

+ (CGFloat)Degree2Rad:(CGFloat)deg {
    return deg * M_DEGREE;
}

+ (CGAngle*)Rad:(CGFloat)rad {
    CGAngle* ret = [[self alloc] init];
    ret->_rad = rad;
    return ret;
}

- (CGAngle*)angleAddDegree:(CGFloat)deg {
    CGAngle* ret = [[[self class] alloc] init] ;
    ret->_rad = _rad;
    return [ret addDegree:deg];
}

- (CGAngle*)angleAddRad:(CGFloat)rad {
    CGAngle* ret = [[[self class] alloc] init];
    ret->_rad = _rad;
    return [ret addRad:rad];
}

- (id)addDegree:(CGFloat)deg {
    deg = -deg * M_DEGREE;
    _rad = _rad + deg;
    return self;
}

- (id)addRad:(CGFloat)rad {
    rad = -rad;
    _rad = _rad + rad;
    return self;
}

- (CGFloat)distance:(CGAngle *)r {
    CGFloat ret = _rad - r->_rad;
    return fabsf(ret);
}

@end

@implementation CGPen

+ (instancetype)Pen:(CGColorRef)color width:(CGFloat)width {
    CGPen* ret = [[self alloc] init];
    ret.color = color;
    ret.width = width;
    return ret;
}

- (id)init {
    self = [super init];
    _width = 1;
    return self;
}

- (void)setIn:(CGGraphic *)gra {
    CGContextSetStrokeColorWithColor(gra.context, _color);
    CGContextSetLineWidth(gra.context, _width);
}

@end

@implementation CGBrush

+ (instancetype)Brush:(CGColorRef)color {
    CGBrush* ret = [[self alloc] init];
    ret.color = color;
    return ret;
}

- (void)setIn:(CGGraphic *)gra {
    CGContextSetFillColorWithColor(gra.context, _color);
}

@end

@implementation CGGraphic

@synthesize context = _ctx;

- (instancetype)initWithContext:(CGContextRef)ctx {
    self = [super init];
    _ctx = CGContextRetain(ctx);
    return self;
}

+ (instancetype)Current {
    return [[self alloc] initWithContext:UIGraphicsGetCurrentContext()] ;
}

+ (instancetype)Current:(CGRect)rc {
    CGGraphic* ret = [self Current];
    CGContextRef ctx = ret.context;
    CGContextScaleCTM(ctx, -1, -1);
    CGContextTranslateCTM(ctx, -rc.size.width, -rc.size.height);
    CGContextClipToRect(ctx, rc);
    return ret;
}

- (void)dealloc {
    CGContextRelease(_ctx);
}

- (NSRect*)bbx {
    return [NSRect rect:CGContextGetClipBoundingBox(_ctx)];
}

- (id)move:(CGPoint)pt {
    CGContextMoveToPoint(_ctx, pt.x, pt.y);
    return self;
}

- (id)line:(CGPoint)pt pen:(CGPen *)pen {
    [pen setIn:self];
    CGContextAddLineToPoint(_ctx, pt.x, pt.y);
    if (pen)
        CGContextStrokePath(_ctx);
    return self;
}

- (id)rect:(CGRect)rc pen:(CGPen*)pen brush:(CGBrush*)br {
    [pen setIn:self];
    [br setIn:self];
    
    CGContextAddRect(_ctx, rc);
    if (br)
        CGContextFillRect(_ctx, rc);
    if (pen)
        CGContextStrokeRect(_ctx, rc);
    return self;
}

- (id)ellipse:(CGRect)rc pen:(CGPen *)pen brush:(CGBrush *)br {
    [pen setIn:self];
    [br setIn:self];
    
    CGContextAddEllipseInRect(_ctx, rc);
    if (br)
        CGContextFillRect(_ctx, rc);
    if (pen)
        CGContextStrokeRect(_ctx, rc);
    
    return self;
}

- (id)arc:(CGPoint)center radius:(CGFloat)radius start:(CGAngle *)start end:(CGAngle *)end clockwise:(int)clockwise pen:(CGPen *)pen brush:(CGBrush *)br {
    [pen setIn:self];
    [br setIn: self];
    
    CGContextAddArc(_ctx, center.x, center.y, radius, start.value, end.value, !clockwise);
    if (br)
        CGContextFillPath(_ctx);
    if (pen)
        CGContextStrokePath(_ctx);
    
    return self;
}

- (id)arc:(CGFloat)radius from:(CGPoint)from to:(CGPoint)to pen:(CGPen *)pen brush:(CGBrush *)br {
    [pen setIn:self];
    [br setIn:self];
    
    CGContextAddArcToPoint(_ctx, from.x, from.y, to.x, to.y, radius);
    if (br)
        CGContextFillPath(_ctx);
    if (pen)
        CGContextStrokePath(_ctx);
    
    return self;
}

- (id)fill:(CGBrush*)br {
    [br setIn:self];
    CGContextFillPath(_ctx);
    return self;
}

- (id)fillRect:(CGRect)rc brush:(CGBrush*)br {
    [br setIn:self];
    CGContextFillRect(_ctx, rc);
    return self;
}

- (id)stroke:(CGPen*)pen {
    [pen setIn:self];
    CGContextStrokePath(_ctx);
    return self;
}

- (id)path:(void (^)(CGGraphic *))block {
    CGContextBeginPath(_ctx);
    block(self);
    CGContextMoveToPoint(_ctx, 0, 0);
    CGContextClosePath(_ctx);
    return self;
}

- (id)push {
    CGContextSaveGState(_ctx);
    return self;
}

- (id)pop {
    CGContextRestoreGState(_ctx);
    return self;
}

- (id)perform {
    CGContextClosePath(_ctx);
    return self;
}
@end
