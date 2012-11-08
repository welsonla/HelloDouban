###这是一个非常简单的Oauth2 登录豆瓣的demo

	没有进行复杂的封装，旨在让和我一样初次接触oauth的人了解oauth的一般认证的流程




更多的信息可以查看 [豆瓣开发者](http://developers.douban.com/)


###替换DouAuth.h文件中为你自己的key和secrect，因为豆瓣的api必须添加测试用户

	#define APPSecret       @"你的AppSecret"
	#define Client_id       @"你的Client_id"


###！！！豆瓣的api中没有提到的是，在请求需要认证的api的时候，在HeaderFields中需要带上你的token去请求认证，这点折磨了我好久

	  请求GET方式认证的api需要加上这个
	  [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
	  
	  
	  请求POST方式认证的api需要加上
	  [request setValue:[NSString stringWithFormat:@"Bearer %@",token] 		 forHTTPHeaderField:@"Authorization"];
	  [request setValue:@"application/x-www-form-urlencoded" 		  forHTTPHeaderField:@"Content_type"];


