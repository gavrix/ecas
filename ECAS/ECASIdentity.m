//
//  ECASIdentity.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 4/29/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASIdentity.h"

#import <FXKeychain/FXKeychain.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>


NSArray *ECASIdentificationTypes() {
	static NSArray *ECASIdentificationTypesArray = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		ECASIdentificationTypesArray = @[
										 @"Client ID Number / Unique Client Identifier",
										 @"Receipt Number (IMM 5401)",
										 @"Immigration File Number / Application Number",
										 @"Record of Landing Number",
										 @"Permanent Resident Card Number",
										 @"Citizenship Receipt Number",
										 @"Citizenship File Number",
										 @"Confirmation of Permanent Residence Number",
										 ];
	});
	return ECASIdentificationTypesArray;
}

NSArray *ECASCountries() {
	static NSArray *ECASCountriesArray = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		ECASCountriesArray = @[
							   @{@"value":@"252", @"name":@"Afghanistan"},
							   @{@"value":@"199", @"name":@"Africa NES"},
							   @{@"value":@"081", @"name":@"Albania"},
							   @{@"value":@"131", @"name":@"Algeria"},
							   @{@"value":@"082", @"name":@"Andorra"},
							   @{@"value":@"151", @"name":@"Angola"},
							   @{@"value":@"620", @"name":@"Anguilla"},
							   @{@"value":@"621", @"name":@"Antigua and Barbuda"},
							   @{@"value":@"703", @"name":@"Argentina"},
							   @{@"value":@"049", @"name":@"Armenia"},
							   @{@"value":@"658", @"name":@"Aruba"},
							   @{@"value":@"299", @"name":@"Asia NES"},
							   @{@"value":@"305", @"name":@"Australia"},
							   @{@"value":@"399", @"name":@"Australia NES"},
							   @{@"value":@"011", @"name":@"Austria"},
							   @{@"value":@"050", @"name":@"Azerbaijan"},
							   @{@"value":@"035", @"name":@"Azores"},
							   @{@"value":@"622", @"name":@"Bahama Islands, The"},
							   @{@"value":@"253", @"name":@"Bahrain"},
							   @{@"value":@"212", @"name":@"Bangladesh"},
							   @{@"value":@"610", @"name":@"Barbados"},
							   @{@"value":@"051", @"name":@"Belarus"},
							   @{@"value":@"012", @"name":@"Belgium"},
							   @{@"value":@"541", @"name":@"Belize"},
							   @{@"value":@"160", @"name":@"Benin, Peoples Republic of"},
							   @{@"value":@"601", @"name":@"Bermuda"},
							   @{@"value":@"254", @"name":@"Bhutan"},
							   @{@"value":@"751", @"name":@"Bolivia"},
							   @{@"value":@"048", @"name":@"Bosnia-Hercegovina"},
							   @{@"value":@"153", @"name":@"Botswana, Republic of"},
							   @{@"value":@"709", @"name":@"Brazil"},
							   @{@"value":@"255", @"name":@"Brunei"},
							   @{@"value":@"083", @"name":@"Bulgaria"},
							   @{@"value":@"188", @"name":@"Burkina-Faso"},
							   @{@"value":@"154", @"name":@"Burundi"},
							   @{@"value":@"256", @"name":@"Cambodia"},
							   @{@"value":@"155", @"name":@"Cameroon, Federal Republic of"},
							   @{@"value":@"511", @"name":@"Canada"},
							   @{@"value":@"039", @"name":@"Canary Islands"},
							   @{@"value":@"911", @"name":@"Cape Verde Islands"},
							   @{@"value":@"624", @"name":@"Cayman Islands"},
							   @{@"value":@"157", @"name":@"Central African Republic"},
							   @{@"value":@"549", @"name":@"Central America NES"},
							   @{@"value":@"156", @"name":@"Chad, Republic of"},
							   @{@"value":@"009", @"name":@"Channel Islands"},
							   @{@"value":@"721", @"name":@"Chile"},
							   @{@"value":@"202", @"name":@"China, People's Republic of"},
							   @{@"value":@"722", @"name":@"Colombia"},
							   @{@"value":@"830", @"name":@"Commonwealth of the Northern Mariana Islands"},
							   @{@"value":@"905", @"name":@"Comoros"},
							   @{@"value":@"158", @"name":@"Congo, Democratic Republic of the"},
							   @{@"value":@"159", @"name":@"Congo, People's Republic of the"},
							   @{@"value":@"840", @"name":@"Cook Islands"},
							   @{@"value":@"542", @"name":@"Costa Rica"},
							   @{@"value":@"043", @"name":@"Croatia"},
							   @{@"value":@"650", @"name":@"Cuba"},
							   @{@"value":@"221", @"name":@"Cyprus"},
							   @{@"value":@"015", @"name":@"Czech Republic"},
							   @{@"value":@"014", @"name":@"Czechoslovakia"},
							   @{@"value":@"017", @"name":@"Denmark"},
							   @{@"value":@"183", @"name":@"Djibouti, Republic of"},
							   @{@"value":@"625", @"name":@"Dominica"},
							   @{@"value":@"651", @"name":@"Dominican Republic"},
							   @{@"value":@"916", @"name":@"East Timor, Democratic Republic of"},
							   @{@"value":@"753", @"name":@"Ecuador"},
							   @{@"value":@"101", @"name":@"Egypt"},
							   @{@"value":@"543", @"name":@"El Salvador"},
							   @{@"value":@"002", @"name":@"England"},
							   @{@"value":@"162", @"name":@"Eritrea"},
							   @{@"value":@"018", @"name":@"Estonia"},
							   @{@"value":@"161", @"name":@"Ethiopia"},
							   @{@"value":@"099", @"name":@"Europe NES"},
							   @{@"value":@"912", @"name":@"Falkland Islands"},
							   @{@"value":@"835", @"name":@"Federated States of Micronesia"},
							   @{@"value":@"801", @"name":@"Fiji"},
							   @{@"value":@"021", @"name":@"Finland"},
							   @{@"value":@"022", @"name":@"France"},
							   @{@"value":@"754", @"name":@"French Guiana"},
							   @{@"value":@"845", @"name":@"French Polynesia"},
							   @{@"value":@"163", @"name":@"Gabon Republic"},
							   @{@"value":@"164", @"name":@"Gambia"},
							   @{@"value":@"052", @"name":@"Georgia"},
							   @{@"value":@"046", @"name":@"Germany, Democratic Republic"},
							   @{@"value":@"024", @"name":@"Germany, Federal Republic of"},
							   @{@"value":@"165", @"name":@"Ghana"},
							   @{@"value":@"084", @"name":@"Gibraltar"},
							   @{@"value":@"025", @"name":@"Greece"},
							   @{@"value":@"521", @"name":@"Greenland"},
							   @{@"value":@"626", @"name":@"Grenada"},
							   @{@"value":@"653", @"name":@"Guadeloupe"},
							   @{@"value":@"832", @"name":@"Guam"},
							   @{@"value":@"544", @"name":@"Guatemala"},
							   @{@"value":@"178", @"name":@"Guinea, Equatorial"},
							   @{@"value":@"166", @"name":@"Guinea, Republic of"},
							   @{@"value":@"167", @"name":@"Guinea-Bissau"},
							   @{@"value":@"711", @"name":@"Guyana"},
							   @{@"value":@"654", @"name":@"Haiti"},
							   @{@"value":@"090", @"name":@"Holy See"},
							   @{@"value":@"545", @"name":@"Honduras"},
							   @{@"value":@"204", @"name":@"Hong Kong"},
							   @{@"value":@"200", @"name":@"Hong Kong SAR"},
							   @{@"value":@"026", @"name":@"Hungary"},
							   @{@"value":@"085", @"name":@"Iceland"},
							   @{@"value":@"205", @"name":@"India"},
							   @{@"value":@"222", @"name":@"Indonesia, Republic of"},
							   @{@"value":@"223", @"name":@"Iran"},
							   @{@"value":@"224", @"name":@"Iraq"},
							   @{@"value":@"027", @"name":@"Ireland, Republic of"},
							   @{@"value":@"206", @"name":@"Israel"},
							   @{@"value":@"028", @"name":@"Italy"},
							   @{@"value":@"169", @"name":@"Ivory Coast, Republic of"},
							   @{@"value":@"602", @"name":@"Jamaica"},
							   @{@"value":@"207", @"name":@"Japan"},
							   @{@"value":@"225", @"name":@"Jordan"},
							   @{@"value":@"053", @"name":@"Kazakhstan"},
							   @{@"value":@"132", @"name":@"Kenya"},
							   @{@"value":@"831", @"name":@"Kiribati"},
							   @{@"value":@"257", @"name":@"Korea, People's Democratic Republic of"},
							   @{@"value":@"258", @"name":@"Korea, Republic of"},
							   @{@"value":@"226", @"name":@"Kuwait"},
							   @{@"value":@"054", @"name":@"Kyrgyzstan"},
							   @{@"value":@"260", @"name":@"Laos"},
							   @{@"value":@"019", @"name":@"Latvia"},
							   @{@"value":@"208", @"name":@"Lebanon"},
							   @{@"value":@"152", @"name":@"Lesotho"},
							   @{@"value":@"170", @"name":@"Liberia"},
							   @{@"value":@"171", @"name":@"Libya"},
							   @{@"value":@"086", @"name":@"Liechtenstein"},
							   @{@"value":@"020", @"name":@"Lithuania"},
							   @{@"value":@"013", @"name":@"Luxembourg"},
							   @{@"value":@"261", @"name":@"Macao"},
							   @{@"value":@"198", @"name":@"Macao SAR"},
							   @{@"value":@"070", @"name":@"Macedonia, FYR"},
							   @{@"value":@"172", @"name":@"Madagascar"},
							   @{@"value":@"036", @"name":@"Madeira"},
							   @{@"value":@"111", @"name":@"Malawi"},
							   @{@"value":@"242", @"name":@"Malaysia"},
							   @{@"value":@"901", @"name":@"Maldives, Republic of"},
							   @{@"value":@"173", @"name":@"Mali, Republic of"},
							   @{@"value":@"030", @"name":@"Malta"},
							   @{@"value":@"833", @"name":@"Marinas"},
							   @{@"value":@"655", @"name":@"Martinique"},
							   @{@"value":@"174", @"name":@"Mauritania"},
							   @{@"value":@"902", @"name":@"Mauritius"},
							   @{@"value":@"906", @"name":@"Mayotte"},
							   @{@"value":@"501", @"name":@"Mexico"},
							   @{@"value":@"055", @"name":@"Moldova"},
							   @{@"value":@"087", @"name":@"Monaco"},
							   @{@"value":@"262", @"name":@"Mongolia, People's Republic of"},
							   @{@"value":@"063", @"name":@"Montenegro, Republic of"},
							   @{@"value":@"627", @"name":@"Montserrat"},
							   @{@"value":@"133", @"name":@"Morocco"},
							   @{@"value":@"175", @"name":@"Mozambique"},
							   @{@"value":@"241", @"name":@"Myanmar (Burma)"},
							   @{@"value":@"122", @"name":@"Namibia"},
							   @{@"value":@"341", @"name":@"Nauru"},
							   @{@"value":@"264", @"name":@"Nepal"},
							   @{@"value":@"652", @"name":@"Netherlands Antilles, The"},
							   @{@"value":@"031", @"name":@"Netherlands, The"},
							   @{@"value":@"628", @"name":@"Nevis"},
							   @{@"value":@"822", @"name":@"New Caledonia"},
							   @{@"value":@"339", @"name":@"New Zealand"},
							   @{@"value":@"512", @"name":@"Newfoundland"},
							   @{@"value":@"546", @"name":@"Nicaragua"},
							   @{@"value":@"176", @"name":@"Niger, Republic of the"},
							   @{@"value":@"177", @"name":@"Nigeria"},
							   @{@"value":@"271", @"name":@"North Vietnam"},
							   @{@"value":@"006", @"name":@"Northern Ireland"},
							   @{@"value":@"032", @"name":@"Norway"},
							   @{@"value":@"899", @"name":@"Ocean NES"},
							   @{@"value":@"263", @"name":@"Oman"},
							   @{@"value":@"209", @"name":@"Pakistan"},
							   @{@"value":@"275", @"name":@"Palestine"},
							   @{@"value":@"213", @"name":@"Palestinian Authority (Gaza/West Bank)"},
							   @{@"value":@"548", @"name":@"Panama Canal Zone"},
							   @{@"value":@"547", @"name":@"Panama, Republic of"},
							   @{@"value":@"343", @"name":@"Papau"},
							   @{@"value":@"342", @"name":@"Papua New Guinea"},
							   @{@"value":@"755", @"name":@"Paraguay"},
							   @{@"value":@"723", @"name":@"Peru"},
							   @{@"value":@"227", @"name":@"Philippines"},
							   @{@"value":@"842", @"name":@"Pitcairn Island"},
							   @{@"value":@"033", @"name":@"Poland"},
							   @{@"value":@"034", @"name":@"Portugal"},
							   @{@"value":@"656", @"name":@"Puerto Rico"},
							   @{@"value":@"265", @"name":@"Qatar"},
							   @{@"value":@"064", @"name":@"Republic of Kosovo"},
							   @{@"value":@"836", @"name":@"Republic of Palau"},
							   @{@"value":@"834", @"name":@"Republic of The Marshall Islands"},
							   @{@"value":@"903", @"name":@"Reunion"},
							   @{@"value":@"088", @"name":@"Romania"},
							   @{@"value":@"056", @"name":@"Russia"},
							   @{@"value":@"179", @"name":@"Rwanda"},
							   @{@"value":@"843", @"name":@"Samoa, American"},
							   @{@"value":@"844", @"name":@"Samoa, Independent State Of"},
							   @{@"value":@"089", @"name":@"San Marino"},
							   @{@"value":@"914", @"name":@"Sao Tome and Principe"},
							   @{@"value":@"231", @"name":@"Saudi Arabia"},
							   @{@"value":@"007", @"name":@"Scotland"},
							   @{@"value":@"180", @"name":@"Senegal"},
							   @{@"value":@"061", @"name":@"Serbia and Montenegro"},
							   @{@"value":@"062", @"name":@"Serbia, Republic of"},
							   @{@"value":@"904", @"name":@"Seychelles"},
							   @{@"value":@"181", @"name":@"Sierra Leone"},
							   @{@"value":@"266", @"name":@"Sikkim (Asia)"},
							   @{@"value":@"246", @"name":@"Singapore"},
							   @{@"value":@"016", @"name":@"Slovak Republic"},
							   @{@"value":@"047", @"name":@"Slovenia"},
							   @{@"value":@"825", @"name":@"Soloman Islands"},
							   @{@"value":@"824", @"name":@"Solomons, The"},
							   @{@"value":@"182", @"name":@"Somalia, Democratic Republic of"},
							   @{@"value":@"121", @"name":@"South Africa, Republic of"},
							   @{@"value":@"799", @"name":@"South America NES"},
							   @{@"value":@"189", @"name":@"South Sudan, Republic Of"},
							   @{@"value":@"821", @"name":@"Southern Antarctic Territories"},
							   @{@"value":@"037", @"name":@"Spain"},
							   @{@"value":@"201", @"name":@"Sri Lanka"},
							   @{@"value":@"915", @"name":@"St. Helena"},
							   @{@"value":@"629", @"name":@"St. Kitts-Nevis"},
							   @{@"value":@"630", @"name":@"St. Lucia"},
							   @{@"value":@"531", @"name":@"St. Pierre and Miquelon"},
							   @{@"value":@"631", @"name":@"St. Vincent and the Grenadines"},
							   @{@"value":@"185", @"name":@"Sudan, Democratic Republic of"},
							   @{@"value":@"752", @"name":@"Surinam"},
							   @{@"value":@"186", @"name":@"Swaziland"},
							   @{@"value":@"040", @"name":@"Sweden"},
							   @{@"value":@"041", @"name":@"Switzerland"},
							   @{@"value":@"210", @"name":@"Syria"},
							   @{@"value":@"057", @"name":@"Tadjikistan"},
							   @{@"value":@"203", @"name":@"Taiwan"},
							   @{@"value":@"130", @"name":@"Tanzania, United Republic of"},
							   @{@"value":@"267", @"name":@"Thailand"},
							   @{@"value":@"268", @"name":@"Tibet"},
							   @{@"value":@"187", @"name":@"Togo, Republic of"},
							   @{@"value":@"846", @"name":@"Tonga"},
							   @{@"value":@"605", @"name":@"Trinidad and Tobago, Republic of"},
							   @{@"value":@"135", @"name":@"Tunisia"},
							   @{@"value":@"045", @"name":@"Turkey"},
							   @{@"value":@"058", @"name":@"Turkmenistan"},
							   @{@"value":@"632", @"name":@"Turks and Caicos Islands"},
							   @{@"value":@"826", @"name":@"Tuvalu"},
							   @{@"value":@"136", @"name":@"Uganda"},
							   @{@"value":@"059", @"name":@"Ukraine"},
							   @{@"value":@"042", @"name":@"Union of Soviet Socialist Republics"},
							   @{@"value":@"280", @"name":@"United Arab Emirates"},
							   @{@"value":@"001", @"name":@"United Kingdom and Colonies"},
							   @{@"value":@"461", @"name":@"United States of America"},
							   @{@"value":@"724", @"name":@"Uruguay"},
							   @{@"value":@"060", @"name":@"Uzbekistan"},
							   @{@"value":@"823", @"name":@"Vanuatu"},
							   @{@"value":@"725", @"name":@"Venezuela"},
							   @{@"value":@"270", @"name":@"Vietnam, Socialist Republic of"},
							   @{@"value":@"633", @"name":@"Virgin Islands, British"},
							   @{@"value":@"657", @"name":@"Virgin Islands, U.S."},
							   @{@"value":@"008", @"name":@"Wales"},
							   @{@"value":@"841", @"name":@"Wallis And Futuna"},
							   @{@"value":@"699", @"name":@"West Indies NES"},
							   @{@"value":@"184", @"name":@"Western Sahara"},
							   @{@"value":@"274", @"name":@"Yemen, People's Democratic Republic of"},
							   @{@"value":@"273", @"name":@"Yemen, Republic of"},
							   @{@"value":@"044", @"name":@"Yugoslavia"},
							   @{@"value":@"112", @"name":@"Zambia"},
							   @{@"value":@"113", @"name":@"Zimbabwe"},
							   ];
	});
	return ECASCountriesArray;
}

