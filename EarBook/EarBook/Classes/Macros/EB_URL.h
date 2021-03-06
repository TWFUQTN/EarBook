//
//  DB_URL.h
//  Day_07DouBan
//
//  Created by lanou3g on 16/6/16.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#ifndef EB_URL_h
#define EB_URL_h

// 基地址
#define EB_BASE_URL @"http://apis.mting.info"

// 推荐页列表数据
#define EB_RECOMMEND_LIST_URL @"http://apis.mting.info/yyting/gateway/batchOperation.action?imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&token=iEd4QgrcSw1-rXvkr8xNcXuanaVqazN3Qb63ToXOFc8*&nwt=1&operations=%5B%22%2Fyyting%2Fbookclient%2FClientGetTopicByType.action%3FterminalType%3D4%26type%3D12%22%2C%22%2Fyyting%2Fbookclient%2FgetRecommend.action%3Ftype%3D1%22%2C%22%2Fyyting%2Fadvertclient%2FgetBizAdvertList.action%3F%22%2C%22%2Fyyting%2Fbookclient%2FgetRecommendTypes.action%3Fsize%3D6%26type%3D3%26typeId%3D0%22%2C%22%2Fyyting%2Fbookclient%2FgetRecommendTypes.action%3Fsize%3D6%26type%3D4%26typeId%3D0%22%2C%22%2Fyyting%2Fbookclient%2FClientGetTopicList.action%3FisTop%3D1%26type%3D1%22%2C%22%2Fyyting%2Fbookclient%2FgetRecommend.action%3Ftype%3D2%22%2C%22%2Fyyting%2Fbookclient%2FgetRecommendTypes.action%3Fsize%3D3%26type%3D1%26typeId%3D0%22%5D&pfunction=1&q=201&sc=7676b0166bf565cd8dbbb13590c022a5"

// 书籍详情页基地址
#define EB_BOOK_DETAIL_BASE_URL @"http://apis.mting.info/yyting/bookclient/ClientGetBookDetail.action?id="

// 书籍详情页
#define EB_BOOK_DETAIL_URL @"&imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&q=3104&sc=1539ffe54be9ad405307820bdcbbb4cd&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw%2A"

// 书籍列表页基地址
#define EB_BOOK_LIST_BASE_URL @"http://42.62.15.103/yyting/bookclient/ClientGetBookResource.action?bookId="

// 书籍列表页1
#define EB_BOOK_LIST_URL1 @"&imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&pageNum="

// 书籍列表页2
#define EB_BOOK_LIST_URL2 @"&pageSize=50&q=904&sc=11619c41107cf5f3017e786f37252243&sortType=0&token=iEd4QgrcSw1-rXvkr8xNcXuanaVqazN3Qb63ToXOFc8%2A"

// more按钮地址
#define EB_MORE_EDIT_RECOMMEND_URL @"http://42.62.15.100/yyting/bookclient/ClientGetBookByTopic.action?imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&pageNum=1&pageSize=500&q=8202&sc=4514a4e550e11cd3e48574c69c413e0d&sort=0&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw%2A&topicId="

// 声音详情页基地址
#define EB_VOICE_BASE_URL @"http://42.62.15.101/yyting/snsresource/getAblumnDetail.action?id="

// 声音详情页
#define EB_VOICE_URL @"&imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&q=1103&sc=901846794747c2fa095c33302378fb5c&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw%2A"

// 声音列表页基地址
#define EB_VOICE_LIST_BASE_URL @"http://117.25.143.74/yyting/snsresource/getAblumnAudios.action?ablumnId=" // 19450

// 声音列表页
#define EB_VOICE_LIST_URL @"&imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&q=13313&sc=952e4b45ce4ca13c350ffe61ed65d58f&sortType=1&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw%2A"

// 分类页面地址
#define EB_CLASSIFICATION_URL @"http://apis.mting.info/yyting/gateway/batchOperation.action?imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&token=iEd4QgrcSw1-rXvkr8xNcXuanaVqazN3Qb63ToXOFc8*&pfunction=1&nwt=1&operations=%5B%22%2Fyyting%2Fbookclient%2FgetCategory.action%3Fopen%3D2%26pt%3D24%22%2C%22%2Fyyting%2Fbookclient%2FClientGetBookType.action%3Ffid%3D1000%26open%3D2%22%2C%22%2Fyyting%2Fbookclient%2FClientGetBookType.action%3Ffid%3D0%26open%3D1%22%5D&q=202&sc=6d2b176aa087e09b31e18d4a912b817a"

