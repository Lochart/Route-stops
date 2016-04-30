//
//  URLListStropsObject.m
//  CityTransport
//
//  Created by Nikolay on 22.04.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import "URLListStropsObject.h"

@implementation URLListStropsObject

-(instancetype)init{
    return self;
}

-(instancetype)initWithKrasnodarId:(NSString *)theId
                     KrasnodarName:(NSString *)theName{

    self = [super init];
    if (self) {
        
        self.krasnodarId = theId;
        self.krasnodarName = theName;
        }
    
    return self;
}

@end