NSDictionary *ECASKeydConutriesNames() {
	static NSDictionary *ECASKeydConutriesNamesDict = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
		for (NSDictionary *country in ECASCountries()) {
			mutableDictionary[country[@"value"]] = country[@"name"];
		}
		ECASKeydConutriesNamesDict = mutableDictionary.copy;

	});
	return ECASKeydConutriesNamesDict;
}


@implementation ECASIdentity

- (id)init {
	self = [super init];
	if (self) {
		@weakify(self)
		[[[RACSignal merge:@[
							 [[RACObserve(self, lastName) skip:2] distinctUntilChanged],
							 [[RACObserve(self, birthday) skip:2] distinctUntilChanged],
							 [[RACObserve(self, identificationType) skip:2] distinctUntilChanged],
							 [[RACObserve(self, identificationNumber) skip:2] distinctUntilChanged],
							 [[RACObserve(self, placeOfBirth) skip:2] distinctUntilChanged]
							 ]] mapReplace:nil] subscribeNext:^(id x) {
			@strongify(self)
			[self saveIdentity];
		}];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.lastName forKey:@"lastname"];
	[aCoder encodeObject:self.birthday forKey:@"birthday"];
	[aCoder encodeObject:self.identificationType forKey:@"identificationType"];
	[aCoder encodeObject:self.identificationNumber forKey:@"identificationNumber"];
	[aCoder encodeObject:self.placeOfBirth forKey:@"placeOfBirth"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [self init];
	if (self && aDecoder) {
		self.lastName = [aDecoder decodeObjectForKey:@"lastname"];
		self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
		self.identificationType = [aDecoder decodeObjectForKey:@"identificationType"];
		self.identificationNumber = [aDecoder decodeObjectForKey:@"identificationNumber"];
		self.placeOfBirth = [aDecoder decodeObjectForKey:@"placeOfBirth"];

	}
	return self;
}

- (void)saveIdentity {
	NSMutableData *data = [NSMutableData new];
	NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[self encodeWithCoder:coder];
	[coder finishEncoding];
	FXKeychain *keychain = [FXKeychain defaultKeychain];
	keychain[@"identity"] = data;
}

+ (instancetype)globalIdentity {
	FXKeychain *keychain = [FXKeychain defaultKeychain];
	NSData *data = keychain[@"identity"];
	id _self = nil;
	if (data && [data isKindOfClass:[NSData class]]) {
		_self = [[self.class alloc] initWithCoder:[[NSKeyedUnarchiver alloc] initForReadingWithData:data]];
	}
	else {
		_self = [self.class new];
	}
	return _self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
			 @"identificationType": @"identifierType",
			 @"identificationNumber": @"identifier",
			 @"lastName": @"surname",
			 @"birthday": @"dateOfBirth",
			 @"placeOfBirth": @"countryOfBirth"
			 };
}


+ (NSValueTransformer *)birthdayJSONTransformer {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"YYYY-MM-dd"];
	
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [formatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [formatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)identificationTypeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *value) {
        return @(value.intValue - 1);
    } reverseBlock:^(NSNumber *value) {
        return @(value.intValue + 1);
    }];
}

@end
