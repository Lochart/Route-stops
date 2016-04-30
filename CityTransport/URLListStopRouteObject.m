//
//  URLListStopRouteObject.m
//  CityTransport
//
//  Created by Nikolay on 26.04.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import "URLListStopRouteObject.h"

@implementation URLListStopRouteObject

-(instancetype)initWithKrasnodarShortName:(NSString *)theShortName
                            KrasnodarName:(NSString *)theName{
    
    self = [super init];
    if (self) {
        self.krasnodarShortName = theShortName;
        self.krasnodarName = theName;
    }
    
    return self;
}

@end
