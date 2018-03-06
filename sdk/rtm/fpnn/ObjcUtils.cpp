//
//  ObjcUtils.cpp
//  fpnn
//
//  Created by 施王兴 on 2017/11/21.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#include <CoreFoundation/CoreFoundation.h>
#include "ObjcUtils.hpp"

void ObjCRelease(void *ocObj)
{
    CFRelease(ocObj);
}
