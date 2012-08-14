package com.chinarewards.report.qqvipadidas;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class PosOfCity {

	private final static String 济南银隆广场 = "济南银隆广场";
	private final static String 济南泉城广场 = "济南泉城广场";
	private final static String 济南恒隆广场 = "济南恒隆广场";
	private final static String 济南贵和广场 = "济南贵和广场";
	private final static String 济南玉函银座 = "济南玉函银座";
	private final static String 济南银座 = "济南银座";
	private final static String 济南洪楼银座 = "济南洪楼银座";
	private final static String 上海置地广场店 = "上海置地广场店";
	private final static String 上海来福士广场 = "上海来福士广场";
	private final static String 上海龙之梦店铺店 = "上海龙之梦店铺店";
	private final static String 上海莘庄百盛店 = "上海莘庄百盛店";
	private final static String 上海打浦桥日月光 = "上海打浦桥日月光";
	private final static String 上海新世界店 = "上海新世界店";
	private final static String 上海成山路浦东商场店 = "上海成山路浦东商场店";
	private final static String 上海港汇广场SC店 = "上海港汇广场SC店";
	private final static String 上海浦东金汇广场店 = "上海浦东金汇广场店";
	private final static String 上海嘉定罗滨森 = "上海嘉定罗滨森";
	private final static String 沈阳运动元素店 = "沈阳运动元素店";
	private final static String 沈阳运动汇店 = "沈阳运动汇店";
	private final static String 沈阳运动源店 = "沈阳运动源店";
	private final static String 沈阳运动家店 = "沈阳运动家店";
	private final static String 沈阳嘉合店 = "沈阳嘉合店";
	private final static String 沈阳大悦城店 = "沈阳大悦城店";
	private final static String 沈阳中街恒隆 = "沈阳中街恒隆";
	private final static String 沈阳万象城 = "沈阳万象城";
	private final static String 沈阳太原街中兴店 = "沈阳太原街中兴店";
	private final static String 广州百丽大厦店 = "广州百丽大厦店";
	private final static String 广州天河城百货 = "广州天河城百货";
	private final static String 广州富一城Sanse名城SC店 = "广州富一城Sanse名城SC店";
	private final static String 广州东川运动城SC店 = "广州东川运动城SC店";
	private final static String 广州北京路广百SE店 = "广州北京路广百SE店";
	private final static String 广州中怡广百Neo店 = "广州中怡广百Neo店";
	private final static String 广州正佳友谊SC店 = "广州正佳友谊SC店";
	private final static String 广州天河城百货名盛SC店 = "广州天河城百货名盛SC店";
	private final static String 广州北京路广百GBF = "广州北京路广百GBF";
	private final static String 广州宝元正佳运动城 = "广州宝元正佳运动城";
	private final static String 深圳南山天虹SC店 = "深圳南山天虹SC店";
	private final static String 深圳太阳广场SC店 = "深圳太阳广场SC店";
	private final static String 深圳南山欢乐颂 = "深圳南山欢乐颂";
	private final static String 深圳华强北茂业 = "深圳华强北茂业";
	private final static String 深圳东门茂业百货 = "深圳东门茂业百货";
	private final static String 深圳龙岗世贸ASE店 = "深圳龙岗世贸ASE店";
	private final static String 深圳双龙天虹 = "深圳双龙天虹";
	private final static String 深圳南山保利广场 = "深圳南山保利广场";
	private final static String 深圳万象城运动一百SC店 = "深圳万象城运动一百SC店";
	private final static String 深圳宝安海雅 = "深圳宝安海雅";
	private final static String 成都金开百货运动城 = "成都金开百货运动城";
	private final static String 成都伊藤锦华店AD生活店 = "成都伊藤锦华店AD生活店";
	private final static String 成都新世界百货 = "成都新世界百货";
	private final static String 成都凯丹广场ASE店 = "成都凯丹广场ASE店";
	private final static String 四川成都西单商场 = "四川成都西单商场";
	private final static String 成都王府井百货店 = "成都王府井百货店";
	private final static String 成都双楠置信店 = "成都双楠置信店";
	private final static String 成都群光百货店 = "成都群光百货店";
	private final static String 川渝休闲双楠逸都路Neo店 = "川渝休闲双楠逸都路Neo店";
	private final static String 川渝休闲春熙路北段后巷子Neo店 = "川渝休闲春熙路北段后巷子Neo店";

	private static Map<String, String> posKeyMerchantMap = new HashMap<String, String>();
	
	//private static Map<String, String> posKeyCityMap = new HashMap<String, String>();

	private static Map<String, Integer> merchantMap = new HashMap<String, Integer>();

	public static String getMerchantNameByPosId(String posId) {
		if (posKeyMerchantMap.containsKey(posId))
			return posKeyMerchantMap.get(posId);
		else
			return "未知";
	}

	static {
		
//		init city map
//		
//		// 济南
//		posKeyCityMap.put("CR-000000320", 济南银隆广场);
//		posKeyCityMap.put("CR-000000035", 济南银隆广场);
//		posKeyCityMap.put("CR-000000094", 济南泉城广场);
//		posKeyCityMap.put("CR-000000304", 济南恒隆广场);
//		posKeyCityMap.put("CR-000000250", 济南恒隆广场);
//		posKeyCityMap.put("CR-000000155", 济南贵和广场);
//		posKeyCityMap.put("CR-000000309", 济南玉函银座);
//		posKeyCityMap.put("CR-000000047", 济南银座);
//		posKeyCityMap.put("CR-000000084", 济南洪楼银座);
//
//		// 上海
//		posKeyCityMap.put("CR-000000060", 上海置地广场店);
//		posKeyCityMap.put("CR-000000097", 上海来福士广场);
//		posKeyCityMap.put("CR-000000126", 上海龙之梦店铺店);
//		posKeyCityMap.put("CR-000000242", 上海莘庄百盛店);
//		posKeyCityMap.put("CR-000000321", 上海莘庄百盛店);
//		posKeyCityMap.put("CR-000000089", 上海打浦桥日月光);
//		posKeyCityMap.put("CR-000000404", 上海新世界店);
//		posKeyCityMap.put("CR-000000406", 上海成山路浦东商场店);
//		posKeyCityMap.put("CR-000000230", 上海港汇广场SC店);
//		posKeyCityMap.put("CR-000000329", 上海浦东金汇广场店);
//		posKeyCityMap.put("CR-000000324", 上海嘉定罗滨森);
//
//		// 沈阳
//		posKeyCityMap.put("CR-000000206", 沈阳运动元素店);
//		posKeyCityMap.put("CR-000000229", 沈阳运动汇店);
//		posKeyCityMap.put("CR-000000306", 沈阳运动源店);
//		posKeyCityMap.put("CR-000000216", 沈阳运动家店);
//		posKeyCityMap.put("CR-000000170", 沈阳运动家店);
//		posKeyCityMap.put("CR-000000234", 沈阳嘉合店);
//		posKeyCityMap.put("CR-000000264", 沈阳大悦城店);
//		posKeyCityMap.put("CR-000000095", 沈阳大悦城店);
//		posKeyCityMap.put("CR-000000305", 沈阳中街恒隆);
//		posKeyCityMap.put("CR-000000087", 沈阳万象城);
//		posKeyCityMap.put("CR-000000093", 沈阳万象城);
//		posKeyCityMap.put("CR-000000013", 沈阳太原街中兴店);
//
//		// 广州
//		posKeyCityMap.put("CR-000000159", 广州百丽大厦店);
//		posKeyCityMap.put("CR-000000079", 广州天河城百货);
//		posKeyCityMap.put("CR-000000005", 广州天河城百货);
//		posKeyCityMap.put("CR-000000208", 广州富一城Sanse名城SC店);
//		posKeyCityMap.put("CR-000000198", 广州富一城Sanse名城SC店);
//		posKeyCityMap.put("CR-000000226", 广州东川运动城SC店);
//		posKeyCityMap.put("CR-000000333", 广州北京路广百SE店);
//		posKeyCityMap.put("CR-000000194", 广州北京路广百SE店);
//		posKeyCityMap.put("CR-000000283", 广州中怡广百Neo店);
//		posKeyCityMap.put("CR-000000214", 广州正佳友谊SC店);
//		posKeyCityMap.put("CR-000000263", 广州天河城百货名盛SC店);
//		posKeyCityMap.put("CR-000000207", 广州天河城百货名盛SC店);
//		posKeyCityMap.put("CR-000000335", 广州北京路广百GBF);
//		posKeyCityMap.put("CR-000000402", 广州宝元正佳运动城);
//
//		// 深圳
//		posKeyCityMap.put("CR-000000013", 深圳南山天虹SC店);
//		posKeyCityMap.put("CR-000000227", 深圳南山天虹SC店);
//		posKeyCityMap.put("CR-000000057", 深圳太阳广场SC店);
//		posKeyCityMap.put("CR-000000026", 深圳太阳广场SC店);
//		posKeyCityMap.put("CR-000000290", 深圳南山欢乐颂);
//		posKeyCityMap.put("CR-000000036", 深圳华强北茂业);
//		posKeyCityMap.put("CR-000000409", 深圳华强北茂业);
//		posKeyCityMap.put("CR-000000070", 深圳东门茂业百货);
//		posKeyCityMap.put("CR-000000025", 深圳东门茂业百货);
//		posKeyCityMap.put("CR-000000184", 深圳龙岗世贸ASE店);
//		posKeyCityMap.put("CR-000000266", 深圳双龙天虹);
//		posKeyCityMap.put("CR-000000318", 深圳南山保利广场);
//		posKeyCityMap.put("CR-000000221", 深圳万象城运动一百SC店);
//		posKeyCityMap.put("CR-000000120", 深圳万象城运动一百SC店);
//		posKeyCityMap.put("CR-000000015", 深圳宝安海雅);
//
//		// 成都
//		posKeyCityMap.put("CR-000000243", 成都金开百货运动城);
//		posKeyCityMap.put("CR-000000212", 成都伊藤锦华店AD生活店);
//		posKeyCityMap.put("CR-000000179", 成都新世界百货);
//		posKeyCityMap.put("CR-000000004", 成都凯丹广场ASE店);
//		posKeyCityMap.put("CR-000000403", 四川成都西单商场);
//		posKeyCityMap.put("CR-000000080", 成都王府井百货店);
//		posKeyCityMap.put("CR-000000331", 成都王府井百货店);
//		posKeyCityMap.put("CR-000000209", 成都双楠置信店);
//		posKeyCityMap.put("CR-000000096", 成都群光百货店);
//		posKeyCityMap.put("CR-000000313", 川渝休闲双楠逸都路Neo店);
//		posKeyCityMap.put("CR-000000008", 川渝休闲春熙路北段后巷子Neo店);
		
		//------------------------------
		
		// 济南
		posKeyMerchantMap.put("CR-000000320", 济南银隆广场);
		posKeyMerchantMap.put("CR-000000035", 济南银隆广场);
		posKeyMerchantMap.put("CR-000000094", 济南泉城广场);
		posKeyMerchantMap.put("CR-000000304", 济南恒隆广场);
		posKeyMerchantMap.put("CR-000000250", 济南恒隆广场);
		posKeyMerchantMap.put("CR-000000155", 济南贵和广场);
		posKeyMerchantMap.put("CR-000000309", 济南玉函银座);
		posKeyMerchantMap.put("CR-000000047", 济南银座);
		posKeyMerchantMap.put("CR-000000084", 济南洪楼银座);

		// 上海
		posKeyMerchantMap.put("CR-000000060", 上海置地广场店);
		posKeyMerchantMap.put("CR-000000097", 上海来福士广场);
		posKeyMerchantMap.put("CR-000000126", 上海龙之梦店铺店);
		posKeyMerchantMap.put("CR-000000242", 上海莘庄百盛店);
		posKeyMerchantMap.put("CR-000000321", 上海莘庄百盛店);
		posKeyMerchantMap.put("CR-000000089", 上海打浦桥日月光);
		posKeyMerchantMap.put("CR-000000404", 上海新世界店);
		posKeyMerchantMap.put("CR-000000406", 上海成山路浦东商场店);
		posKeyMerchantMap.put("CR-000000230", 上海港汇广场SC店);
		posKeyMerchantMap.put("CR-000000329", 上海浦东金汇广场店);
		posKeyMerchantMap.put("CR-000000324", 上海嘉定罗滨森);

		// 沈阳
		posKeyMerchantMap.put("CR-000000206", 沈阳运动元素店);
		posKeyMerchantMap.put("CR-000000229", 沈阳运动汇店);
		posKeyMerchantMap.put("CR-000000306", 沈阳运动源店);
		posKeyMerchantMap.put("CR-000000216", 沈阳运动家店);
		posKeyMerchantMap.put("CR-000000170", 沈阳运动家店);
		posKeyMerchantMap.put("CR-000000234", 沈阳嘉合店);
		posKeyMerchantMap.put("CR-000000264", 沈阳大悦城店);
		posKeyMerchantMap.put("CR-000000095", 沈阳大悦城店);
		posKeyMerchantMap.put("CR-000000305", 沈阳中街恒隆);
		posKeyMerchantMap.put("CR-000000087", 沈阳万象城);
		posKeyMerchantMap.put("CR-000000093", 沈阳万象城);
		posKeyMerchantMap.put("CR-000000013", 沈阳太原街中兴店);

		// 广州
		posKeyMerchantMap.put("CR-000000159", 广州百丽大厦店);
		posKeyMerchantMap.put("CR-000000079", 广州天河城百货);
		posKeyMerchantMap.put("CR-000000005", 广州天河城百货);
		posKeyMerchantMap.put("CR-000000208", 广州富一城Sanse名城SC店);
		posKeyMerchantMap.put("CR-000000198", 广州富一城Sanse名城SC店);
		posKeyMerchantMap.put("CR-000000226", 广州东川运动城SC店);
		posKeyMerchantMap.put("CR-000000333", 广州北京路广百SE店);
		posKeyMerchantMap.put("CR-000000194", 广州北京路广百SE店);
		posKeyMerchantMap.put("CR-000000283", 广州中怡广百Neo店);
		posKeyMerchantMap.put("CR-000000214", 广州正佳友谊SC店);
		posKeyMerchantMap.put("CR-000000263", 广州天河城百货名盛SC店);
		posKeyMerchantMap.put("CR-000000207", 广州天河城百货名盛SC店);
		posKeyMerchantMap.put("CR-000000335", 广州北京路广百GBF);
		posKeyMerchantMap.put("CR-000000402", 广州宝元正佳运动城);

		// 深圳
		posKeyMerchantMap.put("CR-000000013", 深圳南山天虹SC店);
		posKeyMerchantMap.put("CR-000000227", 深圳南山天虹SC店);
		posKeyMerchantMap.put("CR-000000057", 深圳太阳广场SC店);
		posKeyMerchantMap.put("CR-000000026", 深圳太阳广场SC店);
		posKeyMerchantMap.put("CR-000000290", 深圳南山欢乐颂);
		posKeyMerchantMap.put("CR-000000036", 深圳华强北茂业);
		posKeyMerchantMap.put("CR-000000409", 深圳华强北茂业);
		posKeyMerchantMap.put("CR-000000070", 深圳东门茂业百货);
		posKeyMerchantMap.put("CR-000000025", 深圳东门茂业百货);
		posKeyMerchantMap.put("CR-000000184", 深圳龙岗世贸ASE店);
		posKeyMerchantMap.put("CR-000000266", 深圳双龙天虹);
		posKeyMerchantMap.put("CR-000000318", 深圳南山保利广场);
		posKeyMerchantMap.put("CR-000000221", 深圳万象城运动一百SC店);
		posKeyMerchantMap.put("CR-000000120", 深圳万象城运动一百SC店);
		posKeyMerchantMap.put("CR-000000015", 深圳宝安海雅);

		// 成都
		posKeyMerchantMap.put("CR-000000243", 成都金开百货运动城);
		posKeyMerchantMap.put("CR-000000212", 成都伊藤锦华店AD生活店);
		posKeyMerchantMap.put("CR-000000179", 成都新世界百货);
		posKeyMerchantMap.put("CR-000000004", 成都凯丹广场ASE店);
		posKeyMerchantMap.put("CR-000000403", 四川成都西单商场);
		posKeyMerchantMap.put("CR-000000080", 成都王府井百货店);
		posKeyMerchantMap.put("CR-000000331", 成都王府井百货店);
		posKeyMerchantMap.put("CR-000000209", 成都双楠置信店);
		posKeyMerchantMap.put("CR-000000096", 成都群光百货店);
		posKeyMerchantMap.put("CR-000000313", 川渝休闲双楠逸都路Neo店);
		posKeyMerchantMap.put("CR-000000008", 川渝休闲春熙路北段后巷子Neo店);

		// init cityMap
		merchantMap.put(济南银隆广场, new Integer(1));
		merchantMap.put(济南泉城广场, new Integer(2));
		merchantMap.put(济南恒隆广场, new Integer(3));
		merchantMap.put(济南贵和广场, new Integer(4));
		merchantMap.put(济南玉函银座, new Integer(5));
		merchantMap.put(济南银座, new Integer(6));
		merchantMap.put(济南洪楼银座, new Integer(7));
		merchantMap.put(上海置地广场店, new Integer(8));
		merchantMap.put(上海来福士广场, new Integer(9));
		merchantMap.put(上海龙之梦店铺店, new Integer(10));
		merchantMap.put(上海莘庄百盛店, new Integer(11));
		merchantMap.put(上海打浦桥日月光, new Integer(12));
		merchantMap.put(上海新世界店, new Integer(13));
		merchantMap.put(上海成山路浦东商场店, new Integer(14));
		merchantMap.put(上海港汇广场SC店, new Integer(15));
		merchantMap.put(上海浦东金汇广场店, new Integer(16));
		merchantMap.put(上海嘉定罗滨森, new Integer(17));
		merchantMap.put(沈阳运动元素店, new Integer(18));
		merchantMap.put(沈阳运动汇店, new Integer(19));
		merchantMap.put(沈阳运动源店, new Integer(20));
		merchantMap.put(沈阳运动家店, new Integer(21));
		merchantMap.put(沈阳嘉合店, new Integer(22));
		merchantMap.put(沈阳大悦城店, new Integer(23));
		merchantMap.put(沈阳中街恒隆, new Integer(24));
		merchantMap.put(沈阳万象城, new Integer(25));
		merchantMap.put(沈阳太原街中兴店, new Integer(26));
		merchantMap.put(广州百丽大厦店, new Integer(27));
		merchantMap.put(广州天河城百货, new Integer(28));
		merchantMap.put(广州富一城Sanse名城SC店, new Integer(29));
		merchantMap.put(广州东川运动城SC店, new Integer(30));
		merchantMap.put(广州北京路广百SE店, new Integer(31));
		merchantMap.put(广州中怡广百Neo店, new Integer(32));
		merchantMap.put(广州正佳友谊SC店, new Integer(33));
		merchantMap.put(广州天河城百货名盛SC店, new Integer(34));
		merchantMap.put(广州北京路广百GBF, new Integer(35));
		merchantMap.put(广州宝元正佳运动城, new Integer(36));
		merchantMap.put(深圳南山天虹SC店, new Integer(37));
		merchantMap.put(深圳太阳广场SC店, new Integer(38));
		merchantMap.put(深圳南山欢乐颂, new Integer(39));
		merchantMap.put(深圳华强北茂业, new Integer(40));
		merchantMap.put(深圳东门茂业百货, new Integer(41));
		merchantMap.put(深圳龙岗世贸ASE店, new Integer(42));
		merchantMap.put(深圳双龙天虹, new Integer(43));
		merchantMap.put(深圳南山保利广场, new Integer(44));
		merchantMap.put(深圳万象城运动一百SC店, new Integer(45));
		merchantMap.put(深圳宝安海雅, new Integer(46));
		merchantMap.put(成都金开百货运动城, new Integer(47));
		merchantMap.put(成都伊藤锦华店AD生活店, new Integer(48));
		merchantMap.put(成都新世界百货, new Integer(49));
		merchantMap.put(成都凯丹广场ASE店, new Integer(50));
		merchantMap.put(四川成都西单商场, new Integer(51));
		merchantMap.put(成都王府井百货店, new Integer(52));
		merchantMap.put(成都双楠置信店, new Integer(53));
		merchantMap.put(成都群光百货店, new Integer(54));
		merchantMap.put(川渝休闲双楠逸都路Neo店, new Integer(55));
		merchantMap.put(川渝休闲春熙路北段后巷子Neo店, new Integer(56));

	}

	public static Set<String> getAllMerchantName() {
		return merchantMap.keySet();
	}

	public static int getIndexByMerchantName(String cityName) {
		return merchantMap.get(cityName).intValue();
	}

}
