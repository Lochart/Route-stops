//
//  URLListStropsObject.h
//  CityTransport
//
//  Created by Nikolay on 22.04.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLListStropsObject : NSObject

@property (strong, nonatomic) NSString *krasnodarId;
@property (strong, nonatomic) NSString *krasnodarName;;

-(instancetype)initWithKrasnodarId:(NSString *)theId
                     KrasnodarName:(NSString *)theName;

@end
