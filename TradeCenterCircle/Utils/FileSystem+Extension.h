
# ifndef __FILESYSTEMEXTENSION_D999D30520D24C28B07E7F263E723C4E_H_INCLUDED
# define __FILESYSTEMEXTENSION_D999D30520D24C28B07E7F263E723C4E_H_INCLUDED

@interface FileSystem : NSObject {
    NSFileManager* _fmgr;
}

@property (nonatomic, copy) NSString* bundleDirectory;
@property (nonatomic, copy) NSString* cacheDirectory;
@property (nonatomic, copy) NSString* rootWritable;
@property (nonatomic, copy) NSString* tmpDirectory;

+ (FileSystem*)shared;

- (NSString*)pathWritable:(NSString*)name;
- (NSString*)pathBundle:(NSString*)name;
- (NSString*)dirCache:(NSString*)name;

- (NSString*)pathTmp:(NSString*)name;

- (BOOL)mkdir:(NSString*)path;
- (BOOL)mkdir:(NSString *)path intermediate:(BOOL)intermediate;

- (BOOL)exists:(NSString*)path;
- (BOOL)existsDir:(NSString*)path;
- (BOOL)existsFile:(NSString*)path;

- (BOOL)remove:(NSString *)path;
- (NSString*)temporary;

@end

# endif