// 榜单页
#define EB_RANKING_URL @"http://apis.mting.info/yyting/gateway/batchOperation.action?imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&token=iEd4QgrcSw1-rXvkr8xNcXuanaVqazN3Qb63ToXOFc8*&pfunction=1&nwt=1&operations=%5B%22%2Fyyting%2Fbookclient%2FgetRecommendTypes.action%3Fsize%3D8%26type%3D5%26typeId%3D0%22%2C%22%2Fyyting%2Fbookclient%2FgetRecommendTypes.action%3Fsize%3D8%26type%3D6%26typeId%3D0%22%2C%22%2Fyyting%2Fbookclient%2FClientRankingsDir.action%3FpageSize%3D8%22%5D&q=203&sc=a55b5189fb8bee61df3230dbd722816c"

// 周榜
#define EB_WEEK_BASE_URL @"http://42.62.15.103/yyting/bookclient/ClientRankingsItemList.action?PageNum=1&PageSize=100&imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&q=7405&rangeType=1&rankType="

#define EB_WEEK_RANKING_URL @"&sc=26e7614980b18c5cd060916d4a807232&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw%2A"

// 月榜
#define EB_MONTH_BASE_URL @"http://42.62.15.103/yyting/bookclient/ClientRankingsItemList.action?PageNum=1&PageSize=100&imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&q=7405&rangeType=2&rankType="

#define EB_MONTH_RANKING_URL @"&sc=26e7614980b18c5cd060916d4a807232&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw%2A"

// 总榜
#define EB_TOTAL_BASE_URL @"http://42.62.15.103/yyting/bookclient/ClientRankingsItemList.action?PageNum=1&PageSize=100&imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&nwt=1&q=7405&rangeType=3&rankType="

#define EB_TOTAL_RANKING_URL @"&sc=26e7614980b18c5cd060916d4a807232&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw%2A"

// 注册
#define EB_REGISTER_URL @"http://api.mting.info/yyting/usercenter/ManualRegister.action"

// 登录
#define EB_LOGIN_URL @"http://api.mting.info/yyting/usercenter/ClientLogon.action"

//分类书籍类详情页基地址
#define EB_CLASSIFICATION_BOOK_DETAIL_BASE_URL @"http://117.25.143.79/yyting/gateway/batchOperation.action?imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&token=O6VpOdQ4AZ10P28At3e7sXsQ0shEf6PPdJ4gpDt0dCqP6T9pzPD1vEwbDV3QnEO-xu_4lg7PEJQ*&"

//分类书籍类详情页body1
#define EB_CLASSIFICATION_BOOK_DETAIL_BODY1_URL @"nwt=1&operations=%5B%22%2Fyyting%2Fbookclient%2FgetBookList.action%3Fdsize%3D10%26p%3D1%26sort%3D1%26t%3D0%26typeId%3D"

//分类书籍类详情页body2
#define EB_CLASSIFICATION_BOOK_DETAIL_BODY2_URL @"%22%2C%22%2Fyyting%2Fbookclient%2FgetBookList.action%3Fdsize%3D20%26p%3D1%26sort%3D2%26t%3D0%26typeId%3D"

//分类书籍类详情页body3
#define EB_CLASSIFICATION_BOOK_DETAIL_BODY3_URL @"%22%5D&q=4202&sc=1d02bf4fc46245f109fbaed37c08be88"



//分类声音详情页基地址
#define EB_CLASSIFICATION_VOICE_DETAIL_BASE_URL @"http://117.25.143.74/yyting/gateway/batchOperation.action?imei=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx&token=DgTQ7ezdIpVKGFBKFx32v4k18V20K33yMb9vJH6cMCm1MERM9GQasAk6L-vqa3PqIC3t2KIXkyw*&"

//分类声音详情页body1
#define EB_CLASSIFICATION_VOICE_DETAIL_BODY1_URL @"nwt=1&operations=%5B%22%2Fyyting%2Fsnsresource%2FgetRecommendUsers.action%3FneedAlbum%3D0%26needFollow%3D0%26opType%3DH%26referId%3D0%26size%3D10%26type%3D1%26typeId%3D"

//分类声音详情页body2
#define EB_CLASSIFICATION_VOICE_DETAIL_BODY2_URL @"%22%2C%22%2Fyyting%2Fsnsresource%2FgetRecommendAblumns.action%3FneedFlag%3D0%26opType%3DH%26referId%3D0%26size%3D20%26type%3D1%26typeId%3D"

//分类声音详情页body3
#define EB_CLASSIFICATION_VOICE_DETAIL_BODY3_URL @"%22%2C%22%2Fyyting%2Fsnsresource%2FgetRecommendAblumns.action%3FneedFlag%3D0%26opType%3DH%26referId%3D0%26size%3D20%26type%3D2%26typeId%3D"

//分类声音详情页body4
#define EB_CLASSIFICATION_VOICE_DETAIL_BODY4_URL @"%22%5D&q=13702&sc=655b668ce3e8bd91bc42cfc9ef336101"

#endif /* EB_URL_h */
