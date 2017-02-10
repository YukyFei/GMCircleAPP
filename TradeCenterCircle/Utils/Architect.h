
# ifndef __ARCHITECT_3F8B291E5DB74BE7B4C351D7615CE901_H_INCLUDED
# define __ARCHITECT_3F8B291E5DB74BE7B4C351D7615CE901_H_INCLUDED

# import <objc/runtime.h>

# define PRIVATE_CLASS(cls) \
cls##_PrivateClass

# define PRIVATE_CLASS_DECL(cls) \
@class PRIVATE_CLASS(cls);

# define PRIVATE_DECL(cls) \
PRIVATE_CLASS(cls)* d_ptr;

# define PRIVATE_CONSTRUCT(cls) \
d_ptr = [PRIVATE_CLASS(cls) alloc]; \
d_ptr->d_owner = self; \
[d_ptr init];

# define PRIVATE_DESTROY() \
ZERO_RELEASE(d_ptr);

# define PRIVATE_IMPL_BEGIN(cls, sup, exp) \
@interface PRIVATE_CLASS(cls) : sup { \
exp \
@public \
cls* d_owner; \
}

# define PRIVATE_IMPL(cls) \
@end \
@implementation PRIVATE_CLASS(cls)

# define PRIVATE_IMPL_END() \
@end

extern Class PrivateClass_FromObject(id obj);

# define SHARED_IMPL_EXT(cls, name) \
+ (cls*)name { \
static cls* obj = nil; \
bool objinit = NO; \
SYNCHRONIZED_BEGIN \
if (obj == nil) { \
obj = [self alloc]; \
objinit = YES; \
} \
SYNCHRONIZED_END \
if (objinit) { \
[obj init]; } \
return obj; }

# define SHARED_IMPL(cls) SHARED_IMPL_EXT(cls, shared)

# endif
