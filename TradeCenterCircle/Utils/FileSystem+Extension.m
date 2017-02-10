
//# import "Common.h"
# import "FileSystem+Extension.h"
//# import "NSTypes+Extension.h"
#import "Compiler.h"
#import "Architect.h"

# include <sys/types.h>
# include <sys/event.h>
# include <sys/time.h>

@implementation FileSystem

SHARED_IMPL(FileSystem);

- (id)init {
    self = [super init];
    
    _fmgr = [NSFileManager defaultManager];
    
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray* caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    // 获得写入的根目录
    _bundleDirectory = [[NSBundle mainBundle].resourcePath copy];
    _rootWritable = [dirs.lastObject copy];
    _cacheDirectory = [caches.lastObject copy];
    _tmpDirectory = [NSTemporaryDirectory() copy];
    
    return self;
}

- (NSString*)pathTmp:(NSString *)name {
    return [_tmpDirectory stringByAppendingFormat:@"/%@", name];
}
- (NSString*)pathWritable:(NSString*)name {
    return [_rootWritable stringByAppendingFormat:@"/%@", name];
}

- (NSString*)pathBundle:(NSString *)name {
    return [_bundleDirectory stringByAppendingFormat:@"/%@", name];
}

- (NSString*)dirCache:(NSString*)name {
    NSString* ret = [_cacheDirectory stringByAppendingFormat:@"/%@/", name];
    [self mkdir:ret];
    return ret;
}

- (BOOL)mkdir:(NSString *)path {
    return [self mkdir:path intermediate:YES];
}

- (BOOL)mkdir:(NSString*)path intermediate:(BOOL)intermediate {
    return [_fmgr createDirectoryAtPath:path withIntermediateDirectories:intermediate attributes:nil error:nil];
}

- (BOOL)exists:(NSString*)path {
    return [_fmgr fileExistsAtPath:path];
}

- (BOOL)existsDir:(NSString*)path {
    BOOL dir;
    BOOL ret = [_fmgr fileExistsAtPath:path isDirectory:&dir];
    if (ret && dir)
        return YES;
    return NO;
}

- (BOOL)existsFile:(NSString*)path {
    BOOL dir;
    BOOL ret = [_fmgr fileExistsAtPath:path isDirectory:&dir];
    if (ret && !dir)
        return YES;
    return NO;
}

- (BOOL)remove:(NSString *)path {
    NSError* err = nil;
    BOOL ret = [_fmgr removeItemAtPath:path error:&err];
    if (err)
        [err log];
    return ret;
}

- (NSString*)temporary {
    return _tmpDirectory;
}

@end
