//
//  ECASBackendService.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/6/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASBackendService.h"
#import "ECASIdentity.h"
#import "ECASApplication.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <Mantle/Mantle.h>
#import <hpple/TFHpple.h>

NSString *kECASBackendXPATHApplications = @"//form[@action='viewcasestatus.do']/*/section/section[position()>1]";
NSString *kECASBackendXPATHApplicationName = @"//section/h3";
NSString *kECASBackendXPATHApplicationLink = @"//tbody/tr/td[2]/a";

NSString *kECASBackendXPATHApplicationsKey = @"kECASBackendXPATHApplicationsKey";
NSString *kECASBackendXPATHApplicationNameKey = @"kECASBackendXPATHApplicationNameKey";
NSString *kECASBackendXPATHApplicationLinkKey = @"kECASBackendXPATHApplicationLinkKey";

@interface ECASBackendService ()
@property (nonatomic) AFHTTPRequestOperationManager *operationManager;
@end

@implementation ECASBackendService

- (instancetype)init {
	self = [super init];
	if (self) {
		self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://services3.cic.gc.ca/ecas/"]];
		self.operationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
		self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
		[self.operationManager.responseSerializer setAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 103)]];

		self.parserDescriptor = @{ kECASBackendXPATHApplicationsKey : kECASBackendXPATHApplications,
			                       kECASBackendXPATHApplicationNameKey : kECASBackendXPATHApplicationName,
			                       kECASBackendXPATHApplicationLinkKey : kECASBackendXPATHApplicationLink };
	}
	return self;
}

+ (instancetype)sharedService {
	static dispatch_once_t onceToken;
	static id instance = nil;
	dispatch_once(&onceToken, ^{
	    instance = [ECASBackendService new];
	});
	return instance;
}

- (AFHTTPRequestOperation *)authenticateIdentity:(ECASIdentity *)identity withCompletionBlock:(void (^)(NSError *error))completionBlock {
	AFHTTPRequestOperation *operation = [self.operationManager POST:@"authenticate.do"
	                                                     parameters:[[MTLJSONAdapter JSONDictionaryFromModel:identity] mtl_dictionaryByAddingEntriesFromDictionary:
	                                                                                                           @{ @"_page":@"_target0", @"app":@"ecas", @"_submit":@"Continue", @"lang":@"" }]
	                                                        success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    if (completionBlock) {
	        if (operation.response.statusCode == 302) {
	            completionBlock(nil);
			}
	        else {
	            completionBlock([NSError errorWithDomain:@"" code:0 userInfo:@{ NSLocalizedDescriptionKey: @"302 code expected" }]);
			}
		}
	}

	                                                        failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    if (completionBlock) {
	        completionBlock(error);
		}
	}];
	[operation setRedirectResponseBlock: ^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
	    //disable redirect
	    if (redirectResponse) {
	        return nil;
		}
	    return request;
	}];
	return operation;
}

- (AFHTTPRequestOperation *)queryECASStatusWithCompletionBlock:(void (^)(NSArray *applications, NSError *error))completionBlock {
	return [self.operationManager GET:@"viewcasestatus.do"
	                       parameters:@{ @"app":@"ecas" }
	                          success: ^(AFHTTPRequestOperation *operation, NSData *responseObject) {
	    if (completionBlock) {
	        NSMutableArray *applicationsArr = [NSMutableArray array];

	        TFHpple *applicationsParser = [TFHpple hppleWithHTMLData:responseObject];

	        NSArray *applicationsNodes = [applicationsParser searchWithXPathQuery:
	                                      self.parserDescriptor[kECASBackendXPATHApplicationsKey]];
	        for (TFHppleElement * element in applicationsNodes) {
	            TFHpple *appParser = [TFHpple hppleWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
	            NSString *appName = [[appParser peekAtSearchWithXPathQuery:self.parserDescriptor[kECASBackendXPATHApplicationNameKey]] text];
	            NSString *appLink = [[appParser peekAtSearchWithXPathQuery:self.parserDescriptor[kECASBackendXPATHApplicationLinkKey]] objectForKey:@"href"];
	            if (appName.length && appLink.length) {
	                [applicationsArr addObject:[ECASApplication applicationWithName:appName
	                                                                      statusUrl:[NSURL URLWithString:appLink relativeToURL:self.operationManager.baseURL]]];
				}
			}
	        completionBlock(applicationsArr.copy, nil);
		}
	}

	                          failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    if (completionBlock) {
	        completionBlock(nil, error);
		}
	}];
}

- (AFHTTPRequestOperation *)queryApplicationStatus:(ECASApplication *)application withCompletionBlock:(void (^)(NSArray *statusRecords, NSError *error))completionBlock {
	NSString *query = application.statusUrl.query;
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[[query componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString *pairStr, NSUInteger idx, BOOL *stop) {
		NSArray *pair = [pairStr componentsSeparatedByString:@"="];
		params[pair[0]] = pair[1];
	}];
	return [self.operationManager GET:application.statusUrl.relativePath
						   parameters:params
							  success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
								  if (completionBlock) {
									  TFHpple *parser = [TFHpple hppleWithHTMLData:responseObject];
									  NSString *appType = [parser peekAtSearchWithXPathQuery:@"//form[@action='viewcasehistory.do']/section/h2"].text;
									  NSArray *history = [parser searchWithXPathQuery:@"//form[@action='viewcasehistory.do']/section/ol/li"];
									  NSMutableArray *mutableHistoryArr = [NSMutableArray array];
									  for (TFHppleElement *elem in history) {
										  [mutableHistoryArr addObject:elem.text];
									  }
									  completionBlock(mutableHistoryArr.copy, nil);
								  }
							  }
							  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
								  if (completionBlock) {
									  completionBlock(nil, error);
								  }
							  }];
}

@end
