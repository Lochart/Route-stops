//
//  URLListStopRouteObject.h
//  CityTransport
//
//  Created by Nikolay on 26.04.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLListStopRouteObject : NSObject

@property (strong, nonatomic) NSString *krasnodarShortName;
@property (strong, nonatomic) NSString *krasnodarName;

-(instancetype)initWithKrasnodarShortName:(NSString *)theShortName
                            KrasnodarName:(NSString *)theName;


@end
